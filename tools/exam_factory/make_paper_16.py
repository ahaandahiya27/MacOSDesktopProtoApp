# -*- coding: utf-8 -*-
# Boss Challenge Paper 16 — Light · The Triangle & its Properties
#                          · Wastewater Story · Comparing Quantities
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans into FUSION — a Light context (a ray
# bouncing off a mirror) wrapped around a Triangle/angle skill, and a
# Wastewater context (litres treated, % of solids removed) wrapped around a
# Comparing-Quantities skill (ratio, percent, profit/interest). Class-7
# scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_16_<SHORT>_QuestionPaper.html  (pure HTML — questions + options, no answers)
#   Paper_16_<SHORT>_QuestionPaper.pdf
#   Paper_16_<SHORT>_Questions.md
#   Paper_16_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "16"
SHORT = "Light_Triangle_Wastewater_ComparingQuantities"
TITLE = "Light · The Triangle & its Properties · Wastewater Story · Comparing Quantities"
LABELS = {
    "LT": "Light",
    "TR": "The Triangle & its Properties",
    "WW": "Wastewater Story",
    "CQ": "Comparing Quantities",
}

# ---------- LIGHT (25) — Science ----------
LT = [
 ("LT","In a clear, uniform medium, light from a source travels along:",
   "straight lines",
   C("Light moves in straight lines — this is called rectilinear propagation.")+
   steps("Light leaves the source","Nothing bends it in a uniform medium","So it keeps going straight.")+
   U("A torch beam in dusty air shows a straight, sharp line of light."),
   [("curved paths","Light bends only when it crosses into a different medium, not in a uniform one."),
    ("zig-zag paths","Light has no reason to zig-zag in a clear, even medium."),
    ("spreading circles","Ripples spread in circles on water; light rays travel straight.")]),

 ("LT","When a ray of light strikes a plane mirror, the angle of incidence is always:",
   "equal to the angle of reflection",
   C("The law of reflection: angle of incidence equals angle of reflection.")+
   steps("Measure the incoming ray from the normal","Measure the reflected ray from the normal","Both angles come out equal.")+
   U("This rule lets us aim a mirror to send sunlight exactly where we want."),
   [("twice the angle of reflection","The two angles are equal, not in a 2:1 ratio."),
    ("half the angle of reflection","Neither angle is half the other; they are equal."),
    ("always ninety degrees","Ninety degrees is the normal direction, not the relation between the two angles.")]),

 ("LT","The image you see of yourself in a flat bathroom mirror is:",
   "virtual, erect and the same size as you",
   C("A plane mirror forms a virtual, erect image of the same size as the object.")+
   steps("The image cannot be caught on a screen — it is virtual","It stands the same way up — erect","It is as tall as you are — same size.")+
   U("When you comb your hair in a mirror, the reflection is exactly your size, the right way up."),
   [("real, inverted and smaller","A plane mirror never makes a real, upside-down or shrunken image."),
    ("virtual, inverted and larger","A plane-mirror image is erect and the same size, not inverted or larger."),
    ("real and the same size","The image is virtual — it cannot be formed on a screen.")]),

 ("LT","In a plane mirror your right hand appears to be the left hand of the image. This effect is called:",
   "lateral inversion",
   C("Lateral inversion is the left–right swap of an image in a plane mirror.")+
   steps("You raise your right hand","The image raises the hand on its left side","Left and right are interchanged — lateral inversion.")+
   U("The word AMBULANCE is printed reversed on the van so a driver ahead reads it correctly in the mirror."),
   [("dispersion","Dispersion is the splitting of white light into colours, not a left–right swap."),
    ("refraction","Refraction is the bending of light entering a new medium, not the mirror swap."),
    ("magnification","Magnification is a change in size; a plane mirror keeps the size the same.")]),

 ("LT","If a mirror's shiny surface caves inward, just like the inner bowl of a spoon, then it is a:",
   "concave mirror",
   C("A concave mirror has its reflecting surface curved inward, and it can converge light.")+
   steps("Picture the bowl of a spoon facing you","The shiny surface caves in","That inward-curving mirror is concave.")+
   U("A dentist uses a concave mirror to see an enlarged image of a tooth."),
   [("convex mirror","A convex mirror bulges outward, the opposite of caving inward."),
    ("plane mirror","A plane mirror is perfectly flat, not curved at all."),
    ("cylindrical mirror","A cylindrical mirror curves like a tube, not the inward bowl shape described.")]),

 ("LT","The mirror used as a rear-view mirror in cars and on motorbikes is convex because it:",
   "gives a smaller image and a wider field of view",
   C("A convex mirror bulges out, so it shows a wide area in a small, upright image.")+
   steps("A convex mirror spreads reflected rays apart","This shrinks the image","So a much wider scene fits in the glass.")+
   U("A driver glances at the convex mirror and sees a wide stretch of the road behind."),
   [("magnifies the traffic behind","A convex mirror makes things look smaller, not larger."),
    ("forms a real image on the road","A convex mirror forms a virtual image behind the glass, not on the road."),
    ("shows an upside-down image","The image in a convex mirror is erect, not inverted.")]),

 ("LT","When white sunlight passes through a glass prism, it spreads out into a band of colours called the:",
   "spectrum",
   C("A prism splits white light into its seven colours — that band is the spectrum.")+
   steps("White light enters the prism","Each colour bends by a slightly different amount","They fan out into a coloured band — the spectrum.")+
   U("Holding a prism in sunlight throws a little rainbow band onto the wall."),
   [("shadow","A shadow is a dark patch where light is blocked, not a band of colours."),
    ("reflection","Reflection is light bouncing back; the prism splits light by bending it."),
    ("image","An image is a likeness of an object, not a spread-out band of colours.")]),

 ("LT","A rainbow in the sky is formed because tiny water drops act like prisms and cause:",
   "dispersion of sunlight into seven colours",
   C("Rain drops disperse sunlight into its colours, making a rainbow.")+
   steps("Sunlight enters each raindrop","The drop splits the light into colours","Many drops together paint the rainbow arc.")+
   U("After a shower, with the Sun behind you, you can spot a rainbow arching across the sky."),
   [("reflection of sunlight with no colour change","A rainbow shows colours, so simple reflection alone cannot explain it."),
    ("the Sun changing colour","The Sun does not change colour; the drops split its white light."),
    ("clouds glowing on their own","Clouds do not make their own light; the rainbow comes from split sunlight.")]),

 ("LT","The seven colours of the spectrum, in correct order, are remembered by the word VIBGYOR, which starts with:",
   "violet",
   C("VIBGYOR lists the spectrum: Violet, Indigo, Blue, Green, Yellow, Orange, Red.")+
   steps("Write out V-I-B-G-Y-O-R","The first letter V stands for violet","So violet is the first colour in the order.")+
   U("Students use VIBGYOR to recall the rainbow colours in the right sequence."),
   [("red","Red is the last colour in VIBGYOR, not the first."),
    ("green","Green sits in the middle of the order, not at the start."),
    ("white","White is the combination of all the colours, not one of the seven.")]),

 ("LT","A magnifying glass that makes letters look bigger when held close to a page is a:",
   "convex lens",
   C("A convex lens is thicker in the middle and can magnify nearby objects.")+
   steps("Hold a convex lens near small print","It bends light to form an enlarged image","The letters look bigger.")+
   U("A convex lens helps read tiny print on a medicine label."),
   [("concave lens","A concave lens makes things look smaller, not bigger."),
    ("plane mirror","A plane mirror reflects an equal-sized image; it does not magnify print."),
    ("flat glass sheet","A flat sheet of glass does not bend light enough to magnify.")]),

 ("LT","An image that can actually be caught on a screen is called a:",
   "real image",
   C("A real image is formed where rays truly meet, so it can fall on a screen.")+
   steps("Light rays come together at a point","A screen placed there catches the picture","Such an image is real.")+
   U("A cinema projector throws a real image of the film onto the big screen."),
   [("virtual image","A virtual image only seems to be there and cannot be caught on a screen."),
    ("erect image","Erect tells the orientation, not whether the image can be caught on a screen."),
    ("laterally inverted image","Lateral inversion is a left–right swap, not the screen property.")]),

 ("LT","The straight line drawn at right angles to the mirror at the point where the ray hits is called the:",
   "normal",
   C("The normal is the line perpendicular to the mirror at the point of incidence.")+
   steps("Mark where the ray strikes the mirror","Draw a line at 90° to the surface there","That perpendicular is the normal.")+
   U("We always measure the angles of incidence and reflection from the normal, not from the mirror."),
   [("reflected ray","The reflected ray is the bounced-off ray, not the perpendicular line."),
    ("incident ray","The incident ray is the incoming ray, not the perpendicular line."),
    ("axis of the mirror","The axis runs through the mirror's centre; the normal is at the point of incidence.")]),

 ("LT","A periscope, used to see over a wall or out of a submarine, works using two:",
   "plane mirrors set at 45°",
   C("A periscope uses two plane mirrors, each tilted at 45°, to bend light around the obstacle.")+
   steps("Light enters the top and hits the upper mirror","It reflects down to the lower mirror","The lower mirror sends it to your eye.")+
   U("A submarine crew uses a periscope to view ships on the surface while staying underwater."),
   [("convex lenses","A simple periscope works by reflection in mirrors, not by lenses."),
    ("concave mirrors","Plane mirrors, not concave mirrors, are used so the image is undistorted."),
    ("glass prisms only","A basic school periscope uses two plane mirrors, not prisms.")]),

 ("LT","When light falls on a rough, uneven surface and scatters in many directions, it is called:",
   "diffuse reflection",
   C("Diffuse reflection is the scattering of light from a rough surface in many directions.")+
   steps("Light hits a bumpy surface","Each tiny part faces a different way","So the rays bounce off in all directions.")+
   U("A wall is visible from every corner of a room because it scatters light diffusely."),
   [("regular reflection","Regular reflection happens on smooth surfaces and forms a clear image."),
    ("refraction","Refraction is bending while passing into a new medium, not scattering off a surface."),
    ("dispersion","Dispersion splits light into colours; it does not describe scattering off rough surfaces.")]),

 ("LT","A concave mirror is used in a car headlight and a torch because it can:",
   "send out a strong, parallel beam of light",
   C("A concave mirror with the bulb at its focus reflects light into a powerful parallel beam.")+
   steps("Place the bulb at the focus of a concave mirror","Rays from the bulb reflect off the curve","They leave as a straight, parallel beam.")+
   U("A torch throws a far, bright beam because its concave mirror gathers the light forward."),
   [("spread light weakly in all directions","A bare bulb does that; the concave mirror is added to focus the beam."),
    ("split white light into colours","Splitting colours is the job of a prism, not a headlight mirror."),
    ("shrink the scene like a rear-view mirror","Shrinking a wide view is what a convex mirror does, not a headlight.")]),

 ("LT","In a plane mirror, the distance of the image behind the mirror equals the distance of the object in front. So an object 30 cm in front forms an image that is:",
   "30 cm behind the mirror",
   C("A plane mirror places the image as far behind the glass as the object is in front.")+
   steps("Object distance in front = 30 cm","Image distance behind = same value","So the image is 30 cm behind the mirror.")+
   U("Stand 1 m from a mirror and your reflection looks 1 m behind it — a 2 m gap between you and the image."),
   [("15 cm behind the mirror","The image is at the same distance as the object, not half of it."),
    ("60 cm behind the mirror","The image distance equals the object distance, not double it."),
    ("30 cm in front of the mirror","The image of a plane mirror lies behind the mirror, not in front.")]),

 ("LT","A concave lens is thinner in the middle than at the edges, and it always makes a distant object look:",
   "smaller",
   C("A concave (diverging) lens spreads rays out, forming a smaller, erect image.")+
   steps("A concave lens is thin at the centre","It bends rays outward, away from each other","The image of a far object looks smaller.")+
   U("Concave lenses are used in spectacles to help a short-sighted eye see distant objects."),
   [("larger","A concave lens reduces size; only a convex lens can enlarge."),
    ("upside-down","A concave lens gives an erect image, not an inverted one."),
    ("exactly the same size","A concave lens shrinks the image; it does not keep the same size.")]),

 ("LT","Two plane mirrors are placed facing each other; an object between them forms:",
   "many images",
   C("Two facing mirrors reflect images back and forth, forming a long line of many images.")+
   steps("Mirror A makes an image","Mirror B reflects that image","The reflecting repeats, giving many images.")+
   U("Standing between two parallel mirrors in a lift, you see yourself repeated many times."),
   [("exactly one image","A single image forms with one mirror; two facing mirrors give many."),
    ("no image at all","Mirrors always reflect, so images certainly form."),
    ("only a coloured band","A coloured band needs a prism; mirrors give repeated images, not colours.")]),

 ("LT","A ray of light strikes a plane mirror making an angle of 30° with the normal. The angle of reflection is:",
   "30°",
   C("By the law of reflection, the angle of reflection equals the angle of incidence.")+
   steps("Angle of incidence (from the normal) = 30°","Law: reflection angle = incidence angle","So the angle of reflection = 30°.")+
   U("Knowing reflection equals incidence lets us predict exactly where a mirror sends a beam."),
   [("60°","60° would be the angle from the mirror surface, not the angle of reflection from the normal."),
    ("90°","90° is the normal direction itself, not the reflected angle here."),
    ("15°","The reflected angle equals the 30° incidence, not half of it.")]),

 ("LT","A ray hits a plane mirror with an angle of incidence of 40° (measured from the normal). The total angle between the incident ray and the reflected ray is:",
   "80°",
   C("The incident and reflected rays each sit at the angle of incidence from the normal, so the angle between them is twice that.")+
   steps("Angle of incidence = 40°, angle of reflection = 40°","They are on opposite sides of the normal","Total between the rays = 40° + 40° = 80°.")+
   U("Engineers use this doubling rule when aligning mirrors in instruments and laser set-ups."),
   [("40°","40° is each ray's angle from the normal; the two rays together span twice that."),
    ("20°","20° would be half the incidence; the rays actually span double it."),
    ("90°","90° is the normal-to-surface angle, not the angle between these two rays.")]),

 ("LT","When all seven colours of the spectrum are combined back together, they form:",
   "white light",
   C("Recombining the seven spectrum colours gives back white light.")+
   steps("Start with the separate VIBGYOR colours","Bring them together again","They merge into white light.")+
   U("A spinning Newton's disc painted with the seven colours looks whitish-grey as the colours blend."),
   [("black light","Combining colours of light makes white, not black."),
    ("green light","Green is just one colour; all seven together make white."),
    ("no light","The colours add up to white light, not to darkness.")]),

 ("LT","An image formed by a plane mirror is described as virtual because it:",
   "cannot be caught on a screen",
   C("A virtual image only appears to be behind the mirror; rays do not actually meet there, so no screen can catch it.")+
   steps("The reflected rays seem to come from behind the mirror","They do not really meet there","So the image cannot be formed on a screen — it is virtual.")+
   U("You can see your face in a mirror, but you cannot project it onto a wall like a cinema picture."),
   [("is upside-down","Being virtual is about not catching it on a screen, not about orientation."),
    ("is smaller than the object","A plane-mirror image is the same size; 'virtual' refers to the screen test."),
    ("changes colour","A plane mirror does not change colour; 'virtual' is about the screen test.")]),

 ("LT","The image in a plane mirror is laterally inverted, which means the letter 'b' would look like:",
   "the letter 'd'",
   C("Lateral inversion swaps left and right, turning a 'b' into a mirror-image 'd'.")+
   steps("Write the letter b and face it to a mirror","Left and right are swapped","The reflection reads like a d.")+
   U("Anyone reading reversed mirror-writing must flip it left-to-right to understand it."),
   [("the letter 'p'","Flipping top-to-bottom would give p; a mirror swaps left–right, giving d."),
    ("the letter 'q'","q comes from flipping both ways; a single mirror does only the left–right swap."),
    ("the letter 'b' unchanged","A plane mirror laterally inverts, so the b does change to a d-shape.")]),

 ("LT","A beam of sunlight enters a dark room through a small hole and lights up floating dust along a perfectly straight line. This best shows that light:",
   "travels in a straight line",
   C("The straight, visible shaft of light through dust shows rectilinear (straight-line) propagation.")+
   steps("Light enters through the small hole","It lights the dust along its path","The lit path is a straight line.")+
   U("Sunlight slanting through a gap in curtains shows the same straight, dusty beam."),
   [("bends around corners","If light bent around corners the beam would curve, but it stays straight."),
    ("is made of seven colours only when reflected","The straight beam shows direction of travel, not colour splitting."),
    ("cannot pass through air","The beam clearly passes through the air; that is why we see it.")]),

 ("LT","A ray of light hits a plane mirror straight on, along the normal (angle of incidence 0°). It is reflected back:",
   "straight back along the same path",
   C("When a ray travels along the normal, the angle of incidence is 0°, so it reflects straight back.")+
   steps("Angle of incidence from the normal = 0°","Angle of reflection also = 0°","The ray returns along the very same path.")+
   U("A torch aimed dead-straight at a flat mirror bounces the beam right back at you."),
   [("at ninety degrees to the path","A 90° turn would need a 45° incidence, not a head-on 0° one."),
    ("scattered in all directions","A smooth plane mirror gives regular reflection, not scattering."),
    ("split into seven colours","A plane mirror reflects light; it does not split it into colours.")]),
]

# ---------- THE TRIANGLE & ITS PROPERTIES (25) — Maths ----------
TR = [
 ("TR","The sum of the three interior angles of any triangle is always:",
   "180°",
   C("The three interior angles of a triangle always add up to 180°.")+
   steps("Take any triangle","Add its three interior angles","The total is always 180°.")+
   U("Knowing this lets you find a missing angle whenever the other two are given."),
   [("90°","90° is the sum of the two acute angles in a right triangle, not all three angles."),
    ("360°","360° is the angle sum of a four-sided figure, not a triangle."),
    ("270°","The angles of a triangle add to 180°, never 270°.")]),

 ("TR","In a triangle, two angles measure 50° and 60°. The third angle is:",
   "70°",
   C("Use angle sum = 180°: subtract the two known angles from 180°.")+
   steps("Sum of all angles = 180°","Known two: 50° + 60° = 110°","Third angle = 180° − 110° = 70°.")+
   U("Carpenters check a triangular brace by making sure its three angles total 180°."),
   [("60°","60° would need the others to total 120°, but 50° + 60° = 110°."),
    ("80°","80° plus 110° gives 190°, which is more than 180°."),
    ("110°","110° is the sum of the two given angles, not the third one.")]),

 ("TR","An exterior angle of a triangle is equal to the sum of its two:",
   "interior opposite angles",
   C("The exterior angle property: an exterior angle equals the sum of the two interior opposite angles.")+
   steps("Extend one side of the triangle","The exterior angle forms outside","It equals the two non-adjacent interior angles added.")+
   U("This shortcut finds an exterior angle without first working out the angle next to it."),
   [("adjacent interior angles","The exterior angle pairs with the two opposite angles, not the adjacent one."),
    ("three interior angles","The two interior opposite angles, not all three, equal the exterior angle."),
    ("base angles only","The rule uses the two interior opposite angles, which are not always the base angles.")]),

 ("TR","A triangle in which all three sides are equal is called:",
   "equilateral",
   C("An equilateral triangle has all three sides equal — and all three angles equal to 60°.")+
   steps("All three sides have the same length","Equal sides face equal angles","Each angle is 60°.")+
   U("The yield road sign is a clear equilateral triangle."),
   [("isosceles","An isosceles triangle has only two equal sides, not all three."),
    ("scalene","A scalene triangle has all three sides different."),
    ("right-angled","A right-angled triangle has a 90° angle; its sides need not all be equal.")]),

 ("TR","A triangle with exactly two equal sides is called isosceles, and its two base angles are:",
   "equal to each other",
   C("In an isosceles triangle the angles opposite the two equal sides (the base angles) are equal.")+
   steps("Two sides are equal in length","Equal sides face equal angles","So the two base angles are equal.")+
   U("A symmetric roof truss is isosceles, with matching slopes on both sides."),
   [("both right angles","Two right angles would already make 180°, leaving nothing for the third angle."),
    ("always 60°","60° each happens only in an equilateral triangle, not every isosceles one."),
    ("unequal to each other","The whole point of the isosceles base angles is that they are equal.")]),

 ("TR","When every one of a triangle's three sides has a different length, the triangle is called:",
   "scalene",
   C("A scalene triangle has three unequal sides and three unequal angles.")+
   steps("Side 1, side 2 and side 3 are all different","Different sides face different angles","So all three angles differ too.")+
   U("Many ordinary triangular plots of land are scalene, with no two sides matching."),
   [("equilateral","An equilateral triangle has all three sides equal, the opposite of scalene."),
    ("isosceles","An isosceles triangle has two equal sides; a scalene has none equal."),
    ("right-angled","A right-angled triangle is defined by a 90° angle, not by unequal sides.")]),

 ("TR","The line segment joining a vertex of a triangle to the mid-point of the opposite side is called a:",
   "median",
   C("A median joins a vertex to the mid-point of the opposite side; a triangle has three medians.")+
   steps("Pick a vertex","Find the mid-point of the side facing it","Join them — that segment is the median.")+
   U("The three medians meet at the centroid, the balancing point of a triangular sheet."),
   [("altitude","An altitude is the perpendicular from a vertex to the opposite side, not to its mid-point."),
    ("perpendicular bisector","A perpendicular bisector need not pass through a vertex; a median always does."),
    ("hypotenuse","The hypotenuse is the longest side of a right triangle, not a line from a vertex.")]),

 ("TR","The perpendicular drawn from a vertex of a triangle to the line of its opposite side is the:",
   "altitude",
   C("An altitude is the perpendicular (height) from a vertex to the opposite side.")+
   steps("Pick a vertex","Drop a line straight down at 90° to the opposite side","That perpendicular is the altitude.")+
   U("The altitude of a triangle is the height you use in the area formula ½ × base × height."),
   [("median","A median goes to the mid-point, and is not necessarily perpendicular."),
    ("angle bisector","An angle bisector splits the angle in two; it need not meet the side at 90°."),
    ("diagonal","Triangles have no diagonals; diagonals belong to four-or-more-sided figures.")]),

 ("TR","How many medians does a triangle have?",
   "three",
   C("A triangle has three vertices, so it has three medians — one from each vertex.")+
   steps("Each vertex gives one median","A triangle has three vertices","So there are three medians.")+
   U("All three medians cross at one point, the centroid, used to balance a triangular plate."),
   [("one","Only one median is drawn at a time, but a triangle has three in all."),
    ("two","A triangle has three vertices, hence three medians, not two."),
    ("six","Six would double-count; each of the three vertices gives just one median.")]),

 ("TR","In a right-angled triangle, the side opposite the right angle is the longest side, called the:",
   "hypotenuse",
   C("The hypotenuse is the side opposite the 90° angle and is the longest side of a right triangle.")+
   steps("Locate the right angle","The side facing it is the longest","That side is the hypotenuse.")+
   U("A ramp's sloping top is the hypotenuse of the right triangle it makes with the ground."),
   [("base","The base is one of the two shorter sides next to the right angle."),
    ("altitude","The altitude is a height; the hypotenuse is the side opposite the right angle."),
    ("median","The median joins a vertex to a mid-point; it is not the longest side.")]),

 ("TR","By the Pythagoras property, in a right triangle with legs 3 cm and 4 cm, the hypotenuse is:",
   "5 cm",
   C("Pythagoras: hypotenuse² = leg² + leg². Here 3² + 4² = 25, so the hypotenuse is √25 = 5.")+
   steps("3² + 4² = 9 + 16 = 25","Hypotenuse = √25","Hypotenuse = 5 cm.")+
   U("Builders use the 3-4-5 rule to mark a perfect right angle at a corner."),
   [("6 cm","6² = 36, but the legs give 25, so the hypotenuse is 5, not 6."),
    ("7 cm","7 cm is just 3 + 4; Pythagoras squares the sides, giving 5."),
    ("12 cm","12 cm is the product 3 × 4; the hypotenuse from 3 and 4 is 5.")]),

 ("TR","The three sides of a triangle measure 6 cm, 8 cm and 10 cm. The hypotenuse-like longest side shows this is a:",
   "right-angled triangle",
   C("Since 6² + 8² = 36 + 64 = 100 = 10², the triangle satisfies Pythagoras and is right-angled.")+
   steps("6² + 8² = 36 + 64 = 100","10² = 100","The two match, so the angle facing 10 cm is 90°.")+
   U("A 6-8-10 frame is a quick way to set out a square corner on a building site."),
   [("equilateral triangle","Equilateral needs all sides equal; here they are 6, 8 and 10."),
    ("obtuse triangle","An obtuse triangle would fail Pythagoras; here the squares match exactly."),
    ("an impossible triangle","6 + 8 = 14 > 10, so the triangle is perfectly valid.")]),

 ("TR","Which set of lengths can form a triangle? (Sum of any two sides must be greater than the third.)",
   "5 cm, 6 cm, 9 cm",
   C("A triangle is possible only if the sum of any two sides exceeds the third side.")+
   steps("Check 5 + 6 = 11 > 9 ✓","Check 5 + 9 = 14 > 6 ✓","Check 6 + 9 = 15 > 5 ✓ — all pass.")+
   U("Before cutting sticks for a triangular frame, this check tells you if they will actually join."),
   [("2 cm, 3 cm, 6 cm","2 + 3 = 5, which is less than 6, so these cannot form a triangle."),
    ("4 cm, 4 cm, 9 cm","4 + 4 = 8, which is less than 9, so no triangle forms."),
    ("1 cm, 2 cm, 3 cm","1 + 2 = 3 equals the third side, so the sticks would lie flat, not form a triangle.")]),

 ("TR","Two angles of a triangle are equal and the third is 80°. Each of the two equal angles is:",
   "50°",
   C("The two equal angles share what is left after removing 80° from 180°.")+
   steps("Sum of angles = 180°","Remaining for the two equal angles = 180° − 80° = 100°","Each equal angle = 100° ÷ 2 = 50°.")+
   U("An isosceles flag pennant with an 80° tip has two 50° base angles."),
   [("80°","Three 80°-ish angles would overshoot 180°; the two equal ones are 50°."),
    ("40°","40° + 40° + 80° = 160°, which is short of 180°."),
    ("100°","100° is the total of the two equal angles together, not each one.")]),

 ("TR","In a right-angled triangle one angle is 90°. The other two acute angles must add up to:",
   "90°",
   C("Since all three angles total 180° and one is 90°, the other two add to 90°.")+
   steps("Total angle sum = 180°","Subtract the right angle: 180° − 90° = 90°","So the two acute angles add to 90°.")+
   U("In a set-square, the two non-right angles always share the remaining 90°."),
   [("180°","180° is the total of all three angles, not of the two acute ones."),
    ("90° each","They add to 90° together, so each is less than 90°, not 90° each."),
    ("45°","45° is each angle only in a special right triangle, not their sum.")]),

 ("TR","An exterior angle of a triangle is 120°, and one interior opposite angle is 70°. The other interior opposite angle is:",
   "50°",
   C("Exterior angle = sum of the two interior opposite angles, so subtract the known one.")+
   steps("Exterior angle = 120°","One interior opposite angle = 70°","Other = 120° − 70° = 50°.")+
   U("Surveyors use the exterior-angle rule to find a hard-to-reach angle from an easy one."),
   [("70°","70° is the angle already given; the other is 120° − 70° = 50°."),
    ("60°","60° would need the known angle to be 60° too; it is 70°, giving 50°."),
    ("120°","120° is the exterior angle itself, not one of the interior opposite angles.")]),

 ("TR","The point where the three medians of a triangle meet is called the:",
   "centroid",
   C("The three medians of a triangle always intersect at a single point, the centroid.")+
   steps("Draw all three medians","They cross at one common point","That meeting point is the centroid.")+
   U("A triangular sheet balances perfectly on a pin placed at its centroid."),
   [("vertex","A vertex is a corner of the triangle, not where the medians meet."),
    ("hypotenuse","The hypotenuse is a side of a right triangle, not a meeting point."),
    ("midpoint","A midpoint is on one side; the centroid is where all three medians cross.")]),

 ("TR","The perimeter of an equilateral triangle of side 7 cm is:",
   "21 cm",
   C("An equilateral triangle has three equal sides, so its perimeter is 3 × side.")+
   steps("All three sides = 7 cm","Perimeter = 3 × 7","Perimeter = 21 cm.")+
   U("To fence a triangular flower bed with equal sides, you buy three times one side's length."),
   [("14 cm","14 cm is only two sides; an equilateral triangle has three."),
    ("28 cm","28 cm would be four sides; a triangle has three sides."),
    ("7 cm","7 cm is just one side, not the whole perimeter.")]),

 ("TR","A right triangle has a hypotenuse of 13 cm and one leg of 12 cm. The other leg is:",
   "5 cm",
   C("Pythagoras: leg² = hypotenuse² − other leg² = 13² − 12² = 169 − 144 = 25, so the leg is 5.")+
   steps("13² − 12² = 169 − 144 = 25","Other leg = √25","Other leg = 5 cm.")+
   U("The 5-12-13 right triangle is another handy set for marking accurate right angles."),
   [("1 cm","1 cm comes from 13 − 12; Pythagoras squares the sides, giving 5."),
    ("25 cm","25 is the squared value (169 − 144); the leg is its square root, 5 cm."),
    ("17 cm","17 cm is bigger than the hypotenuse, which is impossible for a leg.")]),

 ("TR","A triangle that has one angle greater than 90° is called an:",
   "obtuse-angled triangle",
   C("An obtuse-angled triangle has exactly one angle larger than 90°.")+
   steps("One angle is more than 90°","The other two must be small so all add to 180°","Such a triangle is obtuse-angled.")+
   U("A wide, flat triangular shelf bracket often shows an obtuse angle."),
   [("acute-angled triangle","An acute triangle has all three angles less than 90°."),
    ("right-angled triangle","A right triangle has an angle of exactly 90°, not more."),
    ("equilateral triangle","An equilateral triangle has three 60° angles, all less than 90°.")]),

 ("TR","Is it possible for any single triangle to contain two separate right angles?",
   "No, because two right angles already total 180°",
   C("Two right angles add to 180°, leaving nothing for the third angle, so it is impossible.")+
   steps("Angle sum must be exactly 180°","Two right angles = 90° + 90° = 180°","No degrees remain for the third angle, so it cannot exist.")+
   U("This is why a triangle can have at most one right angle, never two."),
   [("Yes, if the third angle is 0°","An angle of 0° is not a real angle, so the triangle cannot form."),
    ("Yes, in a right-angled triangle","A right-angled triangle has only one right angle, not two."),
    ("Yes, if the sides are equal","Equal sides do not change the angle-sum rule; two right angles still fail.")]),

 ("TR","In an equilateral triangle, each interior angle measures:",
   "60°",
   C("All three angles are equal and sum to 180°, so each is 180° ÷ 3 = 60°.")+
   steps("Three equal angles add to 180°","Each = 180° ÷ 3","Each = 60°.")+
   U("Drawing an equilateral triangle with a protractor means setting every angle to 60°."),
   [("90°","90° each would give 270°, far more than 180°."),
    ("45°","45° each gives only 135°, short of 180°."),
    ("30°","30° each totals just 90°, not the required 180°.")]),

 ("TR","The two equal sides of an isosceles triangle are each 8 cm and the base is 5 cm. Its perimeter is:",
   "21 cm",
   C("Perimeter is the sum of all three sides: 8 + 8 + 5.")+
   steps("Two equal sides: 8 + 8 = 16 cm","Add the base: 16 + 5","Perimeter = 21 cm.")+
   U("Knowing the perimeter tells you how much ribbon edges a triangular pennant."),
   [("16 cm","16 cm is only the two equal sides; the base of 5 cm must be added."),
    ("13 cm","13 cm leaves out one of the equal 8 cm sides."),
    ("40 cm","40 cm would treat all sides as 8 cm; the base is actually 5 cm.")]),

 ("TR","Two sides of a triangle are 7 cm and 10 cm. The third side must be less than:",
   "17 cm",
   C("By the triangle inequality, the third side is less than the sum of the other two.")+
   steps("Sum of the two given sides = 7 + 10 = 17","The third side must be shorter than this sum","So the third side is less than 17 cm.")+
   U("This upper limit tells a designer the longest the third edge of a triangular panel can be."),
   [("3 cm","3 cm is the lower limit (10 − 7); the question asks for the upper limit, 17."),
    ("70 cm","70 cm is 7 × 10; the limit comes from the sum 7 + 10 = 17."),
    ("27 cm","27 cm is far above the sum of 17; the third side must be under 17 cm.")]),

 ("TR","One acute angle of a right-angled triangle is 35°. The other acute angle is:",
   "55°",
   C("The two acute angles of a right triangle add to 90°, so subtract the known one.")+
   steps("Two acute angles add to 90°","Known angle = 35°","Other = 90° − 35° = 55°.")+
   U("A draughtsman finds the second slope angle of a right-angled bracket this same way."),
   [("65°","65° + 35° = 100°, but the two acute angles must total only 90°."),
    ("45°","45° would need the other to be 45° too; here one is 35°, so the other is 55°."),
    ("145°","145° is more than 90°, impossible for an acute angle in a right triangle.")]),
]

# ---------- WASTEWATER STORY (25) — Science ----------
WW = [
 ("WW","The used, dirty water released from homes, offices and factories is called:",
   "wastewater",
   C("Wastewater is the dirty water discharged after use from homes, industries and other places.")+
   steps("Water is used for washing, bathing and cleaning","It picks up dirt and waste","The dirty water that flows out is wastewater.")+
   U("The soapy water that drains from a washing machine is everyday wastewater."),
   [("rainwater","Rainwater is fresh water from clouds, not used dirty water."),
    ("groundwater","Groundwater is clean water stored under the ground, not discharged dirty water."),
    ("distilled water","Distilled water is purified water, the opposite of dirty wastewater.")]),

 ("WW","The wastewater carried away in drains from kitchens, toilets and bathrooms is specially called:",
   "sewage",
   C("Sewage is the wastewater released from homes that flows through the sewerage system.")+
   steps("Homes release dirty water from sinks and toilets","It carries dissolved and suspended impurities","This liquid waste is called sewage.")+
   U("The dirty water leaving a household drain and entering the street sewer is sewage."),
   [("manure","Manure is decomposed organic matter used to enrich soil, not liquid drain water."),
    ("sludge","Sludge is the settled solid that is separated out during treatment, not the raw sewage."),
    ("clarified water","Clarified water is the cleaner water produced after treatment, not raw sewage.")]),

 ("WW","Sewage is a complex mixture that contains suspended solids, dissolved impurities and many:",
   "disease-causing microbes",
   C("Sewage carries harmful microbes (bacteria, etc.) along with organic and inorganic impurities.")+
   steps("People's waste enters the sewage","It is rich in organic matter","This breeds disease-causing microbes.")+
   U("Untreated sewage spreads illnesses like cholera and typhoid because of these microbes."),
   [("precious minerals for drinking","Sewage is unsafe; it carries harmful microbes, not minerals fit for drinking."),
    ("pure oxygen bubbles","Sewage is low in oxygen and full of waste, not pure oxygen."),
    ("clean drinking water","Sewage is dirty and dangerous; it is the opposite of clean drinking water.")]),

 ("WW","The whole underground network of pipes that carries sewage from buildings to the treatment plant is the:",
   "sewerage system",
   C("Sewerage is the system of sewers — the pipes that collect and carry sewage to be treated.")+
   steps("Each building connects to a drain pipe","Small pipes join into larger sewers","Together they form the sewerage system.")+
   U("Under a city's roads runs a hidden sewerage network carrying sewage to the plant."),
   [("water supply pipeline","The water supply brings clean water in; sewerage carries dirty water out."),
    ("electricity grid","The electricity grid carries power, not sewage."),
    ("ventilation duct","Ventilation ducts move air; sewers move sewage.")]),

 ("WW","The place where sewage is cleaned before the water is released back into a river is called a:",
   "wastewater treatment plant",
   C("A wastewater treatment plant (WWTP) cleans sewage through several steps before release.")+
   steps("Sewage arrives through the sewers","It passes through cleaning stages","Treated water leaves the plant for a river or the sea.")+
   U("Every large town has a treatment plant so dirty water is cleaned before reaching a river."),
   [("power station","A power station makes electricity; it does not treat sewage."),
    ("reservoir","A reservoir stores clean water; it does not clean sewage."),
    ("petrol pump","A petrol pump dispenses fuel and has nothing to do with sewage treatment.")]),

 ("WW","At the start of treatment, wastewater is passed through bar screens to remove:",
   "large floating objects like rags and sticks",
   C("Bar screens trap big floating objects such as rags, sticks, cans and plastic.")+
   steps("Sewage enters the plant","It flows through closely spaced metal bars","Large objects are caught and removed.")+
   U("Bar screens stop bottles and cloth from clogging the machinery further down the plant."),
   [("dissolved salts","Dissolved salts pass straight through bars; screens catch only large objects."),
    ("harmful microbes","Microbes are far too tiny to be stopped by bar screens."),
    ("colour from the water","Bar screens remove solids, not colour from the water.")]),

 ("WW","After the bar screens, the water enters a grit and sand removal tank where the heavy particles:",
   "settle down to the bottom",
   C("In the grit chamber the water slows, letting sand, grit and pebbles sink to the bottom.")+
   steps("Water enters the grit tank and slows down","Heavy sand and grit lose speed","They settle to the bottom and are removed.")+
   U("Removing grit early protects the plant's pumps from being worn out by sand."),
   [("float to the top","Heavy grit and sand sink; they do not float."),
    ("dissolve completely","Grit and sand are insoluble; they settle rather than dissolve."),
    ("turn into gas","Sand and grit are solids; they do not become gas in this tank.")]),

 ("WW","In the sedimentation tank, the solid waste that slowly settles at the bottom is called:",
   "sludge",
   C("Sludge is the settled solid removed from the bottom of the sedimentation tank.")+
   steps("Water sits still in the tank","Solids sink to the bottom","This settled solid is called sludge.")+
   U("The sludge is scraped off and sent for further treatment to make biogas or manure."),
   [("scum","Scum is the floating layer of oil and grease skimmed off the top, not the settled solid."),
    ("clarified water","Clarified water is the cleaner water above the sludge, not the settled solid."),
    ("grit","Grit is the sand removed earlier; the soft settled solid here is called sludge.")]),

 ("WW","Floating oil, grease and other light material on top of the settling tank is removed by skimmers and is called:",
   "scum",
   C("Scum is the floating layer of oil, grease and lighter solids skimmed off the surface.")+
   steps("Lighter materials rise to the surface","A skimmer sweeps the top","The collected floating layer is scum.")+
   U("Skimming away scum stops oil and grease from passing on into the cleaner water."),
   [("sludge","Sludge sinks to the bottom; scum is the layer that floats on top."),
    ("clarified water","Clarified water is the cleaned liquid, not the floating oily layer."),
    ("biogas","Biogas is a gas made later from sludge, not the floating surface layer.")]),

 ("WW","The cleaner water left after the solids have settled and the scum is skimmed off is called:",
   "clarified water",
   C("Clarified water is the relatively clear water remaining once sludge settles and scum is removed.")+
   steps("Solids sink as sludge","Scum is skimmed off the top","The clearer water in between is clarified water.")+
   U("Clarified water still needs more cleaning before it is safe to send to a river."),
   [("raw sewage","Raw sewage is the untreated dirty water at the start, not this cleaner water."),
    ("sludge","Sludge is the settled solid, not the clearer water."),
    ("drinking water","Clarified water is cleaner but not yet pure enough to drink.")]),

 ("WW","Clarified water is cleaned further by pumping air into it so that helpful aerobic bacteria can:",
   "grow and consume the remaining wastes",
   C("Air supplies oxygen so aerobic bacteria multiply and digest the leftover organic waste.")+
   steps("Air (oxygen) is pumped into the clarified water","Aerobic bacteria grow rapidly","They feed on and break down the remaining wastes.")+
   U("This aeration step is the heart of cleaning, turning dirty water much cleaner using bacteria."),
   [("freeze the water solid","Aeration warms and oxygenates the water; it does not freeze it."),
    ("add colour to the water","Aeration helps bacteria clean the water, not colour it."),
    ("kill all forms of life instantly","Aeration grows helpful bacteria rather than killing all life.")]),

 ("WW","The settled sludge is taken to a tank where bacteria decompose it without air (anaerobically), producing a useful gas called:",
   "biogas",
   C("Anaerobic decomposition of sludge produces biogas, which can be burned as a fuel.")+
   steps("Sludge is collected in a closed tank","Anaerobic bacteria break it down without air","The process releases biogas.")+
   U("Biogas from sludge can be used as fuel to generate electricity at the plant itself."),
   [("oxygen","Anaerobic decomposition uses up, rather than produces, oxygen."),
    ("petrol","Petrol comes from refining crude oil, not from sludge digestion."),
    ("chlorine","Chlorine is a chemical added to disinfect water, not a gas made from sludge.")]),

 ("WW","After it is dried, the decomposed sludge from a treatment plant can be used as:",
   "manure",
   C("Dried, decomposed sludge is rich in nutrients and can be used as manure for soil.")+
   steps("Sludge is decomposed by bacteria","It is then dried out","The dried matter enriches soil as manure.")+
   U("Using treated sludge as manure returns nutrients to farmland instead of wasting them."),
   [("fuel for cars","Cars run on petrol or diesel, not on dried sludge."),
    ("drinking water","Sludge is solid waste; it can never be drinking water."),
    ("building cement","Dried sludge is used as manure, not as cement for construction.")]),

 ("WW","Throwing cooking oil and fats down the kitchen drain is harmful because they:",
   "harden and block the drains and pipes",
   C("Oils and fats solidify in the pipes, clogging the drains and stopping the free flow of sewage.")+
   steps("Hot oil is poured down the drain","It cools inside the pipe","It hardens and slowly blocks the drain.")+
   U("Households are told to throw used oil in the bin, not the sink, to keep drains clear."),
   [("clean the pipes thoroughly","Oils clog pipes; they certainly do not clean them."),
    ("turn into clean water","Oil does not become water; it hardens and blocks pipes."),
    ("kill all the harmful microbes","Pouring oil down the drain does not disinfect; it causes blockages.")]),

 ("WW","Used tea leaves, solid food and cotton should be thrown in the dustbin, not the drain, because they:",
   "choke the drains",
   C("Solid waste does not dissolve and instead chokes and blocks the drains.")+
   steps("Solid bits are thrown into the sink","They do not dissolve in water","They pile up and choke the drain.")+
   U("Keeping solids out of the sink is simple good housekeeping that prevents blocked pipes."),
   [("clean the drains","Solid waste blocks drains rather than cleaning them."),
    ("become safe drinking water","Tea leaves and food scraps cannot turn into drinking water."),
    ("speed up the water flow","Solids slow and block the flow; they do not speed it up.")]),

 ("WW","In places without a sewerage network, household wastewater is often treated on-site in an underground:",
   "septic tank",
   C("A septic tank is an underground tank that treats sewage on-site where no sewer exists.")+
   steps("Sewage flows into the buried tank","Bacteria decompose the waste there","The treated liquid soaks away or is drained off.")+
   U("Houses far from town sewers, such as in villages, often rely on a septic tank."),
   [("overhead water tank","An overhead tank stores clean water for use, not sewage for treatment."),
    ("petrol tank","A petrol tank holds fuel and has nothing to do with sewage."),
    ("rainwater barrel","A rainwater barrel collects clean rain, not household sewage.")]),

 ("WW","Poor sanitation and open drains are dangerous mainly because stagnant dirty water lets:",
   "mosquitoes and disease germs breed",
   C("Stagnant sewage is a breeding ground for mosquitoes and disease-causing germs.")+
   steps("Dirty water collects and stands still","Mosquitoes lay eggs and germs multiply","This spreads diseases like malaria and cholera.")+
   U("Covering drains and clearing stagnant water cuts down on mosquitoes and illness."),
   [("clean drinking water to form","Stagnant sewage breeds germs; it does not produce clean water."),
    ("electricity to be generated","Open drains do not generate electricity."),
    ("fresh oxygen to fill the air","Rotting sewage worsens air quality rather than adding fresh oxygen.")]),

 ("WW","A low-cost, on-site sanitation method in which earthworms turn human waste into compost is called a:",
   "vermi-processing toilet",
   C("A vermi-processing toilet uses earthworms to break down human waste into useful compost.")+
   steps("Waste enters the toilet's chamber","Earthworms feed on and digest it","They turn it into nutrient-rich compost.")+
   U("Vermi-processing toilets give a clean, low-water sanitation option for areas without sewers."),
   [("flush toilet linked to a sewer","A sewer-linked flush toilet sends waste to a plant; it does not use worms."),
    ("public fountain","A fountain supplies decorative or drinking water, not sanitation."),
    ("rainwater harvesting pit","A harvesting pit collects rainwater; it does not process human waste.")]),

 ("WW","Diseases such as cholera, typhoid and dysentery spread most often through:",
   "water contaminated by untreated sewage",
   C("Many serious diseases spread through water polluted with untreated sewage.")+
   steps("Untreated sewage mixes with water sources","The water carries disease germs","People drinking it fall ill with cholera or typhoid.")+
   U("Treating sewage before release protects communities downstream from waterborne disease."),
   [("clean, treated tap water","Properly treated tap water is safe and does not spread these diseases."),
    ("breathing fresh mountain air","These are waterborne diseases, not spread by clean air."),
    ("eating freshly cooked food","Well-cooked, clean food is not the main route for these waterborne diseases.")]),

 ("WW","Before treated water is released, it is often disinfected with chlorine or ozone, or passed through UV, in order to:",
   "kill the remaining harmful microbes",
   C("Disinfection with chlorine, ozone or UV kills the microbes left in the treated water.")+
   steps("Most waste is removed by earlier steps","Some harmful microbes may still remain","Disinfection kills these before release.")+
   U("Chlorinating treated water makes it safer for the river and any community downstream."),
   [("add minerals for taste","Disinfection removes germs; it is not about taste or minerals."),
    ("make the water blue","Disinfectants kill microbes; they are not added to colour the water."),
    ("freeze the water","Disinfection kills germs chemically or with UV, not by freezing.")]),

 ("WW","A treatment plant takes in 800 litres of sewage and the bar screens plus grit removal take out 200 litres of solids and grit. The fraction of the intake removed at this early stage is:",
   "one-quarter (1/4)",
   C("Express the removed amount as a fraction of the total intake and simplify.")+
   steps("Removed = 200 L out of 800 L","Fraction = 200/800","200/800 = 1/4.")+
   U("Plant operators track such fractions to check each stage is doing its job."),
   [("one-half (1/2)","One-half would be 400 L of 800 L; only 200 L was removed."),
    ("one-eighth (1/8)","One-eighth of 800 L is 100 L; here 200 L was removed."),
    ("one-third (1/3)","One-third of 800 L is about 267 L, not the 200 L removed.")]),

 ("WW","During treatment, 600 litres of water comes in and 540 litres of clean water comes out. The percentage recovered as clean water is:",
   "90%",
   C("Percentage recovered = (clean water out ÷ water in) × 100.")+
   steps("Recovered = 540 of 600 litres","540 ÷ 600 = 0.9","0.9 × 100 = 90%.")+
   U("A high recovery percentage shows the plant is wasting very little of the water it treats."),
   [("60%","60% of 600 L is 360 L, far less than the 540 L recovered."),
    ("54%","54% confuses the 540 figure with a percentage; the true rate is 540/600 = 90%."),
    ("9%","9% of 600 L is only 54 L; the plant actually recovered 540 L.")]),

 ("WW","A village septic tank starts the month holding 50 kg of sludge and ends with 80 kg. The percentage increase in sludge is:",
   "60%",
   C("Percentage increase = (rise ÷ original amount) × 100.")+
   steps("Rise = 80 − 50 = 30 kg","Fraction of original = 30/50","30/50 × 100 = 60%.")+
   U("Tracking the percentage rise tells villagers when the septic tank needs emptying."),
   [("30%","30 kg is the rise itself, but the percentage compares it to 50 kg, giving 60%."),
    ("37.5%","37.5% wrongly divides 30 by 80; the increase is measured against the original 50."),
    ("160%","160% counts the whole 80 kg against 50 kg; the increase alone is 60%.")]),

 ("WW","A town's plant treats sewage in the ratio 3 parts cleaned to 1 part sent back as sludge. Out of 1,200 litres treated, the volume that becomes sludge is:",
   "300 litres",
   C("Split the total in the ratio 3:1, where 1 part out of 4 is sludge.")+
   steps("Total parts = 3 + 1 = 4","One part = 1200 ÷ 4 = 300 L","Sludge is 1 part = 300 L.")+
   U("Knowing the sludge share helps the plant plan how much manure it can later produce."),
   [("400 litres","400 L would be one-third of 1200, but sludge is one part in four, i.e. 300 L."),
    ("900 litres","900 L is the cleaned (3 parts) share, not the 1-part sludge share."),
    ("1200 litres","1200 L is the whole intake, not just the sludge portion.")]),

 ("WW","A plant cleaned 250 litres of sewage on Monday and 300 litres on Tuesday. Out of these two days, the percentage cleaned on Tuesday was:",
   "about 54.5%",
   C("Tuesday's share = (Tuesday ÷ two-day total) × 100.")+
   steps("Two-day total = 250 + 300 = 550 L","Tuesday's fraction = 300/550","300/550 × 100 ≈ 54.5%.")+
   U("Comparing daily shares as percentages helps a plant spot its busiest days."),
   [("about 45.5%","45.5% is Monday's share (250 of 550); Tuesday's is about 54.5%."),
    ("exactly 30%","30% mistakes the litres for a percentage; 300 of 550 is about 54.5%."),
    ("exactly 60%","60% of 550 is 330 L; Tuesday was 300 L, i.e. about 54.5%.")]),
]

# ---------- COMPARING QUANTITIES (25) — Maths ----------
CQ = [
 ("CQ","A ratio compares two quantities of the same kind by:",
   "division",
   C("A ratio compares two like quantities by dividing one by the other.")+
   steps("Take two quantities of the same kind","Divide the first by the second","The result, written a:b, is their ratio.")+
   U("Mixing squash 1:4 with water means 1 part squash divided against 4 parts water."),
   [("addition","A ratio is found by dividing the quantities, not adding them."),
    ("subtraction","Subtraction gives a difference, not the ratio of two quantities."),
    ("multiplication","Multiplication is not how a ratio is formed; division is.")]),

 ("CQ","The ratio 15 : 25 written in its simplest form is:",
   "3 : 5",
   C("Divide both terms of the ratio by their greatest common factor to simplify.")+
   steps("GCF of 15 and 25 is 5","15 ÷ 5 = 3 and 25 ÷ 5 = 5","So 15 : 25 = 3 : 5.")+
   U("Recipes are often written as simplest-form ratios so they scale up neatly."),
   [("5 : 3","5 : 3 reverses the order; 15 : 25 simplifies to 3 : 5, not 5 : 3."),
    ("1 : 2","1 : 2 would need terms like 15 : 30; here it is 15 : 25 = 3 : 5."),
    ("15 : 25","15 : 25 is the un-simplified form; dividing by 5 gives 3 : 5.")]),

 ("CQ","Find 25 percent of 200. The value works out to:",
   "50",
   C("To find a percentage of a number, multiply the number by the percentage written as a fraction.")+
   steps("25% = 25/100 = 1/4","1/4 of 200 = 200 ÷ 4","= 50.")+
   U("A 25% discount on a ₹200 item saves you ₹50."),
   [("25","25 is the percentage figure, not 25% of 200."),
    ("75","75 is 25% of 300, not of 200."),
    ("100","100 is 50% of 200; 25% of 200 is 50.")]),

 ("CQ","The fraction 3/4 written as a percentage is:",
   "75%",
   C("To turn a fraction into a percentage, multiply it by 100.")+
   steps("3/4 × 100","= 300 ÷ 4","= 75, so 3/4 = 75%.")+
   U("Scoring 3 out of 4 on a quiz is the same as 75%."),
   [("34%","34% wrongly reads 3/4 as the digits 3 and 4; 3/4 is actually 75%."),
    ("43%","43% reverses the digits; 3/4 equals 75%."),
    ("7.5%","7.5% is ten times too small; 3/4 × 100 = 75%.")]),

 ("CQ","Written as a fraction in lowest terms, 40% equals:",
   "2/5",
   C("A percentage is a fraction out of 100; simplify it to lowest terms.")+
   steps("40% = 40/100","Divide top and bottom by 20","= 2/5.")+
   U("Knowing 40% = 2/5 makes mental sums like '40% of 25' (= 10) quick."),
   [("4/5","4/5 is 80%, not 40%."),
    ("1/4","1/4 is 25%, not 40%."),
    ("4/10","4/10 is correct before simplifying, but lowest terms is 2/5.")]),

 ("CQ","The decimal 0.6 expressed as a percentage is:",
   "60%",
   C("To change a decimal to a percentage, multiply by 100.")+
   steps("0.6 × 100","= 60","So 0.6 = 60%.")+
   U("If 0.6 of a tank is full, that is 60% of its capacity."),
   [("6%","6% is 0.06, not 0.6; multiplying 0.6 by 100 gives 60%."),
    ("0.6%","0.6% is 0.006; the decimal 0.6 equals 60%."),
    ("600%","600% is 6.0, not 0.6; the correct value is 60%.")]),

 ("CQ","A shopkeeper buys a pen for ₹40 and sells it for ₹50. The profit percent is:",
   "25%",
   C("Profit% = (profit ÷ cost price) × 100.")+
   steps("Profit = 50 − 40 = ₹10","Profit% = (10 ÷ 40) × 100","= 25%.")+
   U("Traders quote profit as a percent of cost so they can compare different items fairly."),
   [("10%","₹10 is the profit amount; as a percent of the ₹40 cost it is 25%."),
    ("20%","20% would mean a profit of ₹8 on ₹40; the actual profit is ₹10, i.e. 25%."),
    ("50%","50% of ₹40 is ₹20 profit; here the profit is only ₹10, i.e. 25%.")]),

 ("CQ","An article costing ₹500 is sold for ₹450. The loss percent is:",
   "10%",
   C("Loss% = (loss ÷ cost price) × 100.")+
   steps("Loss = 500 − 450 = ₹50","Loss% = (50 ÷ 500) × 100","= 10%.")+
   U("Shops mark clearance items at a known loss percent to sell off old stock."),
   [("50%","₹50 is the loss amount; as a percent of ₹500 it is only 10%."),
    ("5%","5% of ₹500 is ₹25; the actual loss is ₹50, i.e. 10%."),
    ("90%","90% is the fraction sold for, not the loss; the loss percent is 10%.")]),

 ("CQ","The simple interest on ₹2,000 at 5% per year for 2 years is:",
   "₹200",
   C("Simple interest = (Principal × Rate × Time) ÷ 100.")+
   steps("SI = (2000 × 5 × 2) ÷ 100","= 20000 ÷ 100","= ₹200.")+
   U("This is how a bank works out the interest it adds to a simple savings deposit."),
   [("₹100","₹100 is the interest for just 1 year; over 2 years it is ₹200."),
    ("₹2,200","₹2,200 is principal plus interest (the amount), not the interest alone."),
    ("₹400","₹400 would need a 10% rate or 4 years; here it is ₹200.")]),

 ("CQ","If 20 out of 50 students wear glasses, the percentage who wear glasses is:",
   "40%",
   C("Percentage = (part ÷ whole) × 100.")+
   steps("Part = 20, whole = 50","20 ÷ 50 = 0.4","0.4 × 100 = 40%.")+
   U("Turning a count into a percentage lets you compare classes of different sizes."),
   [("20%","20 is the count, but as a percent of 50 it is 40%, not 20%."),
    ("50%","50% of 50 is 25 students; here only 20 wear glasses, i.e. 40%."),
    ("70%","70% would be 35 of 50; only 20 wear glasses, i.e. 40%.")]),

 ("CQ","A shirt marked ₹800 is sold at a 15% discount. The discount amount is:",
   "₹120",
   C("Discount = (discount% ÷ 100) × marked price.")+
   steps("15% = 15/100","15/100 × 800 = 1200 ÷ 10","= ₹120.")+
   U("Reading a '15% off' tag, you can quickly work out you save ₹120 on an ₹800 shirt."),
   [("₹15","₹15 is just the percentage figure, not 15% of ₹800."),
    ("₹680","₹680 is the price after the discount, not the discount itself."),
    ("₹150","₹150 is closer to 18.75% of ₹800; 15% of ₹800 is ₹120.")]),

 ("CQ","The ratio of boys to girls in a class is 3 : 2. If there are 30 students in all, the number of girls is:",
   "12",
   C("Divide the total in the given ratio; girls are 2 of the 5 equal parts.")+
   steps("Total parts = 3 + 2 = 5","One part = 30 ÷ 5 = 6","Girls = 2 parts = 2 × 6 = 12.")+
   U("Ratios let a teacher split a class into matching teams of the right proportions."),
   [("18","18 is the number of boys (3 parts), not the girls."),
    ("15","15 would be a 1:1 split; the ratio 3:2 gives 12 girls."),
    ("10","10 would be 2 parts of 25 students; with 30 students each part is 6, so girls = 12.")]),

 ("CQ","30% of a number is 60. The number is:",
   "200",
   C("If 30% of the number is 60, divide 60 by 30% to find the whole.")+
   steps("30% = 0.3","Number = 60 ÷ 0.3","= 200.")+
   U("Working backwards from a percentage helps when you know a part and its percent but not the whole."),
   [("90","90 is 60 + 30, not the number whose 30% is 60."),
    ("18","18 is 30% of 60, the reverse of what is asked."),
    ("180","180 has 30% equal to 54, not 60; the correct number is 200.")]),

 ("CQ","The percentage 45% written as a decimal is:",
   "0.45",
   C("To change a percentage to a decimal, divide by 100 (move the point two places left).")+
   steps("45% = 45 ÷ 100","Move the decimal two places left","= 0.45.")+
   U("Calculators need percentages as decimals, so 45% is entered as 0.45."),
   [("4.5","4.5 is 450%, not 45%; the correct decimal is 0.45."),
    ("0.045","0.045 is 4.5%, ten times too small; 45% is 0.45."),
    ("45.0","45.0 is the number forty-five, not the percentage 45% which is 0.45.")]),

 ("CQ","The price of a cycle rises from ₹2,000 to ₹2,400. The percentage increase is:",
   "20%",
   C("Percentage increase = (rise ÷ original price) × 100.")+
   steps("Rise = 2400 − 2000 = ₹400","Fraction = 400/2000","400/2000 × 100 = 20%.")+
   U("Shoppers track percentage rises to judge how fast prices are climbing."),
   [("40%","₹400 is the rise; against ₹2000 it is a 20% increase, not 40%."),
    ("16.6%","16.6% wrongly divides 400 by 2400; the rise is measured against the original 2000."),
    ("400%","400 is the rise in rupees, but as a percent of 2000 it is 20%.")]),

 ("CQ","Two ratios are equivalent if one can be obtained from the other by multiplying both terms by the same number. Which ratio is equivalent to 2 : 3?",
   "8 : 12",
   C("Equivalent ratios are found by multiplying (or dividing) both terms by the same number.")+
   steps("Multiply both terms of 2 : 3 by 4","2 × 4 = 8 and 3 × 4 = 12","So 2 : 3 = 8 : 12.")+
   U("Doubling or quadrupling a recipe keeps the same ratio of ingredients."),
   [("6 : 8","6 : 8 simplifies to 3 : 4, which is not the same as 2 : 3."),
    ("4 : 9","4 : 9 multiplies the terms by different numbers (2 and 3), so it is not equivalent."),
    ("2 : 6","2 : 6 simplifies to 1 : 3, not 2 : 3.")]),

 ("CQ","A bag has red and blue balls in the ratio 5 : 3. The fraction of the balls that are blue is:",
   "3/8",
   C("Add the ratio parts to get the whole, then write the blue part as a fraction of it.")+
   steps("Total parts = 5 + 3 = 8","Blue = 3 parts","Blue fraction = 3/8.")+
   U("Turning a ratio into a fraction tells you the chance of drawing a blue ball at random."),
   [("3/5","3/5 compares blue to red, not blue to the whole of 8 parts."),
    ("5/8","5/8 is the red fraction; the blue fraction is 3/8."),
    ("3/15","3/15 wrongly multiplies the parts; blue out of the total 8 parts is 3/8.")]),

 ("CQ","A man spends 70% of his salary and saves the rest. If he saves ₹6,000, his salary is:",
   "₹20,000",
   C("Savings are the leftover percent; use that percent and the saved amount to find the whole.")+
   steps("Saved percent = 100% − 70% = 30%","30% of salary = ₹6000, so 1% = ₹200","Salary = 100 × 200 = ₹20,000.")+
   U("Working back from savings and a savings rate reveals an unknown income."),
   [("₹8,571","This wrongly treats ₹6000 as 70%; savings are the 30% portion."),
    ("₹6,000","₹6,000 is only the saved amount, not the whole salary."),
    ("₹60,000","₹60,000 would make 30% equal ₹18,000; the saving is ₹6,000, giving ₹20,000.")]),

 ("CQ","The simple interest on ₹5,000 at 8% per year for 3 years is:",
   "₹1,200",
   C("Simple interest = (Principal × Rate × Time) ÷ 100.")+
   steps("SI = (5000 × 8 × 3) ÷ 100","= 120000 ÷ 100","= ₹1,200.")+
   U("Knowing the SI lets a saver predict exactly what a deposit will earn over the years."),
   [("₹400","₹400 is the interest for 1 year; over 3 years it is ₹1,200."),
    ("₹6,200","₹6,200 is principal plus interest, not the interest by itself."),
    ("₹1,500","₹1,500 would need a 10% rate; at 8% for 3 years it is ₹1,200.")]),

 ("CQ","To compare the ratios 2 : 3 and 3 : 4, you can write them with a common denominator. The larger ratio is:",
   "3 : 4",
   C("Convert each ratio to a fraction with the same denominator and compare.")+
   steps("2 : 3 = 8/12 and 3 : 4 = 9/12","9/12 is greater than 8/12","So 3 : 4 is the larger ratio.")+
   U("Comparing ratios this way tells you which mix is, say, more concentrated."),
   [("2 : 3","2 : 3 equals 8/12, which is smaller than 3 : 4 = 9/12."),
    ("they are equal","8/12 and 9/12 are not equal, so the ratios differ."),
    ("cannot be compared","Ratios can always be compared by writing them as fractions.")]),

 ("CQ","A quantity of 12 is what percent of 48?",
   "25%",
   C("Percentage = (part ÷ whole) × 100.")+
   steps("Part = 12, whole = 48","12 ÷ 48 = 0.25","0.25 × 100 = 25%.")+
   U("Finding what percent one number is of another helps compare scores out of different totals."),
   [("12%","12 is the part; as a percent of 48 it is 25%, not 12%."),
    ("48%","48 is the whole; the part 12 is 25% of it."),
    ("400%","400% reverses the division; 12 is 25% of 48, not 48 of 12.")]),

 ("CQ","₹900 is to be divided between two friends in the ratio 4 : 5. The smaller share is:",
   "₹400",
   C("Split the total into 4 + 5 = 9 equal parts and take the 4-part share.")+
   steps("Total parts = 4 + 5 = 9","One part = 900 ÷ 9 = ₹100","Smaller share = 4 × 100 = ₹400.")+
   U("Sharing prize money or costs fairly in a fixed ratio uses exactly this method."),
   [("₹500","₹500 is the larger share (5 parts); the smaller share is ₹400."),
    ("₹450","₹450 is an equal half; the 4:5 split gives ₹400 and ₹500."),
    ("₹225","₹225 would be a quarter of 900; the smaller of the 4:5 shares is ₹400.")]),

 ("CQ","A number is increased by 10% and the result is 110% of the original. If the original is 80, the new value is:",
   "88",
   C("Increasing by 10% means multiplying by 110% (1.1).")+
   steps("New value = 80 × 110/100","= 80 × 1.1","= 88.")+
   U("Adding a 10% service charge to an ₹80 bill makes it ₹88 in just the same way."),
   [("90","90 is 80 + 10, but a 10% increase of 80 is +8, giving 88."),
    ("8","8 is the increase itself, not the new value of 88."),
    ("70","70 would be a decrease; a 10% rise on 80 gives 88.")]),

 ("CQ","A juice is made by mixing concentrate and water in the ratio 1 : 4. To make 1,000 mL of juice, the amount of concentrate needed is:",
   "200 mL",
   C("Total parts are 1 + 4 = 5; concentrate is 1 of those 5 equal parts.")+
   steps("Total parts = 1 + 4 = 5","One part = 1000 ÷ 5 = 200 mL","Concentrate = 1 part = 200 mL.")+
   U("Following a ratio on a squash bottle gives a drink that tastes just right every time."),
   [("250 mL","250 mL would be one-quarter of 1000; concentrate is one-fifth, i.e. 200 mL."),
    ("800 mL","800 mL is the water (4 parts), not the concentrate."),
    ("100 mL","100 mL is half a part; the single concentrate part is 200 mL.")]),

 ("CQ","A student scored 18 marks out of 20 in a test. Her percentage score is:",
   "90%",
   C("Percentage = (marks scored ÷ total marks) × 100.")+
   steps("Scored 18 of 20","18 ÷ 20 = 0.9","0.9 × 100 = 90%.")+
   U("Report cards turn raw marks into percentages so subjects with different totals compare fairly."),
   [("18%","18 is the marks scored; out of 20 that is 90%, not 18%."),
    ("80%","80% of 20 is 16 marks; she scored 18, i.e. 90%."),
    ("9%","9% is ten times too small; 18 out of 20 is 90%.")]),
]

assert len(LT) == 25 and len(TR) == 25 and len(WW) == 25 and len(CQ) == 25

# Interleave so no two consecutive questions share a chapter; Science/Maths alternate.
items = []
for i in range(25):
    items += [LT[i], TR[i], WW[i], CQ[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=16244,
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
    split = "/".join(str(counts[c]) for c in ("LT", "TR", "WW", "CQ"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Light", "The Triangle & its Properties",
                     "Wastewater Story", "Comparing Quantities"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
