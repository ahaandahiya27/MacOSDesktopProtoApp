# -*- coding: utf-8 -*-
# Boss Challenge Paper 39 — Light · Electric Current & its Effects · Symmetry · Perimeter & Area
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: leans into FUSION. A plane mirror's mirror-image becomes a LINE OF SYMMETRY; a
# circuit's wire loop becomes a PERIMETER; a square mirror's reflecting face becomes an AREA; an
# electromagnet's symmetric coil becomes ROTATIONAL symmetry. The child meets a Science situation
# and reaches for a Maths skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_39_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_39_<SHORT>_QuestionPaper.pdf
#   Paper_39_<SHORT>_Questions.md
#   Paper_39_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "39"
SHORT = "Light_Electricity_Symmetry_PerimeterArea"
TITLE = ("Light · Electric Current & its Effects · "
         "Symmetry · Perimeter & Area")
LABELS = {
    "LI": "Light",
    "EC": "Electric Current & its Effects",
    "SY": "Symmetry",
    "PA": "Perimeter & Area",
}

# ---------- LIGHT (25) — Science ----------
LI = [
 ("LI","In clear air light travels along paths that are perfectly:",
   "straight lines",
   C("Light does not bend on its own in a uniform medium — it shoots out in dead-straight lines.")+
   steps("Light leaves a source","nothing in clear air pulls it sideways","so it keeps going in a straight line."),
   [("curved arcs","Light only appears to curve when it crosses into a new medium, not while travelling in clear air."),
    ("zig-zag steps","Light has no built-in zig-zag; in one medium its path is a single straight line."),
    ("spreading circles","The brightness may spread, but each ray itself runs in a straight line.")]),

 ("LI","We are able to see an ordinary book only because light:",
   "from it enters our eyes",
   C("Seeing is light arriving at the eye — a non-glowing object must bounce light into us before we can see it.")+
   steps("Light from a source falls on the book","the book reflects some of that light","that reflected light enters the eye and we see it."),
   [("is made inside our eyes","The eye detects light; it does not shine its own light onto things to see them."),
    ("is stored in the book","A book holds no light of its own; it only reflects light that falls on it."),
    ("passes straight through it","A book is opaque — light bounces off it rather than passing through.")]),

 ("LI","A shadow forms behind an object only when that object is:",
   "opaque to light",
   C("A shadow is the dark patch where light has been blocked — only something light cannot pass through casts one.")+
   steps("Light travels in straight lines","an opaque object blocks those rays","the unlit region behind it is the shadow."),
   [("transparent","Light passes right through a transparent object, so it casts almost no shadow."),
    ("glowing brightly","A glowing object makes light; it does not block it to form a dark shadow."),
    ("painted white","Colour does not decide a shadow; blocking the light does.")]),

 ("LI","When a ray of light strikes a plane mirror, the angle it bounces off at equals the angle it:",
   "arrived at",
   C("The mirror's rule is beautifully simple: the angle of reflection equals the angle of incidence.")+
   steps("A ray hits the mirror at some angle","the mirror reflects it","it leaves at exactly the same angle on the other side."),
   [("doubles to","Reflection copies the angle exactly; it does not double it."),
    ("halves to","The bounce-off angle is equal, not half, of the arriving angle."),
    ("turns 90° from","Only when a ray hits head-on are things special; in general the two angles are simply equal.")]),

 ("LI","The image of your face in a flat bathroom mirror is:",
   "the same size as your face",
   C("A plane mirror is honest about size — your image is exactly as big as you are.")+
   steps("A plane mirror is flat","it neither shrinks nor enlarges the rays","so the image matches the object's size."),
   [("smaller than your face","Only a convex mirror shrinks the image; a flat mirror keeps the size."),
    ("larger than your face","Only a concave mirror (held close) enlarges; a flat mirror keeps the size."),
    ("upside down","A plane-mirror image stands upright, not upside down.")]),

 ("LI","Hold up your right hand to a flat mirror and the image seems to raise its left hand. This left-right swap is called:",
   "lateral inversion",
   C("A plane mirror flips left and right — your right becomes the image's left. That swap has a name: lateral inversion.")+
   steps("You raise your right hand","the mirror reverses left and right","the image appears to raise its left hand."),
   [("magnification","Magnification is about size change, not the left-right swap."),
    ("dispersion","Dispersion is the splitting of white light into colours, not a left-right flip."),
    ("refraction","Refraction is the bending of light entering a new medium, not the mirror's left-right swap.")]),

 ("LI","An image formed by a plane mirror cannot be caught on a screen, so it is called a:",
   "virtual image",
   C("A plane-mirror image only seems to sit behind the glass — no light actually gathers there, so no screen can catch it. That is a virtual image.")+
   steps("The rays only appear to come from behind the mirror","they never truly meet there","so the image is virtual and cannot land on a screen."),
   [("real image","A real image is one a screen can catch; a plane mirror never makes one."),
    ("solid image","'Solid' is not a kind of image; the plane-mirror image is virtual."),
    ("inverted image","A plane-mirror image is upright, not inverted, and the key point is that it is virtual.")]),

 ("LI","A mirror whose reflecting surface curves inward, like the inside of a spoon's bowl, is a:",
   "concave mirror",
   C("Curve the shiny side inward (a cave) and you get a concave mirror, which can gather light to a point.")+
   steps("Picture the inside of a spoon","its shiny face dips inward","that inward-curving mirror is concave."),
   [("convex mirror","A convex mirror bulges outward, the opposite of curving inward."),
    ("plane mirror","A plane mirror is flat, not curved inward."),
    ("plain glass","Plain glass lets light through and does not reflect like a curved mirror.")]),

 ("LI","A convex (outward-bulging) mirror always gives an image that is upright and:",
   "smaller than the object",
   C("A convex mirror spreads rays out, so it squeezes a wide scene into a small, upright image — handy for seeing a lot at once.")+
   steps("The surface bulges outward","it makes reflected rays diverge","the image comes out upright and diminished."),
   [("larger than the object","A convex mirror shrinks the image; it never enlarges it."),
    ("upside down","A convex mirror's image is upright, not inverted."),
    ("exactly equal in size","Only a flat mirror keeps size; a convex mirror makes a smaller image.")]),

 ("LI","When white sunlight passes through a glass prism it spreads into a band of seven colours. This splitting is called:",
   "dispersion",
   C("A prism reveals that white light is a bundle of colours; pulling them apart into a band is dispersion.")+
   steps("White light enters the prism","each colour bends by a slightly different amount","they fan out into a seven-colour band — dispersion."),
   [("reflection","Reflection bounces light back; dispersion fans white light into its colours."),
    ("absorption","Absorption swallows light; here the light is spread out, not soaked up."),
    ("lateral inversion","Lateral inversion is a mirror's left-right swap, not the splitting of colours.")]),

 ("LI","The seven colours of the rainbow, in order from top to bottom, begin with violet and end with:",
   "red",
   C("Remember VIBGYOR: violet, indigo, blue, green, yellow, orange, red — violet at one end, red at the other.")+
   steps("List the band from one end","violet, indigo, blue, green, yellow, orange","the last colour is red."),
   [("green","Green sits in the middle of the band, not at the end."),
    ("blue","Blue is near the violet end, not the far end of the order."),
    ("white","White is the mix of all colours, not a single colour in the band.")]),

 ("LI","A lens that is thicker in the middle than at its edges bends parallel rays to meet at a point, so it is called a:",
   "converging lens",
   C("Fat in the middle, this convex lens pulls rays together — it converges them to a focus.")+
   steps("The lens is thickest at its centre","it bends incoming parallel rays inward","they meet at a focus, so it is converging."),
   [("diverging lens","A diverging lens is thin in the middle and spreads rays apart."),
    ("plane mirror","A plane mirror reflects; it does not bend rays through itself."),
    ("opaque disc","An opaque disc blocks light; a converging lens lets it through and focuses it.")]),

 ("LI","The Sun is a luminous object, but the Moon is non-luminous because it only:",
   "reflects sunlight to us",
   C("The Moon makes no light of its own — what we see is sunlight bouncing off it.")+
   steps("The Sun produces its own light","the Moon does not","it merely reflects the Sun's light toward Earth."),
   [("makes its own light","If the Moon made its own light it would be luminous; it is not."),
    ("blocks all sunlight","The Moon reflects sunlight rather than blocking it; that is why it glows."),
    ("absorbs all the light","If it absorbed all light it would look dark; instead it reflects light to us.")]),

 ("LI","A real image, unlike a virtual one, has the special property that it can be:",
   "caught on a screen",
   C("Real images are formed where light actually gathers, so a screen placed there catches them — a cinema screen is exactly this.")+
   steps("Real rays truly meet at a point","a screen placed there intercepts them","so a real image can be projected on a screen."),
   [("seen only in a mirror","Mirror images you cannot catch are virtual; a real image lands on a screen."),
    ("formed only by flat mirrors","Flat mirrors make virtual images; real images come from converging mirrors/lenses."),
    ("made larger forever","Size is a separate matter; the defining trait of a real image is that a screen can catch it.")]),

 ("LI","A pinhole camera forms an image of a candle that is real and:",
   "upside down",
   C("Straight-line light through a tiny hole crosses over, so the top of the candle lands at the bottom — an inverted image.")+
   steps("Light from the candle's top goes through the hole","straight lines cross at the pinhole","the top maps to the bottom, so the image is inverted."),
   [("right side up","The crossing of straight rays at the hole flips the image upside down."),
    ("the same as in a mirror","A pinhole image is real and inverted; a mirror image is virtual and upright."),
    ("a band of colours","A pinhole gives a faithful inverted image, not a spread of colours.")]),

 ("LI","A driver's rear-view mirror is convex because, compared with a flat mirror, it gives a:",
   "wider field of view",
   C("Bulging outward, a convex mirror squeezes a broad scene into the glass — the driver sees much more of the road.")+
   steps("A convex mirror diverges reflected rays","this packs a wide scene into a small image","so the driver sees a wider field of view."),
   [("magnified close-up","Convex mirrors shrink, not magnify; that would narrow the view, not widen it."),
    ("upside-down view","Convex-mirror images stay upright; the real advantage is the wider view."),
    ("coloured view","A convex mirror does not add colours; it widens the field of view.")]),

 ("LI","In a flat mirror, if you stand 30 cm in front of the glass, your image appears to be:",
   "30 cm behind the glass",
   C("A plane mirror places the image as far behind it as the object is in front — a perfect match of distances.")+
   steps("Object distance in front = 30 cm","a plane mirror mirrors this distance","so the image sits 30 cm behind the glass."),
   [("15 cm behind the glass","The image distance equals the object distance, so it is 30 cm, not half."),
    ("60 cm behind the glass","The mirror matches the distance exactly; it does not double it."),
    ("right on the glass surface","The image lies behind the glass at the object's distance, not on the surface.")]),

 ("LI","A dentist uses a concave mirror to look at a tooth up close because, held near, it gives an image that is:",
   "enlarged and upright",
   C("Bring an object inside a concave mirror's focus and it acts like a magnifier — a big, upright image of the tooth.")+
   steps("The tooth is held close to the concave mirror","the inward curve magnifies","the dentist sees an enlarged, upright image."),
   [("tiny and upright","A convex mirror shrinks; a close concave mirror enlarges the image."),
    ("enlarged but upside down","Held close, the concave-mirror image is upright, not inverted."),
    ("the exact same size","A concave mirror used close enlarges; it does not keep the size.")]),

 ("LI","When light bounces off a rough, uneven wall it scatters in many directions. This is called:",
   "diffuse reflection",
   C("A bumpy surface sends rays every which way — that scattering is diffuse reflection, why a wall has no clear image.")+
   steps("The surface is rough","each tiny bump faces a different way","reflected rays scatter, giving diffuse reflection."),
   [("regular reflection","Regular reflection happens on a smooth mirror and gives a clear image, not scatter."),
    ("dispersion","Dispersion splits white light into colours; this is about scattering off a rough surface."),
    ("refraction","Refraction is bending on entering a new medium, not scattering off a rough wall.")]),

 ("LI","A lens that is thinner in the middle than at the edges spreads parallel rays apart, so it is a:",
   "concave (diverging) lens",
   C("Pinched in the middle, this lens pushes rays outward — it diverges them, the opposite of focusing.")+
   steps("The lens is thinnest at its centre","incoming parallel rays bend outward","they spread apart, so it is a diverging lens."),
   [("convex lens","A convex lens is thick in the middle and converges rays, the opposite."),
    ("plane mirror","A plane mirror reflects light; a diverging lens transmits and spreads it."),
    ("magnifying glass","A magnifying glass is a convex lens; a diverging lens makes things look smaller.")]),

 ("LI","The word AMBULANCE is painted reversed on the front of the van so that a driver ahead reads it correctly in a:",
   "plane mirror",
   C("Lateral inversion strikes again — reversed lettering flips back to normal in the rear-view mirror, so the word reads right.")+
   steps("A flat mirror swaps left and right","the painters reverse the word in advance","the mirror un-reverses it, so the driver reads AMBULANCE.")
   ,
   [("convex lens","A lens does not perform the simple left-right swap that fixes the reversed word; a flat mirror does."),
    ("prism","A prism splits colours; it does not flip the reversed lettering back to normal."),
    ("concave mirror","A concave mirror can flip and resize unpredictably; the reliable left-right swap is the plane mirror's.")]),

 ("LI","Two plane mirrors set face-to-face show many repeated images because the light is:",
   "reflected again and again between them",
   C("Each mirror catches the other's image and reflects it once more, so a single object spawns a whole row of images.")+
   steps("Mirror one makes an image","mirror two reflects that image","each reflects the other repeatedly, multiplying the images."),
   [("split into colours","The many images come from repeated reflection, not from colour splitting."),
    ("absorbed by the glass","If the glass absorbed the light there would be no images at all."),
    ("bent into the mirror","Plane mirrors reflect light back; they do not bend it into the glass to multiply images.")]),

 ("LI","A magnifying glass that makes tiny print look bigger is simply a:",
   "convex lens",
   C("Held close, a fat-in-the-middle convex lens enlarges the print into a big, upright image.")+
   steps("A convex lens is thick in the middle","held close to small print","it forms an enlarged upright image — a magnifier."),
   [("concave lens","A concave lens makes things look smaller, not bigger."),
    ("plane mirror","A plane mirror keeps the size the same; it is not a magnifier."),
    ("convex mirror","A convex mirror shrinks the image, the opposite of magnifying.")]),

 ("LI","Light from the bright Sun reaches us because, between Sun and Earth, light needs:",
   "no material medium to travel through",
   C("Unlike sound, light crosses the empty space between Sun and Earth — it needs no air, water, or solid to travel.")+
   steps("Space between Sun and Earth is nearly empty","sound could not cross it","but light does, because it needs no medium."),
   [("air all the way","Most of the gap is empty space with no air, yet light still crosses it."),
    ("a solid path","Light does not need a solid; it travels through the vacuum of space."),
    ("a stream of water","There is no water in space; light needs no medium at all to travel.")]),

 ("LI","In a periscope used to see over a wall, the light is turned twice using two:",
   "plane mirrors",
   C("A periscope is just two flat mirrors set at 45° — each reflects the light, bending the view up and over the wall.")+
   steps("Light enters the top","a slanted plane mirror reflects it down","a second plane mirror sends it to your eye."),
   [("convex lenses","Lenses focus light; a periscope turns the path with flat mirrors, not lenses."),
    ("prisms that split colours","A simple periscope uses plane mirrors to bend the path, not colour-splitting prisms."),
    ("concave mirrors","Concave mirrors would distort and resize the view; periscopes use plane mirrors.")]),
]

