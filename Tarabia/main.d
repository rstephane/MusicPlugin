/**
* Copyright: SMAOLAB 2018
* License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
* Author:   Stephane Ribas
*/
module main;

import std.math;
import std.algorithm;

import dplug.core,
       dplug.client;

import gui;

mixin(DLLEntryPoint!());

version(VST)
{
    import dplug.vst;
    mixin(VSTEntryPoint!TarabiaClient);
}

version(AU)
{
    import dplug.au;
    mixin(AUEntryPoint!TarabiaClient);
}

enum : int
{
    paramTarabiaAmount,
    paramMix,
    paramClip,
}


/// Example mono/stereo distortion plugin.
final class TarabiaClient : dplug.client.Client
{
public:
nothrow:
@nogc:

    this()
    {
    }

    override PluginInfo buildPluginInfo()
    {
        // Plugin info is parsed from plugin.json here at compile time.
        // Indeed it is strongly recommended that you do not fill PluginInfo
        // manually, else the information could diverge.
        static immutable PluginInfo pluginInfo = parsePluginInfo(import("plugin.json"));
        return pluginInfo;
    }

    // This is an optional overload, default is zero parameter.
    // Caution when adding parameters: always add the indices
    // in the same order as the parameter enum.
    override Parameter[] buildParameters()
    {
        auto params = makeVec!Parameter();
        params.pushBack( mallocNew!LinearFloatParameter(paramTarabiaAmount, "Distortion amount", "", 0.00f, 0.99f, 0.0f) );
        params.pushBack( mallocNew!LinearFloatParameter(paramMix, "Dry/Wet", "%", 0.0f, 100.0f, 80.0f) );
        params.pushBack( mallocNew!BoolParameter(paramClip, "Soft Clipping?", true));
        return params.releaseData();
    }

    override LegalIO[] buildLegalIO()
    {
        auto io = makeVec!LegalIO();
        io.pushBack(LegalIO(1, 1));
        io.pushBack(LegalIO(1, 2));
        io.pushBack(LegalIO(2, 1));
        io.pushBack(LegalIO(2, 2));
        return io.releaseData();
    }

    // This override is optional, the default implementation will
    // have one default preset.
    override Preset[] buildPresets() nothrow @nogc
    {
        auto presets = makeVec!Preset();
        presets.pushBack( makeDefaultPreset() );
        return presets.releaseData();
    }

    // This override is also optional. It allows to split audio buffers in order to never
    // exceed some amount of frames at once.
    // This can be useful as a cheap chunking for parameter smoothing.
    // Buffer splitting also allows to allocate statically or on the stack with less worries.
    override int maxFramesInProcess() const //nothrow @nogc
    {
        return 256; // 512
    }

    override void reset(double sampleRate, int maxFrames, int numInputs, int numOutputs) nothrow @nogc
    {
        // Clear here any state and delay buffers you might have.

        assert(maxFrames <= 512); // guaranteed by audio buffer splitting
    }

