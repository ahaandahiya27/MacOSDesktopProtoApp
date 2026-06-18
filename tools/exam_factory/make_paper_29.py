# -*- coding: utf-8 -*-
# Boss Challenge Paper 29 — Soil · The Triangle & its Properties · Respiration in Organisms · Arithmetic Expressions
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans into FUSION — several Arithmetic-Expressions items are wrapped
# in a Soil context (water percolating through a sample, totalling repeated drainage) and a
# Respiration context (breaths per minute over several minutes). A Soil item and a Respiration
# item also cross-link through the air trapped between soil particles that plant roots breathe.
# The child reads a Science context and applies a Maths skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_29_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_29_<SHORT>_QuestionPaper.pdf
#   Paper_29_<SHORT>_Questions.md
#   Paper_29_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "29"
SHORT = "Soil_Triangle_Respiration_ArithmeticExpressions"
TITLE = ("Soil · The Triangle & its Properties · Respiration in Organisms · Arithmetic Expressions")
LABELS = {
    "SO": "Soil",
    "TR": "The Triangle & its Properties",
    "RE": "Respiration in Organisms",
    "AE": "Arithmetic Expressions",
}

# ---------- SOIL (25) — Science ----------
SO = [
 ("SO","Rocks broken down very slowly over a long time by the sun, water and wind to form soil is a process called:",
   "weathering",
   C("Weathering is the slow breaking of solid rock into tiny bits that become soil.")+
   steps("Heat, rain, frost and wind act on rock for ages","the rock cracks and crumbles into small pieces","those pieces build up as soil — this is weathering."),
   [("erosion","Erosion carries soil away; it does not break the parent rock into soil in the first place."),
    ("sedimentation","Sedimentation is the settling of particles in still water, not the breaking of rock."),
    ("evaporation","Evaporation is water turning to vapour, nothing to do with making soil from rock.")]),

 ("SO","A vertical slice cut down through the ground, showing different layers one below another, is known as the soil:",
   "profile",
   C("A soil profile is the whole stack of layers seen when you cut straight down.")+
   steps("Dig a deep pit or look at a road cutting","you see bands of different colour and texture","that full set of bands is the soil profile."),
   [("texture","Texture describes how coarse or fine the particles feel, not the stack of layers."),
    ("horizon","A horizon is just one single layer, not the whole slice."),
    ("crust","Crust is the hard surface skin, not the layered slice through the ground.")]),

 ("SO","Each separate layer that can be seen in a soil profile is called a soil:",
   "horizon",
   C("A horizon is one distinct layer within the soil profile.")+
   steps("The profile is made of bands stacked up","each band differs in colour, humus and particle size","one such band is a horizon."),
   [("profile","The profile is all the layers together, not a single one of them."),
    ("grain","A grain is one tiny particle, far smaller than a whole layer."),
    ("texture","Texture is how the soil feels, not a named layer.")]),

 ("SO","The topmost, dark layer of soil, rich in humus and home to many small living things, is the:",
   "topsoil",
   C("Topsoil is the dark, life-filled upper layer where most plants root.")+
   steps("Dead leaves and creatures rot at the surface","this makes the top layer dark and fertile","plant roots and worms live there — it is the topsoil."),
   [("subsoil","Subsoil lies below the topsoil and has far less humus."),
    ("bedrock","Bedrock is the solid unbroken rock at the very bottom, not the dark top layer."),
    ("gravel layer","A gravel layer is loose stones, not the humus-rich top layer.")]),

 ("SO","The rotted remains of dead plants and animals that make the topsoil dark and fertile are called:",
   "humus",
   C("Humus is the dark, rotted organic matter that feeds the soil.")+
   steps("Leaves, roots and creatures die and decay","they break into a dark crumbly material","this material, humus, enriches the topsoil."),
   [("gravel","Gravel is small stones, not rotted living matter."),
    ("clay","Clay is a kind of very fine mineral particle, not decayed remains."),
    ("bedrock","Bedrock is solid rock, the opposite of soft rotted humus.")]),

 ("SO","The soil that has the largest particles, feels gritty, and lets water drain away the fastest is:",
   "sandy soil",
   C("Sandy soil has big particles with wide gaps, so water rushes through.")+
   steps("Large grains cannot pack tightly","wide spaces are left between them","water drains quickly — that is sandy soil."),
   [("clayey soil","Clayey soil has the smallest particles and drains the slowest, not the fastest."),
    ("loamy soil","Loamy soil is a balanced mix that drains at a medium pace, not the fastest."),
    ("humus","Humus is rotted matter, not a soil type defined by particle size.")]),

 ("SO","The soil made of the smallest, tightly packed particles, which holds the most water and feels smooth and sticky when wet, is:",
   "clayey soil",
   C("Clayey soil has tiny particles packed close, trapping water between them.")+
   steps("Very fine grains sit close together","little space is left for water to drain","so water is held — that is clayey soil."),
   [("sandy soil","Sandy soil has large particles and drains fast; it holds little water."),
    ("loamy soil","Loamy soil is a balanced mix, not the most water-holding of all."),
    ("gravelly soil","Gravelly soil is mostly stones with huge gaps, holding almost no water.")]),

 ("SO","The best soil for growing most crops, a balanced mixture of sand, clay and humus, is called:",
   "loamy soil",
   C("Loam blends drainage and water-holding, making it ideal for most crops.")+
   steps("It has enough sand to drain well","enough clay and humus to hold water and food","this balance makes loam the best growing soil."),
   [("sandy soil","Pure sandy soil drains too fast and holds too little for most crops."),
    ("clayey soil","Pure clayey soil holds too much water and can waterlog roots."),
    ("rocky soil","Rocky soil is mostly stones and grows very little.")]),

 ("SO","The amount of water a soil can soak up and keep for plants to use is called its water:",
   "holding capacity",
   C("Water-holding capacity is how much water a soil keeps after draining.")+
   steps("Pour water onto soil and let it drain","some water clings on between the particles","how much it keeps is its water-holding capacity."),
   [("percolation rate","Percolation rate is how fast water passes through, not how much is kept."),
    ("temperature","Temperature is how warm the soil is, not how much water it stores."),
    ("profile","The profile is the soil's layers, not a measure of stored water.")]),

 ("SO","How quickly water sinks down and passes on through a soil sample is described by the soil's:",
   "percolation rate",
   C("Percolation rate measures how fast water moves down through soil.")+
   steps("Pour a known amount of water into the soil","time how long it takes to pass through","the speed of passing through is the percolation rate."),
   [("water-holding capacity","That measures how much water stays behind, not the speed of passing through."),
    ("humus content","Humus content is how much rotted matter there is, not a speed."),
    ("colour","Colour is what the soil looks like, not how fast water drains.")]),

 ("SO","200 mL of water takes 40 minutes to percolate through a soil sample. Its percolation rate, in mL per minute, is:",
   "5",
   C("Percolation rate = amount of water divided by the time taken.")+
   steps("Take the water amount, 200 mL","divide by the time, 40 minutes","200 ÷ 40 = 5 mL per minute."),
   [("8","8 comes from 40 ÷ 5; you must divide the water by the time, not the other way round."),
    ("240","240 comes from adding 200 and 40; rate needs division, not addition."),
    ("160","160 comes from subtracting 40 from 200; rate needs division, not subtraction.")]),

 ("SO","One soil lets 300 mL of water through in 30 minutes; another lets 300 mL through in 60 minutes. The faster-draining soil is the one with the:",
   "shorter percolation time",
   C("For the same amount of water, less time means faster draining.")+
   steps("Both samples pass the same 300 mL","one finishes in 30 min, the other in 60 min","the 30-minute sample drains faster — shorter time."),
   [("more humus","More humus tends to hold water; it does not by itself make draining faster."),
    ("larger water-holding capacity","Holding more water means slower draining, not faster."),
    ("darker colour","Colour does not decide how fast water drains through.")]),

 ("SO","Heavy water-holding soils such as clayey soil and clay-rich loam are best for growing crops like:",
   "wheat and gram",
   C("Clayey, water-holding soils suit cereals and pulses such as wheat and gram.")+
   steps("These crops need steady moisture at their roots","clayey soil holds water well","so wheat, gram and paddy grow well there."),
   [("cactus","A cactus is a desert plant suited to dry, sandy soil, not wet clayey soil."),
    ("nothing at all","Clayey soil is fertile for many crops; it is not barren."),
    ("only mushrooms","Mushrooms are not the field crops grown on clayey farm soil.")]),

 ("SO","Light, well-draining sandy-loam soil is the right kind for growing the crop:",
   "cotton",
   C("Cotton needs well-drained sandy-loam soil and plenty of warmth.")+
   steps("Cotton roots dislike standing water","sandy-loam drains quickly and warms fast","so cotton grows well on it."),
   [("paddy","Paddy (rice) needs water-holding clayey soil, not fast-draining sandy-loam."),
    ("nothing","Sandy-loam is good farm soil; it grows many crops, including cotton."),
    ("water lilies","Water lilies grow in ponds, not in well-drained field soil.")]),

 ("SO","The removal of the fertile top layer of soil by wind or flowing water is called soil:",
   "erosion",
   C("Erosion is the carrying away of topsoil by wind or water.")+
   steps("Rain or wind loosens the bare top layer","it is swept off the land","this loss of topsoil is soil erosion."),
   [("weathering","Weathering breaks rock into soil; erosion carries the soil away."),
    ("percolation","Percolation is water sinking through soil, not topsoil being carried off."),
    ("pollution","Pollution is adding harmful matter, not the carrying away of topsoil.")]),

 ("SO","Planting trees and grasses protects land from erosion mainly because their roots:",
   "bind the soil particles together",
   C("Roots grip the soil and hold the particles so wind and water cannot sweep them off.")+
   steps("Bare soil is washed or blown away easily","roots spread through the soil and clutch it","this binding holds the soil in place."),
   [("warm the soil","Roots do not heat the soil; they hold its particles together."),
    ("add water to the soil","Roots take up water; they do not pour water in to stop erosion."),
    ("change the soil colour","Colour has nothing to do with stopping the soil from being carried off.")]),

 ("SO","Throwing harmful chemicals, plastic bags and other waste onto the land, which spoils the soil, is called soil:",
   "pollution",
   C("Soil pollution is the spoiling of soil by harmful waste added to it.")+
   steps("Chemicals and plastics are dumped on the ground","they poison the soil and harm its life","this damage is soil pollution."),
   [("erosion","Erosion is topsoil being carried away, not waste being added."),
    ("weathering","Weathering is rock breaking into soil, not waste spoiling soil."),
    ("percolation","Percolation is water sinking through soil, not pollution.")]),

 ("SO","Below the topsoil lies a harder, lighter layer with little humus but more minerals, known as the:",
   "subsoil",
   C("Subsoil sits under the topsoil and holds more minerals but less humus.")+
   steps("Roots and humus stay mostly in the top layer","the layer below has fewer living things","this mineral-rich lower band is the subsoil."),
   [("topsoil","Topsoil is the dark humus-rich upper layer, not the harder layer below it."),
    ("bedrock","Bedrock is solid rock at the very bottom, not the layer just under topsoil."),
    ("humus layer","The humus-rich part is the topsoil, not this mineral subsoil.")]),

 ("SO","The bottommost layer of the soil profile, made of solid, continuous rock, is the:",
   "bedrock",
   C("Bedrock is the unbroken parent rock at the base of the profile.")+
   steps("Above it lie the loose, weathered layers","at the very bottom the rock is still solid","this solid base is the bedrock."),
   [("topsoil","Topsoil is the dark layer at the top, not the solid rock at the bottom."),
    ("subsoil","Subsoil is loose mineral soil above the rock, not the solid rock itself."),
    ("humus","Humus is soft rotted matter near the surface, not hard bottom rock.")]),

 ("SO","The size of the particles that make up a soil decides the soil's:",
   "texture",
   C("Soil texture is set by how big or small its particles are.")+
   steps("Sand has big grains, clay has tiny ones","this changes how the soil feels and drains","that quality is the soil texture."),
   [("profile","The profile is the soil's layered slice, not its particle size."),
    ("erosion","Erosion is the carrying off of soil, not a property set by particle size."),
    ("humus","Humus is rotted matter; texture is about particle size.")]),

 ("SO","In heavy rain, sandy soil floods far less than clayey soil because sandy soil has a:",
   "higher percolation rate",
   C("Sandy soil drains rainwater away fast, so it floods less.")+
   steps("Big grains leave wide gaps","water rushes down through those gaps","fast draining means less flooding — a high percolation rate."),
   [("lower percolation rate","A low rate means slow draining and more flooding, the opposite of sandy soil."),
    ("more humus","Humus holds water; it would make draining slower, not faster."),
    ("smaller particles","Sandy soil has larger particles, not smaller ones.")]),

 ("SO","Earthworms are called a farmer's friend because, as they tunnel through the ground, they:",
   "make burrows that let air and water in",
   C("Earthworm burrows loosen the soil and let air and water reach the roots.")+
   steps("Worms eat their way through the soil","they leave open tunnels behind","air and water move through these — helping plants."),
   [("eat the crop roots","Earthworms feed on dead matter, not on living crop roots."),
    ("harden the soil","Their burrowing loosens the soil; it does not harden it."),
    ("remove all the humus","Worms enrich the soil with their casts; they do not strip out humus.")]),

 ("SO","The ideal field soil mixes the fast drainage of sand with the water-holding of clay; this balanced soil is:",
   "loam",
   C("Loam combines sand's drainage with clay's water-holding for the best crop soil.")+
   steps("Pure sand drains too fast, pure clay holds too much","mixing them with humus balances both","that balanced soil is loam."),
   [("pure sand","Pure sand drains so fast that it cannot hold water for crops."),
    ("pure clay","Pure clay holds so much water that roots can waterlog."),
    ("gravel","Gravel is loose stones with huge gaps and almost no water-holding.")]),

 ("SO","Warming a small lump of moist soil and seeing water droplets form on the cool lid shows the soil contains:",
   "moisture",
   C("The droplets are water that was held inside the soil and turned to vapour.")+
   steps("Heat drives the trapped water out as vapour","the vapour meets the cool lid and condenses","the droplets prove the soil held water."),
   [("only air","Air would not form water droplets on the lid."),
    ("humus","Humus is solid rotted matter; it does not appear as droplets on a lid."),
    ("salt only","Salt would not rise as vapour and condense as water on the lid.")]),

 ("SO","Pouring water onto a lump of dry soil and seeing bubbles rise out of it shows the soil contains:",
   "air",
   C("The rising bubbles are air that was trapped between the soil particles.")+
   steps("Dry soil has air in the gaps between grains","water fills those gaps and pushes the air out","the escaping air appears as bubbles."),
   [("water","The soil was dry; the bubbles are escaping air, not water."),
    ("humus","Humus is solid matter and would not rise as bubbles."),
    ("only minerals","Minerals are solid grains; they do not bubble up through water.")]),
]