# ---------- ELECTRIC CURRENT & ITS EFFECTS (25) — Science ----------
EC = [
 ("EC","For a bulb to glow, the electric circuit joining it to the cell must form a:",
   "closed (complete) loop",
   C("Current can only flow when the path makes an unbroken loop from one terminal of the cell, through the bulb, and back.")+
   steps("Current leaves one terminal of the cell","it needs an unbroken path through the bulb","and back to the other terminal — a closed loop."),
   [("broken open path","An open path stops the current, so the bulb stays dark."),
    ("single straight wire","One free-ended wire is not a loop; the current has no way back to the cell."),
    ("loop with the switch off","An open switch breaks the loop, so the bulb will not glow.")]),

 ("EC","Inside any household circuit, the part whose job is to open or close the path for current is the:",
   "switch",
   C("A switch is a gate: close it and the loop is complete so current flows; open it and the loop breaks.")+
   steps("A closed switch joins the wire ends","current then flows around the loop","opening the switch breaks the path and stops the current."),
   [("cell","A cell supplies the push; the part that simply opens or closes the path is the switch."),
    ("fuse","A fuse melts only on overload; the everyday part that opens or closes the path is the switch."),
    ("bulb","A bulb gives light; it does not open or close the path — the switch does.")]),

 ("EC","A glowing torch bulb gives off light because its thin filament gets so hot it shines. This is the:",
   "heating effect of current",
   C("Current squeezing through the thin filament heats it white-hot, and the glowing wire gives off light — the heating effect.")+
   steps("Current passes through the thin filament","the filament resists and heats up","it glows white-hot, showing the heating effect."),
   [("magnetic effect of current","The magnetic effect makes a wire act like a magnet; the bulb glows by heating."),
    ("chemical effect of current","The chemical effect happens in liquids; a bulb glows from heat."),
    ("cooling effect of current","Current heats the filament, it does not cool it.")]),

 ("EC","The filament of a bulb is made of tungsten because tungsten has a very high:",
   "melting point",
   C("The filament must glow white-hot without melting, so it is made of tungsten — a metal that melts only at a huge temperature.")+
   steps("The filament must reach a glowing heat","an ordinary metal would melt","tungsten's very high melting point lets it glow safely."),
   [("weight","Weight does not stop a filament melting; a high melting point does."),
    ("cost","Tungsten is chosen for its high melting point, not because it is expensive."),
    ("colour","Colour plays no part; the high melting point is what matters in a filament.")]),

 ("EC","A safety fuse protects an appliance by melting and breaking the circuit when the current becomes:",
   "too large",
   C("A fuse is a deliberate weak link — too much current heats it past its melting point, breaking the loop before damage is done.")+
   steps("Excess current overheats the thin fuse wire","the fuse melts","the loop breaks and the dangerous current stops."),
   [("too small","A small, safe current does not melt the fuse; only an excessive current does."),
    ("perfectly steady","A steady, normal current is fine; the fuse acts only when current is too large."),
    ("turned off","With the current off there is nothing to melt; the fuse acts during an overload.")]),

 ("EC","Hans Oersted discovered that a wire carrying current can deflect a nearby compass needle, showing that current has a:",
   "magnetic effect",
   C("A current-carrying wire behaves like a magnet — it nudges a compass needle. That is the magnetic effect of current.")+
   steps("Current flows through a wire","this creates a magnetism around the wire","a nearby compass needle swings, showing the magnetic effect."),
   [("heating effect","The heating effect makes wires hot; the compass swings because of magnetism."),
    ("chemical effect","The chemical effect appears in liquids; the moving compass shows magnetism."),
    ("lighting effect","A swinging compass needle is about magnetism, not the giving-off of light.")]),

 ("EC","A coil of wire wound on an iron piece becomes a magnet only while current flows. This device is an:",
   "electromagnet",
   C("Switch the current on and the coil-plus-iron becomes a strong magnet; switch it off and the magnetism vanishes — an electromagnet.")+
   steps("Current flows through the coil","the iron core becomes strongly magnetic","switch off the current and the magnetism disappears."),
   [("permanent magnet","A permanent magnet keeps its magnetism with no current; an electromagnet needs the current."),
    ("simple battery","A battery supplies current; the coil-and-iron that becomes a magnet is the electromagnet."),
    ("ordinary fuse","A fuse is a safety link that melts; it is not a switchable magnet.")]),

 ("EC","An electric bell rings repeatedly because it uses an electromagnet that switches:",
   "on and off rapidly",
   C("The electromagnet pulls the hammer to strike, which breaks the circuit; it then releases and reconnects — on, off, on, off — so the bell rings.")+
   steps("Current makes the electromagnet pull the hammer","the strike breaks the circuit, so the magnet lets go","the contact remakes and it repeats — a steady ring."),
   [("on and stays on","If it stayed on, the hammer would strike once and stop; the bell needs rapid on-off."),
    ("off permanently","With the magnet off, nothing moves; ringing needs it switching on and off."),
    ("to a different colour","An electric bell rings by rapid switching, not by changing colour.")]),

 ("EC","Materials such as copper and iron let current pass through them easily, so they are called:",
   "conductors",
   C("Metals hand current along freely — copper, iron, aluminium — so we call them conductors.")+
   steps("A material is tested in a circuit","copper and iron let current flow and the bulb glows","such materials are conductors."),
   [("insulators","Insulators block current; copper and iron let it through, so they are conductors."),
    ("fuses","A fuse is a safety device, not a class of current-passing material."),
    ("magnets","Being a conductor is about passing current, not about attracting iron.")]),

 ("EC","Rubber and plastic do not allow current to pass, so wires are coated with them to act as:",
   "insulators",
   C("Plastic and rubber refuse to pass current, so a coating of them keeps the live wire from giving us a shock — they insulate.")+
   steps("Current cannot flow through rubber or plastic","a coating of them surrounds the metal wire","it blocks current from leaking out — an insulator."),
   [("conductors","Conductors pass current; rubber and plastic block it, so they are insulators."),
    ("electromagnets","An electromagnet is a current-driven magnet, not a current-blocking coating."),
    ("cells","A cell supplies current; the rubber coating's job is to block current as an insulator.")]),

 ("EC","If you connect two identical cells in series instead of one, the bulb in the same circuit usually glows:",
   "more brightly",
   C("Two cells push harder than one, driving more current through the bulb, so it shines brighter.")+
   steps("Two cells joined end to end add their push","more current flows through the filament","the bulb glows more brightly."),
   [("more dimly","More cells push more current, brightening the bulb rather than dimming it."),
    ("exactly the same","Adding a second cell increases the push and the brightness; it does not stay the same."),
    ("a different colour","More cells make the bulb brighter, not a new colour.")]),

 ("EC","A battery, strictly speaking, is made of:",
   "two or more cells joined together",
   C("One unit is a cell; join two or more and you have a battery — the cells share their push.")+
   steps("A single unit that supplies current is a cell","join two or more end to end","the combination is called a battery."),
   [("a single cell only","One unit is just a cell; a battery is two or more joined."),
    ("a bulb and a wire","A bulb and wire are parts of the circuit, not what makes up a battery."),
    ("a switch and a fuse","A switch and fuse control and protect the circuit; a battery is joined cells.")]),

 ("EC","In a circuit diagram, the symbol for a cell shows a longer line and a shorter line, where the longer line marks the:",
   "positive terminal",
   C("By convention the long thin line of the cell symbol is its positive terminal; the short thick line is negative.")+
   steps("The cell symbol has two lines","the longer, thinner line is positive","the shorter, thicker line is negative."),
   [("negative terminal","The longer line is positive; the shorter, thicker line is the negative terminal."),
    ("switch","A switch has its own symbol; the two-line symbol with a long line is the cell."),
    ("bulb","A bulb is drawn as a circle with a cross or loop; the long-and-short lines are the cell.")]),

 ("EC","An electromagnet can be made stronger by increasing the number of:",
   "turns in its coil",
   C("More loops of wire pile up the magnetism, so winding extra turns makes a stronger electromagnet.")+
   steps("Each turn of the coil adds to the magnetism","wind on more turns","the electromagnet becomes stronger."),
   [("iron cores removed","Removing the iron core weakens the magnet; the core helps, more turns help."),
    ("switches added","Adding switches does not strengthen the magnet; more coil turns do."),
    ("bulbs in the circuit","Bulbs draw current away; they do not strengthen the electromagnet — extra turns do.")]),

 ("EC","An electric room heater and a clothes iron both work mainly on the:",
   "heating effect of current",
   C("Both push current through a high-resistance coil that gets hot — pure heating effect put to work.")+
   steps("Current flows through a special heating coil","the coil resists and gets very hot","the heat warms the room or presses clothes."),
   [("magnetic effect of current","The magnetic effect runs bells and motors; heaters and irons use heat."),
    ("chemical effect of current","The chemical effect works in liquids; a heater uses the heating effect."),
    ("reflecting effect of current","There is no 'reflecting effect'; heaters and irons use the heating effect.")]),

 ("EC","If a bulb in a working circuit suddenly stops glowing, the most likely simple cause is a:",
   "break or loose connection in the loop",
   C("A glowing circuit going dark usually means the loop has opened somewhere — a loose wire, a blown filament, or an open switch.")+
   steps("The bulb glowed, so the loop was complete","then it went dark","most likely the loop broke at a loose joint or the filament."),
   [("too-bright Sun outside","Sunlight does not switch a circuit bulb off; a broken loop does."),
    ("the wire being too short","A short but complete wire still carries current; a break stops it."),
    ("colour of the casing","The casing colour cannot stop current; a break in the loop can.")]),

 ("EC","Compared with an old filament bulb, a CFL or LED is preferred at home because it:",
   "uses less electricity for the same light",
   C("Filament bulbs waste most of their energy as heat; CFLs and LEDs give the same brightness using far less electricity.")+
   steps("A filament bulb turns much energy into heat","a CFL/LED gives light far more efficiently","so it uses less electricity for the same brightness."),
   [("uses more electricity","CFLs and LEDs use less, not more, electricity than filament bulbs."),
    ("needs no circuit","Every electric lamp still needs a complete circuit to work."),
    ("makes more heat","Filament bulbs make more heat; CFLs and LEDs make less, which is why they are efficient.")]),

 ("EC","A compass needle brought near a straight wire carrying current will:",
   "deflect from its north–south rest position",
   C("The current's magnetism tugs the needle, swinging it away from plain north–south — Oersted's classic result.")+
   steps("A current sets up magnetism around the wire","this acts on the magnetic compass needle","the needle deflects from north–south."),
   [("stay exactly still","The needle does move — the current's magnetism deflects it."),
    ("melt instantly","A compass needle does not melt; it simply swings due to magnetism."),
    ("turn into a battery","A compass needle cannot become a battery; it only deflects.")]),

 ("EC","In the symbolic circuit diagram, a switch is shown as a:",
   "small gap that a lever can close",
   C("A switch symbol is a little break in the line with a hinged lever — push it across to close the gap and complete the loop.")+
   steps("Draw the wire with a small gap","a hinged line can bridge the gap","closing it completes the circuit — that is the switch symbol."),
   [("circle with a cross","A circle with a cross is the bulb symbol, not the switch."),
    ("pair of long and short lines","Long-and-short parallel lines are the cell symbol, not the switch."),
    ("zig-zag line","A zig-zag stands for resistance, not a switch.")]),

 ("EC","An MCB (miniature circuit breaker) is used in modern homes in place of a fuse because, after it trips, it can be:",
   "switched back on without replacing anything",
   C("A blown fuse must be replaced; an MCB simply trips like a switch and can be flipped back on once the fault is cleared.")+
   steps("Too much current makes the MCB trip and break the loop","unlike a fuse it does not melt away","once the fault is fixed you switch it back on."),
   [("eaten away and discarded","That describes a fuse; an MCB is reusable and just switches back on."),
    ("filled with water","An MCB is not refilled with anything; it is simply reset."),
    ("left tripped forever","An MCB is meant to be reset and switched back on after the fault is cleared.")]),

 ("EC","The chief job of the iron core inside an electromagnet's coil is to:",
   "make the magnetism much stronger",
   C("Iron concentrates the coil's magnetism, so the same current lifts far more — the core is what makes an electromagnet powerful.")+
   steps("The coil alone makes weak magnetism","an iron core concentrates that magnetism","so the electromagnet becomes much stronger."),
   [("block the current","The iron core strengthens the magnet; it does not block the current."),
    ("change the bulb's colour","An electromagnet's core has nothing to do with a bulb's colour."),
    ("cool the wire down","The iron core boosts the magnetism, it is not there to cool the wire.")]),

 ("EC","When you join cells to make a battery, you must connect the positive terminal of one cell to the ___ of the next.",
   "negative terminal",
   C("Cells add their push only when joined head to tail — the positive of one to the negative of the next.")+
   steps("Take two cells","join the positive of one to the negative of the other","their pushes add up into a battery."),
   [("positive terminal","Joining positive to positive opposes the pushes; you join positive to negative."),
    ("middle of the wire","Cells join terminal to terminal, not to the middle of a wire."),
    ("switch","Cells are joined positive-to-negative to each other, not directly onto a switch.")]),

 ("EC","A torch will NOT light if its cell is put in the wrong way round, because the circuit then has its cells:",
   "pushing against each other",
   C("Reversed cells fight one another, so their pushes cancel and little or no current flows — the torch stays dark.")+
   steps("Cells must point the same way to add up","a reversed cell pushes the opposite way","the pushes cancel, so the bulb stays dark."),
   [("joined too tightly","Tightness is not the issue; reversed cells cancel each other's push."),
    ("made of plastic","The casing material is not why a reversed cell fails; opposing pushes are."),
    ("too cold to work","A wrong-way cell fails because the pushes oppose, not because of cold.")]),

 ("EC","Touching a bare live wire is dangerous because the human body acts as a:",
   "conductor of electric current",
   C("Our moist body lets current pass through it, so touching a live wire gives a shock — the body is a conductor.")+
   steps("A live wire carries current","the body lets current pass through it","so current flows through us — a dangerous shock."),
   [("perfect insulator","If the body were a perfect insulator we would feel no shock; sadly it conducts."),
    ("source of new current","The body does not generate current; it conducts the current from the wire."),
    ("kind of fuse","The body is not a protective fuse; it is a conductor, which is why shocks happen.")]),

 ("EC","A drawing that uses agreed symbols for the cell, switch, and bulb instead of real pictures is called a:",
   "circuit diagram",
   C("Engineers draw circuits with simple agreed symbols, not little pictures — that neat symbol drawing is a circuit diagram.")+
   steps("Each part has a standard symbol","arrange the symbols and join them with lines","the result is a circuit diagram everyone can read."),
   [("photograph","A photograph shows real objects; a circuit diagram uses standard symbols."),
    ("map of a city","A city map shows roads, not electrical parts; circuit symbols make a circuit diagram."),
    ("bar graph","A bar graph compares amounts; a circuit's symbol drawing is a circuit diagram.")]),
]

