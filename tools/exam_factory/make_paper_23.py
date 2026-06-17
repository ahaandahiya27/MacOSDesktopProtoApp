# -*- coding: utf-8 -*-
# Boss Challenge Paper 23 — Light · Lines & Angles · Respiration in Organisms · Integers
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans into FUSION — many Lines-&-Angles items are wrapped in a
# real Light situation (a ray striking a mirror, the angle of incidence vs reflection, the
# normal at 90° to the surface), and many Integers items are wrapped in a Respiration /
# temperature situation (a freezer warming, a temperature drop, a diver's depth). The child
# reads a Science context and applies a Maths skill. Class-7 scope, simple wording, hard
# thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_23_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_23_<SHORT>_QuestionPaper.pdf
#   Paper_23_<SHORT>_Questions.md
#   Paper_23_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U, LIME

PNUM  = "23"
SHORT = "Light_LinesAngles_Respiration_Integers"
TITLE = ("Light · Lines & Angles · Respiration in Organisms · Integers")
LABELS = {
    "LI": "Light",
    "LA": "Lines & Angles",
    "RE": "Respiration in Organisms",
    "IN": "Integers",
}

# A tiny reflection diagram (pure SVG, no dependency) for the law-of-reflection items.
MIRROR = ('<svg viewBox="0 0 200 110" class="dgm" style="max-width:200px">'
          '<line x1="20" y1="90" x2="180" y2="90" stroke="#666" stroke-width="3"/>'
          '<line x1="100" y1="20" x2="100" y2="90" stroke="#999" stroke-dasharray="4 3"/>'
          '<line x1="40" y1="30" x2="100" y2="90" stroke="#e07" stroke-width="2"/>'
          '<line x1="100" y1="90" x2="160" y2="30" stroke="#07a" stroke-width="2"/>'
          '<text x="46" y="28" font-size="8" fill="#e07">incident ray</text>'
          '<text x="120" y="28" font-size="8" fill="#07a">reflected ray</text>'
          '<text x="103" y="34" font-size="8" fill="#999">normal</text>'
          '<text x="30" y="104" font-size="8" fill="#666">angle of incidence = angle of reflection (from the normal)</text>'
          '</svg>')