    override void processAudio(const(float*)[] inputs, float*[]outputs, int frames,
                               TimeInfo info) nothrow @nogc
    {
        assert(frames <= 512); // guaranteed by audio buffer splitting

        int numInputs = cast(int)inputs.length;
        int numOutputs = cast(int)outputs.length;

        int minChan = numInputs > numOutputs ? numOutputs : numInputs;

        /// Read parameter values
        float tarabiaAmount;
        immutable float mix = readFloatParamValue(paramMix) / 100.0f;
        tarabiaAmount = readFloatParamValue(paramTarabiaAmount);
        bool tarabiaClip = readBoolParamValue(paramClip);

        // Rstephane, tau1 and 2 are the window clipping...
        float x, k, tau1 = 0.8, tau2 = 0.2;

        for (int chan = 0; chan < minChan; ++chan)
        {
            for (int f = 0; f < frames; ++f)
            {
                float inputSample = inputs[chan][f]; // * inputGain;

                if (inputSample != 0.0) // we don't need to process audio if there is no audio signal at input :)
                {
                    float _outputSample = inputSample; // the TEMP output signal to test if clipping
                    float outputSample = inputSample; // the real output signal...

                    x = inputSample; // input in [-1..1]

                    // The tarabia formula !
                    k = 2*tarabiaAmount/(1-tarabiaAmount); // amount in [-1..1]
                    _outputSample = (1+k)*x/(1+k*fabs(x));

                    // We check if Clipping !!
                    _outputSample *=0.75; // We should normalize the signal before doing the aliasing / clipping f(x)=1/L where L is the clipping factor; 0.75 is made due to 0.707.. and more looks similar to DB level ;-)

                    switch (tarabiaClip) {
                    case true: // Soft clipping, very nice clipping method , I like it !
                        // see https://wiki.analog.com/resources/tools-software/sigmastudio/toolbox/nonlinearprocessors/asymmetricsoftclipper
                        // exemple : tau1 = 0.5, tau2=0.5 <= try to different value 08 and 0.2 ... one day ;-)
                        // Tau1 and 2 are the window limits...
                        // I consider that _outsample is the TEMP signal, if this signal clips then we apply the formula below ...

                        // out = in , if abs(in) <tau1 when in >0, idem if abs(in) < tau2 for input <0
                        if ( ( abs(_outputSample) < tau1 ) && (_outputSample > 0) )
                        {
                          // Signal is good :) no clipping
                          outputSample = _outputSample;
                        }

                        //  if abs(in) >=tau1 & in > 0 THEN out = tau1 + (1 - tau1) * tanh ( (abs(in) - tau1) / (1 - tau1) )
                        if ( ( abs(_outputSample) >= tau1 ) && ( _outputSample > 0 ) )
                        {
                          outputSample = tau1 + (1 - tau1) * tanh ( (abs(_outputSample) - tau1) / (1 - tau1) );
                        }

                        // if abs(in) >=tau2 & In < 0 THEN out = -tau2 - (1 - tau2) * tanh ( (abs(in) - tau2) / (1 - tau2) )
                        if ( ( abs(_outputSample) >= tau2 ) && ( _outputSample < 0 ) )
                        {
                          outputSample = -tau2 - (1 - tau2) * tanh ( (abs(_outputSample) - tau2) / (1 - tau2) );
                        }

                        break;

                    case false:
                        // autre formule from yamaha research / Clipping and simple Aliasing
                        // http://www.ness-music.eu/wp-content/uploads/2015/10/esqueda.pdf
                        // output = (3 x input / 2)*(1- (input*input)/3)

                        if ( ( abs(_outputSample) < tau1 ) && (_outputSample > 0) )
                        {
                          // Signal is good :) no clipping
                          outputSample = _outputSample;
                        }
                        if ( ( abs(_outputSample) >= tau1 ) && ( _outputSample > 0 ) )
                        {
                          outputSample = (3 * _outputSample /2) * (1 - (_outputSample * _outputSample) /3 );
                        }
                        if ( ( abs(_outputSample) >= tau2 ) && ( _outputSample < 0 ) )
                        {
                          outputSample = (3 * _outputSample /2) * (1 - (_outputSample * _outputSample) /3 );
                        }

                        break;

                    default:
                        break;

                    }

                    // re inject in the buffer :)
                    // We assume that the input signal is not allready disorted or clipping :)
                    outputs[chan][f] = ((outputSample * mix) + (inputSample * (1 - mix)));
                }
            }
        }

        // fill with zero the remaining channels
        for (int chan = minChan; chan < numOutputs; ++chan)
            outputs[chan][0..frames] = 0; // D has array slices assignments and operations

        /// Get access to the GUI
        if (TarabiaGUI gui = cast(TarabiaGUI) graphicsAcquire())
        {
            /// This is where you would update any elements in the gui
            /// such as feeding values to meters.

            graphicsRelease();
        }
    }

    override IGraphics createGraphics()
    {
        return mallocNew!TarabiaGUI(this);
    }

private:

}