# ---------- SYMMETRY (25) — Maths ----------
SY = [
 ("SY","A figure has line symmetry if a straight line divides it into two halves that are exact:",
   "mirror images of each other",
   C("Fold along the line and the two halves land perfectly on top of one another — they are mirror images.")+
   steps("Draw a line through the figure","fold along it","if the two halves match exactly, the figure has line symmetry."),
   [("different shapes","Symmetry needs the halves to match; different shapes mean no line symmetry."),
    ("bigger and smaller copies","The two halves must be the same size and shape — mirror images, not a big and small copy."),
    ("rotated by 90°","Line symmetry is about a fold/mirror match, not a quarter turn.")]),

 ("SY","The straight line along which a symmetric figure can be folded so the halves match is called the:",
   "line of symmetry",
   C("That special fold line is the line (or axis) of symmetry.")+
   steps("Find the fold that makes the halves coincide","that fold line is special","we call it the line of symmetry."),
   [("number line","A number line orders numbers; it is not the fold line of a shape."),
    ("base line","'Base line' is not the term; the fold line is the line of symmetry."),
    ("diagonal only","A line of symmetry may or may not be a diagonal; the general name is line of symmetry.")]),

 ("SY","A square has exactly this many lines of symmetry:",
   "4",
   C("A square folds onto itself along two diagonals and two lines through opposite side-midpoints — four lines in all.")+
   steps("Two folds join midpoints of opposite sides","two folds run along the diagonals","that makes 4 lines of symmetry."),
   [("2","A rectangle has 2; a square's extra equal sides give it 4 lines."),
    ("1","One line is far too few — a square has four lines of symmetry."),
    ("8","A square has 4 lines of symmetry, not 8 (its rotational order is 4 too, but lines are 4).")]),

 ("SY","A rectangle that is not a square has exactly this many lines of symmetry:",
   "2",
   C("A rectangle folds onto itself only along the two lines joining the midpoints of opposite sides — its diagonals do NOT give symmetry.")+
   steps("Fold across the midlines of the long sides","fold across the midlines of the short sides","only these 2 folds match — so 2 lines."),
   [("4","Only a square has 4; a plain rectangle's diagonals are not symmetry lines, so it has 2."),
    ("1","A rectangle has two midline folds, not one."),
    ("0","A rectangle does have symmetry — two lines, not none.")]),

 ("SY","An equilateral triangle (all sides equal) has this many lines of symmetry:",
   "3",
   C("From each corner a fold to the midpoint of the opposite side matches the halves — three equal corners give three lines.")+
   steps("Drop a fold from each vertex to the opposite side's midpoint","all three sides are equal","so there are 3 lines of symmetry."),
   [("1","An isosceles triangle has 1; the equilateral's three equal sides give 3."),
    ("2","Two is short by one — an equilateral triangle has 3 lines of symmetry."),
    ("0","A scalene triangle has 0; an equilateral one has 3.")]),

 ("SY","A scalene triangle, whose three sides are all different lengths, has this many lines of symmetry:",
   "0",
   C("With no two sides equal, no fold can match the halves — a scalene triangle has no line of symmetry.")+
   steps("Try any fold line","the unequal sides never match up","so a scalene triangle has 0 lines of symmetry."),
   [("1","An isosceles triangle has 1 because two sides match; a scalene triangle has none."),
    ("3","Three lines belong to the equilateral triangle, not the all-different scalene one."),
    ("2","No fold matches a scalene triangle's halves, so it has 0, not 2.")]),

 ("SY","A circle has this many lines of symmetry:",
   "infinitely many",
   C("Every line through the centre of a circle cuts it into two identical halves — and there are endlessly many such lines.")+
   steps("Draw any line through the centre","it splits the circle into matching halves","since there are countless such lines, there are infinitely many."),
   [("only 2","A circle is not limited to 2 — every diameter is a line of symmetry, so infinitely many."),
    ("only 4","Four is far too few; a circle has infinitely many lines of symmetry."),
    ("0","A circle is extremely symmetric — infinitely many lines, not none.")]),

 ("SY","The capital letter H has this many lines of symmetry:",
   "2",
   C("The letter H matches itself across a vertical fold and across a horizontal fold — two lines.")+
   steps("Fold H left-to-right: the halves match","fold H top-to-bottom: the halves match","so H has 2 lines of symmetry."),
   [("1","The letter A has 1; H matches across both a vertical and a horizontal fold, so 2."),
    ("0","H is symmetric — it has 2 lines, not none."),
    ("4","H matches across only the vertical and horizontal folds, giving 2 lines, not 4.")]),

 ("SY","When a figure looks exactly the same after being turned about its centre by less than a full turn, it has:",
   "rotational symmetry",
   C("Spin the shape part-way and if it looks unchanged, it has rotational symmetry.")+
   steps("Rotate the figure about its centre","stop before a full 360° turn","if it looks identical, it has rotational symmetry."),
   [("line symmetry only","Line symmetry is about folding; looking the same after a turn is rotational symmetry."),
    ("no symmetry","Looking the same after a partial turn is exactly what rotational symmetry means."),
    ("translation symmetry","Translation is sliding; this is about turning, so it is rotational symmetry.")]),

 ("SY","Turning a square about its centre through one full revolution, the number of times it lands exactly on itself is:",
   "4",
   C("Turn a square and it matches itself at 90°, 180°, 270° and 360° — four matching positions in one full turn.")+
   steps("Rotate the square through a full turn","it coincides with itself at 90°, 180°, 270°, 360°","that is 4 positions — order 4."),
   [("2","A rectangle has order 2; a square matches at every 90°, giving order 4."),
    ("1","Order 1 means it matches only after a full turn; a square matches four times."),
    ("8","A square matches itself 4 times in a full turn, so its order is 4, not 8.")]),

 ("SY","The smallest angle through which an equilateral triangle must be turned to look the same is:",
   "120°",
   C("An equilateral triangle has rotational order 3, so 360° ÷ 3 = 120° brings it back onto itself.")+
   steps("Its rotational order is 3","divide a full turn by the order: 360° ÷ 3","the smallest matching angle is 120°."),
   [("90°","90° is the square's turning angle; the triangle's is 360° ÷ 3 = 120°."),
    ("60°","Turning 60° does not yet match the triangle; the smallest is 120°."),
    ("180°","180° matches a rectangle; the equilateral triangle needs 120°.")]),

 ("SY","A regular polygon with n equal sides always has this many lines of symmetry:",
   "n",
   C("Each side and each vertex of a regular n-gon gives a matching fold — exactly n lines of symmetry.")+
   steps("A regular polygon has n equal sides","each contributes one symmetry fold","so it has n lines of symmetry."),
   [("2 always","Only special quadrilaterals have 2; a regular n-gon has n lines, growing with n."),
    ("n − 1","A regular n-gon has n lines, not one fewer."),
    ("always 4","Only the square gives 4; a regular n-gon has n lines in general.")]),

 ("SY","A regular hexagon (6 equal sides) has this many lines of symmetry:",
   "6",
   C("Being a regular 6-gon, it has exactly 6 lines of symmetry — one for each side/vertex pairing.")+
   steps("A regular n-gon has n lines of symmetry","here n = 6","so the hexagon has 6 lines."),
   [("3","Three is half too few; a regular hexagon has 6 lines of symmetry."),
    ("12","A regular hexagon has 6 lines of symmetry (its rotational order is 6 as well), not 12."),
    ("2","Two lines belong to a rectangle; a regular hexagon has 6.")]),

 ("SY","A plain parallelogram (not a rectangle or rhombus) has 0 lines of symmetry but its order of rotational symmetry is:",
   "2",
   C("A slanted parallelogram cannot be folded to match, yet a half-turn (180°) brings it back onto itself — rotational order 2.")+
   steps("No fold matches its slanted halves, so 0 lines","but turn it 180° about its centre","it lands on itself — rotational order 2."),
   [("0","Although it has no fold-symmetry, a half-turn matches it, so its rotational order is 2, not 0."),
    ("4","Only a square reaches order 4; a plain parallelogram matches just twice."),
    ("1","Order 1 would mean no partial-turn match; the parallelogram matches at 180°, so order 2.")]),

 ("SY","A line of symmetry behaves exactly like a mirror because each half is the reflection of the other. This links symmetry directly to:",
   "the mirror image idea from Light",
   C("FUSION: a fold line is a mirror — one half is the laterally-reversed reflection of the other, just like a plane mirror's image.")+
   steps("Place a mirror along the line of symmetry","the visible half plus its reflection rebuilds the whole figure","so a symmetry line is really a mirror line."),
   [("the heating effect of current","Heating belongs to electricity; a symmetry line is a mirror line, tied to Light."),
    ("the area of a circle","Area is a size, not a reflection; symmetry lines connect to mirror images."),
    ("the boiling of water","Boiling is unrelated; a line of symmetry mirrors one half onto the other.")]),

 ("SY","The mirror image of the digit-display word made by a square's four matching positions shows the square also has rotational symmetry of order:",
   "4",
   C("A square coincides with itself at four turn positions in one revolution — order 4, matching its 4 lines of symmetry.")+
   steps("Turn the square through 360°","it matches itself at 90°, 180°, 270°, 360°","that is order 4."),
   [("2","A rectangle is order 2; the square's equal sides push it to order 4."),
    ("1","A square matches four times in a turn, so its order is 4, not 1."),
    ("3","Order 3 belongs to the equilateral triangle; a square is order 4.")]),

 ("SY","Which capital letter has a horizontal line of symmetry but NOT a vertical one?",
   "E",
   C("Fold E top-to-bottom and the halves match; fold it left-to-right and they do not — horizontal symmetry only.")+
   steps("Fold E across the middle row: halves match (horizontal line)","fold E down the middle: halves do not match","so E has only a horizontal line of symmetry."),
   [("A","A has a vertical line of symmetry, not a horizontal one."),
    ("H","H has both a horizontal and a vertical line, not just horizontal."),
    ("T","T has only a vertical line of symmetry, the opposite of E.")]),

 ("SY","The number of lines of symmetry of a rhombus (a slanted diamond with 4 equal sides) is:",
   "2",
   C("A rhombus folds onto itself along its two diagonals only — two lines of symmetry.")+
   steps("Fold along the long diagonal: halves match","fold along the short diagonal: halves match","its sides' midlines do NOT match, so exactly 2 lines."),
   [("4","Only a square (a special rhombus) reaches 4; a slanted rhombus has just its 2 diagonals."),
    ("1","A rhombus has two diagonal folds, not one."),
    ("0","A rhombus is symmetric along both diagonals, giving 2 lines, not none.")]),

 ("SY","An isosceles triangle (exactly two equal sides) has this many lines of symmetry:",
   "1",
   C("The single fold down from the apex between the two equal sides matches the halves — exactly one line.")+
   steps("Fold from the top vertex straight down","the two equal sides match across the fold","that is the only matching fold — 1 line."),
   [("0","A scalene triangle has 0; the two equal sides of an isosceles triangle give it 1 line."),
    ("3","Three lines belong to the equilateral triangle; an isosceles one has just 1."),
    ("2","An isosceles triangle has a single line of symmetry, not 2.")]),

 ("SY","A figure whose order of rotational symmetry is 1 actually means the figure:",
   "looks the same only after a full 360° turn",
   C("Order 1 is the lowest — the shape matches itself only once per full turn, i.e. it has no real rotational symmetry.")+
   steps("Rotate the figure through a whole 360°","it matches itself only at the end","so its order is 1 — effectively no rotational symmetry."),
   [("matches itself every 90°","Matching every 90° is order 4, not order 1."),
    ("has four lines of symmetry","Order of rotation is about turning, not the count of fold lines."),
    ("cannot be drawn","Order-1 figures are perfectly ordinary; they just match only after a full turn.")]),

 ("SY","The English capital letter with the GREATEST number of lines of symmetry among A, H, O, T is:",
   "O",
   C("O (drawn as a circle/oval) matches across many folds — far more than A (1), H (2) or T (1).")+
   steps("A has 1, T has 1, H has 2","O folds to match across a vertical and horizontal line at least","O has the most lines of symmetry of the four."),
   [("A","A has just one vertical line; O has more."),
    ("H","H has 2 lines, but O (circular) has even more."),
    ("T","T has only one line; O has the greatest number.")]),

 ("SY","A semicircle (half a disc) has this many lines of symmetry:",
   "1",
   C("Only the fold straight down through the middle of the flat edge matches a semicircle's halves — exactly one line.")+
   steps("Fold the semicircle down its centre, perpendicular to the straight edge","the two quarter-discs match","that single fold is its only line of symmetry."),
   [("0","A semicircle does have one centre fold that matches; it is not asymmetric."),
    ("infinitely many","A full circle has infinitely many lines; cutting it in half leaves just 1."),
    ("2","A semicircle has only the one perpendicular centre fold — 1 line, not 2.")]),

 ("SY","A regular pentagon (5 equal sides) has its order of rotational symmetry equal to:",
   "5",
   C("A regular n-gon has rotational order n; for a pentagon n = 5, so it matches itself 5 times in a full turn.")+
   steps("A regular polygon's rotational order equals its number of sides","a pentagon has 5 sides","so its order of rotational symmetry is 5."),
   [("4","Four would be a square; the pentagon's five sides give order 5."),
    ("1","A regular pentagon matches itself five times per turn, not just once."),
    ("10","A regular pentagon has order 5 (and 5 lines of symmetry), not 10.")]),

 ("SY","Among these shapes — scalene triangle, square, rhombus, rectangle — the one with the MOST lines of symmetry is the:",
   "square",
   C("Square 4, rhombus 2, rectangle 2, scalene triangle 0 — the square wins with four lines.")+
   steps("Count each: scalene 0, rectangle 2, rhombus 2","the square has 4","so the square has the most lines of symmetry."),
   [("rhombus","A rhombus has 2 lines; the square has 4 — more."),
    ("rectangle","A rectangle has 2 lines; the square's equal sides give it 4."),
    ("scalene triangle","A scalene triangle has 0 lines — the fewest, not the most.")]),

 ("SY","The capital letter B has a single line of symmetry, and that line is:",
   "horizontal",
   C("Fold B top-to-bottom and the two bumps match across the middle row — its one line of symmetry is horizontal.")+
   steps("Fold B across the middle, top onto bottom: the halves match","fold it left-to-right: the round side and straight side do not match","so B's only line of symmetry is horizontal."),
   [("vertical","Folding B down the middle does not match the curved right onto the flat left; its line is horizontal."),
    ("diagonal","B has no slanted matching fold; its single line of symmetry is horizontal."),
    ("both horizontal and vertical","Only the horizontal fold matches B; the vertical fold does not, so it has just one line.")]),
]