# ---------- LIGHT (25) — Science ----------
LI = [
 ("LI","Light from a torch travels from the bulb to the wall along a path that is:",
   "a straight line",
   C("Light travels in straight lines; this is called the rectilinear propagation of light.")+
   steps("Light leaves the source","With nothing to bend it","it travels straight ahead in a line.")+
   U("A torch beam in a dusty room shows up as a perfectly straight shaft of light."),
   [("a wavy curve","Light does not naturally wiggle along; in air it travels in straight lines."),
    ("a circle","Light does not loop round in a circle; it goes straight from the source to the wall."),
    ("a zig-zag","Undisturbed light does not zig-zag; it travels in a straight line.")]),

 ("LI","The bouncing back of light when it falls on a shiny surface such as a mirror is called:",
   "reflection",
   C("Reflection is the bouncing back of light from a surface.")+
   steps("Light strikes a shiny surface","It does not pass through","so it bounces back — reflection.")+
   U("You see yourself in a mirror because light bounces — reflects — off it back to your eyes."),
   [("refraction","Refraction is the bending of light as it passes INTO a new material, not its bouncing back."),
    ("dispersion","Dispersion is white light splitting into colours; the bouncing back is reflection."),
    ("absorption","Absorption is light being soaked up and lost; bouncing back is reflection.")]),

 ("LI","When a ray of light reflects from a plane mirror, the angle of incidence is always:",
   "equal to the angle of reflection",
   C("The law of reflection says the angle of incidence equals the angle of reflection.")+
   steps("The incoming ray makes an angle with the normal","The bounced ray makes another angle","and the law says these two are equal.")+MIRROR+
   U("A snooker ball off a cushion, like light off a mirror, leaves at the same angle it arrived."),
   [("twice the angle of reflection","The two angles are EQUAL, not double; angle of incidence = angle of reflection."),
    ("always ninety degrees","The angle is not fixed at 90°; whatever the incidence, the reflection equals it."),
    ("always zero","The angle is zero only for a ray hitting straight on; in general incidence equals reflection.")]),

 ("LI","The image of your face in a flat bathroom mirror is described as:",
   "virtual, erect and the same size",
   C("A plane mirror gives a virtual, upright image that is the same size as the object.")+
   steps("The image cannot be caught on a screen — it is virtual","It is the right way up — erect","and it is exactly as big as you are.")+
   U("Your reflection in a flat mirror is life-size, upright, and only seems to be behind the glass."),
   [("real and upside down","A plane-mirror image is virtual and upright, not a real inverted one."),
    ("smaller than your face","A flat mirror gives a same-size image, not a shrunken one — that is a convex mirror."),
    ("larger than your face","A flat mirror does not magnify; the image is exactly the same size as you.")]),

 ("LI","When you raise your right hand before a plane mirror, the image seems to raise the hand on your left. This swapping of left and right is called:",
   "lateral inversion",
   C("Lateral inversion is the left-right swapping of an image in a plane mirror.")+
   steps("You raise your right hand","Your mirror image raises the hand on your left","this left-right swap is lateral inversion.")+
   U("The word AMBULANCE is painted reversed on the van so it reads correctly in a driver's mirror."),
   [("magnification","Magnification is a change in size; the left-right swap is lateral inversion."),
    ("dispersion","Dispersion is the splitting of white light into colours, not the left-right swap."),
    ("refraction","Refraction is the bending of light; the left-right reversal in a mirror is lateral inversion.")]),

 ("LI","In a plane mirror, an object placed 30 cm in front of the mirror forms its image at:",
   "30 cm behind the mirror",
   C("In a plane mirror the image is as far behind the mirror as the object is in front.")+
   steps("Object distance in front = 30 cm","The image sits the same distance the other side","so it is 30 cm behind the mirror.")+
   U("Step back from a mirror and your reflection seems to step back by exactly the same amount."),
   [("30 cm in front of the mirror","The image lies BEHIND the mirror, not in front with the object; 30 cm behind."),
    ("15 cm behind the mirror","The image distance equals the object distance, so it is 30 cm, not 15 cm, behind."),
    ("60 cm behind the mirror","The image is the SAME distance as the object (30 cm), not double, behind the mirror.")]),

 ("LI","A mirror whose reflecting surface curves inwards, like the inside of a spoon, is a:",
   "concave mirror",
   C("A concave mirror curves inwards and can gather light to a point.")+
   steps("Look at the bowl side of a shiny spoon","Its surface curves inward","that inward-curving mirror is concave.")+
   U("A dentist uses a small concave mirror to see an enlarged image of a tooth."),
   [("convex mirror","A convex mirror bulges OUTWARDS; the inward-curving one is concave."),
    ("plane mirror","A plane mirror is flat; the inward-curving spoon-bowl shape is a concave mirror."),
    ("lens","A lens is a transparent bender of light, not a curved reflecting mirror.")]),

 ("LI","The mirror used as a vehicle's rear-view mirror, because it gives a small upright image and a wide view, is a:",
   "convex mirror",
   C("A convex mirror always gives a small, upright image and shows a wide area behind.")+
   steps("A driver needs to see a wide area behind","A convex mirror shrinks the view to fit more in","so it is used as the rear-view mirror.")+
   U("The wide, slightly shrunken view in a car's side mirror comes from its convex shape."),
   [("concave mirror","A concave mirror can give a large or inverted image; the wide-view rear mirror is convex."),
    ("plane mirror","A plane mirror shows a same-size image and a narrower view; vehicles use a convex mirror."),
    ("magnifying glass","A magnifying glass is a convex lens, not the mirror used for the rear view, which is convex.")]),

 ("LI","A transparent piece of glass, thicker in the middle than at the edges, that bends light to a point is a:",
   "convex lens",
   C("A convex lens is thick in the middle and converges (brings together) the light passing through it.")+
   steps("Light passes through the transparent glass","The thick middle bends the rays inward","so the convex lens brings them to a point.")+
   U("A magnifying glass is a convex lens; held in the sun it can focus light to a tiny hot spot."),
   [("concave lens","A concave lens is THINNER in the middle and spreads light out, the opposite of converging."),
    ("plane mirror","A plane mirror reflects light; a lens lets light through and bends it — the convex lens converges it."),
    ("convex mirror","A convex mirror reflects and spreads light; the converging glass that light passes through is a convex lens.")]),

 ("LI","White sunlight passing through a glass prism spreads out into a band of seven colours. This splitting of white light is called:",
   "dispersion",
   C("Dispersion is the splitting of white light into its seven colours by a prism.")+
   steps("White light is really many colours mixed","A prism bends each colour by a different amount","so the colours fan out — dispersion.")+
   U("A glass prism on a sunny windowsill throws a little rainbow across the wall by dispersion."),
   [("reflection","Reflection is light bouncing back; the splitting of white light into colours is dispersion."),
    ("absorption","Absorption is light being soaked up; the fanning out into colours is dispersion."),
    ("lateral inversion","Lateral inversion is the left-right mirror swap, not the splitting of white light.")]),

 ("LI","The correct order of the seven colours of the rainbow, from the inner to the outer edge, begins with violet and ends with:",
   "red",
   C("The rainbow runs violet, indigo, blue, green, yellow, orange, red — ending in red.")+
   steps("Remember VIBGYOR","V is violet at one end","and R, red, is at the other end.")+
   U("In a rainbow after rain, the topmost broad band you notice is red, the last colour in VIBGYOR."),
   [("white","White is the mixture of all the colours, not one of the seven; the band ends in red."),
    ("black","Black is the absence of light, not a rainbow colour; the order ends in red."),
    ("violet","Violet is at the START of VIBGYOR; the order ENDS with red.")]),

 ("LI","A rainbow appears in the sky after rain because tiny water droplets in the air act like prisms and cause:",
   "dispersion of sunlight",
   C("Raindrops split sunlight into its colours by dispersion, forming the rainbow.")+
   steps("Sunlight is white, a mix of colours","Each raindrop bends the colours by different amounts","so sunlight disperses into a rainbow.")+
   U("A rainbow needs both sunshine and raindrops, because the drops disperse the sunlight."),
   [("absorption of sunlight","If the drops absorbed the light there would be no colours; the rainbow is made by dispersion."),
    ("reflection of moonlight","A daytime rainbow comes from sunlight dispersed by raindrops, not moonlight."),
    ("the Sun changing colour","The Sun stays white; the colours appear because raindrops disperse its light.")]),

 ("LI","An image that can be caught and shown on a screen, like the picture from a cinema projector, is called a:",
   "real image",
   C("A real image is one that can actually be formed on a screen.")+
   steps("Light rays really meet at the image point","Place a screen there","and the image shows up — it is real.")+
   U("The picture thrown onto a cinema screen is a real image made by a convex lens."),
   [("virtual image","A virtual image CANNOT be caught on a screen, like the one in a plane mirror; the cinema image is real."),
    ("mirror image","'Mirror image' is not the term for a screen image; one caught on a screen is a real image."),
    ("shadow","A shadow is a dark patch where light is blocked, not an image formed on a screen.")]),

 ("LI","To measure the angle of incidence of a ray striking a mirror, the angle is taken between the ray and:",
   "the normal",
   C("Angles of incidence and reflection are always measured from the normal — the line at 90° to the mirror.")+
   steps("Draw the perpendicular line at the point the ray hits","This line is the normal","measure the ray's angle from it.")+MIRROR+
   U("In the lab you draw a normal first, then measure how far the incoming ray leans from it."),
   [("the mirror surface itself","Angles are measured from the NORMAL, not flat along the mirror surface."),
    ("the edge of the table","The table edge is irrelevant; the angle is measured from the normal to the mirror."),
    ("the reflected ray","The angle of incidence is measured from the normal, not from the reflected ray.")]),

 ("LI","We are able to see a non-luminous object, such as a book, because the book:",
   "reflects light into our eyes",
   C("Non-luminous objects do not make their own light; we see them by the light they reflect to our eyes.")+
   steps("The book makes no light of its own","Light from a lamp or the Sun falls on it","it reflects that light into our eyes, so we see it.")+
   U("In a totally dark room you cannot see a book until some light shines on it to be reflected."),
   [("makes its own light","A book is non-luminous — it makes no light of its own; we see it by reflected light."),
    ("absorbs all the light","If it absorbed all light it would look black and unseen; we see it by the light it reflects."),
    ("bends light through itself","A book is not transparent; we see it because it reflects light to our eyes.")]),

 ("LI","A concave mirror is used by a dentist to look at a tooth because, held close, it gives an image that is:",
   "enlarged and upright",
   C("Held close to an object, a concave mirror gives a magnified, upright image — handy for a close look.")+
   steps("The dentist holds the small mirror near the tooth","A concave mirror then enlarges the view","showing a bigger, upright image of the tooth.")+
   U("A concave shaving or make-up mirror enlarges your face so you can see fine detail."),
   [("smaller and upside down","Held close, the concave mirror enlarges the image; it does not shrink and invert it."),
    ("the same size as the tooth","A flat mirror gives a same-size image; the concave mirror enlarges, which is why the dentist uses it."),
    ("coloured like a rainbow","A mirror does not split light into colours; the close concave mirror simply enlarges the image.")]),

 ("LI","Light falling straight onto a mirror, exactly along the normal, reflects back along the same path. Its angle of incidence is:",
   "zero degrees",
   C("If a ray travels along the normal, it makes a 0° angle with it and bounces straight back.")+
   steps("The ray lies right on the normal","So the angle between ray and normal is 0°","and it reflects straight back the way it came.")+
   U("Shine a torch straight down at a flat mirror and the beam bounces straight back up at you."),
   [("ninety degrees","A 90° ray would skim flat along the mirror; a ray along the normal makes 0°."),
    ("forty-five degrees","45° would send the ray off sideways; straight along the normal the angle is 0°."),
    ("one hundred eighty degrees","180° is not a valid angle of incidence; a ray on the normal makes 0°.")]),

 ("LI","A concave lens, which is thinner in the middle than at its edges, affects passing light by:",
   "spreading the rays apart",
   C("A concave lens is a diverging lens — it spreads light rays outward.")+
   steps("The lens is thin in the middle, thick at the edges","Light bends away from the thinner centre","so the rays spread apart — diverge.")+
   U("Spectacles for short-sighted people use concave lenses that spread light before it enters the eye."),
   [("bringing the rays to a point","Bringing rays together is what a CONVEX lens does; a concave lens spreads them apart."),
    ("bouncing the rays straight back","Bouncing back is reflection from a mirror; a concave lens lets light through and spreads it."),
    ("splitting the rays into colours","Splitting into colours is dispersion by a prism; a concave lens simply spreads the rays.")]),

 ("LI","A flat, smooth, polished surface gives a clear sharp image, while a rough wall does not, because a rough surface scatters light in:",
   "many different directions",
   C("A rough surface scatters reflected light all over, so no clear image forms.")+
   steps("On a smooth mirror, parallel rays stay neatly parallel after bouncing","On a rough wall the rays bounce every which way","scattered light cannot form a sharp image.")+
   U("You see your face in polished glass but not in a brick wall, which scatters the light."),
   [("one single direction","A smooth mirror keeps rays orderly; a ROUGH surface scatters them in many directions."),
    ("a perfect circle","Scattered light does not form a circle; it simply goes off in many directions."),
    ("the colours of the rainbow","Scattering is about direction, not colour; the rough surface sends light in many directions.")]),

 ("LI","The image formed in a plane mirror is called virtual because the light rays:",
   "only appear to come from behind the mirror",
   C("A plane-mirror image is virtual: rays do not really meet behind the mirror, they only appear to.")+
   steps("Reflected rays spread out in front of the mirror","Traced backwards, they seem to start behind it","but no light is really there — so the image is virtual.")+
   U("Your reflection looks like it is behind the glass, yet nothing is actually there — it is virtual."),
   [("actually meet on a screen behind it","If they really met, the image would be real; in a plane mirror they only appear to meet, so it is virtual."),
    ("are completely absorbed by the glass","The rays are reflected, not absorbed; the image is virtual because they only appear to come from behind."),
    ("split into seven colours","No colour-splitting is involved; the image is virtual because the rays only seem to come from behind.")]),

 ("LI","When a beam of light passes from air into a glass slab, it bends. This bending of light on entering a new material is called:",
   "refraction",
   C("Refraction is the bending of light as it passes from one transparent material into another.")+
   steps("Light changes speed entering the glass","This change of speed bends its path","that bending is refraction.")+
   U("A straw in a glass of water looks bent at the surface because of the refraction of light."),
   [("reflection","Reflection is light bouncing back off a surface, not bending as it enters glass — that is refraction."),
    ("dispersion","Dispersion is the splitting of white light into colours; the simple bending on entry is refraction."),
    ("transparency","Transparency just means light can pass through; the bending as it passes in is refraction.")]),

 ("LI","A magnifying glass that makes small print look bigger is, in fact, a:",
   "convex lens",
   C("A magnifying glass is a convex lens that produces an enlarged image of nearby print.")+
   steps("Hold a convex lens close to small text","The lens enlarges the image you see","that is how a magnifying glass works.")+
   U("Holding a magnifying glass over an insect makes it look much larger — it is a convex lens."),
   [("concave lens","A concave lens makes things look smaller; a magnifying glass is a convex lens."),
    ("plane mirror","A plane mirror gives a same-size image; the magnifier that enlarges print is a convex lens."),
    ("glass prism","A prism splits light into colours; the magnifier that enlarges print is a convex lens.")]),

 ("LI","If a ray of light strikes a plane mirror at an angle of incidence of 50°, the angle of reflection will be:",
   "50 degrees",
   C("By the law of reflection, the angle of reflection equals the angle of incidence.")+
   steps("Angle of incidence = 50°","Law of reflection: reflection equals incidence","so the angle of reflection is also 50°.")+MIRROR+
   U("Aim a laser pointer at a mirror at 50° and it bounces off at the very same 50°."),
   [("40 degrees","40° would be the angle to the mirror SURFACE; measured from the normal the reflection equals 50°."),
    ("100 degrees","100° is the angle between the two rays, not the angle of reflection, which equals 50°."),
    ("25 degrees","The reflection is not half the incidence; it EQUALS it, so it is 50°.")]),

 ("LI","Objects that give out their own light, such as the Sun and a glowing bulb, are described as:",
   "luminous",
   C("Luminous objects produce their own light; the Sun, a flame and a lit bulb are luminous.")+
   steps("Some objects make light themselves","Others only reflect borrowed light","the light-makers are luminous.")+
   U("At night a candle is luminous, while the table it stands on is seen only by the candle's light."),
   [("non-luminous","Non-luminous objects do NOT make their own light, like a book or the Moon; the Sun is luminous."),
    ("transparent","Transparent means light passes through, like clear glass; making its own light is being luminous."),
    ("opaque","Opaque means light cannot pass through; an object that makes its own light is luminous.")]),

 ("LI","A convex mirror is preferred over a plane mirror as a shop security or rear-view mirror mainly because it:",
   "covers a wider area",
   C("A convex mirror bulges out and shows a much wider area than a flat mirror of the same size.")+
   steps("A convex mirror's curved surface spreads the view","More of the scene fits into the same mirror","so it covers a wider area.")+
   U("The big round convex mirror at a shop corner lets the shopkeeper watch the whole aisle at once."),
   [("magnifies everything","A convex mirror SHRINKS the image; its value is the wide view, not magnification."),
    ("shows a real image on a screen","A convex mirror's image is virtual and cannot go on a screen; its merit is the wider view."),
    ("splits light into colours","A mirror does not split light into colours; the convex mirror is chosen for its wide view.")]),
]

