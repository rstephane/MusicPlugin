/**
* Copyright: SMAOLAB 2018
* License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
* Author:   Stephane Ribas
*/
module gui;

import dplug.gui;
import dplug.flatwidgets;
import dplug.client;

import main;

// Plugin GUI, based on FlatBackgroundGUI.
// This allows to use knobs rendered with Knobman
class TarabiaGUI : FlatBackgroundGUI!("background-177x500.png")
{
public:
nothrow:
@nogc:

    TarabiaClient _client;

    this(TarabiaClient client)
    {
        _client = client;
        super(500, 177); // size

        // Sets the number of pixels recomputed around dirtied controls.
        // Since we aren't using pbr we can set this value to 0 to save
        // on resources.
        // If you are mixing pbr and flat elements, you may want to set this
        // to a higher value such as 30.
        setUpdateMargin(0);

        // All resources are bundled as a string import.
        // You can avoid resource compilers that way.
        // The only cost is that each resource is in each binary, this creates overhead
        OwnedImage!RGBA knobImage = loadOwnedImage(cast(ubyte[])(import("knob.png")));
        OwnedImage!RGBA switchOnImage = loadOwnedImage(cast(ubyte[])(import("switchOn.png")));
        OwnedImage!RGBA switchOffImage = loadOwnedImage(cast(ubyte[])(import("switchOff.png")));

        // Creates all widets and adds them as children to the GUI
        // widgets are not visible until their positions have been set

        // change the number of images contained in the knob.png file :)
        int numFrames = 101;

        UIFilmstripKnob clipKnob = mallocNew!UIFilmstripKnob(context(), cast(FloatParameter) _client.param(paramTarabiaAmount), knobImage, numFrames);
        addChild(clipKnob);

        UIFilmstripKnob mixKnob = mallocNew!UIFilmstripKnob(context(), cast(FloatParameter) _client.param(paramMix), knobImage, numFrames);
        addChild(mixKnob);

        // Clipping Switch...
        UIImageSwitch modeSwitch = mallocNew!UIImageSwitch(context(), cast(BoolParameter) _client.param(paramClip), switchOnImage, switchOffImage);
        addChild(modeSwitch);

        // Builds the UI hierarchy
        // Note: when Dplug has resizeable UI, all positionning is going
        // to move into a reflow() override.
        // Meanwhile, we hardcode each position.
        // X 0 is on the left handside to right ...
        // Y is on the TOP to BOTTOM :)
        immutable int knobX1 = 360; // Dry Wet X
        immutable int knobY1 = 30; // Dry Wet Y
        immutable int knobX2 = 75; // Amount X
        immutable int knobY2 = 80; // Amount Y

        // change the size of the knobs
        immutable int knobWidth = 90;
        immutable int knobHeight = 90;

        // Tarabia Amount Knob
        clipKnob.position = box2i(knobX2, knobY2, knobX2 + knobWidth, knobY2 + knobHeight);

        // MIX Amount Knob
        mixKnob.position = box2i(knobX1, knobY1, knobX1 + knobWidth, knobY1 + knobHeight);

        // Clipping Switch... well it is more distortion and simple aliasing
        immutable int switchX = 262;
        immutable int switchY = 135;
        immutable int switchWidth = 51;
        immutable int switchHeight = 21;

        modeSwitch.position = box2i(switchX, switchY, switchX + switchWidth, switchY  + switchHeight);


    }

}