# ---------- PERIMETER & AREA (25) — Maths ----------
PA = [
 ("PA","The perimeter of any flat figure is the total length of its:",
   "boundary all the way around",
   C("Perimeter is the distance you would walk going right around the edge of a shape.")+
   steps("Start at one point on the boundary","walk all the way around the edge","the total length covered is the perimeter."),
   [("inside region","The inside region is the area; perimeter is the boundary length."),
    ("longest side only","Perimeter adds every side, not just the longest one."),
    ("two diagonals","Diagonals cross the inside; perimeter is the distance around the outside.")]),

 ("PA","The perimeter of a rectangle of length l and breadth b is:",
   "2 × (l + b)",
   C("Add one length and one breadth, then double — a rectangle has two of each.")+
   steps("A rectangle has 2 lengths and 2 breadths","sum is l + b + l + b","which is 2 × (l + b)."),
   [("l × b","l × b is the area, not the perimeter, of a rectangle."),
    ("l + b","l + b is only half the way around; the perimeter is double that."),
    ("4 × l","4 × l would be a square of side l, not a rectangle of length l and breadth b.")]),

 ("PA","If every side of a square measures s, then the total distance around its boundary works out to:",
   "4 × s",
   C("All four sides of a square are equal, so the perimeter is simply four times one side.")+
   steps("A square has 4 equal sides","each is length s","total boundary = 4 × s."),
   [("s × s","s × s is the area of the square, not its perimeter."),
    ("2 × s","Two sides is only half the square; the perimeter uses all four sides."),
    ("s + 4","You multiply the side by 4, you do not add 4 to it.")]),

 ("PA","To find how much surface a rectangle of length l and breadth b covers, you compute:",
   "l × b",
   C("Area counts the unit squares that fill the rectangle — length times breadth.")+
   steps("The rectangle is l units long and b units wide","it holds l × b unit squares","so its area is l × b."),
   [("2 × (l + b)","That is the perimeter; the area is l × b."),
    ("l + b","Adding the sides gives a length, not an area; area is l × b."),
    ("4 × l","4 × l is a perimeter-like length, not the area l × b.")]),

 ("PA","A square sheet of card measures 6 cm along each edge; the surface it covers is:",
   "36 cm²",
   C("Area of a square is side × side, so 6 × 6 = 36 square centimetres.")+
   steps("Area of a square = side × side","= 6 × 6","= 36 cm²."),
   [("24 cm²","24 cm is the perimeter (4 × 6), not the area; the area is 6 × 6 = 36."),
    ("12 cm²","12 is just 6 + 6; the area needs 6 × 6 = 36 cm²."),
    ("36 cm","Area is measured in square units (cm²), so the answer is 36 cm², not 36 cm.")]),

 ("PA","The area of a triangle with base b and height h is:",
   "½ × b × h",
   C("A triangle is exactly half of the rectangle that would surround it, so its area is half of base times height.")+
   steps("Build a rectangle of base b and height h","the triangle is half of it","so its area is ½ × b × h."),
   [("b × h","b × h is the full rectangle; a triangle is only half of that."),
    ("b + h","Adding base and height gives a length, not an area."),
    ("2 × b × h","A triangle's area is half b×h, not double it.")]),

 ("PA","The area of a parallelogram is found by multiplying its base by its:",
   "height (perpendicular distance)",
   C("A parallelogram can be cut and slid into a rectangle of the same base and height, so area = base × height.")+
   steps("Slide a triangle from one end to the other","the parallelogram becomes a rectangle","its area is base × perpendicular height."),
   [("slanted side","The slant side is longer than the true height; area uses the perpendicular height."),
    ("two diagonals","Diagonals are not used for a parallelogram's area; base × height is."),
    ("perimeter","Perimeter is the boundary length; the area is base × height.")]),

 ("PA","The distance once around a circle is called its:",
   "circumference",
   C("A circle has no straight sides, so its 'perimeter' has a special name — the circumference.")+
   steps("Walk once around the circle's edge","there are no corners","that total distance is the circumference."),
   [("diameter","The diameter is the straight distance across the circle, not around it."),
    ("radius","The radius is centre-to-edge, far less than the distance all the way around."),
    ("area","Area is the space inside; the distance around is the circumference.")]),

 ("PA","The circumference of a circle of radius r is given by:",
   "2 × π × r",
   C("Circumference is π times the diameter, and the diameter is 2r, so it equals 2πr.")+
   steps("Circumference = π × diameter","diameter = 2r","so circumference = 2 × π × r."),
   [("π × r²","π r² is the area of the circle, not its circumference."),
    ("π × r","Circumference uses the full diameter 2r, giving 2πr, not πr."),
    ("2 × r","2r is the diameter, a straight line; the way around is π times longer.")]),

 ("PA","The area of a circle of radius r is:",
   "π × r²",
   C("The space inside a circle is π times the square of its radius.")+
   steps("Use the area rule for a circle","square the radius and multiply by π","area = π × r²."),
   [("2 × π × r","2πr is the circumference (distance around), not the area inside."),
    ("π × r","Area needs r squared; πr is neither the area nor the circumference."),
    ("π × d","π × diameter is the circumference, not the area, which is π r².")]),

 ("PA","For school problems, the value of π is most often taken as:",
   "22/7",
   C("π is a never-ending decimal near 3.14; in Class 7 we usually use the handy fraction 22/7.")+
   steps("π ≈ 3.14159…","a convenient close fraction is 22 ÷ 7","so we take π = 22/7 in calculations."),
   [("7/22","π is a little more than 3, so it is 22/7, not the upside-down 7/22 (which is under 1)."),
    ("2/7","2/7 is far less than 1; π is about 3.14, i.e. 22/7."),
    ("22","π is about 3, not 22; the fraction 22/7 ≈ 3.14 is what we use.")]),

 ("PA","The perimeter of a rectangular field is 30 m and its length is 9 m. Its breadth is:",
   "6 m",
   C("Half the perimeter is l + b = 15; subtract the length 9 to get the breadth 6 m.")+
   steps("Perimeter = 2(l + b) = 30, so l + b = 15","l = 9","b = 15 − 9 = 6 m."),
   [("21 m","21 = 30 − 9 forgets to halve the perimeter first; l + b = 15, so b = 6."),
    ("12 m","12 m double-counts; from l + b = 15 and l = 9, b = 6 m."),
    ("3 m","3 m is too small; 15 − 9 = 6, not 3.")]),

 ("PA","Two shapes can have the SAME perimeter yet different areas. This shows that perimeter and area:",
   "measure different things",
   C("Perimeter measures the boundary length; area measures the inside space — equal boundaries can wrap very different areas.")+
   steps("Take a long thin rectangle and a fat one with equal perimeters","their inside spaces differ","so equal perimeter does not force equal area."),
   [("are always equal","They are not equal — they measure boundary versus inside, two different things."),
    ("are the same measurement","Perimeter is a length; area is a region — clearly different measurements."),
    ("cannot be compared","They can be compared per shape; the point is they can differ even with equal perimeter.")]),

 ("PA","One square metre (1 m²) equals this many square centimetres:",
   "10 000 cm²",
   C("Since 1 m = 100 cm, a square metre is 100 × 100 = 10 000 square centimetres.")+
   steps("1 m = 100 cm","1 m² = 100 cm × 100 cm","= 10 000 cm²."),
   [("100 cm²","100 is the side conversion; area needs 100 × 100 = 10 000 cm²."),
    ("1 000 cm²","1 m² is 100 × 100 = 10 000 cm², not 1 000."),
    ("1 000 000 cm²","That would be a square kilometre-style jump; 1 m² is 10 000 cm².")]),

 ("PA","The area of a right-angled triangle whose two perpendicular sides are 8 cm and 5 cm is:",
   "20 cm²",
   C("The two perpendicular sides serve as base and height, so area = ½ × 8 × 5 = 20 cm².")+
   steps("Take base = 8 cm and height = 5 cm","area = ½ × 8 × 5","= 20 cm²."),
   [("40 cm²","40 is 8 × 5, the full rectangle; the triangle is half, so 20 cm²."),
    ("13 cm²","13 is 8 + 5, a length; the area is ½ × 8 × 5 = 20 cm²."),
    ("20 cm","Area is in square units, so 20 cm², not 20 cm.")]),

 ("PA","The diameter of a circle whose radius is 7 cm is:",
   "14 cm",
   C("The diameter is twice the radius, so 2 × 7 = 14 cm.")+
   steps("Diameter = 2 × radius","= 2 × 7","= 14 cm."),
   [("7 cm","7 cm is the radius itself; the diameter is double that, 14 cm."),
    ("49 cm","49 is 7², used for area-style steps, not the diameter, which is 2 × 7 = 14."),
    ("3.5 cm","3.5 cm is half the radius; the diameter is twice the radius, 14 cm.")]),

 ("PA","A square garden has area 81 m². The length of each side is:",
   "9 m",
   C("Side × side = 81, and 9 × 9 = 81, so each side is 9 m.")+
   steps("Area of a square = side²","side² = 81","side = √81 = 9 m."),
   [("40.5 m","40.5 is half of 81; the side is the square root, √81 = 9 m."),
    ("18 m","18 is 81 ÷ 4.5 or a perimeter guess; the side is √81 = 9 m."),
    ("81 m","81 m is the area's number, not the side; the side is √81 = 9 m.")]),

 ("PA","The circumference of a circular flower bed of radius 7 m, taking π = 22/7, is:",
   "44 m",
   C("Circumference = 2πr = 2 × (22/7) × 7; the 7s cancel to give 2 × 22 = 44 m.")+
   steps("Circumference = 2 × (22/7) × 7","the 7 cancels: 2 × 22","= 44 m."),
   [("22 m","22 m forgets the factor of 2; 2 × 22 = 44 m."),
    ("154 m","154 = (22/7) × 7² is the AREA; the circumference is 2πr = 44 m."),
    ("14 m","14 m is just the diameter (2 × 7); the circumference is π times longer, 44 m.")]),

 ("PA","A circuit's wire bends right around a rectangular board 12 cm by 8 cm before returning to the cell. The length of wire forming that closed loop equals the:",
   "perimeter, 40 cm",
   C("FUSION: a circuit's closed loop is literally the boundary of the board, so the wire length is the perimeter 2(12+8)=40 cm.")+
   steps("The wire follows the board's edge all the way round and back","that closed loop is the board's perimeter","2 × (12 + 8) = 40 cm of wire."),
   [("area, 96 cm","96 cm² is the board's area; the wire follows the boundary, whose length is the perimeter 40 cm."),
    ("diagonal, 20 cm","The wire runs around the edge, not across a diagonal; its length is the perimeter, 40 cm."),
    ("half-perimeter, 20 cm","A full closed loop is the whole perimeter 40 cm, not half of it.")]),

 ("PA","A square plane mirror has a side of 15 cm. The reflecting glass surface you can see covers an area of:",
   "225 cm²",
   C("FUSION: the mirror's shiny face is a square, so its area is side² = 15 × 15 = 225 cm².")+
   steps("The reflecting face is a square of side 15 cm","area of a square = side × side","= 15 × 15 = 225 cm²."),
   [("60 cm²","60 cm is the perimeter (4 × 15), not the area; the area is 15 × 15 = 225 cm²."),
    ("30 cm²","30 is just 15 + 15; the surface area is 15 × 15 = 225 cm²."),
    ("225 cm","Surface area is in square units, so 225 cm², not 225 cm.")]),

 ("PA","To fence a square plot of side 25 m, the length of fencing needed is the plot's:",
   "perimeter, 100 m",
   C("Fencing runs around the boundary, so its length is the perimeter — 4 × 25 = 100 m.")+
   steps("Fencing follows the boundary","perimeter of a square = 4 × side","= 4 × 25 = 100 m."),
   [("area, 625 m","625 m² is the land inside; fencing follows the boundary, so 100 m of perimeter."),
    ("side, 25 m","One side is only a quarter of the way around; the full fence is 4 × 25 = 100 m."),
    ("diagonal, 50 m","Fencing goes around the edge, not across; the perimeter is 100 m.")]),

 ("PA","A rectangle has area 48 cm² and length 8 cm. Its breadth is:",
   "6 cm",
   C("Breadth = area ÷ length, so 48 ÷ 8 = 6 cm.")+
   steps("Area = length × breadth","breadth = area ÷ length = 48 ÷ 8","= 6 cm."),
   [("40 cm","40 = 48 − 8 wrongly subtracts; breadth = 48 ÷ 8 = 6 cm."),
    ("384 cm","384 = 48 × 8 wrongly multiplies; you divide to get 6 cm."),
    ("12 cm","12 cm is too big; 48 ÷ 8 = 6, not 12.")]),

 ("PA","The area of a circular coin of radius 7 mm, taking π = 22/7, is:",
   "154 mm²",
   C("Area = πr² = (22/7) × 7 × 7; one 7 cancels, leaving 22 × 7 = 154 mm².")+
   steps("Area = (22/7) × 7²","= (22/7) × 49 = 22 × 7","= 154 mm²."),
   [("44 mm²","44 mm is the circumference (2πr), not the area, which is πr² = 154 mm²."),
    ("22 mm²","22 mm² drops a factor of 7; πr² = (22/7) × 49 = 154 mm²."),
    ("49 mm²","49 is just r²; you must still multiply by π, giving 154 mm².")]),

 ("PA","A photo 10 cm by 6 cm is given a uniform border 1 cm wide all around. The outer rectangle (photo + border) measures:",
   "12 cm by 8 cm",
   C("A 1 cm border adds 1 cm to every edge, so it adds 2 cm to each overall dimension: 10+2 by 6+2.")+
   steps("The border adds 1 cm on the left AND 1 cm on the right → +2 cm to length","same for top and bottom → +2 cm to breadth","outer size = 12 cm by 8 cm."),
   [("11 cm by 7 cm","Adding only 1 cm forgets the border on the opposite side; each dimension grows by 2 cm."),
    ("10 cm by 6 cm","That is the photo alone; with the border each side grows, giving 12 by 8 cm."),
    ("14 cm by 10 cm","A 1 cm border adds 2 cm per dimension, not 4; the outer size is 12 by 8 cm.")]),

 ("PA","The number of square tiles, each of side 1 m, needed to cover a floor 4 m long and 3 m wide is:",
   "12",
   C("Each 1 m tile covers 1 m²; the floor's area is 4 × 3 = 12 m², so 12 tiles fill it exactly.")+
   steps("Floor area = length × breadth = 4 × 3 = 12 m²","each tile covers 1 m²","so 12 ÷ 1 = 12 tiles are needed."),
   [("14","14 is the perimeter 2(4+3); the number of tiles is the area 4 × 3 = 12."),
    ("7","7 is just 4 + 3; the tile count is the area 4 × 3 = 12."),
    ("24","24 doubles the area; the floor is 4 × 3 = 12 m², so 12 tiles, not 24.")]),
]