# ---------- THE TRIANGLE & ITS PROPERTIES (25) — Maths ----------
TR = [
 ("TR","The sum of the three interior angles of any triangle always adds up to:",
   "180°",
   C("The three inside angles of every triangle total 180 degrees.")+
   steps("Tear off the three corners of a paper triangle","place them side by side at a point","they form a straight line — that is 180°."),
   [("90°","90° is one right angle, not the total of all three angles."),
    ("360°","360° is the angle sum of a four-sided figure, not a triangle."),
    ("270°","270° is three-quarters of a full turn, not the triangle's angle sum.")]),

 ("TR","A triangle whose three sides are all equal in length is known as:",
   "equilateral",
   C("Equilateral means all three sides are the same length.")+
   steps("Measure each of the three sides","all three come out equal","such a triangle is equilateral."),
   [("isosceles","An isosceles triangle has only two equal sides, not all three."),
    ("scalene","A scalene triangle has all three sides different."),
    ("right-angled","A right-angled triangle is defined by a 90° angle, not by equal sides.")]),

 ("TR","A triangle with exactly two sides equal in length is called:",
   "isosceles",
   C("Isosceles means two of the sides match in length.")+
   steps("Measure the three sides","exactly two are equal, one differs","such a triangle is isosceles."),
   [("equilateral","An equilateral triangle has all three sides equal, not just two."),
    ("scalene","A scalene triangle has no equal sides at all."),
    ("obtuse","Obtuse describes an angle over 90°, not a count of equal sides.")]),

 ("TR","A triangle whose three sides all have different lengths is called:",
   "scalene",
   C("Scalene means every side is a different length.")+
   steps("Measure the three sides","no two of them are equal","such a triangle is scalene."),
   [("equilateral","An equilateral triangle has all sides equal, the opposite of scalene."),
    ("isosceles","An isosceles triangle has two equal sides; a scalene has none equal."),
    ("right","Right describes a 90° angle, not three unequal sides.")]),

 ("TR","In an equilateral triangle, each of the three interior angles measures exactly:",
   "60°",
   C("An equilateral triangle's three equal angles share 180° evenly.")+
   steps("All three angles are equal","they must total 180°","180 ÷ 3 = 60° each."),
   [("90°","90° each would total 270°, far more than a triangle's 180°."),
    ("45°","45° each would total only 135°, less than 180°."),
    ("30°","30° each would total only 90°, far less than 180°.")]),

 ("TR","Two angles of a triangle measure 50° and 60°. The third angle measures:",
   "70°",
   C("The three angles must add to 180°, so subtract the known two.")+
   steps("Add the known angles: 50 + 60 = 110","subtract from 180: 180 − 110","the third angle is 70°."),
   [("110°","110° is the sum of the two given angles, not the missing third one."),
    ("130°","130° comes from 180 − 50; you must subtract both known angles."),
    ("80°","80° is a guess; 180 − 110 gives 70°, not 80°.")]),

 ("TR","A triangle that has one of its angles equal to exactly 90° is called a:",
   "right-angled triangle",
   C("A right-angled triangle contains one 90° angle.")+
   steps("Look at the three angles","one of them is a perfect square corner, 90°","such a triangle is right-angled."),
   [("acute triangle","An acute triangle has all angles under 90°, none equal to 90°."),
    ("obtuse triangle","An obtuse triangle has one angle over 90°, not exactly 90°."),
    ("equilateral triangle","An equilateral triangle has three 60° angles, none equal to 90°.")]),

 ("TR","In a right-angled triangle, the longest side, which lies opposite the right angle, is called the:",
   "hypotenuse",
   C("The hypotenuse is the side facing the 90° angle and is the longest side.")+
   steps("Find the right angle in the triangle","the side directly across from it is the longest","that side is the hypotenuse."),
   [("base","The base is one of the two shorter sides that form the right angle."),
    ("altitude","The altitude is a height drawn to a side, not the side opposite the right angle."),
    ("median","A median joins a vertex to the midpoint of a side, not the longest side itself.")]),

 ("TR","In a right triangle the two shorter sides are 3 cm and 4 cm. The length of the hypotenuse is:",
   "5 cm",
   C("By the Pythagoras property, the hypotenuse squared equals the sum of the squares of the other two sides.")+
   steps("Square the sides: 3² = 9 and 4² = 16","add them: 9 + 16 = 25","the hypotenuse is √25 = 5 cm."),
   [("7 cm","7 cm comes from just adding 3 + 4; you must add the squares, not the sides."),
    ("12 cm","12 cm comes from multiplying 3 × 4; that is not how the hypotenuse is found."),
    ("25 cm","25 cm is 3² + 4²; you still need the square root, which is 5 cm.")]),

 ("TR","A right triangle has two sides of 6 cm and 8 cm forming the right angle. Its hypotenuse is:",
   "10 cm",
   C("Square the two short sides, add them, then take the square root.")+
   steps("Square the sides: 6² = 36 and 8² = 64","add them: 36 + 64 = 100","the hypotenuse is √100 = 10 cm."),
   [("14 cm","14 cm comes from adding 6 + 8; you must add the squares, not the sides."),
    ("48 cm","48 cm comes from 6 × 8; that is not how the hypotenuse is found."),
    ("100 cm","100 cm is 6² + 8²; you still need the square root, which is 10 cm.")]),

 ("TR","An exterior angle of a triangle is equal to the sum of the two:",
   "opposite interior angles",
   C("An exterior angle equals the two interior angles that do not touch it.")+
   steps("Extend one side of the triangle","the angle outside is the exterior angle","it equals the two far inside angles added."),
   [("adjacent angles","The exterior angle is linked to the two far angles, not the one beside it."),
    ("all three interior angles","Those total 180°; the exterior angle equals only the two opposite ones."),
    ("base angles","Base angles are a feature of isosceles triangles, not this rule.")]),

 ("TR","The two interior opposite angles of a triangle are 45° and 55°. The exterior angle at the third vertex is:",
   "100°",
   C("An exterior angle equals the sum of the two opposite interior angles.")+
   steps("Identify the two opposite angles: 45° and 55°","add them together: 45 + 55","the exterior angle is 100°."),
   [("80°","80° is a guess; 45 + 55 gives 100°, not 80°."),
    ("90°","90° is a right angle, but the rule gives 45 + 55 = 100°."),
    ("145°","145° comes from 100 + 45; the exterior angle is just the sum of the two opposite angles.")]),

 ("TR","A segment drawn from a vertex of a triangle straight to the midpoint of the opposite side is a:",
   "median",
   C("A median runs from a corner to the middle of the side across from it.")+
   steps("Pick a vertex of the triangle","find the midpoint of the opposite side","the segment joining them is a median."),
   [("altitude","An altitude is perpendicular to a side; a median goes to the side's midpoint."),
    ("hypotenuse","The hypotenuse is the longest side of a right triangle, not a segment to a midpoint."),
    ("angle bisector","An angle bisector splits an angle in two; it need not reach the midpoint of a side.")]),

 ("TR","The perpendicular line segment drawn from a vertex straight to the opposite side of a triangle is called an:",
   "altitude",
   C("An altitude is the perpendicular height from a vertex to the opposite side.")+
   steps("Pick a vertex","drop a line straight down, at right angles, to the opposite side","that perpendicular segment is the altitude."),
   [("median","A median goes to the midpoint of a side, not perpendicular to it."),
    ("base","The base is a side of the triangle, not the perpendicular drawn to it."),
    ("exterior angle","An exterior angle is an angle, not a line segment inside the triangle.")]),

 ("TR","The number of medians that a triangle has is:",
   "3",
   C("A triangle has one median from each of its three vertices.")+
   steps("Each vertex gives one median to the opposite side","a triangle has three vertices","so it has three medians."),
   [("1","Only one median would mean only one vertex was used; a triangle has three."),
    ("2","Two medians would leave one vertex without its own median."),
    ("6","Six is double the count; each of the three vertices gives just one median.")]),

 ("TR","For three given lengths to form a triangle, the sum of any two of the sides must be:",
   "greater than the third side",
   C("Two sides together must overreach the third, or they cannot meet to close the shape.")+
   steps("Try to join three rods at their ends","if two short ones cannot reach across the long one, no triangle forms","so any two sides must sum to more than the third."),
   [("equal to the third side","If two sides only equal the third, they lie flat and form no triangle."),
    ("less than the third side","If two sides fall short of the third, they cannot meet to close the triangle."),
    ("equal to 180°","180° is the angle sum; this rule is about side lengths, not angles.")]),

 ("TR","Which of the following sets of lengths can form a triangle?",
   "5 cm, 6 cm, 9 cm",
   C("A set works only if every pair of sides sums to more than the remaining side.")+
   steps("Check 5 + 6 = 11, which is more than 9","check 5 + 9 and 6 + 9, both more than the third","all checks pass, so a triangle forms."),
   [("2 cm, 3 cm, 8 cm","2 + 3 = 5, which is less than 8, so these cannot close into a triangle."),
    ("1 cm, 1 cm, 5 cm","1 + 1 = 2, far less than 5, so no triangle is possible."),
    ("4 cm, 4 cm, 9 cm","4 + 4 = 8, which is less than 9, so these cannot form a triangle.")]),

 ("TR","In an isosceles triangle, the two angles that lie opposite the two equal sides are:",
   "equal to each other",
   C("Equal sides face equal angles, so the two base angles match.")+
   steps("An isosceles triangle has two equal sides","the angle opposite each equal side is also equal","so the two base angles are equal."),
   [("both 90°","Two 90° angles would already total 180°, leaving nothing for the third angle."),
    ("always 60°","60° each happens only in an equilateral triangle, not every isosceles one."),
    ("different","The equal sides force these two angles to be equal, not different.")]),

 ("TR","An isosceles triangle has its two equal angles each measuring 70°. The third angle measures:",
   "40°",
   C("Subtract the two equal angles from the 180° total to get the third.")+
   steps("Add the two equal angles: 70 + 70 = 140","subtract from 180: 180 − 140","the third angle is 40°."),
   [("70°","70° is each of the two equal angles, not the different third angle."),
    ("110°","110° comes from 180 − 70; you must subtract both 70° angles."),
    ("50°","50° is a guess; 180 − 140 gives 40°, not 50°.")]),

 ("TR","An equilateral triangle also counts as a special isosceles triangle because it has:",
   "at least two equal sides",
   C("Isosceles needs at least two equal sides, and an equilateral triangle has three.")+
   steps("Isosceles means two or more sides are equal","an equilateral triangle has all three sides equal","so it certainly has two equal sides — a special isosceles."),
   [("a right angle","An equilateral triangle has three 60° angles and no right angle."),
    ("all different sides","Its sides are all equal, not all different."),
    ("only one line of symmetry","An equilateral triangle has three lines of symmetry, not one.")]),

 ("TR","The three angles of a triangle are in the ratio 1 : 2 : 3. The largest of these angles is:",
   "90°",
   C("Split 180° into 1 + 2 + 3 = 6 equal parts, then take the largest share.")+
   steps("Total parts: 1 + 2 + 3 = 6","each part is 180 ÷ 6 = 30°","the largest is 3 parts = 3 × 30 = 90°."),
   [("60°","60° is 2 parts, the middle angle, not the largest."),
    ("120°","120° is more than half of 180°; the parts give the largest as 90°."),
    ("180°","180° is the whole angle sum, not a single angle in the triangle.")]),

 ("TR","Can a single triangle have two right angles?",
   "no, the angle sum would already exceed 180°",
   C("Two right angles alone make 180°, leaving nothing for the third angle.")+
   steps("Two right angles total 90 + 90 = 180°","a triangle needs a third angle as well","that would push the total over 180°, so it is impossible."),
   [("yes, always","Two right angles already use the whole 180°, so a third angle cannot fit."),
    ("yes, if it is large","Size does not matter; two 90° angles always overfill the 180° budget."),
    ("only if equilateral","An equilateral triangle has three 60° angles, none of them right.")]),

 ("TR","Within a single triangle, you can have at most one:",
   "obtuse angle",
   C("Two obtuse angles would each top 90° and together break the 180° limit.")+
   steps("An obtuse angle is more than 90°","two of them would total more than 180°","so a triangle can hold only one obtuse angle."),
   [("acute angle","A triangle has at least two acute angles, often three, not at most one."),
    ("side","Every triangle has three sides, not at most one."),
    ("vertex","Every triangle has three vertices, not at most one.")]),

 ("TR","In a right-angled triangle, the two sides that form the right angle serve as the base and the:",
   "height",
   C("The two sides meeting at the right angle act as base and height for the area.")+
   steps("The right angle is made by two sides","one is taken as the base","the other, at right angles to it, is the height."),
   [("hypotenuse","The hypotenuse faces the right angle; it is neither the base nor the height here."),
    ("median","A median joins a vertex to a midpoint; it is not a side forming the right angle."),
    ("exterior angle","An exterior angle is an angle, not a side acting as a height.")]),

 ("TR","In any triangle, the longest side always lies opposite the:",
   "largest angle",
   C("Bigger angles open wider, so the side facing the biggest angle is the longest.")+
   steps("A wider angle spreads its two sides apart","the side across from it must stretch further","so the longest side faces the largest angle."),
   [("smallest angle","The smallest angle faces the shortest side, not the longest."),
    ("right angle only","This rule holds in every triangle, not just right-angled ones."),
    ("shortest side","A side cannot be opposite another side; it is opposite an angle.")]),
]