# ---------- LINES & ANGLES (25) — Maths (with fusion stems) ----------
LA = [
 ("LA","Two rays that start from the same end-point together form a figure called a/an:",
   "angle",
   C("An angle is formed by two rays sharing a common end-point, the vertex.")+
   steps("Take two rays","Join them at one common end-point","the opening between them is an angle.")+
   U("The hands of a clock, joined at the centre, make an angle that changes through the day."),
   [("triangle","A triangle is a closed figure with three sides; two rays from a point make just an angle."),
    ("circle","A circle is a round closed curve, not the figure made by two rays from a point."),
    ("line segment","A line segment is a straight piece with two end-points; two rays from one point make an angle.")]),

 ("LA","An angle that measures exactly 90 degrees is called a:",
   "right angle",
   C("A right angle measures exactly 90°, like the corner of a square.")+
   steps("Look at the corner of a book","It opens to exactly 90°","that is a right angle.")+
   U("The corner where two walls of a room meet is a right angle of 90°."),
   [("straight angle","A straight angle is 180°, a flat line; the 90° corner is a right angle."),
    ("acute angle","An acute angle is LESS than 90°; exactly 90° is a right angle."),
    ("reflex angle","A reflex angle is more than 180°; the 90° corner is a right angle.")]),

 ("LA","An angle that is greater than 0 degrees but less than 90 degrees is called:",
   "an acute angle",
   C("An acute angle is smaller than a right angle — between 0° and 90°.")+
   steps("Compare the angle with a 90° corner","If it is smaller than 90°","it is acute.")+
   U("The sharp tip of a slice of pizza makes an acute angle, narrower than a square corner."),
   [("an obtuse angle","An obtuse angle is BIGGER than 90°; a small angle under 90° is acute."),
    ("a right angle","A right angle is exactly 90°; an angle smaller than that is acute."),
    ("a straight angle","A straight angle is 180°; an angle under 90° is acute.")]),

 ("LA","An angle that is greater than 90 degrees but less than 180 degrees is called:",
   "an obtuse angle",
   C("An obtuse angle is bigger than a right angle but less than a straight angle.")+
   steps("Compare with 90° and with 180°","If it is between the two","it is obtuse.")+
   U("A laptop opened well past upright makes an obtuse angle between screen and keyboard."),
   [("an acute angle","An acute angle is LESS than 90°; one between 90° and 180° is obtuse."),
    ("a right angle","A right angle is exactly 90°; a wider one up to 180° is obtuse."),
    ("a reflex angle","A reflex angle is more than 180°; one between 90° and 180° is obtuse.")]),

 ("LA","Two angles whose measures add up to exactly 90 degrees are called:",
   "complementary angles",
   C("Complementary angles are a pair that together make a right angle, 90°.")+
   steps("Add the two angle measures","If the total is 90°","the angles are complementary.")+
   U("If you split a 90° corner into two parts, those two parts are complementary angles."),
   [("supplementary angles","Supplementary angles add to 180°, not 90°; a pair adding to 90° is complementary."),
    ("vertically opposite angles","Vertically opposite angles are equal pairs made by crossing lines, not a pair adding to 90°."),
    ("reflex angles","A reflex angle is a single angle over 180°; a pair adding to 90° is complementary.")]),

 ("LA","Two angles whose measures add up to exactly 180 degrees are called:",
   "supplementary angles",
   C("Supplementary angles are a pair that together make a straight angle, 180°.")+
   steps("Add the two angle measures","If the total is 180°","the angles are supplementary.")+
   U("The two angles on a straight road sign split by a pole add to 180° — they are supplementary."),
   [("complementary angles","Complementary angles add to 90°, not 180°; a pair adding to 180° is supplementary."),
    ("equal angles","Supplementary angles need not be equal; they only have to add to 180°."),
    ("acute angles","Two acute angles add to less than 180°; a pair that totals 180° is supplementary.")]),

 ("LA","The complement of an angle of 30 degrees is an angle of:",
   "60 degrees",
   C("Complementary angles add to 90°, so the complement of 30° is 90° − 30°.")+
   steps("Complement means the two add to 90°","90° − 30°","= 60°.")+
   U("Splitting a 90° corner so one part is 30° leaves the other part as its 60° complement."),
   [("70 degrees","70° + 30° = 100°, not 90°; the complement of 30° is 60°."),
    ("150 degrees","150° + 30° = 180°, which is the SUPPLEMENT; the complement is 60°."),
    ("30 degrees","30° + 30° = 60°, not 90°; the complement of 30° is 60°.")]),

 ("LA","The supplement of an angle of 110 degrees is an angle of:",
   "70 degrees",
   C("Supplementary angles add to 180°, so the supplement of 110° is 180° − 110°.")+
   steps("Supplement means the two add to 180°","180° − 110°","= 70°.")+
   U("On a straight line, an angle of 110° leaves 70° beside it — its supplement."),
   [("90 degrees","90° + 110° = 200°, not 180°; the supplement of 110° is 70°."),
    ("80 degrees","80° + 110° = 190°, not 180°; the supplement is 70°."),
    ("250 degrees","An angle inside a pair cannot be 250°; the supplement of 110° is 70°.")]),

 ("LA","When two straight lines cross, the pair of angles that lie exactly opposite each other across the crossing point are:",
   "always equal",
   C("Vertically opposite angles, formed when two lines cross, are always equal.")+
   steps("Two lines cross at a point","They make two pairs of opposite angles","each opposite pair is equal.")+
   U("The opposite angles made by an open pair of scissors are always equal to each other."),
   [("always 90 degrees","Vertically opposite angles are equal to each other but need not be 90° unless the lines are perpendicular."),
    ("always adding to 90 degrees","Opposite angles are EQUAL, not complementary; it is the adjacent pair that adds up (to 180°)."),
    ("always different","Vertically opposite angles are never different — they are always equal.")]),

 ("LA","A ray of light strikes a mirror with an angle of incidence of 40°. Using the law that the reflected angle equals it, the angle of reflection is:",
   "40 degrees",
   C("The angle of reflection equals the angle of incidence, so 40° in gives 40° out.")+
   steps("Angle of incidence = 40° (measured from the normal)","Reflection equals incidence","so the angle of reflection = 40°.")+MIRROR+
   U("A torch beam hitting a mirror at 40° to the normal leaves at the same 40°."),
   [("50 degrees","50° would be the angle to the mirror surface; measured from the normal the reflection is 40°."),
    ("80 degrees","80° is the angle between the incident and reflected rays, not the reflection, which is 40°."),
    ("20 degrees","The reflection is not half the incidence; it equals it, so 40°.")]),

 ("LA","A light ray hits a mirror so that its angle of incidence is 30°. The total angle between the incident ray and the reflected ray is:",
   "60 degrees",
   C("Both rays make 30° with the normal on either side, so the angle between them is 30° + 30°.")+
   steps("Incident ray is 30° from the normal","Reflected ray is also 30° from the normal, the other side","total between the rays = 30° + 30° = 60°.")+MIRROR+
   U("The wider the ray leans, the bigger the V it makes with its reflection; at 30° each side, that V is 60°."),
   [("30 degrees","30° is each ray's angle from the normal; the angle BETWEEN the two rays is double, 60°."),
    ("90 degrees","90° would need each ray at 45°; at 30° each side the angle between is 60°."),
    ("15 degrees","15° is half of one angle; the angle between the rays is 30° + 30° = 60°.")]),

 ("LA","Two adjacent angles that together lie along a straight line form a linear pair, and they always add up to:",
   "180 degrees",
   C("The angles of a linear pair sit on a straight line and add to 180°.")+
   steps("A straight line is a straight angle of 180°","Split it into two adjacent angles","those two add back to 180°.")+
   U("Where a leaning ladder meets the flat ground, the two angles beside it add up to 180°."),
   [("90 degrees","90° is a right angle; a linear pair on a straight line adds to 180°."),
    ("360 degrees","360° is a full turn; two angles forming a straight line add to 180°."),
    ("60 degrees","A linear pair always totals 180°, not 60°.")]),

 ("LA","Two straight lines in the same plane that never meet, however far they are extended, are called:",
   "parallel lines",
   C("Parallel lines stay the same distance apart and never meet.")+
   steps("Draw two straight lines that keep an equal gap","Extend them as far as you like","they never cross — they are parallel.")+
   U("The two rails of a railway track are parallel lines that run side by side without meeting."),
   [("intersecting lines","Intersecting lines DO cross at a point; lines that never meet are parallel."),
    ("perpendicular lines","Perpendicular lines cross at 90°; lines that never meet at all are parallel."),
    ("curved lines","Parallel lines are straight; the term for straight lines that never meet is parallel.")]),

 ("LA","A straight line that cuts across two or more other lines is called a:",
   "transversal",
   C("A transversal is a line that crosses two or more lines at different points.")+
   steps("Draw two lines","Then draw a line cutting across both","that crossing line is the transversal.")+
   U("A road that cuts across two parallel railway tracks acts like a transversal."),
   [("bisector","A bisector cuts an angle or segment into two equal parts; a line crossing others is a transversal."),
    ("perpendicular","A perpendicular meets a line at 90°; a line cutting across several lines is a transversal."),
    ("diagonal","A diagonal joins corners of a figure; a line crossing two other lines is a transversal.")]),

 ("LA","When a transversal crosses two parallel lines, each pair of corresponding angles is:",
   "equal",
   C("Corresponding angles formed by a transversal cutting parallel lines are equal.")+
   steps("A transversal crosses two parallel lines","Angles in matching positions are corresponding","and for parallel lines they are equal.")+
   U("Builders use the equal corresponding angles of parallel beams to keep their cuts matching."),
   [("always 90 degrees","Corresponding angles are equal to each other but are 90° only if the transversal is perpendicular."),
    ("adding to 90 degrees","Corresponding angles are EQUAL, not complementary; they do not generally add to 90°."),
    ("always different","For parallel lines, corresponding angles are equal, never simply different.")]),

 ("LA","When a transversal crosses two parallel lines, a pair of co-interior (allied) angles on the same side adds up to:",
   "180 degrees",
   C("Co-interior angles between two parallel lines are supplementary, adding to 180°.")+
   steps("Look at the two interior angles on the same side of the transversal","For parallel lines they are allied","and they add to 180°.")+
   U("The two same-side inner angles between parallel railings add to a straight 180°."),
   [("90 degrees","Co-interior angles add to 180°, not 90°."),
    ("360 degrees","A full turn is 360°; the same-side interior pair between parallel lines adds to 180°."),
    ("equal, whatever the size","Co-interior angles are supplementary (add to 180°), not necessarily equal.")]),

 ("LA","In a reflection experiment, the normal is drawn perpendicular to the mirror. The angle between the flat mirror surface and the normal is:",
   "90 degrees",
   C("The normal is by definition perpendicular to the mirror, so it makes a 90° angle with the surface.")+
   steps("Perpendicular means at a right angle","The normal stands perpendicular to the mirror","so the angle between them is 90°.")+MIRROR+
   U("When you stand a pencil straight up on a flat mirror, it makes a 90° normal with the surface."),
   [("45 degrees","The normal is perpendicular, not slanted at 45°; the angle with the surface is 90°."),
    ("180 degrees","180° is a flat straight line; the upright normal makes 90° with the mirror."),
    ("0 degrees","0° would mean the normal lies flat on the mirror; instead it stands at 90°.")]),

 ("LA","A light ray makes an angle of 20° with the flat surface of a mirror. Since angles of incidence are measured from the normal, the angle of incidence is:",
   "70 degrees",
   C("The normal is 90° from the surface, so an angle of 20° to the surface is 90° − 20° from the normal.")+
   steps("Angle to the mirror surface = 20°","Angle from the normal = 90° − 20°","= 70°, the angle of incidence.")+MIRROR+
   U("A ray skimming low to a mirror, only 20° above it, actually leans 70° away from the upright normal."),
   [("20 degrees","20° is measured from the SURFACE; the angle of incidence is taken from the normal, so 70°."),
    ("90 degrees","90° would be flat along the mirror; from the normal the incidence is 90° − 20° = 70°."),
    ("110 degrees","An angle of incidence cannot exceed 90°; here it is 90° − 20° = 70°.")]),

 ("LA","One of two complementary angles is 55 degrees. The other angle must be:",
   "35 degrees",
   C("Complementary angles add to 90°, so the second is 90° − 55°.")+
   steps("The two add to 90°","90° − 55°","= 35°.")+
   U("Split a 90° corner so one slice is 55° and the leftover slice is its 35° complement."),
   [("45 degrees","45° + 55° = 100°, not 90°; the complement of 55° is 35°."),
    ("125 degrees","125° + 55° = 180° — that is the supplement; the complement is 35°."),
    ("55 degrees","Two 55° angles add to 110°, not 90°; the complement of 55° is 35°.")]),

 ("LA","Two angles form a linear pair. If one of them is 125 degrees, the other is:",
   "55 degrees",
   C("A linear pair adds to 180°, so the second angle is 180° − 125°.")+
   steps("Linear pair adds to 180°","180° − 125°","= 55°.")+
   U("A leaning signpost makes 125° on one side of the ground line and 55° on the other."),
   [("65 degrees","65° + 125° = 190°, not 180°; the partner of 125° in a linear pair is 55°."),
    ("125 degrees","Two 125° angles add to 250°, far past 180°; the other angle is 55°."),
    ("45 degrees","45° + 125° = 170°, not 180°; the linear-pair partner is 55°.")]),

 ("LA","When two lines cross, one angle is found to be 65 degrees. The angle vertically opposite to it is:",
   "65 degrees",
   C("Vertically opposite angles are equal, so the opposite angle is also 65°.")+
   steps("Two crossing lines make opposite pairs","Vertically opposite angles are equal","so opposite 65° is 65°.")+
   U("Open a pair of scissors to 65° and the opposite gap between the handles is also 65°."),
   [("25 degrees","25° would be the complement of 65°, not its vertically opposite, which equals 65°."),
    ("115 degrees","115° is the ADJACENT angle (the linear-pair partner); the vertically opposite one is 65°."),
    ("90 degrees","Vertically opposite angles equal the original, so 65°, not a fixed 90°.")]),

 ("LA","A transversal crosses two parallel lines and one corresponding angle is 80 degrees. Its matching corresponding angle is:",
   "80 degrees",
   C("Corresponding angles between parallel lines are equal, so the match is also 80°.")+
   steps("The lines are parallel","Corresponding angles are equal for parallel lines","so the matching angle is 80°.")+
   U("In a ladder leaning on a wall, the equal corresponding angles keep each rung the same slant."),
   [("100 degrees","100° is the SUPPLEMENT (co-interior partner); the matching corresponding angle equals 80°."),
    ("10 degrees","10° is the complement of 80°, not its corresponding angle, which equals 80°."),
    ("90 degrees","Corresponding angles equal the original 80°, not a fixed 90°.")]),

 ("LA","An angle whose measure is more than 180 degrees but less than 360 degrees is called:",
   "a reflex angle",
   C("A reflex angle is larger than a straight angle (180°) but less than a full turn (360°).")+
   steps("Compare with 180° and 360°","If it lies between the two","it is a reflex angle.")+
   U("The larger opening on the outside of a wide-open door is a reflex angle, more than 180°."),
   [("an obtuse angle","An obtuse angle is between 90° and 180°; one above 180° is a reflex angle."),
    ("a straight angle","A straight angle is exactly 180°; an angle bigger than that is reflex."),
    ("a right angle","A right angle is 90°; an angle over 180° is a reflex angle.")]),

 ("LA","Two angles are supplementary and one of them measures exactly 90 degrees. The other angle must be:",
   "90 degrees",
   C("Supplementary angles add to 180°, so the partner of 90° is 180° − 90°.")+
   steps("The two add to 180°","180° − 90°","= 90°.")+
   U("Two right-angle corners placed side by side along a straight edge add to a flat 180°."),
   [("0 degrees","0° is not an angle of a real pair; the supplement of 90° is 90°."),
    ("180 degrees","180° + 90° = 270°, far past 180°; the supplement of 90° is 90°."),
    ("45 degrees","45° + 90° = 135°, not 180°; the supplement of 90° is 90°.")]),

 ("LA","The figure made by a single straight, never-ending path with no thickness and no end-points is called a:",
   "line",
   C("A line is straight, has no thickness, and extends without end in both directions.")+
   steps("Start with a straight path","Let it run on forever both ways with no ends","that is a line.")+
   U("A perfectly straight, endless laser beam in space is a good picture of a geometric line."),
   [("line segment","A line segment has two definite END-points; a never-ending straight path is a line."),
    ("ray","A ray has one end-point and goes on one way only; a path endless both ways is a line."),
    ("angle","An angle is the opening between two rays, not a single endless straight path, which is a line.")]),
]