# ---------- USE-CASE TAILS (25 each) ----------
LI_UC = [
 "Straight-line travel of light is why a torch beam makes a sharp-edged spot on a wall.",
 "Knowing you see by reflected light explains why a dark room hides everything until you switch on a lamp.",
 "Understanding opaque shadows is how a sundial tells the time from a stick's shadow.",
 "Equal incidence-and-reflection angles let you aim a torch off a mirror to light a hidden corner.",
 "Knowing a mirror keeps your size is why a dressing mirror shows you true-to-life.",
 "Lateral inversion is why the word in your shirt's mirror reflection reads backwards.",
 "Knowing mirror images are virtual explains why you can never catch your reflection on paper behind the glass.",
 "Concave mirrors are why a shaving or makeup mirror shows an enlarged face up close.",
 "Convex mirrors at shop corners and on cars let you see a wide area in a small mirror.",
 "Dispersion is the science behind the rainbow you see after rain and in a garden spray.",
 "Knowing VIBGYOR lets you name every band of a rainbow correctly.",
 "Converging lenses are inside magnifying glasses, cameras, and the human eye.",
 "Knowing the Moon only reflects sunlight explains why it has phases and no light of its own.",
 "Real images are what land on a cinema screen and inside a camera.",
 "The inverted pinhole image is the simple idea behind every camera ever built.",
 "Convex rear-view mirrors are why a car's wing mirror shows so much of the road behind.",
 "Equal image distance is why you step back from a mirror and your reflection seems to step back too.",
 "Concave dentist's mirrors give a doctor a big, clear view of a small tooth.",
 "Diffuse reflection is why you can read this page from any angle without a blinding glare.",
 "Diverging lenses help correct short-sightedness in many people's spectacles.",
 "The reversed AMBULANCE word is read perfectly in a driver's rear-view mirror so they pull over.",
 "Repeated reflections between two mirrors create the dazzling patterns in a kaleidoscope.",
 "A convex-lens magnifier helps you read tiny print and examine small insects.",
 "Light needing no medium is why sunlight crosses empty space to warm the whole Earth.",
 "Periscopes let submarines and crowd-stuck spectators see over things in the way.",
]
EC_UC = [
 "Knowing a circuit must be a closed loop is the first thing you check when a torch won't light.",
 "Understanding switches is why one flick on the wall turns a whole room's light on or off.",
 "The heating effect is why an electric kettle and a hair-dryer get hot from current.",
 "Tungsten's high melting point is why old bulbs could glow for years without melting.",
 "Fuses are tiny guardians that melt to save your TV during an electrical surge.",
 "Oersted's magnetic effect is the seed of every electric motor and loudspeaker.",
 "Electromagnets let a scrapyard crane pick up and drop tonnes of iron at the flick of a switch.",
 "The rapid on-off electromagnet is exactly how a school or doorbell rings.",
 "Knowing metals conduct is why electricians use copper wire to carry house current.",
 "Knowing rubber insulates is why wire coatings and tool handles keep you safe from shocks.",
 "Adding cells for a brighter bulb is why a big torch with more batteries shines farther.",
 "Knowing a battery is joined cells explains the row of AAs inside a remote or toy.",
 "Reading the cell symbol's long line lets you wire a circuit the right way the first time.",
 "More coil turns is how engineers make electromagnets strong enough to lift cars.",
 "The heating effect is why a room heater and a clothes iron both warm up from current.",
 "Spotting a loose connection is the everyday fix when a bulb or charger suddenly stops working.",
 "Choosing CFL/LED over filament bulbs is why your electricity bill drops for the same brightness.",
 "A deflecting compass near a wire is the simple demo that current makes magnetism.",
 "Reading the switch symbol lets you understand any appliance's circuit diagram.",
 "Resettable MCBs are why a tripped home circuit just needs a flip, not a new fuse.",
 "The iron core is why an electromagnet can be far stronger than the bare coil alone.",
 "Joining positive-to-negative correctly is why a series of cells powers a device at full strength.",
 "Knowing a reversed cell cancels the push is why a torch stays dark with a battery in backwards.",
 "Knowing the body conducts is why we never touch bare wires or sockets with wet hands.",
 "Reading circuit diagrams is the skill that lets you understand and repair any simple gadget's wiring.",
]
SY_UC = [
 "Spotting mirror-image halves is how you check a paper butterfly was folded evenly.",
 "Naming the line of symmetry helps you design a balanced logo or rangoli pattern.",
 "Knowing a square has 4 lines is why floor tiles look identical however you turn them.",
 "A rectangle's 2 lines explain why a door looks the same flipped top-to-bottom but not corner-to-corner.",
 "Three lines of symmetry are why a traffic 'yield' triangle looks balanced from every side.",
 "Recognising a scalene triangle's 0 lines warns you it will look lopsided in a design.",
 "A circle's endless symmetry is why wheels, plates, and coins look the same however they spin.",
 "Knowing H has 2 lines helps in puzzles about which letters read the same in a mirror.",
 "Rotational symmetry is why a ceiling fan or pinwheel looks unchanged as it spins.",
 "A square's order-4 turning is why a square stool fits its frame in any of four positions.",
 "The 120° turn of a triangle is the maths behind a three-blade fan looking steady.",
 "The n-lines rule lets you instantly say a regular octagon stop-sign has 8 lines of symmetry.",
 "A hexagon's 6 lines are why honeycomb cells pack so neatly and look identical.",
 "A parallelogram's order-2 spin shows up in slanted patterns that match after a half-turn.",
 "Seeing a symmetry line AS a mirror connects your maths fold to the reflections you studied in Light.",
 "The square's order-4 rotation is why a square photo frame hangs true any of four ways.",
 "Sorting letters like E by their symmetry line is handy for stencils and mirror-writing.",
 "A rhombus's 2 diagonal lines explain the balanced look of a diamond-shaped road sign.",
 "An isosceles triangle's single line is why a simple tent or roof looks evenly balanced.",
 "Order 1 reminds you a plain scribble has no rotational symmetry at all.",
 "Comparing letters' symmetry lines is a neat trick for designing readable mirrored signs.",
 "A semicircle's single line helps you fold a paper protractor or fan in half evenly.",
 "A pentagon's order-5 spin appears in star shapes and the classic football's panels.",
 "Comparing shapes' symmetry lines helps you pick the most balanced shape for a badge.",
 "Spotting a letter's single symmetry line is handy when designing stencils and mirror-readable signs.",
]
PA_UC = [
 "Knowing perimeter is the boundary length is how you measure ribbon to edge a board.",
 "The 2(l+b) rule tells a carpenter how much beading to buy for a rectangular photo frame.",
 "The 4 × side rule tells you the fencing needed around a square garden bed.",
 "Area = l × b is how you work out how much carpet covers a rectangular room.",
 "Side² is how you find the tiles needed to cover a square kitchen floor.",
 "Half-base-times-height is how you find the cloth in a triangular flag or bunting.",
 "Base × height tells a painter the area of a slanted parallelogram-shaped panel.",
 "Circumference is how you measure the trim needed around a round table top.",
 "2πr lets a wheelwright find how far a wheel rolls in one full turn.",
 "πr² is how you find the grass area of a circular park to order enough seed.",
 "Using π = 22/7 makes round-shape sums quick and neat in exams and at home.",
 "Finding a missing side from the perimeter helps you plan a field's dimensions from a fixed fence.",
 "Knowing equal-perimeter shapes can differ in area helps you pick the roomiest pen for the same fence.",
 "The m²-to-cm² conversion is vital when a plan is in metres but tiles come in centimetres.",
 "Half-base-times-height with the legs is the fast way to find a right-triangular plot's area.",
 "Doubling the radius for the diameter is how you check if a round lid fits a jar's mouth.",
 "Taking the square root of the area gives the side of a square plot from its land size.",
 "2πr with π = 22/7 quickly gives the edging for a circular flower bed.",
 "Seeing a circuit's wire loop AS a perimeter links your electricity wiring to boundary maths.",
 "Treating a square mirror's face AS an area links the Light chapter to your area formula.",
 "The perimeter-as-fencing idea is how farmers cost the wire around a square field.",
 "Breadth = area ÷ length is how you find a room's width from its floor area and length.",
 "πr² for a coin shows why a wider coin uses more metal than a narrow one.",
 "Adding a uniform border is how you size a mount or frame around a photograph.",
 "Counting unit tiles over a floor's area is exactly how you order the right number of tiles for a room.",
]