# ---------- RESPIRATION IN ORGANISMS (25) — Science ----------
RE = [
 ("RE","The process by which living cells break down food to release the energy stored in it is called:",
   "respiration",
   C("Respiration is the release of energy from food inside the cells.")+
   steps("Food carries stored chemical energy","cells break the food down","this frees energy for the body to use — respiration."),
   [("digestion","Digestion breaks food into simpler nutrients; respiration then releases its energy."),
    ("photosynthesis","Photosynthesis makes food using light; respiration breaks food down for energy."),
    ("excretion","Excretion removes waste; it does not release energy from food.")]),

 ("RE","Respiration that uses oxygen to break down glucose completely is called:",
   "aerobic respiration",
   C("Aerobic respiration breaks glucose down fully using oxygen.")+
   steps("Oxygen reaches the cells","it helps split glucose all the way","this oxygen-using release is aerobic respiration."),
   [("anaerobic respiration","Anaerobic respiration happens without oxygen, not with it."),
    ("photosynthesis","Photosynthesis builds food; it does not break glucose for energy."),
    ("transpiration","Transpiration is water loss from leaves, not the breakdown of glucose.")]),

 ("RE","Respiration that takes place without using any oxygen is called:",
   "anaerobic respiration",
   C("Anaerobic respiration releases energy from glucose without oxygen.")+
   steps("Oxygen is not available to the cells","glucose is only partly broken down","this oxygen-free release is anaerobic respiration."),
   [("aerobic respiration","Aerobic respiration needs oxygen, which this kind does without."),
    ("breathing","Breathing is taking air in and out, not a kind of cellular respiration."),
    ("digestion","Digestion breaks down food in the gut, not energy release without oxygen.")]),

 ("RE","During very hard exercise our muscle cells run short of oxygen and partly break glucose down into:",
   "lactic acid",
   C("Without enough oxygen, muscles make lactic acid as they release some energy.")+
   steps("Hard exercise uses oxygen faster than it arrives","muscles switch to anaerobic respiration","glucose is broken partly into lactic acid."),
   [("alcohol","Alcohol is made by yeast in anaerobic respiration, not by human muscles."),
    ("carbon dioxide and water only","That is the full aerobic result; oxygen-starved muscles make lactic acid instead."),
    ("glucose","Glucose is the starting food, not a product of its breakdown.")]),

 ("RE","The build-up of lactic acid in the muscles after running fast is felt by us as:",
   "muscle cramps",
   C("Lactic acid collecting in tired muscles causes cramps and aching.")+
   steps("Hard running makes muscles produce lactic acid","the acid builds up faster than it clears","this causes the cramping and ache we feel."),
   [("extra energy","Lactic acid is a sign of energy shortage, not a burst of extra energy."),
    ("cooling","Lactic acid does not cool the muscles; it makes them ache."),
    ("hunger","Hunger comes from low food stores, not from lactic acid in the muscles.")]),

 ("RE","Yeast carries out anaerobic respiration, breaking sugar down into alcohol and:",
   "carbon dioxide",
   C("Yeast turns sugar into alcohol and carbon dioxide gas without oxygen.")+
   steps("Yeast has no oxygen supply in the dough or vat","it breaks sugar only part-way","the products are alcohol and carbon dioxide."),
   [("oxygen","Yeast does not produce oxygen; aerobic respiration uses oxygen up."),
    ("lactic acid","Lactic acid is made by tired muscles, not by yeast."),
    ("water only","Water alone is not the gas product; yeast releases carbon dioxide.")]),

 ("RE","Dough rises and bread becomes spongy because the yeast in it releases the gas:",
   "carbon dioxide",
   C("Carbon dioxide bubbles from yeast puff up the dough.")+
   steps("Yeast feeds on the sugar in the dough","it releases carbon dioxide gas","the trapped bubbles make the dough rise."),
   [("oxygen","Yeast uses no oxygen here; the gas that puffs the dough is carbon dioxide."),
    ("nitrogen","Yeast does not release nitrogen; the rising gas is carbon dioxide."),
    ("hydrogen","Yeast does not release hydrogen; the bubbles are carbon dioxide.")]),

 ("RE","The taking in of air and giving it out, done by the body to exchange gases, is called:",
   "breathing",
   C("Breathing is the movement of air into and out of the body.")+
   steps("Air is drawn in through the nose","and pushed back out again","this in-and-out of air is breathing."),
   [("respiration","Respiration is the energy release inside cells; breathing just moves the air."),
    ("digestion","Digestion breaks down food in the gut, not the movement of air."),
    ("circulation","Circulation is the flow of blood, not the movement of air in and out.")]),

 ("RE","The breathing in of air, when it is drawn into the lungs, is called:",
   "inhalation",
   C("Inhalation is the breath in that fills the lungs with air.")+
   steps("The chest expands","air rushes into the lungs to fill the space","this breath in is inhalation."),
   [("exhalation","Exhalation is the breath out, the reverse of inhalation."),
    ("respiration","Respiration is the cell-level energy release, not the breath in."),
    ("transpiration","Transpiration is water vapour leaving a plant's leaves, not a breath in.")]),

 ("RE","The breathing out of air, when it is pushed out of the lungs, is called:",
   "exhalation",
   C("Exhalation is the breath out that empties air from the lungs.")+
   steps("The chest contracts","air is pushed back out of the lungs","this breath out is exhalation."),
   [("inhalation","Inhalation is the breath in, the reverse of exhalation."),
    ("percolation","Percolation is water sinking through soil, nothing to do with breathing out."),
    ("digestion","Digestion is the breakdown of food, not the pushing out of air.")]),

 ("RE","Compared with the air we breathe in, the air we breathe out has much more of the gas:",
   "carbon dioxide",
   C("Exhaled air is richer in carbon dioxide, the waste gas of respiration.")+
   steps("Cells use oxygen and make carbon dioxide","this carbon dioxide is carried to the lungs","so the air breathed out has more of it."),
   [("oxygen","We use up oxygen, so exhaled air has less of it, not more."),
    ("nitrogen","Nitrogen passes in and out almost unchanged; it is not what increases."),
    ("hydrogen","Hydrogen is not a main gas of breathing; carbon dioxide is what rises.")]),

 ("RE","The large, dome-shaped muscle lying below the lungs that helps in breathing is the:",
   "diaphragm",
   C("The diaphragm is the breathing muscle beneath the lungs.")+
   steps("It separates the chest from the belly","it moves down and up as we breathe","this changes the chest space — it is the diaphragm."),
   [("heart","The heart pumps blood; it is not the muscle that drives breathing."),
    ("liver","The liver processes food and blood; it has no role in breathing movements."),
    ("ribs","Ribs are bones that move with breathing, but the dome-shaped muscle is the diaphragm.")]),

 ("RE","When we breathe in, the diaphragm moves down and flattens, while the ribs move:",
   "up and out",
   C("During a breath in, the ribs swing up and outwards to widen the chest.")+
   steps("The diaphragm flattens downward","the ribs lift up and outward","together they enlarge the chest so air rushes in."),
   [("down and in","Down and in happens when breathing out, not breathing in."),
    ("in only","Both up and outward movement is needed; in only would shrink the chest."),
    ("not at all","The ribs do move; they swing up and out during a breath in.")]),

 ("RE","The number of times a person breathes in and out in one minute is called the:",
   "breathing rate",
   C("Breathing rate counts the breaths taken each minute.")+
   steps("Count each full breath in and out","do this over one minute","that count is the breathing rate."),
   [("heart rate","Heart rate counts heartbeats per minute, not breaths."),
    ("pulse","The pulse measures heartbeats felt in an artery, not breaths."),
    ("percolation rate","Percolation rate is about water draining through soil, not breathing.")]),

 ("RE","If a person breathes 18 times each minute, the number of breaths taken in 3 minutes is:",
   "54",
   C("Multiply the breaths per minute by the number of minutes.")+
   steps("Breaths per minute: 18","number of minutes: 3","18 × 3 = 54 breaths."),
   [("21","21 comes from adding 18 + 3; the total over time needs multiplication."),
    ("6","6 comes from 18 ÷ 3; you must multiply, not divide."),
    ("15","15 ignores the calculation; 18 × 3 gives 54.")]),

 ("RE","Fish take in the oxygen dissolved in water using their:",
   "gills",
   C("Gills let fish pull dissolved oxygen out of the water.")+
   steps("Water flows over the gills","oxygen in the water passes into the blood","so fish breathe through gills."),
   [("lungs","Fish do not have lungs for water; they use gills."),
    ("skin","Fish breathe mainly through gills, not their skin."),
    ("nostrils","A fish's nostrils smell the water; they do not take in oxygen like gills.")]),

 ("RE","An earthworm has no lungs or gills; it breathes through its moist:",
   "skin",
   C("Gases pass in and out through an earthworm's damp skin.")+
   steps("Its skin is kept moist","oxygen dissolves in the moisture and seeps in","so the earthworm breathes through its skin."),
   [("gills","Earthworms have no gills; they breathe through the skin."),
    ("nostrils","Earthworms have no nostrils or lungs; gas exchange is through the skin."),
    ("leaves","Leaves belong to plants; an earthworm breathes through its skin.")]),

 ("RE","Insects such as cockroaches take air into the body through tiny holes along their sides called:",
   "spiracles",
   C("Spiracles are the small openings through which insects take in air.")+
   steps("Air enters the tiny side openings","it travels through fine tubes inside","these openings are the spiracles."),
   [("stomata","Stomata are the breathing pores of leaves, not of insects."),
    ("gills","Gills belong to fish in water, not to air-breathing insects."),
    ("nostrils","Insects do not have nostrils; they use spiracles.")]),

 ("RE","Plants take in and give out gases for respiration mainly through tiny pores on their leaves called:",
   "stomata",
   C("Stomata are the leaf pores through which plants exchange gases.")+
   steps("Tiny pores dot the leaf surface","gases pass in and out through them","these pores are the stomata."),
   [("spiracles","Spiracles are the breathing holes of insects, not of leaves."),
    ("gills","Gills belong to fish; plants use stomata."),
    ("roots","Roots take in some air from soil, but leaf gas exchange is through stomata.")]),

 ("RE","The wind-pipe that carries air from the nose and throat down towards the lungs is the:",
   "trachea",
   C("The trachea is the tube that carries air down to the lungs.")+
   steps("Air passes the nose and throat","it travels down a firm tube in the neck","that air tube is the trachea."),
   [("oesophagus","The oesophagus is the food pipe; it carries food, not air."),
    ("aorta","The aorta is a large blood vessel, not an air passage."),
    ("diaphragm","The diaphragm is the breathing muscle, not the air tube.")]),

 ("RE","The pair of organs in our chest where oxygen passes from the air into the blood are the:",
   "lungs",
   C("The lungs are where oxygen crosses from air into the blood.")+
   steps("Air reaches the lungs through the trachea","oxygen seeps into the blood there","so the lungs are the gas-exchange organs."),
   [("kidneys","Kidneys filter the blood to make urine; they do not exchange air gases."),
    ("liver","The liver processes nutrients and blood; it is not where oxygen enters blood."),
    ("gills","Gills are for fish in water; humans use lungs.")]),

 ("RE","The roots of a plant get the oxygen they need for respiration from the:",
   "air spaces between soil particles",
   C("Roots breathe the air trapped in the gaps between soil grains.")+
   steps("Soil has air in the spaces between its particles","root cells take oxygen from this air","that is why waterlogged soil can suffocate roots."),
   [("sunlight","Sunlight is used to make food in leaves, not as a source of oxygen for roots."),
    ("leaves only","Leaves exchange their own gases; roots get oxygen from soil air."),
    ("water in the clouds","Roots take oxygen from soil air, not from clouds far above.")]),

 ("RE","The word equation for aerobic respiration is: glucose + oxygen → carbon dioxide + water +:",
   "energy",
   C("Aerobic respiration releases energy along with carbon dioxide and water.")+
   steps("Glucose joins with oxygen","they break down to carbon dioxide and water","and energy is set free — the whole point of respiration."),
   [("alcohol","Alcohol is a product of yeast's anaerobic respiration, not aerobic respiration."),
    ("lactic acid","Lactic acid forms in oxygen-starved muscles, not in full aerobic respiration."),
    ("sunlight","Sunlight is used in photosynthesis, not released by respiration.")]),

 ("RE","Lime water turns milky when we blow our breath through it, which proves that exhaled air contains:",
   "carbon dioxide",
   C("Carbon dioxide turns clear lime water milky, so the test detects it.")+
   steps("Blow exhaled air through lime water","the lime water goes cloudy and milky","this milkiness shows carbon dioxide is present."),
   [("oxygen","Oxygen does not turn lime water milky; carbon dioxide does."),
    ("hydrogen","Hydrogen does not cause the milky change; carbon dioxide does."),
    ("nitrogen","Nitrogen does not react with lime water; the milkiness shows carbon dioxide.")]),

 ("RE","Compared with our breathing while we sleep, our breathing rate while we are running:",
   "increases",
   C("Running needs more energy, so we breathe faster to take in more oxygen.")+
   steps("Running muscles need more energy","more energy needs more oxygen","so the breathing rate goes up."),
   [("decreases","Breathing speeds up during running; it does not slow down."),
    ("stops","Breathing certainly does not stop during exercise; it speeds up."),
    ("stays exactly the same","Exercise raises the demand for oxygen, so the rate rises, not stays equal.")]),
]