# ---------- RESPIRATION IN ORGANISMS (25) — Science ----------
RE = [
 ("RE","The process by which living things break down food to release the energy stored in it is called:",
   "respiration",
   C("Respiration is the breakdown of food inside the body to release its stored energy.")+
   steps("Food holds chemical energy","The body breaks the food down","releasing that energy — this is respiration.")+
   U("The energy that lets you run and think comes from respiration releasing energy from your food."),
   [("digestion","Digestion breaks food into simpler parts in the gut; releasing the energy from it is respiration."),
    ("transpiration","Transpiration is the loss of water vapour from plant leaves, not the release of energy from food."),
    ("germination","Germination is a seed sprouting; the release of energy from food is respiration.")]),

 ("RE","The gas that our body takes IN from the air during breathing, to help release energy, is:",
   "oxygen",
   C("We breathe in oxygen, which the body uses to release energy from food.")+
   steps("Air is drawn into the lungs","The body needs a gas to burn food for energy","that gas is oxygen, taken in from the air.")+
   U("A person trapped without fresh air struggles because the body needs the oxygen in it."),
   [("carbon dioxide","Carbon dioxide is breathed OUT as a waste, not taken in; we take in oxygen."),
    ("nitrogen","Nitrogen makes up most of the air but is not used in respiration; the body takes in oxygen."),
    ("hydrogen","Hydrogen is not the breathing gas; the body takes in oxygen to release energy.")]),

 ("RE","The waste gas that our body gives OUT when we breathe, and which turns lime water milky, is:",
   "carbon dioxide",
   C("Carbon dioxide is the waste gas produced in respiration and breathed out.")+
   steps("Respiration uses oxygen and makes a waste gas","That gas is breathed out","it is carbon dioxide, which clouds lime water.")+LIME+
   U("Breathing out through a straw into lime water turns it milky, showing the carbon dioxide you exhale."),
   [("oxygen","Oxygen is breathed IN and used up; the waste gas breathed out is carbon dioxide."),
    ("hydrogen","Hydrogen is not a product of respiration; the gas breathed out is carbon dioxide."),
    ("helium","Helium plays no part in breathing; the waste gas given out is carbon dioxide.")]),

 ("RE","Respiration that uses oxygen to break down food, as in humans, is called:",
   "aerobic respiration",
   C("Aerobic respiration uses oxygen to release energy from food.")+
   steps("Food is broken down","Oxygen takes part in the breakdown","this oxygen-using process is aerobic respiration.")+
   U("Sitting and breathing normally, your cells carry out aerobic respiration using the oxygen you inhale."),
   [("anaerobic respiration","Anaerobic respiration happens WITHOUT oxygen; the oxygen-using kind is aerobic."),
    ("transpiration","Transpiration is water vapour leaving a leaf, not an oxygen-using breakdown of food."),
    ("digestion","Digestion breaks food into simpler bits; the oxygen-using release of energy is aerobic respiration.")]),

 ("RE","When muscles work very hard during exercise and run short of oxygen, they release energy WITHOUT oxygen. This is called:",
   "anaerobic respiration",
   C("Anaerobic respiration releases energy from food without using oxygen.")+
   steps("Hard-working muscles use oxygen faster than it arrives","They switch to releasing energy without oxygen","that is anaerobic respiration.")+
   U("Sprinting flat out, your leg muscles briefly respire anaerobically when oxygen can't keep up."),
   [("aerobic respiration","Aerobic respiration NEEDS oxygen; respiration without oxygen is anaerobic."),
    ("photosynthesis","Photosynthesis is how plants make food using light, not how muscles release energy without oxygen."),
    ("evaporation","Evaporation is a liquid turning to vapour; releasing energy without oxygen is anaerobic respiration.")]),

 ("RE","In human beings, the main organs in which the exchange of gases with the air takes place are the:",
   "lungs",
   C("The lungs are the organs where oxygen enters the blood and carbon dioxide leaves it.")+
   steps("Air is breathed into the chest","A pair of organs exchange gases there","those organs are the lungs.")+
   U("Taking a deep breath fills your two lungs, where oxygen passes into your blood."),
   [("kidneys","Kidneys filter wastes from the blood to make urine; gas exchange happens in the lungs."),
    ("stomach","The stomach digests food; the exchange of breathing gases happens in the lungs."),
    ("liver","The liver does many jobs but does not exchange breathing gases; the lungs do that.")]),

 ("RE","The dome-shaped sheet of muscle below the lungs that moves down to help us breathe in is the:",
   "diaphragm",
   C("The diaphragm is the muscle below the lungs that flattens to draw air in and relaxes to push it out.")+
   steps("Breathing in needs more room in the chest","A muscle below the lungs moves down to make space","that muscle is the diaphragm.")+
   U("Hiccups are sudden jerks of the diaphragm, the breathing muscle beneath your lungs."),
   [("the windpipe","The windpipe is the tube carrying air to the lungs, not the muscle that moves to breathe; that is the diaphragm."),
    ("the heart","The heart pumps blood; the breathing muscle below the lungs is the diaphragm."),
    ("the ribs","The ribs are bones that protect the lungs; the dome-shaped breathing muscle is the diaphragm.")]),

 ("RE","The number of times a healthy person breathes in and out in one minute while resting is closest to:",
   "about 15 to 18 times",
   C("A resting person's breathing rate is roughly 15 to 18 breaths per minute.")+
   steps("Breathing is steady at rest","Counting full breaths for a minute","gives around 15 to 18.")+
   U("Sitting quietly and counting your breaths for a minute gives a number around 15 to 18."),
   [("about 2 times","Only 2 breaths a minute would be dangerously slow; the resting rate is about 15 to 18."),
    ("about 100 times","100 breaths a minute is far too fast for rest; the normal rate is about 15 to 18."),
    ("about 500 times","500 breaths a minute is impossible; a resting person breathes about 15 to 18 times.")]),

 ("RE","When yeast respires without oxygen, as in making bread and dough rise, it produces carbon dioxide and:",
   "alcohol",
   C("Yeast carries out anaerobic respiration (fermentation), making carbon dioxide and alcohol.")+
   steps("Yeast respires without oxygen","It breaks sugar down","producing carbon dioxide gas and alcohol.")+
   U("Bread dough rises because yeast releases carbon dioxide bubbles as it ferments the sugar."),
   [("oxygen","Yeast without air gives off carbon dioxide and alcohol; it does not produce oxygen."),
    ("pure water only","Fermentation by yeast gives carbon dioxide and alcohol, not just water."),
    ("salt","No salt is produced; yeast fermentation makes carbon dioxide and alcohol.")]),

 ("RE","The painful muscle cramp you sometimes feel after very hard exercise is caused by a build-up of:",
   "lactic acid",
   C("When muscles respire without enough oxygen, they make lactic acid, which causes cramp.")+
   steps("Hard exercise outpaces the oxygen supply","Muscles respire anaerobically","building up lactic acid that causes cramp.")+
   U("Aching, cramping legs after a hard sprint are due to lactic acid made by the working muscles."),
   [("extra oxygen","Cramp comes from a SHORTAGE of oxygen, not a surplus; the cause is lactic acid build-up."),
    ("pure water","Plain water does not cause cramp; the culprit is lactic acid from anaerobic respiration."),
    ("carbon dioxide stored in the bones","Carbon dioxide is breathed out, not stored in bones; muscle cramp is from lactic acid.")]),

 ("RE","The pipe that carries air from the nose and throat down towards the lungs is called the windpipe, or:",
   "trachea",
   C("The trachea, or windpipe, is the tube that carries air down towards the lungs.")+
   steps("Air enters through the nose","It travels down a tube to the chest","that tube is the trachea, or windpipe.")+
   U("Food 'going down the wrong way' means it has slipped towards the trachea instead of the food pipe."),
   [("oesophagus","The oesophagus carries FOOD to the stomach; the air tube to the lungs is the trachea."),
    ("artery","An artery carries blood, not air; the air tube to the lungs is the trachea."),
    ("xylem","Xylem is a water tube in plants, not the human air pipe, which is the trachea.")]),

 ("RE","Inside the lungs, the exchange of oxygen and carbon dioxide actually takes place in tiny balloon-like sacs called:",
   "alveoli",
   C("Alveoli are the tiny air sacs of the lungs where gases pass into and out of the blood.")+
   steps("Air travels deep into the lungs","It reaches countless tiny sacs","these alveoli exchange the gases with the blood.")+
   U("The lungs hold millions of tiny alveoli, giving a huge surface for taking in oxygen."),
   [("nostrils","Nostrils are the openings of the nose where air enters; the gas exchange sacs are the alveoli."),
    ("kidneys","Kidneys filter blood to make urine; the lung sacs that exchange gases are the alveoli."),
    ("stomata","Stomata are tiny pores on plant leaves; the human lung sacs are the alveoli.")]),

 ("RE","Fish are able to breathe under water because they take in oxygen dissolved in the water through their:",
   "gills",
   C("Fish breathe with gills, which take dissolved oxygen out of the water.")+
   steps("There is oxygen dissolved in water","Fish need an organ to take it in","their feathery gills do this.")+
   U("A fish opening and closing its gill covers is pushing water over its gills to breathe."),
   [("lungs","Most fish have no lungs; they breathe under water using gills."),
    ("leaves","Leaves belong to plants; fish breathe through their gills."),
    ("skin only","While some animals use skin, fish chiefly breathe through their gills.")]),

 ("RE","Insects such as the cockroach take air into their bodies through tiny holes along their sides called:",
   "spiracles",
   C("Spiracles are the small holes through which insects take air into their breathing tubes.")+
   steps("Insects have no lungs","Air enters through tiny side holes","these holes are the spiracles, leading to air tubes.")+
   U("A grasshopper breathes through rows of spiracles along its body, not through a nose."),
   [("nostrils","Insects do not have nostrils like ours; they take in air through spiracles."),
    ("gills","Gills are for water-breathing animals like fish; insects use spiracles."),
    ("stomata","Stomata are pores on plant leaves; the breathing holes of an insect are spiracles.")]),

 ("RE","Plants also respire, taking in oxygen and giving out carbon dioxide. In the leaves, the gases pass in and out mainly through tiny pores called:",
   "stomata",
   C("Stomata are tiny pores on leaves through which plants exchange gases.")+
   steps("Plants must exchange gases too","Leaves have tiny adjustable pores","these stomata let the gases in and out.")+
   U("Under a microscope a leaf shows many tiny mouth-like stomata that open to exchange gases."),
   [("alveoli","Alveoli are air sacs in animal lungs; the leaf pores are the stomata."),
    ("spiracles","Spiracles are breathing holes of insects; the leaf pores for gas exchange are stomata."),
    ("roots hairs","Root hairs absorb water from soil; the leaf pores for gases are the stomata.")]),

 ("RE","An earthworm has no lungs or gills. It takes in oxygen through its:",
   "moist skin",
   C("An earthworm breathes through its damp skin, letting oxygen pass straight into its body.")+
   steps("The earthworm has no lungs or gills","Oxygen can pass through a moist surface","so it breathes through its moist skin.")+
   U("Earthworms come to the surface after rain partly because waterlogged soil makes skin-breathing hard."),
   [("dry scales","An earthworm has no dry scales; it breathes through soft, moist skin."),
    ("feathers","Feathers belong to birds; an earthworm breathes through its moist skin."),
    ("a single lung","An earthworm has no lung at all; it breathes through its moist skin.")]),

 ("RE","Bubbling the air a person breathes out through clear lime water turns it milky. This simple test shows that exhaled air is rich in:",
   "carbon dioxide",
   C("Lime water turns milky with carbon dioxide, so the milkiness proves exhaled air is rich in it.")+
   steps("Lime water is a clear test liquid","It turns milky only with carbon dioxide","exhaled air turns it milky, so it is rich in carbon dioxide.")+LIME+
   U("This lime-water test is the classic way to show the air you breathe out carries carbon dioxide."),
   [("oxygen","Oxygen does not turn lime water milky; the milkiness shows carbon dioxide."),
    ("nitrogen","Nitrogen leaves lime water unchanged; the milky colour shows carbon dioxide."),
    ("water vapour","Although breath has water vapour, it is the carbon dioxide that turns lime water milky.")]),

 ("RE","When a person starts running fast, their breathing rate compared with when resting will:",
   "increase",
   C("Exercise makes the muscles need more oxygen, so breathing speeds up.")+
   steps("Running muscles demand more energy","More energy needs more oxygen","so the breathing rate increases.")+
   U("After dashing up the stairs you find yourself panting — breathing faster to get more oxygen."),
   [("decrease","Exercise SPEEDS breathing up to supply more oxygen; it does not slow it down."),
    ("stop altogether","Breathing never stops during exercise; it gets faster to meet the demand."),
    ("stay exactly the same","Active muscles need more oxygen, so breathing clearly speeds up, not stays the same.")]),

 ("RE","Word equation for aerobic respiration: glucose + oxygen → carbon dioxide + energy + ____. The missing product is:",
   "water",
   C("Aerobic respiration turns glucose and oxygen into carbon dioxide, water and energy.")+
   steps("Glucose reacts with oxygen","Energy is released for the body","along with carbon dioxide and water as products.")+
   U("Part of the moisture you breathe out is the water made when your cells respire."),
   [("more glucose","Glucose is USED UP in respiration, not produced; the missing product is water."),
    ("oxygen","Oxygen is a raw material that is used up, not made; the missing product is water."),
    ("nitrogen","Nitrogen takes no part in respiration; the missing product alongside carbon dioxide is water.")]),

 ("RE","Compared with the air we breathe in, the air we breathe out contains more carbon dioxide and more:",
   "water vapour",
   C("Exhaled air carries more carbon dioxide and more water vapour than the air taken in.")+
   steps("Respiration produces carbon dioxide and water","Both leave the body in the breath","so exhaled air has more carbon dioxide and water vapour.")+
   U("Breathe on a cold mirror and it fogs up, showing the extra water vapour in your breath."),
   [("oxygen","Exhaled air has LESS oxygen, since the body used some; it has more carbon dioxide and water vapour."),
    ("nitrogen","The amount of nitrogen barely changes; what rises is carbon dioxide and water vapour."),
    ("dust","Breathing does not add dust; exhaled air has more carbon dioxide and water vapour.")]),

 ("RE","Compared with aerobic respiration, anaerobic respiration releases:",
   "less energy from the same food",
   C("Without oxygen, food is not fully broken down, so anaerobic respiration releases less energy.")+
   steps("Aerobic respiration fully breaks food down with oxygen","Anaerobic respiration cannot finish the job","so it releases less energy from the same food.")+
   U("Sprinting anaerobically tires you quickly because that route squeezes out far less energy."),
   [("much more energy","Without oxygen the food is only partly used, so LESS energy comes out, not more."),
    ("exactly the same energy","Anaerobic respiration is less complete, so it gives less energy than aerobic, not the same."),
    ("no energy at all","Anaerobic respiration does release SOME energy — just less than aerobic respiration.")]),

 ("RE","The roots of a plant also need to respire. This is why plants growing in waterlogged soil may suffer, because the water:",
   "drives air out of the soil",
   C("Waterlogged soil has little air in its spaces, so roots cannot get the oxygen they need.")+
   steps("Roots need oxygen from air in the soil","Water filling the soil pushes the air out","so the roots are starved of oxygen.")+
   U("Over-watered potted plants often wilt because their roots are short of air in the soggy soil."),
   [("gives the roots extra oxygen","Water actually pushes air OUT of the soil, leaving roots short of oxygen, not richer in it."),
    ("makes the leaves respire faster","The problem is at the roots, where water drives out the air they need."),
    ("turns the roots into gills","Roots do not become gills; waterlogging harms them by driving air out of the soil.")]),

 ("RE","Before air reaches the lungs, the nose helps by warming the air and also:",
   "filtering out dust and germs",
   C("The nose warms, moistens and filters the incoming air, trapping dust and germs in tiny hairs and mucus.")+
   steps("Cold, dirty air would harm the lungs","The nose warms it and traps particles","so it filters out dust and germs before the lungs.")+
   U("Tiny hairs and sticky mucus in your nose catch dust, which is why breathing through the nose is healthier."),
   [("removing all the oxygen","The nose does not remove oxygen — the lungs need it; the nose filters out dust and germs."),
    ("adding carbon dioxide","The nose does not add carbon dioxide; it warms the air and filters dust and germs."),
    ("cooling the air right down","The nose WARMS cold air rather than chilling it, while filtering out dust and germs.")]),

 ("RE","All the energy released by respiration in living cells originally comes from the food, which in green plants is first made using the energy of:",
   "sunlight",
   C("Green plants trap sunlight to make food in photosynthesis; respiration later releases that stored energy.")+
   steps("Plants make food using sunlight","That food stores the Sun's energy","respiration later releases it — so it traces back to sunlight.")+
   U("The energy in the bread you eat traces back to sunlight captured by wheat plants."),
   [("moonlight","Moonlight is far too weak to make food; plants use sunlight, whose energy respiration later releases."),
    ("the soil's heat","Soil heat does not power food-making; green plants use sunlight."),
    ("wind","Wind does not give plants energy to make food; they use sunlight.")]),

 ("RE","A single-celled organism like Amoeba does not need special breathing organs because it can:",
   "exchange gases straight through its surface",
   C("An Amoeba is so tiny that oxygen and carbon dioxide pass directly across its cell surface.")+
   steps("The whole tiny cell touches the water around it","Gases simply diffuse in and out across the surface","so no breathing organ is needed.")+
   U("An Amoeba in pond water takes in oxygen straight through its surface, unlike a large animal with lungs."),
   [("hold its breath for hours","An Amoeba does not hold its breath; being tiny, it exchanges gases straight across its surface."),
    ("make its own oxygen inside","An Amoeba does not manufacture oxygen; it takes it in by diffusion across its surface."),
    ("grow tiny lungs when needed","An Amoeba never grows lungs; it simply exchanges gases through its surface.")]),
]