def _with_uc(lst, ucs):
    assert len(lst) == len(ucs) == 25, (len(lst), len(ucs))
    out = []
    for it, uc in zip(lst, ucs):
        code, stem, correct, html, distr = it
        out.append((code, stem, correct, html + U(uc), distr))
    return out


LI = _with_uc(LI, LI_UC)
EC = _with_uc(EC, EC_UC)
SY = _with_uc(SY, SY_UC)
PA = _with_uc(PA, PA_UC)

items = []
for i in range(25):
    items += [LI[i], EC[i], SY[i], PA[i]]
assert len(items) == 100

for a, b in zip(items, items[1:]):
    assert a[0] != b[0], (a[1], b[1])


def fingerprint(stem):
    words = re.sub(r"[^\w\s]", "", stem.lower()).split()
    return " ".join(words[:14])


if __name__ == "__main__":
    here = os.path.dirname(os.path.abspath(__file__))
    papers_dir = os.path.abspath(os.path.join(
        here, "..", "..", "desktopAhaan", "Resources", "BossChallengePapers"))

    # ---- fingerprint collision guard against the running index ----
    idx_path = os.path.join(papers_dir, "QUESTION_INDEX.json")
    with open(idx_path, encoding="utf-8") as fh:
        idx = json.load(fh)
    existing = set(idx.get("fingerprints", []))

    new_fps = [fingerprint(it[1]) for it in items]
    dupe_internal = {f for f in new_fps if new_fps.count(f) > 1}
    assert not dupe_internal, ("internal dup fingerprints", dupe_internal)
    clash = [f for f in new_fps if f in existing]
    assert not clash, ("fingerprint clash with existing index", clash)

    os.chdir(papers_dir)

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=39017,
                          append_manifest=False)

    subdir = f"Paper_{PNUM}_{SHORT}"
    moves = {
        "QuestionPaper.html": f"Paper_{PNUM}_{SHORT}_QuestionPaper.html",
        "QuestionPaper.pdf":  f"Paper_{PNUM}_{SHORT}_QuestionPaper.pdf",
        "Questions.md":       f"Paper_{PNUM}_{SHORT}_Questions.md",
        "Solutions.html":     f"Paper_{PNUM}_{SHORT}_Solutions.html",
    }
    for src, dst in moves.items():
        shutil.move(os.path.join(subdir, src), dst)
    os.rmdir(subdir)

    counts = {}
    for ch, *_ in items:
        counts[ch] = counts.get(ch, 0) + 1
    split = "/".join(str(counts[c]) for c in ("LI", "EC", "SY", "PA"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Light",
                     "Electric Current & its Effects",
                     "Symmetry",
                     "Perimeter & Area"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