# ---------- ARITHMETIC EXPRESSIONS (25) — Maths ----------
AE = [
 ("AE","In the expression 7 + 3 × 4, following the correct order of operations, the part we work out first is:",
   "3 × 4",
   C("Multiplication is done before addition in the order of operations.")+
   steps("Scan the expression for × and ÷ first","here the multiplication is 3 × 4","so that part is worked out before the addition."),
   [("7 + 3","Addition is done after multiplication, so 7 + 3 is not the first step."),
    ("4 alone","A single number is not an operation; the first step is the multiplication 3 × 4."),
    ("7 × 4","The 7 is added, not multiplied by 4; the multiplication present is 3 × 4.")]),

 ("AE","The value of 7 + 3 × 4 is:",
   "19",
   C("Do the multiplication first, then the addition.")+
   steps("Multiply first: 3 × 4 = 12","then add: 7 + 12","the value is 19."),
   [("40","40 comes from doing 7 + 3 first; multiplication must come before addition."),
    ("14","14 is a wrong guess; 7 + (3 × 4) = 19, not 14."),
    ("84","84 comes from multiplying everything; only the 3 × 4 is multiplied here.")]),

 ("AE","The value of (7 + 3) × 4, where the bracket is done first, is:",
   "40",
   C("Brackets are always worked out before anything else.")+
   steps("Do the bracket first: 7 + 3 = 10","then multiply: 10 × 4","the value is 40."),
   [("19","19 is the value of 7 + 3 × 4 without the bracket; the bracket changes the order."),
    ("14","14 ignores the multiplication; 10 × 4 gives 40."),
    ("84","84 is not correct; the bracket gives 10, and 10 × 4 = 40.")]),

 ("AE","In the order of operations, brackets are always worked out:",
   "first",
   C("Whatever is inside brackets is calculated before the rest.")+
   steps("Look for brackets in the expression","solve everything inside them first","then carry on with the other operations."),
   [("last","Brackets come first, not last, in the order of operations."),
    ("after addition","Brackets are done before addition, not after it."),
    ("never","Brackets must be worked out; they are done first, not ignored.")]),

 ("AE","The value of 20 − 6 ÷ 2 is:",
   "17",
   C("Division is done before subtraction.")+
   steps("Divide first: 6 ÷ 2 = 3","then subtract: 20 − 3","the value is 17."),
   [("7","7 comes from doing 20 − 6 first; division must come before subtraction."),
    ("14","14 is a wrong guess; 20 − (6 ÷ 2) = 17, not 14."),
    ("10","10 is not correct; 6 ÷ 2 = 3 and 20 − 3 = 17.")]),

 ("AE","The parts of an expression that are separated from one another by + and − signs are called its:",
   "terms",
   C("Terms are the pieces of an expression split by plus and minus signs.")+
   steps("Find the + and − signs in the expression","the chunks between them are the terms","so + and − separate the terms."),
   [("factors","Factors are numbers multiplied together, not the parts split by + and −."),
    ("brackets","Brackets group parts of an expression; they are not the parts themselves."),
    ("products","A product is the result of multiplying; terms are split by + and −.")]),

 ("AE","In the expression 5 + 8 − 2, the terms are:",
   "5, 8 and −2",
   C("Each piece keeps the sign in front of it, so the terms are 5, 8 and −2.")+
   steps("Split at the + and − signs","the pieces are 5, then +8, then −2","so the terms are 5, 8 and −2."),
   [("5 and 8 only","The −2 is also a term; it must not be left out."),
    ("5 × 8","5 × 8 is a product; this expression uses + and −, giving terms, not a product."),
    ("just 11","11 is the value, not the list of terms that make up the expression.")]),

 ("AE","Without calculating, which is greater: 24 + 17 or 24 + 15?",
   "24 + 17",
   C("Both add to the same 24, so the one adding more is greater.")+
   steps("Both start from 24","17 is more than 15","so 24 + 17 is the greater total."),
   [("24 + 15","24 + 15 adds a smaller number, so it is the smaller total."),
    ("they are equal","They cannot be equal; 17 and 15 added to 24 give different totals."),
    ("cannot tell","You can tell at once: adding more to the same number gives more.")]),

 ("AE","Without working it out, the value of 38 − 12 compared with 38 − 20 is:",
   "greater than",
   C("Taking away less leaves more, so 38 − 12 is the larger result.")+
   steps("Both start from 38","12 taken away is less than 20 taken away","so 38 − 12 leaves more — it is greater."),
   [("less than","Subtracting the smaller amount leaves more, so 38 − 12 is not less."),
    ("equal to","They cannot be equal; removing 12 and removing 20 give different results."),
    ("cannot be compared","They can be compared at once: removing less leaves more.")]),

 ("AE","Using the distributive idea, 6 × 13 can be rewritten as:",
   "6 × 10 + 6 × 3",
   C("Splitting 13 into 10 + 3 and multiplying each part by 6 keeps the value the same.")+
   steps("Write 13 as 10 + 3","multiply each part by 6","6 × 13 = 6 × 10 + 6 × 3."),
   [("6 × 10 × 3","Multiplying the split parts together changes the value; they should be added."),
    ("6 + 10 + 3","Just adding the numbers drops the multiplication by 6 entirely."),
    ("6 × 10 − 3","The 6 must multiply the 3 as well, and the parts are added, not subtracted bare.")]),

 ("AE","By the distributive law, 8 × 99 is easiest to work out as:",
   "8 × 100 − 8",
   C("Treat 99 as 100 − 1, so 8 × 99 = 8 × 100 − 8 × 1.")+
   steps("Write 99 as 100 − 1","multiply each part by 8","8 × 99 = 8 × 100 − 8."),
   [("8 × 100 + 8","99 is one less than 100, so you subtract 8, not add it."),
    ("8 × 90 + 9","8 × 90 + 9 does not equal 8 × 99; the split must keep the value."),
    ("8 + 99","Adding loses the multiplication; 8 × 99 needs the product, not a sum.")]),

 ("AE","The value of 8 × 99 is:",
   "792",
   C("Use 8 × 100 − 8 to find it quickly.")+
   steps("8 × 100 = 800","subtract 8: 800 − 8","the value is 792."),
   [("808","808 comes from adding 8 instead of subtracting; 99 is one less than 100."),
    ("729","729 is a wrong figure; 800 − 8 gives 792."),
    ("891","891 is not correct; 8 × 99 = 792.")]),

 ("AE","Changing the order of the two numbers, 15 + 27 gives exactly the same answer as:",
   "27 + 15",
   C("Addition gives the same result whichever order the numbers are added.")+
   steps("Adding can be done in any order","swap 15 and 27","27 + 15 equals 15 + 27."),
   [("27 − 15","Subtraction is not the same as the addition; the order and sign both differ."),
    ("15 − 27","Changing + to − changes the value; this is not the same as 15 + 27."),
    ("27 × 15","Multiplying is a different operation and gives a far larger answer.")]),

 ("AE","Swapping the two numbers in 20 − 8 to make 8 − 20 changes the answer, which shows that subtraction is:",
   "not commutative",
   C("Order matters in subtraction, so it is not commutative.")+
   steps("20 − 8 gives 12","8 − 20 gives a different value (−12)","since order changes the answer, subtraction is not commutative."),
   [("commutative","If it were commutative the answer would not change, but it does."),
    ("the same either way","The two orders give different answers, so it is not the same either way."),
    ("always zero","20 − 8 is 12, not zero; the answer is certainly not always zero.")]),

 ("AE","Removing the brackets, the value of 50 − (20 + 5) is:",
   "25",
   C("Do the bracket first, then subtract the whole result.")+
   steps("Add inside the bracket: 20 + 5 = 25","subtract from 50: 50 − 25","the value is 25."),
   [("35","35 comes from 50 − 20 + 5; the whole 25 inside the bracket must be subtracted."),
    ("75","75 comes from adding instead of subtracting the bracket's value."),
    ("30","30 is a wrong guess; 50 − 25 = 25.")]),

 ("AE","The value of 30 − (10 − 4) is:",
   "24",
   C("Work out the bracket first, then subtract that result from 30.")+
   steps("Inside the bracket: 10 − 4 = 6","subtract from 30: 30 − 6","the value is 24."),
   [("16","16 comes from 30 − 10 − 4; the bracket's value 6 must be subtracted as one."),
    ("36","36 comes from 30 − 10 + 4; the bracket gives 6, not −6 added back wrongly."),
    ("20","20 is a wrong guess; 30 − 6 = 24.")]),

 ("AE","A soil sample lets 50 mL of water pass in each 10-minute period, for 4 such periods. The expression for the total water passed is:",
   "50 × 4",
   C("The same 50 mL is repeated 4 times, which is multiplication.")+
   steps("Each period passes 50 mL","there are 4 equal periods","total = 50 × 4 = 200 mL."),
   [("50 + 4","Adding 50 and 4 ignores that 50 mL repeats four times."),
    ("50 ÷ 4","Dividing would find a share, not the total of four equal amounts."),
    ("50 − 4","Subtracting makes no sense for totalling four equal amounts.")]),

 ("AE","A boy breathes 20 times a minute. The expression for the breaths he takes in 5 minutes plus 3 extra breaths is:",
   "20 × 5 + 3",
   C("Multiply the rate by the minutes, then add the extra breaths.")+
   steps("Breaths in 5 minutes: 20 × 5","add the 3 extra breaths","the expression is 20 × 5 + 3."),
   [("20 + 5 + 3","Adding the rate and minutes drops the repeated multiplication."),
    ("20 × (5 + 3)","The bracket would multiply the 3 by 20 too, but the 3 is just added on."),
    ("20 × 5 × 3","The 3 extra breaths are added, not multiplied in.")]),

 ("AE","The value of 20 × 5 + 3 is:",
   "103",
   C("Do the multiplication first, then add.")+
   steps("Multiply first: 20 × 5 = 100","then add: 100 + 3","the value is 103."),
   [("160","160 comes from 20 × (5 + 3); here the 3 is added after the multiplication."),
    ("28","28 comes from 20 + 5 + 3; the 20 and 5 must be multiplied."),
    ("130","130 is a wrong figure; 100 + 3 = 103.")]),

 ("AE","Which sign makes the statement true: 12 + 8 ___ 5 × 4?",
   "=",
   C("Work out both sides; if they match, the sign is the equals sign.")+
   steps("Left side: 12 + 8 = 20","right side: 5 × 4 = 20","both are 20, so they are equal."),
   [(">","The left side is not greater; both sides equal 20."),
    ("<","The left side is not smaller; both sides equal 20."),
    ("none","One sign does fit: the equals sign, since both sides are 20.")]),

 ("AE","The value of 3 × (4 + 2) − 5 is:",
   "13",
   C("Do the bracket first, then multiply, then subtract.")+
   steps("Bracket first: 4 + 2 = 6","multiply: 3 × 6 = 18","subtract: 18 − 5 = 13."),
   [("9","9 skips the bracket or the multiplication; the correct order gives 13."),
    ("15","15 comes from a wrong order; 3 × 6 − 5 = 13."),
    ("21","21 comes from adding instead of subtracting the 5; 18 − 5 = 13.")]),

 ("AE","Regrouping the numbers, (12 + 8) + 5 gives the same total as:",
   "12 + (8 + 5)",
   C("Addition can be regrouped without changing the total.")+
   steps("Adding can be grouped any way","move the brackets to the second pair","(12 + 8) + 5 = 12 + (8 + 5)."),
   [("12 − (8 + 5)","Changing + to − changes the value; regrouping keeps all the plus signs."),
    ("(12 × 8) + 5","Multiplying the first pair changes the operation and the value."),
    ("12 + 8 − 5","Turning the last + into − changes the total; regrouping keeps it the same.")]),

 ("AE","To make 6 × 47 easier, splitting 47 into 40 + 7 and multiplying each part by 6 uses the:",
   "distributive law",
   C("Breaking a number into parts and multiplying each part uses the distributive law.")+
   steps("Write 47 as 40 + 7","multiply each part by 6: 6 × 40 + 6 × 7","this split-and-multiply is the distributive law."),
   [("order of brackets only","Brackets help write it, but the rule that lets you split is the distributive law."),
    ("commutative law of subtraction","Subtraction is not even commutative; this split uses the distributive law."),
    ("no rule at all","There is a rule: the distributive law lets you split and multiply each part.")]),

 ("AE","In the expression 100 − 25 × 3, the very first step is to work out:",
   "25 × 3",
   C("Multiplication is done before subtraction.")+
   steps("Look for × first","here it is 25 × 3","so that multiplication is the first step."),
   [("100 − 25","Subtraction comes after multiplication, so 100 − 25 is not the first step."),
    ("100 × 3","The 100 is not multiplied by 3; the multiplication present is 25 × 3."),
    ("25 + 3","There is no addition here; the first step is the multiplication 25 × 3.")]),

 ("AE","The value of 100 − 25 × 3 is:",
   "25",
   C("Do the multiplication first, then subtract.")+
   steps("Multiply first: 25 × 3 = 75","then subtract: 100 − 75","the value is 25."),
   [("225","225 comes from (100 − 25) × 3; multiplication must come before subtraction."),
    ("75","75 is only 25 × 3; you still subtract it from 100 to get 25."),
    ("50","50 is a wrong guess; 100 − 75 = 25.")]),
]