# ---------- INTEGERS (25) — Maths (with fusion stems) ----------
IN = [
 ("IN","The collection of numbers ... −3, −2, −1, 0, 1, 2, 3 ... which includes negatives, zero and positives, is called the:",
   "integers",
   C("Integers are the whole numbers together with their negatives and zero.")+
   steps("Start with the counting numbers","Add zero and the negative whole numbers","this whole set is the integers.")+
   U("A thermometer scale showing readings both above and below zero is a line of integers."),
   [("fractions","Fractions are parts of a whole like 1/2; the set including negatives and zero is the integers."),
    ("decimals","Decimals like 0.5 are not the named set; whole numbers with negatives and zero are the integers."),
    ("only the positive numbers","Integers include the NEGATIVES and zero too, not just the positive numbers.")]),

 ("IN","The value of (−5) + 3 is:",
   "−2",
   C("Adding a positive to a negative moves you to the right on the number line.")+
   steps("Start at −5","Move 3 steps right (adding 3)","you land on −2.")+
   U("Owing 5 rupees and then receiving 3 leaves you 2 rupees in debt, i.e. −2."),
   [("−8","−8 would be (−5) + (−3); adding +3 to −5 gives −2."),
    ("8","8 ignores the signs; (−5) + 3 is −2, not 8."),
    ("2","2 has the wrong sign; starting below zero, (−5) + 3 lands on −2.")]),

 ("IN","The value of (−7) + (−2) is:",
   "−9",
   C("Adding two negatives makes a bigger negative — you move further left.")+
   steps("Start at −7","Add another −2, moving 2 more steps left","you reach −9.")+
   U("Owing 7 rupees and then owing 2 more means you owe 9 rupees in all, i.e. −9."),
   [("−5","−5 would come from (−7) + 2; here we add −2, giving −9."),
    ("9","9 has the wrong sign; two negatives added give the negative −9."),
    ("5","5 ignores the signs; (−7) + (−2) is −9.")]),

 ("IN","The value of 8 + (−12) is:",
   "−4",
   C("Adding a negative larger than the positive carries you below zero.")+
   steps("Start at 8","Move 12 steps left (adding −12)","you pass zero and land on −4.")+
   U("Having 8 rupees and then spending 12 leaves you 4 rupees short, i.e. −4."),
   [("20","20 would be 8 + 12; adding −12 instead gives −4."),
    ("4","4 has the wrong sign; since 12 is bigger than 8, the answer is −4."),
    ("−20","−20 mishandles the signs; 8 + (−12) is −4.")]),

 ("IN","The value of (−6) − (−4) is:",
   "−2",
   C("Subtracting a negative is the same as adding its positive.")+
   steps("(−6) − (−4) becomes (−6) + 4","Start at −6 and move 4 right","you land on −2.")+
   U("Owing 6 rupees, then having a 4-rupee debt cancelled, leaves you owing just 2, i.e. −2."),
   [("−10","−10 would be (−6) + (−4); subtracting −4 means adding +4, giving −2."),
    ("10","10 ignores the signs; (−6) − (−4) is −2."),
    ("2","2 has the wrong sign; the result stays below zero at −2.")]),

 ("IN","The value of (−4) × (−3) is:",
   "12",
   C("The product of two negative numbers is positive.")+
   steps("Multiply the numbers: 4 × 3 = 12","Two minus signs make a plus","so (−4) × (−3) = +12.")+
   U("Cancelling 4 debts of 3 rupees each leaves you 12 rupees better off — a positive 12."),
   [("−12","Two negatives multiplied give a POSITIVE, so the answer is +12, not −12."),
    ("−7","−7 looks like an addition; multiplying gives 12."),
    ("7","7 comes from adding the numbers, not multiplying; (−4) × (−3) = 12.")]),

 ("IN","The value of (−5) × 4 is:",
   "−20",
   C("A negative times a positive gives a negative product.")+
   steps("Multiply the numbers: 5 × 4 = 20","One minus sign makes the answer negative","so (−5) × 4 = −20.")+
   U("Spending 5 rupees on each of 4 days leaves you 20 rupees down, i.e. −20."),
   [("20","One negative factor makes the product NEGATIVE, so −20, not +20."),
    ("−1","−1 looks like an addition (−5 + 4); multiplying gives −20."),
    ("−9","−9 is (−5) + (−4); the product (−5) × 4 is −20.")]),

 ("IN","The value of (−20) ÷ 5 is:",
   "−4",
   C("A negative divided by a positive gives a negative result.")+
   steps("Divide the numbers: 20 ÷ 5 = 4","One minus sign keeps the answer negative","so (−20) ÷ 5 = −4.")+
   U("Sharing a 20-rupee debt equally among 5 days is a 4-rupee debt each, i.e. −4."),
   [("4","One negative in the division makes the answer NEGATIVE, so −4, not +4."),
    ("−100","−100 is a multiplication mistake; dividing gives −4."),
    ("−15","−15 would be (−20) + 5; the quotient is −4.")]),

 ("IN","Dividing one negative by another, the value of (−36) ÷ (−9) works out to:",
   "4",
   C("A negative divided by a negative gives a positive result.")+
   steps("Divide the numbers: 36 ÷ 9 = 4","Two minus signs make a plus","so (−36) ÷ (−9) = +4.")+
   U("Splitting a shared loss neatly so both signs cancel leaves a clean positive 4."),
   [("−4","Two negatives in a division give a POSITIVE, so +4, not −4."),
    ("−45","−45 would come from adding; dividing gives 4."),
    ("324","324 is a multiplication slip; (−36) ÷ (−9) = 4.")]),

 ("IN","On a cold morning the temperature falls from 5 °C to −3 °C. The change in temperature is:",
   "a drop of 8 °C",
   C("The change is the new reading minus the old: (−3) − 5 = −8, a drop of 8 degrees.")+
   steps("Change = final − initial = (−3) − 5","(−3) − 5 = −8","the minus sign means a drop of 8 °C.")+
   U("Going from 5 °C down past zero to −3 °C is a total fall of 8 degrees."),
   [("a drop of 2 °C","Only counting to zero misses the part below it; from 5 to −3 is a drop of 8 °C, not 2."),
    ("a rise of 8 °C","The temperature FELL, so it is a drop of 8 °C, not a rise."),
    ("a drop of 15 °C","5 to −3 spans 8 degrees, not 15; it is a drop of 8 °C.")]),

 ("IN","During the day the temperature rises from −4 °C to 6 °C. The rise in temperature is:",
   "10 °C",
   C("The rise is the final reading minus the initial: 6 − (−4) = 6 + 4.")+
   steps("Rise = final − initial = 6 − (−4)","6 − (−4) = 6 + 4","= 10 °C.")+
   U("Warming from −4 °C up to 6 °C means the temperature climbed a full 10 degrees."),
   [("2 °C","2 °C ignores the distance below zero; from −4 to 6 is a 10-degree rise."),
    ("−10 °C","The temperature ROSE, so the change is +10 °C, not −10."),
    ("24 °C","6 and −4 are 10 apart, not 24; the rise is 10 °C.")]),

 ("IN","The additive inverse (opposite) of the integer −7 is:",
   "7",
   C("The additive inverse of a number is the number that adds to it to give zero.")+
   steps("We need a number that makes −7 into 0","−7 + 7 = 0","so the additive inverse of −7 is 7.")+
   U("Owing 7 rupees is cancelled exactly by gaining 7 rupees, the opposite of −7."),
   [("−7","−7 + (−7) = −14, not 0; the additive inverse of −7 is +7."),
    ("0","−7 + 0 = −7, not 0; the inverse that cancels −7 is 7."),
    ("1/7","1/7 is the reciprocal, used in multiplication; the additive inverse of −7 is 7.")]),

 ("IN","Which of these two integers is the greater: −2 or −8?",
   "−2",
   C("On the number line, the integer further to the right is greater; −2 lies right of −8.")+
   steps("Draw a number line","−2 sits closer to zero, to the right of −8","so −2 is the greater integer.")+
   U("A temperature of −2 °C is warmer (greater) than a colder −8 °C."),
   [("−8","−8 is further LEFT and colder, so it is the smaller integer; −2 is greater."),
    ("they are equal","−2 and −8 are different points on the line; −2 is the greater of the two."),
    ("neither, both are zero","Neither is zero; comparing them, −2 is the greater integer.")]),

 ("IN","On the number line, the integer −3 lies:",
   "to the left of 0",
   C("Negative integers sit to the left of zero on the number line.")+
   steps("Zero is the centre of the number line","Negative numbers are placed to its left","so −3 is to the left of 0.")+
   U("On a thermometer, −3 °C is marked below the zero, on the cold side."),
   [("to the right of 0","Positive numbers go right of zero; the negative −3 goes to the LEFT."),
    ("exactly on 0","−3 is three steps away from zero, not on it; it lies to the left of 0."),
    ("to the right of 5","−3 is far to the left even of 0, so certainly not right of 5; it is left of 0.")]),

 ("IN","When any integer is added to its own additive inverse, the result is always:",
   "0",
   C("A number plus its opposite cancels out exactly to zero.")+
   steps("Take any integer and its opposite, like 9 and −9","Add them: 9 + (−9)","the result is 0.")+
   U("Earning 9 rupees and then spending 9 leaves you exactly where you started — at 0."),
   [("1","A number plus its opposite is 0, not 1, because they cancel."),
    ("twice the number","Adding the OPPOSITE cancels the number to 0; adding the same number would double it."),
    ("always positive","The sum is exactly 0, which is neither positive nor negative.")]),

 ("IN","A deep-freezer is at −18 °C. If it warms up by 5 °C after the door is left open, its new temperature is:",
   "−13 °C",
   C("Warming by 5° adds 5 to the temperature: (−18) + 5.")+
   steps("Start at −18 °C","Warming adds: (−18) + 5","= −13 °C.")+
   U("A freezer at −18 °C that warms 5 degrees still sits well below zero, at −13 °C."),
   [("−23 °C","−23 would be COOLING by 5°; warming adds 5, giving −13 °C."),
    ("13 °C","The freezer is still below zero; (−18) + 5 = −13 °C, not +13."),
    ("−18 °C","Warming changes the reading; (−18) + 5 = −13 °C, not the same −18.")]),

 ("IN","Multiplying three negative ones together, the value of (−1) × (−1) × (−1) comes to:",
   "−1",
   C("Multiplying an odd number of negative ones gives a negative result.")+
   steps("(−1) × (−1) = +1","Then +1 × (−1) = −1","three minus signs (an odd number) give −1.")+
   U("Flipping a sign an odd number of times leaves it negative — the rule behind this answer."),
   [("1","Three negatives (an odd count) give −1, not +1; an even count would give +1."),
    ("−3","−3 comes from adding the −1s; multiplying three of them gives −1."),
    ("3","3 ignores the signs and the operation; the product is −1.")]),

 ("IN","The value of 0 × (−99) is:",
   "0",
   C("Any number multiplied by zero is zero.")+
   steps("Multiplication by 0 always gives 0","It does not matter that −99 is large or negative","0 × (−99) = 0.")+
   U("Zero packets of anything, however valuable, is worth nothing at all — exactly 0."),
   [("−99","Multiplying by 0 gives 0, not −99; the −99 is wiped out by the zero."),
    ("99","Any number times 0 is 0, so the answer is 0, not 99."),
    ("−1","0 × (−99) is exactly 0, not −1.")]),

 ("IN","The value of 4 − 9 is:",
   "−5",
   C("Subtracting a larger number from a smaller one gives a negative result.")+
   steps("Start at 4","Move 9 steps left (subtracting 9)","you cross zero to −5.")+
   U("Having 4 rupees and needing to pay 9 leaves you 5 rupees short, i.e. −5."),
   [("5","Since 9 is bigger than 4, the answer is NEGATIVE: −5, not +5."),
    ("13","13 would be 4 + 9; subtracting gives −5."),
    ("−13","−13 mishandles the operation; 4 − 9 is −5.")]),

 ("IN","Multiplying any integer by 1 gives:",
   "the same integer",
   C("One is the multiplicative identity: multiplying by 1 leaves a number unchanged.")+
   steps("Take any integer, say −6","Multiply it by 1","you get back −6 — the same integer.")+
   U("Buying 1 group of a quantity gives you exactly that quantity, unchanged."),
   [("zero","Multiplying by 1 leaves the number unchanged; it is multiplying by 0 that gives zero."),
    ("always a positive number","Multiplying by 1 keeps the original SIGN; −6 × 1 stays −6, still negative."),
    ("double the integer","Multiplying by 1 does not double it; that would be multiplying by 2.")]),

 ("IN","At dawn the temperature is −2 °C and by noon it is 11 °C. The difference between the two temperatures is:",
   "13 °C",
   C("The difference is the higher reading minus the lower: 11 − (−2) = 11 + 2.")+
   steps("Difference = 11 − (−2)","11 − (−2) = 11 + 2","= 13 °C.")+
   U("From a frosty −2 °C at dawn to a mild 11 °C at noon, the temperature spanned 13 degrees."),
   [("9 °C","9 °C ignores the part below zero; from −2 to 11 spans 13 degrees."),
    ("11 °C","11 °C is just the noon reading, not the difference, which is 13 °C."),
    ("22 °C","11 and −2 are 13 apart, not 22; the difference is 13 °C.")]),

 ("IN","Arranged from the smallest to the largest, the integers −5, −1, 0 and 3 begin with:",
   "−5",
   C("The most negative number is the smallest, sitting furthest left on the number line.")+
   steps("Place them on a number line","−5 is furthest to the left","so −5 is the smallest.")+
   U("Among the readings −5, −1, 0 and 3 °C, the coldest — smallest — is −5 °C."),
   [("3","3 is the LARGEST, furthest right; the smallest is −5."),
    ("0","0 is bigger than the negatives; the smallest of the four is −5."),
    ("−1","−1 is greater than −5; the smallest integer in the list is −5.")]),

 ("IN","The value of (−3) × (5 + (−5)) is:",
   "0",
   C("The bracket adds to zero, and any number times zero is zero.")+
   steps("First the bracket: 5 + (−5) = 0","Then (−3) × 0","= 0.")+
   U("Multiplying by something that cancels to nothing always leaves you with nothing — zero."),
   [("−30","−30 would ignore that the bracket is 0; (−3) × 0 = 0."),
    ("30","The bracket is 0, so the product is 0, not 30."),
    ("−3","−3 forgets to multiply by the zero bracket; the answer is 0.")]),

 ("IN","The only integer that is neither positive nor negative is:",
   "0",
   C("Zero is the integer that is neither positive nor negative; it is the boundary between them.")+
   steps("Positive integers are right of zero, negatives left","Zero itself sits in the middle","so zero is neither positive nor negative.")+
   U("On a thermometer, 0 °C marks the dividing line between the warm and cold readings."),
   [("1","1 is a positive integer; the one that is neither positive nor negative is 0."),
    ("−1","−1 is a negative integer; the neither-nor integer is 0."),
    ("there is no such integer","There IS such an integer — it is 0, which is neither positive nor negative.")]),

 ("IN","A diver starts at the surface (0 m), descends to a depth of −15 m, then rises 6 m. The diver's new position is:",
   "−9 m",
   C("Rising 6 m from −15 m adds 6 to the depth: (−15) + 6.")+
   steps("Start at −15 m","Rising 6 m adds: (−15) + 6","= −9 m, still below the surface.")+
   U("A diver 15 m down who swims up 6 m is still 9 m below the surface, at −9 m."),
   [("−21 m","−21 would be descending another 6 m; rising 6 m gives (−15) + 6 = −9 m."),
    ("9 m","The diver is still below the surface, so −9 m, not +9 m above it."),
    ("−15 m","Rising 6 m changes the depth; (−15) + 6 = −9 m, not the same −15 m.")]),
]

items = []
for i in range(25):
    items += [LI[i], LA[i], RE[i], IN[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=23719,
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
    split = "/".join(str(counts[c]) for c in ("LI", "LA", "RE", "IN"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Light",
                     "Lines & Angles",
                     "Respiration in Organisms",
                     "Integers"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