# ---------- real-life use-case lines (25 each) ----------
SO_UC = [
 "Weathering is how the rock of distant mountains slowly turns into the soil of the plains.",
 "A soil profile is what road-builders expose when they slice through a hillside for a new highway.",
 "Gardeners read the soil horizons to know how deep to dig before they hit poor subsoil.",
 "The dark topsoil in your kitchen garden is the layer that actually feeds your plants.",
 "Compost you add to a pot turns into humus, the same dark stuff that enriches a forest floor.",
 "Sandy soil is why a beach drains within minutes after a wave washes over it.",
 "Potters dig clayey soil because its fine, sticky particles can be shaped and baked.",
 "Farmers prize loamy soil because it grows the widest range of vegetables and grains.",
 "Water-holding capacity is why a clay pot of basil needs watering less often than a sandy one.",
 "Builders test percolation before digging a soak-pit so that rainwater drains away properly.",
 "Working out a percolation rate is exactly what a farmer does to compare two fields' drainage.",
 "Comparing percolation times tells you which plot in a village will waterlog first in the monsoon.",
 "Wheat and gram fields across north India sit on the heavy, water-holding clayey-loam soils.",
 "Cotton belts of the Deccan grow on the light, well-draining sandy-loam soils of the region.",
 "Soil erosion is what strips a bare hillside after heavy rain, leaving deep gullies behind.",
 "Tree-planting drives on riverbanks work because the roots literally bind the soil in place.",
 "Dumping plastic and chemicals on open land is the soil pollution your town fights with bins.",
 "Builders dig past the subsoil to reach firm ground before laying a house foundation.",
 "Bedrock is the solid base quarry workers finally reach beneath all the loose soil above.",
 "Rubbing soil between your fingers to judge its texture is a test any farmer can do by hand.",
 "After a storm, sandy playgrounds are usable sooner because the water percolates away fast.",
 "Earthworms aerating a garden bed are why gardeners welcome them instead of removing them.",
 "Mixing sand into heavy garden clay to make loam is a classic trick for richer flower beds.",
 "The droplets on a jar lid when you warm moist soil show the very water your plants drink.",
 "Bubbles rising when you wet dry soil reveal the air that plant roots breathe underground.",
]
TR_UC = [
 "Builders trust the 180° angle-sum rule when they check that a triangular roof truss is drawn right.",
 "Equilateral triangles give road Yield signs their perfectly balanced three-sided shape.",
 "Isosceles triangles shape the two matching slopes of many simple house roofs.",
 "Scalene triangles appear whenever a ramp, a sail and the ground make three unequal sides.",
 "The 60° corners of an equilateral triangle are why three of them tile a flat surface neatly.",
 "Surveyors find a missing third angle by subtracting the two they measured from 180°.",
 "The set-squares in your geometry box are right-angled triangles used for drawing.",
 "The hypotenuse is the sloping reach a ladder makes against a wall — the triangle's longest side.",
 "The 3-4-5 right triangle is the carpenter's trick for marking a perfectly square corner.",
 "The 6-8-10 triangle scales the same square-corner trick up for larger building work.",
 "The exterior-angle rule helps a designer work out the bend where two roof beams meet.",
 "Adding the two far angles to get an exterior angle speeds up many drawing checks.",
 "A median marks the balance line artists use to find a triangle's centre of gravity.",
 "An altitude is the straight height you measure to work out a triangular flag's area.",
 "The three medians of a triangle meet at the one point where it balances on a pin.",
 "The triangle inequality is why you cannot build a triangle from two short twigs and one long one.",
 "Checking that two sides beat the third tells a craftsman whether three rods will close up.",
 "Equal base angles let bridge-makers trust a symmetric support to share its load evenly.",
 "Finding the odd angle of an isosceles triangle is a quick, exam-style calculation.",
 "Calling an equilateral triangle a special isosceles one shows how shapes nest inside each other.",
 "Splitting 180° in a ratio is how designers share out a triangle's angles in fixed proportions.",
 "Knowing two right angles are impossible stops beginners drawing triangles that cannot exist.",
 "Allowing only one obtuse angle is why very wide triangles still look the way they do.",
 "Using the two right-angle sides as base and height makes a right triangle's area easy to find.",
 "The longest-side-faces-largest-angle rule helps you sketch triangles in correct proportion.",
]
RE_UC = [
 "Respiration is the slow burning inside every cell that powers you even while you sleep.",
 "Aerobic respiration is what keeps you going on a long, steady walk with plenty of oxygen.",
 "Anaerobic respiration is the back-up your body falls on for a sudden, all-out sprint.",
 "Lactic acid is the tiredness you feel in your legs after sprinting up a long staircase.",
 "The cramp after fast running is your muscles complaining about the lactic acid they built up.",
 "Yeast making carbon dioxide is the same reaction that ferments juice into a fizzy drink.",
 "The little holes in a slice of bread are pockets of carbon dioxide left by busy yeast.",
 "Breathing is the chest movement you can watch rise and fall in a sleeping friend.",
 "Inhalation is the deep breath in you take just before blowing out birthday candles.",
 "Exhalation is the breath out that fogs up a cold window on a winter morning.",
 "The extra carbon dioxide you breathe out is what green plants happily use in daylight.",
 "The diaphragm is the muscle that twitches out of rhythm when you get the hiccups.",
 "The ribs lifting up and out is the movement you feel when you take a big deep breath.",
 "Doctors note your breathing rate along with your pulse during a health check-up.",
 "Multiplying breaths per minute by the minutes is how a nurse estimates total breaths taken.",
 "Gills are why a fish drowns in air yet thrives pulling oxygen straight from water.",
 "An earthworm staying moist underground is what lets its skin keep breathing.",
 "Spiracles along an insect's body are the tiny breathing holes you can spot under a lens.",
 "Stomata opening and closing on leaves is how a plant breathes without any lungs at all.",
 "The trachea is the windpipe you can feel as the firm tube down the front of your neck.",
 "Your lungs are the two organs an X-ray shows filling much of your chest.",
 "Roots breathing the air between soil grains is why over-watered pot plants suffocate and rot.",
 "The respiration word-equation is the energy recipe printed in every biology textbook.",
 "The lime-water-turning-milky test is a classroom favourite for catching carbon dioxide.",
 "Your breathing speeding up during games is your body grabbing oxygen faster for energy.",
]
AE_UC = [
 "Order of operations is what a calculator follows so 7 + 3 × 4 comes to 19, not 40.",
 "Getting 19 from 7 + 3 × 4 is the rule that keeps everyone's answer the same.",
 "Brackets giving 40 show how a shopkeeper groups a discount before multiplying.",
 "Doing brackets first is the habit that keeps a long bill adding up correctly.",
 "Spreadsheets apply 20 − 6 ÷ 2 = 17 automatically the moment you type the formula.",
 "Spotting the terms split by + and − is the first step in tidying up any expression.",
 "Listing terms with their signs is how you keep track of money coming in and going out.",
 "Comparing 24 + 17 with 24 + 15 by eye saves time when checking two quick bills.",
 "Judging 38 − 12 against 38 − 20 without sums is a handy mental-maths shortcut.",
 "Splitting 6 × 13 into 6 × 10 + 6 × 3 is the trick behind fast mental multiplication.",
 "Turning 8 × 99 into 8 × 100 − 8 is how a market seller totals near-round prices quickly.",
 "Getting 792 from 8 × 99 the smart way beats long multiplication every time.",
 "Swapping 15 + 27 to 27 + 15 is the freedom that lets you add a column from either end.",
 "Knowing 20 − 8 is not 8 − 20 stops costly mistakes when subtracting account balances.",
 "Removing the brackets in 50 − (20 + 5) is just what you do when paying off two charges at once.",
 "Handling 30 − (10 − 4) carefully avoids errors when a refund sits inside a deduction.",
 "Writing 50 × 4 for repeated drainage is how a scientist totals up a soil experiment.",
 "Writing 20 × 5 + 3 for breaths shows how a formula captures a real counting task.",
 "Getting 103 from 20 × 5 + 3 confirms that the breathing-count formula works.",
 "Choosing the = sign for 12 + 8 and 5 × 4 is how you check that two offers are really equal.",
 "Evaluating 3 × (4 + 2) − 5 step by step is the discipline every exam question rewards.",
 "Regrouping (12 + 8) + 5 freely is the rule that lets you add up friends' scores in any order.",
 "Splitting 47 into 40 + 7 to multiply by 6 is everyday mental-maths in a busy shop.",
 "Spotting that × comes before − in 100 − 25 × 3 prevents a common billing slip.",
 "Getting 25 from 100 − 25 × 3 shows exactly why the multiplication-first rule matters.",
]


def _with_uc(lst, ucs):
    assert len(lst) == len(ucs) == 25
    out = []
    for it, uc in zip(lst, ucs):
        code, stem, correct, html, distr = it
        out.append((code, stem, correct, html + U(uc), distr))
    return out


SO = _with_uc(SO, SO_UC)
TR = _with_uc(TR, TR_UC)
RE = _with_uc(RE, RE_UC)
AE = _with_uc(AE, AE_UC)

items = []
for i in range(25):
    items += [SO[i], TR[i], RE[i], AE[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=29317,
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
    split = "/".join(str(counts[c]) for c in ("SO", "TR", "RE", "AE"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Soil",
                     "The Triangle & its Properties",
                     "Respiration in Organisms",
                     "Arithmetic Expressions"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
