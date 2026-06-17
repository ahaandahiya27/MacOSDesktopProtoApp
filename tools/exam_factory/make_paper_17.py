# -*- coding: utf-8 -*-
# Boss Challenge Paper 17 — Respiration in Organisms · Lines & Angles
#                          · Electric Current & its Effects · Exponents & Powers
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans into FUSION — a Respiration context (a
# yeast cell or a bacterium that DOUBLES) wrapped around an Exponents skill
# (powers of 2), a breathing-rate context wrapped around simple multiplication,
# and a compass-deflection context (Electric Current's magnetic effect) wrapped
# around a Lines-&-Angles skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_17_<SHORT>_QuestionPaper.html  (pure HTML — questions + options, no answers)
#   Paper_17_<SHORT>_QuestionPaper.pdf
#   Paper_17_<SHORT>_Questions.md
#   Paper_17_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "17"
SHORT = "Respiration_LinesAngles_ElectricCurrent_Exponents"
TITLE = "Respiration in Organisms · Lines & Angles · Electric Current & its Effects · Exponents & Powers"
LABELS = {
    "RE": "Respiration in Organisms",
    "LA": "Lines & Angles",
    "EC": "Electric Current & its Effects",
    "EP": "Exponents & Powers",
}

# ---------- RESPIRATION IN ORGANISMS (25) — Science ----------
RE = [
 ("RE","The main job of respiration inside a living cell is to break down food in order to:",
   "release energy",
   C("Respiration breaks down food, mainly glucose, to release the energy a cell needs to work.")+
   steps("Food such as glucose is the cell's fuel","Respiration breaks the glucose down","The stored energy is released for the body to use.")+
   U("The energy from your breakfast lets you walk, think and play through the morning."),
   [("make more food","Plants make food in photosynthesis; respiration uses food up, it does not make it."),
    ("remove all water","Respiration produces a little water; its purpose is energy, not removing water."),
    ("cool the body down","Respiration actually releases warmth; cooling is done by sweating, not respiration.")]),

 ("RE","During aerobic respiration the body uses up a gas taken in from the air. That gas is:",
   "oxygen",
   C("Aerobic respiration needs oxygen to break glucose down fully and release plenty of energy.")+
   steps("We breathe air in through the nose","The lungs hand oxygen to the blood","Cells use that oxygen to burn glucose.")+
   U("You breathe faster while running because your muscles are calling for more oxygen."),
   [("nitrogen","Air is mostly nitrogen, but the body does not use it in respiration."),
    ("carbon dioxide","Carbon dioxide is given OUT by respiration, not taken in for it."),
    ("hydrogen","There is almost no free hydrogen in the air, and the body does not breathe it in.")]),

 ("RE","The gas that a person breathes OUT in a larger amount than they breathe in is:",
   "carbon dioxide",
   C("Respiration produces carbon dioxide, so exhaled air is richer in it than the air taken in.")+
   steps("Cells burn glucose using oxygen","Carbon dioxide is made as a waste gas","It is carried to the lungs and breathed out.")+
   U("Breathing onto a cold mirror or into lime water shows the carbon dioxide you give out."),
   [("oxygen","We breathe oxygen IN and use it up, so exhaled air has less oxygen, not more."),
    ("nitrogen","Nitrogen passes in and out almost unchanged; its amount barely differs."),
    ("water vapour only","Exhaled air does carry water vapour, but the gas asked about here is carbon dioxide.")]),

 ("RE","A simple test in the lab to show that exhaled air contains carbon dioxide is that it turns:",
   "lime water milky",
   C("Carbon dioxide reacts with clear lime water and turns it milky white.")+
   steps("Blow exhaled air through clear lime water","The carbon dioxide reacts with the lime water","The liquid turns milky, proving CO2 is present.")+
   U("This same milky-lime-water test is used in school labs to detect carbon dioxide."),
   [("blue litmus red","That test shows an acid in general, not specifically the gas you breathe out."),
    ("starch blue-black","Iodine on starch gives blue-black; it has nothing to do with carbon dioxide."),
    ("a glowing splint bright","A glowing splint flares up in oxygen, not in carbon dioxide.")]),

 ("RE","The tiny structures inside a cell where most energy is released are nicknamed the powerhouse. They are the:",
   "mitochondria",
   C("Mitochondria are the cell organelles where respiration releases most of the cell's energy.")+
   steps("Glucose and oxygen reach the cell","Inside the mitochondria they react","Energy is released, so the mitochondria are the powerhouse.")+
   U("Muscle cells, which need lots of energy, are packed with many mitochondria."),
   [("chloroplasts","Chloroplasts trap sunlight to make food; they do not release energy by respiration."),
    ("vacuoles","A vacuole stores sap and water; it is not where energy is released."),
    ("cell walls","A cell wall gives shape and support; it has no role in releasing energy.")]),

 ("RE","When there is not enough oxygen, yeast carries out anaerobic respiration and produces alcohol along with the gas:",
   "carbon dioxide",
   C("Yeast respiring without oxygen makes alcohol and carbon dioxide — this is fermentation.")+
   steps("Yeast gets little or no oxygen","It breaks glucose down only partly","Alcohol and carbon dioxide are formed.")+
   U("The carbon dioxide from yeast makes bread dough rise and gives it a spongy texture."),
   [("oxygen","Yeast in this case lacks oxygen; it does not produce oxygen as a product."),
    ("hydrogen","Fermentation by yeast gives carbon dioxide, not hydrogen gas."),
    ("nitrogen","Nitrogen is not a product of yeast respiration.")]),

 ("RE","After running very fast, the muscles in your legs may respire without enough oxygen and build up:",
   "lactic acid",
   C("In our muscles, anaerobic respiration produces lactic acid, which causes cramps.")+
   steps("Hard exercise outpaces the oxygen supply","Muscles respire partly without oxygen","Lactic acid collects and the muscle aches.")+
   U("The cramp you feel after a sprint eases off after rest, as oxygen clears the lactic acid."),
   [("alcohol","Yeast makes alcohol without oxygen; human muscles make lactic acid instead."),
    ("glucose","Glucose is the fuel being used up, not the waste that builds up."),
    ("starch","Starch is a stored food, not a product of muscle respiration.")]),

 ("RE","Humans take air into a pair of spongy organs in the chest. These breathing organs are the:",
   "lungs",
   C("The lungs are the pair of organs where air is taken in and gases are exchanged.")+
   steps("Air travels down the windpipe","It reaches the two lungs in the chest","Inside the lungs oxygen passes into the blood.")+
   U("A doctor listens to your lungs with a stethoscope to check that you are breathing well."),
   [("kidneys","Kidneys filter the blood to make urine; they are not breathing organs."),
    ("gills","Gills are the breathing organs of fish, not of humans."),
    ("liver","The liver handles food and cleans the blood; it does not take in air.")]),

 ("RE","A fish stays underwater all its life and takes in oxygen dissolved in the water using its:",
   "gills",
   C("Fish breathe through gills, which absorb oxygen that is dissolved in water.")+
   steps("Water flows in through the fish's mouth","It passes over the feathery gills","The gills take in the dissolved oxygen.")+
   U("A fish kept in stale, low-oxygen water gulps at the surface because its gills cannot get enough."),
   [("lungs","Fish do not have lungs; they use gills to breathe underwater."),
    ("skin only","A few animals breathe through skin, but a fish mainly uses its gills."),
    ("spiracles","Spiracles are the breathing holes of insects, not of fish.")]),

 ("RE","An earthworm has no lungs or gills. It exchanges gases for respiration through its:",
   "moist skin",
   C("An earthworm breathes through its moist skin, which lets gases pass in and out.")+
   steps("The earthworm's skin is kept damp","Oxygen dissolves in the moisture","It then passes through the thin skin into the body.")+
   U("Earthworms come up to the surface in heavy rain because waterlogged soil leaves their skin too short of air."),
   [("dry scales","Earthworms have soft, moist skin, not dry scales, and scales would block gas exchange."),
    ("a pair of lungs","Earthworms have no lungs; they rely entirely on their moist skin."),
    ("feathery gills","Gills belong to water animals like fish, not to the earthworm.")]),

 ("RE","Insects such as a cockroach take air directly into their bodies through tiny breathing holes called:",
   "spiracles",
   C("Insects breathe through spiracles — small holes that lead into air tubes called tracheae.")+
   steps("Air enters the body through the spiracles","It travels along tubes called tracheae","These tubes carry air to every part of the insect.")+
   U("A cockroach does not use lungs at all; its spiracles and air tubes deliver oxygen straight to its tissues."),
   [("alveoli","Alveoli are the tiny air sacs inside human lungs, not the holes on an insect."),
    ("stomata","Stomata are the breathing pores of leaves, not of insects."),
    ("gills","Gills are for water animals; an insect like a cockroach uses spiracles.")]),

 ("RE","A green plant does not have a nose. The tiny pores on its leaves through which gases pass are the:",
   "stomata",
   C("Stomata are small pores on leaves through which a plant exchanges gases.")+
   steps("Each leaf has many tiny pores called stomata","Oxygen and carbon dioxide move through them","So the leaf exchanges gases without any lungs.")+
   U("On a hot day a plant can close its stomata to save water, just like shutting tiny windows."),
   [("roots only","Roots take in some air from the soil, but the leaf's gas pores are the stomata."),
    ("xylem tubes","Xylem carries water up the plant; it does not exchange breathing gases with the air."),
    ("the bark","Bark is the protective outer cover; the pores asked about are the stomata.")]),

 ("RE","When you breathe IN, a sheet of muscle below your lungs flattens and moves down. This muscle is the:",
   "diaphragm",
   C("The diaphragm flattens and moves down during inhalation, making room for air.")+
   steps("The diaphragm contracts and flattens","The chest cavity gets bigger","Air rushes into the lungs to fill the space.")+
   U("Place a hand on your stomach and breathe in — you can feel the chest expand as the diaphragm drops."),
   [("the heart","The heart pumps blood; it does not move down to pull air in."),
    ("the windpipe","The windpipe is the tube carrying air; it is not the muscle that flattens."),
    ("the ribs alone","The ribs help, but the dome-shaped muscle that flattens is the diaphragm.")]),

 ("RE","Taking air into the body and giving it out is called breathing, while the release of energy from food is called:",
   "respiration",
   C("Breathing is the in-and-out of air; respiration is the energy-releasing breakdown of food in cells.")+
   steps("Breathing moves air in and out of the lungs","Respiration happens inside the cells","There, food is broken down to release energy.")+
   U("You can hold your breath for a moment, but respiration in your cells never stops."),
   [("digestion","Digestion breaks food into simpler bits; respiration then releases energy from them."),
    ("transpiration","Transpiration is the loss of water vapour from a plant, not energy release."),
    ("circulation","Circulation is the flow of blood; it is not the release of energy from food.")]),

 ("RE","Bubbles of gas trapped in rising bread dough come from yeast. As the dough is baked, this makes the bread:",
   "soft and full of holes",
   C("Carbon dioxide from yeast forms bubbles that make baked bread light and porous.")+
   steps("Yeast respires in the dough and releases carbon dioxide","The gas forms many bubbles","Baking sets the dough around them, leaving soft holes.")+
   U("The carbon dioxide from yeast is what gives a slice of bread its soft, holey texture."),
   [("hard and solid","The gas bubbles do the opposite — they make the bread light, not hard."),
    ("sour and wet","Bread is baked dry; the bubbles make it spongy, not sour and wet."),
    ("flat with no rise","Without yeast gas the bread would stay flat; the gas is what makes it rise.")]),

 ("RE","The roots of a land plant also need to breathe. They get the oxygen they use from the:",
   "air spaces between soil particles",
   C("Soil has air in the gaps between its particles, and roots take oxygen from there.")+
   steps("Soil grains do not pack perfectly","Air fills the tiny gaps between them","Root cells take oxygen from this trapped soil air.")+
   U("Over-watering a potted plant can rot the roots because water fills the gaps and shuts out the air."),
   [("sunlight on the leaves","Leaves use sunlight to make food; roots cannot get oxygen from sunlight."),
    ("water rising in the stem","Water travels up the stem, but the roots get their oxygen from soil air."),
    ("carbon dioxide in the soil","Roots need oxygen for respiration; carbon dioxide is the waste they give out.")]),

 ("RE","Aerobic respiration releases much more energy than anaerobic respiration because aerobic respiration:",
   "uses oxygen to break glucose down completely",
   C("With oxygen, glucose is broken down fully, so far more energy is released.")+
   steps("Aerobic respiration has plenty of oxygen","Glucose is broken right down to carbon dioxide and water","This complete breakdown frees the most energy.")+
   U("This is why active animals rely on oxygen-using aerobic respiration to get plenty of energy."),
   [("makes alcohol as well","Making alcohol is anaerobic and releases LESS energy, not more."),
    ("works only in plants","Aerobic respiration happens in animals too, not only in plants."),
    ("needs no food at all","All respiration needs food; energy cannot come from nothing.")]),

 ("RE","Gas exchange in the human lungs happens at millions of tiny, balloon-like air sacs called:",
   "alveoli",
   C("Alveoli are the tiny air sacs in the lungs where oxygen enters the blood.")+
   steps("Air reaches the ends of the airways","There it fills tiny sacs called alveoli","Oxygen passes from the alveoli into the blood.")+
   U("The huge number of tiny alveoli gives the lungs a vast surface to soak up oxygen quickly."),
   [("spiracles","Spiracles are the breathing holes of insects, not the sacs in human lungs."),
    ("nostrils","Nostrils are where air enters the nose; gas exchange happens deep in the alveoli."),
    ("villi","Villi are tiny finger-like folds in the intestine for absorbing food, not gases.")]),

 ("RE","A frog is special because, besides its lungs, it can also take in oxygen through its:",
   "moist skin",
   C("A frog can breathe through its moist skin as well as through its lungs.")+
   steps("On land the frog mostly uses its lungs","In water it relies on its damp skin","Oxygen passes straight through the moist skin into the blood.")+
   U("A frog resting at the bottom of a pond keeps taking in oxygen through its moist skin."),
   [("gills throughout life","A tadpole has gills, but an adult frog uses lungs and skin, not gills."),
    ("dry feathers","Frogs have no feathers; their skin is moist, which is what helps them breathe."),
    ("a shell","Frogs have no shell; their breathing surface is the moist skin.")]),

 ("RE","FUSION: A single yeast cell respires and DOUBLES into two every hour. Starting from one cell, the number after 5 hours is best written as the power:",
   "2 to the power 5, which equals 32",
   C("Doubling once an hour for 5 hours multiplies by 2 five times: 2⁵ = 32.")+
   steps("Start: 1 cell","Each hour the count is multiplied by 2","After 5 hours: 1 × 2 × 2 × 2 × 2 × 2 = 2⁵ = 32 cells.")+
   U("This rapid doubling is why a little yeast can make a whole bowl of dough rise."),
   [("5 to the power 2, which equals 25","The base that doubles is 2 and it acts 5 times, so it is 2⁵, not 5²."),
    ("2 to the power 4, which equals 16","Five doublings give 2⁵; four doublings (2⁴ = 16) is one hour short."),
    ("2 times 5, which equals 10","Doubling repeatedly is multiplying, giving 2⁵ = 32, not 2 × 5 = 10.")]),

 ("RE","FUSION: At rest a child breathes 18 times each minute. The total number of breaths taken in a quarter of an hour (15 minutes) is:",
   "270 breaths",
   C("Breaths add up at a steady rate, so multiply the per-minute rate by the minutes.")+
   steps("Breathing rate = 18 breaths per minute","Time = 15 minutes","Total = 18 × 15 = 270 breaths.")+
   U("Doctors use the breaths-per-minute rate to check how well a patient is breathing."),
   [("33 breaths","Adding 18 + 15 mixes up the units; you must multiply rate by time."),
    ("180 breaths","That uses only 10 minutes (18 × 10); the question asks for 15 minutes."),
    ("1080 breaths","That is 18 × 60, a full hour; 15 minutes gives 18 × 15 = 270.")]),

 ("RE","We start to breathe faster and more deeply during exercise mainly because the working muscles:",
   "need extra oxygen to release more energy",
   C("Exercising muscles demand more energy, so they need more oxygen, and breathing speeds up.")+
   steps("Muscles work harder and need more energy","More energy needs more oxygen","So breathing speeds up to take in extra oxygen.")+
   U("After climbing stairs you pant for a while until your muscles get the extra oxygen they used."),
   [("are trying to cool down","Faster breathing is about getting oxygen, not mainly about cooling."),
    ("need to take in carbon dioxide","Muscles need oxygen IN; carbon dioxide is the waste sent out."),
    ("have stopped respiring","Exercising muscles respire faster, not less, which is why breathing rises.")]),

 ("RE","Cells that need a great deal of energy, such as busy muscle cells, contain a large number of:",
   "mitochondria",
   C("More mitochondria mean more respiration, so high-energy cells are rich in them.")+
   steps("Busy cells need lots of energy","Energy is released in the mitochondria","So such cells pack in many mitochondria.")+
   U("Heart muscle, which never rests, is packed with mitochondria to keep its energy flowing."),
   [("vacuoles","Large vacuoles store sap or water; they do not boost energy release."),
    ("cell walls","A cell has only one wall and it is for support, not energy."),
    ("nuclei","A cell usually has a single nucleus that controls it, not many for energy.")]),

 ("RE","When you breathe OUT, the diaphragm relaxes and the chest cavity becomes smaller. This pushes the air out because the:",
   "space for the lungs shrinks",
   C("On exhaling, the chest cavity shrinks, squeezing the lungs so air flows out.")+
   steps("The diaphragm relaxes and curves up","The chest cavity gets smaller","The lungs are squeezed and push air out.")+
   U("Feel your chest fall as you breathe out — the shrinking space pushes the stale air away."),
   [("diaphragm flattens down","Flattening down happens when breathing IN, not breathing out."),
    ("lungs fill with more air","Breathing out empties the lungs; they do not take in more air then."),
    ("ribs swing further out","The ribs move IN and down when breathing out, not further out.")]),

 ("RE","Tiny living things (microbes) in the soil and the air also respire. This tells us that respiration is a process carried out by:",
   "all living organisms",
   C("Every living thing — plant, animal or microbe — respires to release energy.")+
   steps("Plants, animals and microbes are all alive","Every living cell needs energy","So respiration is common to all living organisms.")+
   U("From a tiny soil microbe to a giant whale, every living thing must respire to stay alive."),
   [("only large animals","Even the smallest microbes respire, not just large animals."),
    ("only green plants","Plants respire, but so do animals and microbes; it is not plants alone."),
    ("only animals that move","Even still plants and microbes respire, so movement is not the test.")]),
]

# ---------- LINES & ANGLES (25) — Maths ----------
LA = [
 ("LA","Two angles whose measures add up to exactly 90° are called:",
   "complementary angles",
   C("A pair of angles that sum to 90° are complementary to each other.")+
   steps("Add the two angle measures","If the total is 90°","then the angles are complementary.")+
   U("Two angles of a set square, 30° and 60°, are complementary because together they make 90°."),
   [("supplementary angles","Supplementary angles add to 180°, not 90°."),
    ("vertically opposite angles","Vertically opposite angles are equal; they need not add to 90°."),
    ("adjacent angles","Adjacent angles only share a vertex and arm; their sum can be anything.")]),

 ("LA","Two angles whose measures add up to exactly 180° are called:",
   "supplementary angles",
   C("A pair of angles that sum to 180° are supplementary to each other.")+
   steps("Add the two angle measures","If the total is 180°","then the angles are supplementary.")+
   U("The two angles a folding signboard makes on a straight edge add up to 180° — they are supplementary."),
   [("complementary angles","Complementary angles add to 90°, not 180°."),
    ("corresponding angles","Corresponding angles sit in matching corners at a transversal; they need not sum to 180°."),
    ("acute angles","An acute angle is simply one less than 90°; it is not about a pair summing to 180°.")]),

 ("LA","The complement of an angle of 35° (the angle you add to make 90°) is:",
   "55°",
   C("Complement = 90° − the angle.")+
   steps("Complement = 90° − 35°","90 − 35 = 55","So the complement is 55°.")+
   U("A ramp tilted 35° from a wall leaves a 55° gap up to the upright — its complement."),
   [("65°","65° would come from 90 − 25; here you subtract 35, giving 55°."),
    ("145°","145° = 180 − 35, which is the SUPPLEMENT, not the complement."),
    ("35°","An angle equals its complement only at 45°; 35° pairs with 55°.")]),

 ("LA","The supplement of an angle of 110° (the angle you add to make 180°) is:",
   "70°",
   C("Supplement = 180° − the angle.")+
   steps("Supplement = 180° − 110°","180 − 110 = 70","So the supplement is 70°.")+
   U("A ladder leaning at 110° on one side leaves 70° on the other side along the ground."),
   [("80°","80° = 90 − 10 has nothing to do with this; 180 − 110 = 70."),
    ("250°","You cannot have a supplement above 180°; the answer is 180 − 110 = 70°."),
    ("110°","An angle equals its supplement only at 90°; 110° pairs with 70°.")]),

 ("LA","When two straight lines cross, the pair of angles directly opposite each other at the crossing are always:",
   "equal",
   C("Vertically opposite angles, formed when two lines cross, are equal.")+
   steps("Two lines cross at one point","This makes two pairs of opposite angles","Each opposite pair is equal.")+
   U("The opposite corners where two roads cross always open by the same angle."),
   [("supplementary","Opposite angles are equal; it is the ADJACENT pairs that add to 180°."),
    ("always 90°","Opposite angles are equal to each other but need not be 90°."),
    ("complementary","Opposite angles are equal, not a pair summing to 90°.")]),

 ("LA","Two adjacent angles formed on a straight line (a linear pair) always add up to:",
   "180°",
   C("The angles of a linear pair lie on a straight line, so they sum to 180°.")+
   steps("The two angles sit on a straight line","A straight angle measures 180°","So the linear pair adds up to 180°.")+
   U("An open laptop lid and its base split a straight line into two angles that total 180°."),
   [("90°","90° is a right angle; a straight line gives 180°."),
    ("360°","360° is a full turn around a point, not the angle on one straight line."),
    ("270°","A straight line accounts for 180°, not 270°.")]),

 ("LA","An angle that measures more than 90° but less than 180° is called:",
   "an obtuse angle",
   C("An obtuse angle lies between 90° and 180°.")+
   steps("Check if the angle is bigger than 90°","Check it is still under 180°","If both are true it is obtuse.")+
   U("The wide angle of an open pair of scissors, past a right angle, is obtuse."),
   [("an acute angle","An acute angle is LESS than 90°, not between 90° and 180°."),
    ("a right angle","A right angle is exactly 90°, not more."),
    ("a reflex angle","A reflex angle is more than 180°, larger than an obtuse angle.")]),

 ("LA","An angle that measures more than 180° but less than 360° is called:",
   "a reflex angle",
   C("A reflex angle is greater than 180° and less than a full turn of 360°.")+
   steps("Check the angle is bigger than 180°","Check it is still under 360°","Then it is a reflex angle.")+
   U("The big angle a clock's hands sweep from 12 right round past 6 is a reflex angle."),
   [("an obtuse angle","An obtuse angle is under 180°, smaller than a reflex angle."),
    ("a straight angle","A straight angle is exactly 180°, not more."),
    ("a complete angle","A complete angle is exactly 360°, a full turn, not less.")]),

 ("LA","The line that crosses two or more other lines at distinct points is called a:",
   "transversal",
   C("A transversal is a line that cuts across two or more lines.")+
   steps("Draw two lines","Draw a third line cutting both","That cutting line is the transversal.")+
   U("A road crossing two parallel railway tracks acts as a transversal."),
   [("parallel line","Parallel lines run alongside and never meet; a transversal cuts across them."),
    ("perpendicular only","A transversal may cross at any angle, not only at 90°."),
    ("ray","A ray starts at a point and goes one way; a transversal cuts across other lines.")]),

 ("LA","When a transversal cuts two parallel lines, each pair of corresponding angles is:",
   "equal",
   C("Corresponding angles between parallel lines, cut by a transversal, are equal.")+
   steps("A transversal crosses two parallel lines","Angles in matching corners are corresponding","On parallel lines these are equal.")+
   U("On a zebra crossing's parallel stripes, matching corner angles stay equal."),
   [("supplementary","Corresponding angles are equal; co-interior angles are the ones that sum to 180°."),
    ("complementary","Corresponding angles are equal, not a pair adding to 90°."),
    ("always right angles","They are equal to each other, but need not each be 90°.")]),

 ("LA","When a transversal cuts two parallel lines, a pair of co-interior (allied) angles on the same side adds up to:",
   "180°",
   C("Co-interior angles between parallel lines are supplementary, summing to 180°.")+
   steps("Look at the two interior angles on the same side","On parallel lines these are co-interior angles","Their sum is 180°.")+
   U("Between two parallel shelf edges, the same-side angles a bracket makes add to 180°."),
   [("90°","Co-interior angles sum to 180°, not 90°."),
    ("they are equal","It is corresponding and alternate angles that are equal; co-interior ones sum to 180°."),
    ("360°","A single pair of co-interior angles sums to 180°, not 360°.")]),

 ("LA","Two angles form a linear pair. If one of them is 70°, the other angle must be:",
   "110°",
   C("A linear pair adds to 180°, so subtract the known angle from 180°.")+
   steps("The two angles add to 180°","Other angle = 180° − 70°","180 − 70 = 110°.")+
   U("If a signpost arm tilts to 70° on one side, the other side of the line shows 110°."),
   [("20°","20° = 90 − 70 would be the complement; a linear pair needs 180 − 70 = 110°."),
    ("70°","The two are equal only if each is 90°; here 70° pairs with 110°."),
    ("290°","An angle of a linear pair cannot exceed 180°; the answer is 110°.")]),

 ("LA","Two lines crossing make four angles. If one angle is 65°, the angle vertically opposite to it is:",
   "65°",
   C("Vertically opposite angles are equal, so the opposite angle is the same.")+
   steps("Two lines cross at a point","The angle directly opposite is vertically opposite","Vertically opposite angles are equal, so it is 65°.")+
   U("Where two pencils cross at 65°, the angle straight across is also 65°."),
   [("115°","115° = 180 − 65 is the ADJACENT angle, not the opposite one."),
    ("25°","25° = 90 − 65 is the complement; the opposite angle is equal at 65°."),
    ("90°","Opposite angles equal each other; they are 65°, not automatically 90°.")]),

 ("LA","The special angle that is exactly equal to its own complement is:",
   "45°",
   C("An angle equals its complement when both are 45°, since 45 + 45 = 90.")+
   steps("Let the angle equal its complement","Then angle + angle = 90°","So 2 × angle = 90°, giving angle = 45°.")+
   U("A diagonal fold that splits a right-angled corner in half makes two equal 45° angles."),
   [("90°","90° has a complement of 0°; an angle equal to its complement is 45°."),
    ("30°","30° pairs with 60°, so it does not equal its own complement."),
    ("60°","60° pairs with 30°, so it is not equal to its complement.")]),

 ("LA","Two lines in a plane that always stay the same distance apart and never meet, however far they go, are called:",
   "parallel lines",
   C("Parallel lines never meet and keep a constant distance apart.")+
   steps("The two lines run side by side","They keep the same gap everywhere","Since they never meet, they are parallel.")+
   U("The two rails of a train track stay parallel so they never meet, however far they run."),
   [("intersecting lines","Intersecting lines cross at a point; parallel lines never meet."),
    ("perpendicular lines","Perpendicular lines meet at 90°; parallel lines do not meet at all."),
    ("concurrent lines","Concurrent lines all pass through one common point, the opposite of parallel.")]),

 ("LA","The sum of all the angles formed around a single point (going once all the way round) is:",
   "360°",
   C("Angles around a point make one full turn, which is 360°.")+
   steps("Imagine turning all the way around the point","One full turn is 360°","So the angles around a point add to 360°.")+
   U("The hands of a clock sweep a full 360° around its centre in twelve hours."),
   [("180°","180° is the angle on a straight line, only half a turn."),
    ("90°","90° is a single right angle, far less than a full turn."),
    ("270°","270° is three-quarters of a turn; a full turn is 360°.")]),

 ("LA","Two complementary angles are exactly equal to each other. Each of these angles measures:",
   "45°",
   C("Equal complementary angles each measure 45°, since they add to 90°.")+
   steps("The two equal angles add to 90°","So each is 90° ÷ 2","90 ÷ 2 = 45°.")+
   U("Folding a square napkin corner to corner gives two equal 45° angles."),
   [("90°","Two 90° angles would add to 180°, not 90°."),
    ("30°","Two 30° angles add to only 60°, not 90°."),
    ("60°","Two 60° angles add to 120°, not 90°.")]),

 ("LA","An angle that measures exactly 90° is known as a:",
   "right angle",
   C("A right angle measures exactly 90°.")+
   steps("Check the angle measure","If it is exactly 90°","it is a right angle.")+
   U("The corner of this page, or of a book, is a perfect 90° right angle."),
   [("straight angle","A straight angle is 180°, twice a right angle."),
    ("acute angle","An acute angle is less than 90°, not exactly 90°."),
    ("reflex angle","A reflex angle is more than 180°, far bigger than 90°.")]),

 ("LA","When a transversal crosses two parallel lines, a pair of alternate interior angles (the Z-shape) are:",
   "equal",
   C("Alternate interior angles between parallel lines are equal — the Z pattern.")+
   steps("Find the two inside angles on opposite sides of the transversal","On parallel lines these are alternate interior angles","Such angles are equal.")+
   U("On a ladder leaning across two parallel walls, the Z-shaped angles match."),
   [("supplementary","Alternate interior angles are equal; co-interior angles are the ones summing to 180°."),
    ("complementary","They are equal, not a pair adding to 90°."),
    ("always 90°","They are equal to each other, but need not each be a right angle.")]),

 ("LA","The complement of any acute angle (an angle smaller than 90°) is always:",
   "another acute angle",
   C("Subtracting a positive acute angle from 90° always leaves a positive angle below 90°.")+
   steps("Take an acute angle, less than 90°","Its complement = 90° − that angle","The result is still positive and below 90°, so it is acute.")+
   U("Tilt a stick a little from the floor and the small gap left to the upright is also small — still acute."),
   [("an obtuse angle","The complement is below 90°, so it cannot be obtuse."),
    ("a right angle","The complement equals 90° only when the angle is 0°, which is not an angle here."),
    ("a reflex angle","Complements are below 90°; they can never be reflex.")]),

 ("LA","Two angles are supplementary and one of them is a right angle (90°). The other angle is therefore:",
   "also 90°",
   C("Supplementary angles sum to 180°, so the partner of 90° is 180 − 90 = 90°.")+
   steps("The two angles add to 180°","Other angle = 180° − 90°","180 − 90 = 90°.")+
   U("Two right angles set side by side fill a straight line of 180°."),
   [("0°","0° is not an angle here; 180 − 90 = 90°."),
    ("180°","That would make the sum 270°; the partner is 180 − 90 = 90°."),
    ("45°","45° pairs with 135°, not with 90°.")]),

 ("LA","FUSION: A current-carrying wire deflects a compass needle so that it turns to 50° from its rest line. The angle still needed to complete a right angle (90°) from the rest line is:",
   "40°",
   C("The needle is at 50°; the gap to a 90° right angle is the complement, 90 − 50.")+
   steps("Deflection so far = 50°","Right angle target = 90°","Remaining angle = 90° − 50° = 40°.")+
   U("An electrician notes the needle has 40° still to turn to reach a right angle from its rest line."),
   [("50°","50° is the part already turned; the part still needed is 90 − 50 = 40°."),
    ("130°","130° = 180 − 50 measures up to a straight line, not to a right angle."),
    ("90°","90° is the whole right angle; only 40° more is needed after the 50° turn.")]),

 ("LA","FUSION: A switch lever swings through a straight angle (a half-turn) as it is flicked. The number of degrees it sweeps through is:",
   "180°",
   C("A straight angle, or a half-turn, measures 180°.")+
   steps("A full turn is 360°","A half-turn is half of that","360 ÷ 2 = 180°.")+
   U("A see-saw tipping from one extreme to the other swings through a straight angle of 180°."),
   [("90°","90° is a quarter-turn (a right angle), not a half-turn."),
    ("360°","360° is a complete turn; a half-turn is half of it, 180°."),
    ("45°","45° is only an eighth of a turn, far less than a half-turn.")]),

 ("LA","Two adjacent angles must, by definition, share a common vertex and one common:",
   "arm (side)",
   C("Adjacent angles share a vertex and one arm and lie on opposite sides of it.")+
   steps("Both angles meet at the same vertex","They have one ray in common","That shared ray is the common arm.")+
   U("Two adjacent slices of a pizza share the same tip and one straight cut between them."),
   [("circle","Angles are made of rays, not circles; the shared part is an arm."),
    ("midpoint","A midpoint is a point on a segment; adjacent angles share a vertex and an arm."),
    ("length","Angles are about turning, not length; they share a common arm.")]),

 ("LA","If two angles are both equal AND supplementary, then each of them must measure:",
   "90°",
   C("Equal supplementary angles split 180° into two equal parts of 90° each.")+
   steps("The two equal angles add to 180°","So each is 180° ÷ 2","180 ÷ 2 = 90°.")+
   U("When a door is opened to stand square to its frame, it makes two equal 90° angles."),
   [("45°","Two 45° angles add to only 90°, not 180°."),
    ("60°","Two 60° angles add to 120°, not 180°."),
    ("180°","Two 180° angles would add to 360°, not 180°.")]),
]

# ---------- ELECTRIC CURRENT & ITS EFFECTS (25) — Science ----------
EC = [
 ("EC","An electric current can flow in a circuit only when the path is:",
   "closed (complete)",
   C("Current flows only around a complete, unbroken loop — a closed circuit.")+
   steps("Trace the wire from one terminal of the cell","Follow it all the way back to the other terminal","If the loop is unbroken, current can flow.")+
   U("A torch lights only when its switch completes the loop inside it."),
   [("open at the switch","An open switch breaks the loop, so no current flows."),
    ("made only of plastic","Plastic does not conduct; the path must be a closed metal loop."),
    ("a single straight wire with no cell","A current needs a cell to push it and a complete loop to travel.")]),

 ("EC","The device used to open or close a circuit, switching a current on or off, is the:",
   "switch",
   C("A switch breaks or completes the circuit, turning the current off or on.")+
   steps("A closed switch completes the loop, so current flows","An open switch breaks the loop","So the switch controls the current.")+
   U("Flicking a wall switch completes or breaks the circuit to turn a room light on or off."),
   [("cell","A cell pushes the current; it does not open and close the loop."),
    ("bulb","A bulb is the device that lights up; it does not switch the circuit."),
    ("wire","A wire carries current; the part that opens and closes the loop is the switch.")]),

 ("EC","When an electric current passes through a thin wire, the wire becomes hot. This is called the:",
   "heating effect of current",
   C("Current passing through a wire produces heat — the heating effect.")+
   steps("Current flows through the wire","The wire resists the flow and warms up","This warming is the heating effect of current.")+
   U("The coil of an electric kettle gets hot by the heating effect and warms the water."),
   [("magnetic effect of current","The magnetic effect makes a needle move; this question is about heat."),
    ("chemical effect of current","The chemical effect changes substances in a liquid, not the heating of a wire."),
    ("lighting effect of current","The proper named effect here is the heating effect, which can then cause glow.")]),

 ("EC","The coil inside an electric heater or toaster is made of a special wire that gives out a lot of heat. This wire is:",
   "nichrome",
   C("Nichrome has high resistance and a high melting point, so it glows hot without melting.")+
   steps("Current meets the high resistance of nichrome","The wire heats up strongly","Its high melting point lets it glow without melting.")+
   U("The glowing orange coil you see in a room heater is made of nichrome wire."),
   [("copper","Copper lets current pass too easily, so it heats very little — useless for a heater coil."),
    ("aluminium foil","Thin aluminium would melt; nichrome is chosen for its high melting point."),
    ("plastic","Plastic does not conduct electricity, so no current and no heat would flow through it.")]),

 ("EC","A safety device that contains a thin wire which MELTS and breaks the circuit when the current grows too large is a:",
   "fuse",
   C("A fuse melts and breaks the circuit when the current exceeds a safe value, protecting it.")+
   steps("Too much current heats the thin fuse wire","The fuse wire melts","The circuit breaks, stopping the dangerous current.")+
   U("A fuse in a plug melts and saves the appliance if too large a current rushes through."),
   [("switch","A switch is flicked by hand; a fuse melts by itself when current is too high."),
    ("cell","A cell supplies current; it does not melt to protect the circuit."),
    ("bulb","A bulb gives light; the part that melts to protect the circuit is the fuse.")]),

 ("EC","A compass needle placed near a wire moves when current flows through the wire. This shows that an electric current has a:",
   "magnetic effect",
   C("A current-carrying wire acts like a magnet and can deflect a compass needle.")+
   steps("Switch on the current in the wire","The wire behaves like a magnet","The nearby compass needle is deflected — the magnetic effect.")+
   U("This magnetic effect is the idea behind electric motors and bells."),
   [("heating effect","The heating effect warms the wire; here it is the needle's movement that is seen."),
    ("chemical effect","The chemical effect appears in liquids, not as a compass needle moving."),
    ("no effect at all","The needle clearly moves, proving current does have an effect — a magnetic one.")]),

 ("EC","A coil of wire wound around an iron core becomes a magnet ONLY while current flows. This device is an:",
   "electromagnet",
   C("An electromagnet is magnetic only while current passes through its coil.")+
   steps("Wind a coil of wire around an iron piece","Pass current through the coil","The iron becomes a magnet — and loses it when the current stops.")+
   U("A scrapyard crane uses a powerful electromagnet to lift cars, then drops them by cutting the current."),
   [("permanent magnet","A permanent magnet stays magnetic always; an electromagnet works only with current."),
    ("simple cell","A cell supplies current; it is not itself a coil-and-iron magnet."),
    ("fuse","A fuse protects a circuit by melting; it is not a magnet.")]),

 ("EC","An electric bell rings repeatedly. It works using the:",
   "magnetic effect of current",
   C("An electric bell uses an electromagnet that repeatedly attracts an iron strip to strike the gong.")+
   steps("Current makes the electromagnet pull an iron strip","The strip hits the gong and breaks the circuit","The magnet lets go, the circuit closes again, and it repeats.")+
   U("Your school bell rings using an electromagnet that keeps striking a gong."),
   [("heating effect of current","The bell rings by magnetism, not by getting hot."),
    ("chemical effect of current","No liquid chemicals are changed in a bell; it uses an electromagnet."),
    ("lateral inversion","Lateral inversion is a mirror idea, nothing to do with an electric bell.")]),

 ("EC","The thin coiled wire inside an electric bulb that glows brightly when current passes is called the:",
   "filament",
   C("The filament is the thin wire in a bulb that heats up and glows.")+
   steps("Current enters the bulb","It passes through the thin filament","The filament heats up so much that it glows and gives light.")+
   U("When a bulb 'fuses', it is usually the thin filament inside that has snapped."),
   [("fuse","A fuse is a safety wire that melts; the glowing wire in a bulb is the filament."),
    ("terminal","Terminals are the connecting ends; the part that glows is the filament."),
    ("electrode","Electrodes are used in liquids for the chemical effect, not the glowing bulb wire.")]),

 ("EC","Two or more cells joined together end to end so they can drive a current make a:",
   "battery",
   C("A battery is a combination of two or more cells joined together.")+
   steps("Take two or more single cells","Join the positive end of one to the negative of the next","Together they form a battery.")+
   U("A TV remote works on a battery of two cells joined together."),
   [("switch","A switch only opens and closes the circuit; joined cells make a battery."),
    ("fuse","A fuse is a single safety wire, not a group of cells."),
    ("filament","A filament is the glowing wire in a bulb, not a set of cells.")]),

 ("EC","If more cells are added in series in a circuit (without overloading it), the bulb will usually glow:",
   "brighter",
   C("More cells in series push a larger current, so the bulb glows brighter.")+
   steps("Each extra cell adds more push","A bigger push drives more current","More current through the bulb makes it glow brighter.")+
   U("Adding a fresh cell to a torch makes its beam noticeably brighter."),
   [("dimmer","Adding cells increases the push and the current, so the bulb gets brighter, not dimmer."),
    ("with no change","More cells clearly change the brightness; the bulb glows brighter."),
    ("a different colour","Extra cells change brightness, not the colour of the bulb.")]),

 ("EC","An electromagnet can be made STRONGER by increasing the current and also by:",
   "winding more turns of wire in the coil",
   C("More turns of wire (and more current) make an electromagnet stronger.")+
   steps("Add more turns of wire around the iron core","Each turn adds to the magnetic pull","So more turns make a stronger electromagnet.")+
   U("Winding more turns onto a nail-and-wire electromagnet lets it pick up more pins."),
   [("using a wooden core","Wood is not magnetic; an iron core is what makes the electromagnet strong."),
    ("removing the cell","Removing the cell stops the current, so the magnetism disappears."),
    ("painting the wire","Paint does nothing to the magnetism; more turns and more current do.")]),

 ("EC","An electric iron, a room heater and a toaster all work mainly because of the:",
   "heating effect of electric current",
   C("These appliances use the heating effect — current through a coil produces heat.")+
   steps("Current flows through a high-resistance coil","The coil heats up strongly","That heat is used to press clothes, warm the room or toast bread.")+
   U("An electric iron, a toaster and a geyser all turn electricity into useful heat."),
   [("magnetic effect of electric current","The magnetic effect runs bells and electromagnets, not the heat of a toaster."),
    ("chemical effect of electric current","The chemical effect happens in liquids, not in a dry heating coil."),
    ("reflection of light","Reflection is about mirrors and light, not about an electric heater.")]),

 ("EC","The symbol for an electric cell shows two lines: a longer thin line and a shorter thick line. The longer thin line stands for the:",
   "positive terminal",
   C("In a cell's symbol, the longer thin line is the positive terminal and the short thick line the negative.")+
   steps("Look at the two lines in the cell symbol","The longer, thinner line marks the positive terminal","The shorter, thicker line marks the negative terminal.")+
   U("Knowing which line is positive lets you connect a cell the right way round in a circuit."),
   [("negative terminal","The short thick line is the negative terminal; the long thin line is positive."),
    ("switch","A switch has its own symbol; the long thin line belongs to the cell's positive end."),
    ("fuse","A fuse has a different symbol; this long thin line is the cell's positive terminal.")]),

 ("EC","A fuse wire is chosen so that it melts easily at the right moment. Compared with ordinary wire, a fuse wire has a:",
   "low melting point",
   C("A fuse wire is made of a metal with a low melting point so it melts before the circuit is harmed.")+
   steps("Too large a current heats the fuse wire","Because the fuse metal melts at a low temperature","it melts quickly and breaks the circuit in time.")+
   U("The fuse wire is deliberately the weakest link, melting first to protect everything else."),
   [("very high melting point","A high melting point would stop the fuse from melting in time — the opposite of what is needed."),
    ("no resistance at all","A fuse must heat up and melt, so it cannot have zero resistance."),
    ("a magnetic core","A fuse works by melting, not by magnetism; it has no magnetic core.")]),

 ("EC","If the filament of a bulb breaks, the bulb stops glowing because the:",
   "circuit is no longer complete",
   C("A broken filament breaks the loop, so current can no longer flow and the bulb is dark.")+
   steps("The filament is part of the current's path","If it breaks, the loop is open","No current flows, so the bulb does not glow — it is fused.")+
   U("A bulb goes dark the moment its filament breaks, just as if a switch were opened."),
   [("bulb has run out of light","A bulb stores no light; it glows only while current flows through its filament."),
    ("cell has become a magnet","A broken filament, not the cell, is why the bulb goes out."),
    ("glass has changed colour","The colour of the glass does not stop the bulb; the broken filament does.")]),

 ("EC","Hans Christian Oersted noticed a compass needle move near a wire carrying current. His discovery linked electricity with:",
   "magnetism",
   C("Oersted's experiment showed that an electric current produces a magnetic effect.")+
   steps("A current flows in the wire","A nearby compass needle deflects","This proved that electricity and magnetism are linked.")+
   U("Oersted's chance discovery led to electric motors that run fans, mixers and trains."),
   [("light","The compass result was about magnetism, not about light."),
    ("sound","No sound was involved; the needle moved because of a magnetic effect."),
    ("heat only","Although current can heat a wire, Oersted's needle test revealed magnetism.")]),

 ("EC","In a circuit diagram, the gap in the line with a small lever that can be joined or left open represents a:",
   "switch",
   C("The symbol with a small movable lever leaving a gap is the switch.")+
   steps("Find the small lever in the circuit symbol","A closed lever completes the loop","An open lever breaks it — so the symbol is a switch.")+
   U("Reading the switch symbol helps you trace where a circuit can be turned on or off."),
   [("cell","A cell is shown by two parallel lines of different length, not a lever."),
    ("resistor / coil","A coil or resistor has its own zig-zag or loop symbol, not a lever and gap."),
    ("bulb","A bulb is drawn as a circle with a cross inside, not a lever in the line.")]),

 ("EC","An MCB (Miniature Circuit Breaker) is used in modern homes instead of a fuse because, unlike a fuse, an MCB:",
   "can be switched back on after it trips",
   C("An MCB trips to break the circuit and can simply be reset, while a fuse must be replaced.")+
   steps("Too much current makes the MCB trip and break the circuit","The danger passes","You just flip the MCB back on — no wire to replace.")+
   U("After an overload trips your home's MCB, you just switch it back up — no new wire needed."),
   [("never breaks the circuit","An MCB does break the circuit on overload; that is the whole point of it."),
    ("gives out light when working","An MCB is a safety switch, not a lamp; it does not give out light."),
    ("makes the current larger","An MCB protects by cutting current off, not by increasing it.")]),

 ("EC","Why is copper, and not nichrome, used for the long connecting wires that join the parts of a circuit?",
   "copper lets current pass easily without heating up much",
   C("Copper has very low resistance, so it carries current with little heating — ideal for connecting wires.")+
   steps("Connecting wires should not waste energy as heat","Copper has very low resistance","So current passes easily and the wires stay cool.")+
   U("The copper wires in your home carry current to every room while staying cool to the touch."),
   [("copper has a high melting point so it glows","Connecting wires should NOT glow; copper is used because it barely heats up."),
    ("copper is magnetic","Copper is not magnetic; it is chosen for its easy, low-resistance conduction."),
    ("copper melts to protect the circuit","Melting to protect is a fuse's job; copper wires are meant to carry current safely.")]),

 ("EC","FUSION: A toy's holder has slots for cells, and the slots are arranged in 2 rows with 3 cells in each row, so the total is 2 × 2 × ... no — the toy actually has 2³ cells in all. The number 2³ equals:",
   "8 cells",
   C("2³ means 2 × 2 × 2, which equals 8.")+
   steps("2³ = 2 × 2 × 2","2 × 2 = 4","4 × 2 = 8 cells.")+
   U("A toy robot needing 2³ = 8 cells uses two full sets of four."),
   [("6 cells","6 = 2 × 3; but 2³ means 2 × 2 × 2 = 8."),
    ("5 cells","Adding 2 + 3 gives 5; the power 2³ means multiplying three 2s to get 8."),
    ("23 cells","2³ is two-cubed, equal to 8, not the digits 2 and 3 written together.")]),

 ("EC","FUSION: An electromagnet's strength is tested by counting paper clips it can lift. The strongest electromagnet here lifts 10² clips. The number 10² equals:",
   "100 clips",
   C("10² means 10 × 10, which equals 100.")+
   steps("10² = 10 × 10","10 × 10 = 100","So it lifts 100 clips.")+
   U("A strong school electromagnet lifting 10² = 100 clips shows how extra turns boost its pull."),
   [("20 clips","20 = 10 × 2; but 10² means 10 × 10 = 100."),
    ("12 clips","Adding 10 + 2 gives 12; the power 10² means 10 × 10 = 100."),
    ("1000 clips","1000 is 10³ (10 × 10 × 10); 10² is just 10 × 10 = 100.")]),

 ("EC","A device that uses the heating effect to make a wire glow and so give out light is best described as a:",
   "bulb",
   C("A bulb uses the heating effect: current heats the filament until it glows and gives light.")+
   steps("Current flows through the thin filament","The heating effect makes it very hot","The white-hot filament glows and gives off light.")+
   U("A glowing bulb is the heating effect turned into light for your study table."),
   [("compass","A compass shows magnetic direction; it does not glow from the heating effect."),
    ("cell","A cell supplies the current; it does not glow to give light."),
    ("fuse","A fuse melts to break a circuit; it is not designed to glow and give light.")]),

 ("EC","To make a simple electromagnet you should wind the coil of wire around a core made of:",
   "soft iron",
   C("A soft-iron core becomes strongly magnetic with current and loses it quickly when current stops.")+
   steps("Wind the coil around a soft-iron nail or rod","Pass current through the coil","The soft iron becomes a strong, temporary magnet.")+
   U("A soft-iron core lets a crane's electromagnet drop its load the instant it is switched off."),
   [("wood","Wood cannot be magnetised, so it would not make an electromagnet."),
    ("rubber","Rubber is not magnetic and does not conduct, so it cannot serve as the core."),
    ("glass","Glass cannot be magnetised; soft iron is needed for the core.")]),

 ("EC","The two metal ends of an electric cell, to which the connecting wires of a circuit are joined, are called its:",
   "terminals",
   C("A cell has two terminals — a positive and a negative — where the wires connect.")+
   steps("Look at the two ends of a cell","One end is the positive terminal, the other negative","Wires are joined to these two terminals.")+
   U("You match a cell's + and − terminals to the marks in a remote so it powers up correctly."),
   [("filaments","A filament is the glowing wire inside a bulb, not the ends of a cell."),
    ("fuses","A fuse is a safety wire that melts; the connecting ends of a cell are its terminals."),
    ("switches","A switch opens and closes a circuit; the wire-joining ends of a cell are its terminals.")]),
]

# ---------- EXPONENTS & POWERS (25) — Maths ----------
EP = [
 ("EP","In the power 2⁵, the small raised number 5 tells us how many times the base 2 is:",
   "multiplied by itself",
   C("The exponent tells how many times the base is used as a factor in a multiplication.")+
   steps("2⁵ means 2 used as a factor 5 times","2 × 2 × 2 × 2 × 2","So the exponent counts the multiplications.")+
   U("Powers let us write huge repeated multiplications, like 2 doubling over and over, in a tiny space."),
   [("added to itself","An exponent means repeated multiplication, not repeated addition."),
    ("divided by itself","An exponent means repeated multiplication, not division."),
    ("subtracted from itself","An exponent means repeated multiplication, not subtraction.")]),

 ("EP","Evaluate the cube of two. Worked out fully, the value of 2³ comes to:",
   "8",
   C("2³ = 2 × 2 × 2 = 8.")+
   steps("2³ = 2 × 2 × 2","2 × 2 = 4","4 × 2 = 8.")+
   U("Eight identical small cubes stack to build one larger cube — a picture of 2³ = 8."),
   [("6","6 = 2 × 3; but 2³ means three 2s multiplied, giving 8."),
    ("9","9 = 3²; here the base is 2, so 2³ = 8."),
    ("23","2³ is two-cubed = 8, not the digits 2 and 3 placed side by side.")]),

 ("EP","Written as a power of 10, the number 10 000 (ten thousand) is:",
   "10⁴",
   C("10 000 has four zeros, so it is 10 × 10 × 10 × 10 = 10⁴.")+
   steps("Count the zeros in 10 000 — there are 4","Each zero means one more factor of 10","So 10 000 = 10⁴.")+
   U("Scientists write ten thousand as 10⁴ to keep big numbers short and tidy."),
   [("10³","10³ = 1000, which is ten thousand divided by ten — one zero short."),
    ("10⁵","10⁵ = 100 000, which is ten times too big."),
    ("4¹⁰","The base here is 10 (we are multiplying 10s), so it is 10⁴, not 4¹⁰.")]),

 ("EP","Using the rule aᵐ × aⁿ = aᵐ⁺ⁿ, the product 2² × 2³ equals:",
   "2⁵",
   C("Same base, so add the exponents: 2 + 3 = 5.")+
   steps("Bases are equal (both 2)","Add the exponents: 2 + 3 = 5","So 2² × 2³ = 2⁵.")+
   U("The add-the-powers rule saves you from writing out all the 2s when multiplying."),
   [("2⁶","Adding exponents gives 2 + 3 = 5, not 6; 6 would come from multiplying them."),
    ("4⁵","Keep the base the same when adding exponents; it stays 2, giving 2⁵, not 4⁵."),
    ("2¹","2 + 3 = 5, so the exponent is 5, not 1.")]),

 ("EP","Using the rule aᵐ ÷ aⁿ = aᵐ⁻ⁿ, the quotient 5⁶ ÷ 5² equals:",
   "5⁴",
   C("Same base, so subtract the exponents: 6 − 2 = 4.")+
   steps("Bases are equal (both 5)","Subtract the exponents: 6 − 2 = 4","So 5⁶ ÷ 5² = 5⁴.")+
   U("Subtracting powers quickly simplifies a fraction of two equal-base numbers."),
   [("5³","Subtract the exponents: 6 − 2 = 4, not 3."),
    ("5⁸","For division you SUBTRACT exponents (6 − 2 = 4); adding would give 8."),
    ("1⁴","The base stays 5 when subtracting exponents, giving 5⁴, not 1⁴.")]),

 ("EP","Any non-zero number raised to the power 0 is equal to:",
   "1",
   C("By the rules of exponents, any non-zero number to the power 0 equals 1.")+
   steps("Consider aᵐ ÷ aᵐ = a⁰","But anything divided by itself is 1","So a⁰ = 1 for any non-zero a.")+
   U("The handy rule a⁰ = 1 keeps the pattern of powers neat as they step down."),
   [("0","Zero is not the answer; any non-zero base to the power 0 is 1."),
    ("the base itself","The base itself is the value of a¹, not a⁰; a⁰ = 1."),
    ("undefined for all numbers","For non-zero bases a⁰ is well defined and equals 1.")]),

 ("EP","The number 64 can be written neatly as a power of 2. It is equal to:",
   "2⁶",
   C("64 = 2 × 2 × 2 × 2 × 2 × 2 = 2⁶.")+
   steps("Keep dividing 64 by 2: 64, 32, 16, 8, 4, 2, 1","That is six divisions by 2","So 64 = 2⁶.")+
   U("A chessboard doubling puzzle reaches 64 on the sixth square, as 2⁶."),
   [("2⁵","2⁵ = 32, which is half of 64; one more factor of 2 gives 2⁶ = 64."),
    ("2⁸","2⁸ = 256, which is four times 64; the correct power is 2⁶."),
    ("6²","6² = 36, not 64; written as a power of 2, sixty-four is 2⁶.")]),

 ("EP","Using the rule (aᵐ)ⁿ = aᵐⁿ, the value of (3²)³ is:",
   "3⁶",
   C("A power raised to a power multiplies the exponents: 2 × 3 = 6.")+
   steps("(3²)³ means 3² used as a factor 3 times","Multiply the exponents: 2 × 3 = 6","So (3²)³ = 3⁶.")+
   U("The multiply-the-powers rule turns a power of a power into one simple exponent."),
   [("3⁵","For a power of a power you MULTIPLY exponents (2 × 3 = 6); adding gives the wrong 5."),
    ("3⁸","2 × 3 = 6, not 8; 8 has no source here."),
    ("9³","Keep the base 3 and multiply exponents to get 3⁶; rewriting as 9³ changes the base.")]),

 ("EP","Comparing the two numbers 3⁴ and 4³, which one is LARGER?",
   "3⁴, because it equals 81 while 4³ equals 64",
   C("Work out each: 3⁴ = 81 and 4³ = 64, so 3⁴ is larger.")+
   steps("3⁴ = 3 × 3 × 3 × 3 = 81","4³ = 4 × 4 × 4 = 64","81 > 64, so 3⁴ is larger.")+
   U("Comparing powers shows a bigger base does not always win — the exponent matters too."),
   [("4³, because it equals 81","4³ is 64, not 81; it is 3⁴ that equals 81 and is larger."),
    ("they are equal","81 and 64 are not equal; 3⁴ is the larger."),
    ("4³, because 4 is bigger than 3","A bigger base does not always win once the exponents differ; here 3⁴ = 81 beats 4³ = 64.")]),

 ("EP","The value of (−1) raised to any EVEN power, for example (−1)⁴, is:",
   "+1",
   C("An even number of negative factors multiply to a positive 1.")+
   steps("(−1)⁴ = (−1)(−1)(−1)(−1)","Pair them: (−1)(−1) = +1, and (−1)(−1) = +1","+1 × +1 = +1.")+
   U("Multiplying an even count of minus signs always lands you back on a plus."),
   [("−1","A negative raised to an EVEN power is positive; −1 results from an odd power."),
    ("0","Multiplying −1 by itself never gives 0; it gives +1 for even powers."),
    ("4","The base is −1, so (−1)⁴ = +1, not 4.")]),

 ("EP","Taking care of the sign, the cube of negative two, written (−2)³, has the value:",
   "−8",
   C("An odd number of negative factors keeps the result negative: (−2)³ = −8.")+
   steps("(−2)³ = (−2)(−2)(−2)","(−2)(−2) = +4","+4 × (−2) = −8.")+
   U("Tracking the sign of a power matters when a debt or a temperature drop is cubed."),
   [("+8","An ODD power of a negative number stays negative, so the answer is −8, not +8."),
    ("−6","(−2)³ means multiply three −2s, not −2 × 3; the value is −8."),
    ("+6","The result is negative and equals −8, not +6.")]),

 ("EP","Written in standard (scientific) form, the number 3 450 000 is:",
   "3.45 × 10⁶",
   C("Move the decimal so one non-zero digit stays in front, then count the places moved.")+
   steps("Place the decimal after the first digit: 3.45","Count places moved from 3 450 000: 6","So 3 450 000 = 3.45 × 10⁶.")+
   U("Astronomers write a distance like 3 450 000 km as 3.45 × 10⁶ km to read it easily."),
   [("34.5 × 10⁵","Standard form needs exactly one non-zero digit before the decimal; 34.5 has two."),
    ("3.45 × 10⁵","That equals 345 000, ten times too small; the correct power is 10⁶."),
    ("3.45 × 10⁷","That equals 34 500 000, ten times too big; the correct power is 10⁶.")]),

 ("EP","The value of 5² (five squared) is:",
   "25",
   C("5² = 5 × 5 = 25.")+
   steps("5² = 5 × 5","5 × 5 = 25","So 5² = 25.")+
   U("A 5-by-5 grid of tiles holds 5² = 25 tiles in all."),
   [("10","10 = 5 × 2; but 5² means 5 × 5 = 25."),
    ("52","5² is five-squared = 25, not the digits 5 and 2 side by side."),
    ("7","7 = 5 + 2; squaring means multiplying, so 5² = 25.")]),

 ("EP","Using the rule (a × b)ᵐ = aᵐ × bᵐ, the value of (2 × 3)² is:",
   "36",
   C("(2 × 3)² = 6² = 36, which also equals 2² × 3² = 4 × 9 = 36.")+
   steps("First 2 × 3 = 6","Then 6² = 6 × 6 = 36","Check: 2² × 3² = 4 × 9 = 36 — same answer.")+
   U("Squaring a product the smart way: square each factor, then multiply the results."),
   [("12","12 = 2 × 3 × 2; but squaring 6 gives 6 × 6 = 36."),
    ("18","18 = 2 × 9 mixes the steps; (2 × 3)² = 36."),
    ("25","25 = 5²; here (2 × 3)² = 6² = 36.")]),

 ("EP","The sum 7⁰ + 3⁰ is equal to:",
   "2",
   C("Any non-zero number to the power 0 is 1, so 7⁰ + 3⁰ = 1 + 1 = 2.")+
   steps("7⁰ = 1","3⁰ = 1","1 + 1 = 2.")+
   U("Remembering any non-zero number to the power 0 is 1 keeps such sums quick."),
   [("0","Each term is 1, not 0, so the sum is 2."),
    ("10","Mistaking 7⁰ for 7 and 3⁰ for 3 gives 10; both are actually 1, summing to 2."),
    ("1","There are two terms, each equal to 1, so the sum is 1 + 1 = 2.")]),

 ("EP","Written as a power of 10, the number 1000 (one thousand) is:",
   "10³",
   C("1000 has three zeros, so it is 10 × 10 × 10 = 10³.")+
   steps("Count the zeros in 1000 — there are 3","Each zero is one factor of 10","So 1000 = 10³.")+
   U("A thousand rupees is written as 10³ rupees in standard form."),
   [("10²","10² = 100, which is one thousand divided by ten — one zero short."),
    ("10⁴","10⁴ = 10 000, ten times too big."),
    ("3¹⁰","The base is 10 (we multiply 10s), so it is 10³, not 3¹⁰.")]),

 ("EP","The value of 2⁴ (two to the power four) is:",
   "16",
   C("2⁴ = 2 × 2 × 2 × 2 = 16.")+
   steps("2 × 2 = 4","4 × 2 = 8","8 × 2 = 16.")+
   U("Four straight doublings of one rupee — 1, 2, 4, 8, 16 — reach 2⁴ = 16."),
   [("8","8 = 2³; one more factor of 2 gives 2⁴ = 16."),
    ("6","6 = 2 × 3; but 2⁴ means four 2s multiplied, giving 16."),
    ("32","32 = 2⁵; here we want 2⁴ = 16.")]),

 ("EP","The value of 3³ (three cubed) is:",
   "27",
   C("3³ = 3 × 3 × 3 = 27.")+
   steps("3 × 3 = 9","9 × 3 = 27","So 3³ = 27.")+
   U("Twenty-seven small cubes pack into one big cube, showing 3³ = 27."),
   [("9","9 = 3²; one more factor of 3 gives 3³ = 27."),
    ("12","12 = 3 × 4; cubing 3 means 3 × 3 × 3 = 27."),
    ("33","3³ is three-cubed = 27, not the digits 3 and 3 side by side.")]),

 ("EP","Any number raised to the power 1 (for example 9¹) is simply equal to:",
   "the number itself",
   C("A base to the power 1 means the base is used once, so it equals the base itself.")+
   steps("9¹ means 9 used as a factor just once","Using it once gives 9","So a¹ = a.")+
   U("Any quantity to the power 1 is just itself — one factor, nothing repeated."),
   [("1","a⁰ equals 1; a¹ equals the base itself, here 9."),
    ("0","A power of 1 gives the base, not 0."),
    ("double the number","Power 1 keeps the number the same, it does not double it.")]),

 ("EP","The number 10⁶ (ten to the power six) written out in full is:",
   "one million (1 000 000)",
   C("10⁶ has six zeros, which is one million.")+
   steps("10⁶ = 10 × 10 × 10 × 10 × 10 × 10","That places six zeros after a 1","So 10⁶ = 1 000 000, one million.")+
   U("A camera of 10⁶ pixels is called a one-megapixel camera."),
   [("one thousand","One thousand is 10³, not 10⁶."),
    ("one lakh","One lakh is 100 000 = 10⁵; 10⁶ is ten lakh, i.e. one million."),
    ("sixty","10⁶ means six factors of 10, equal to one million, not 10 × 6 = 60.")]),

 ("EP","FUSION: A bacterium SPLITS into 2 every 20 minutes. Starting from a single bacterium, after 4 splits the count is best written as the power:",
   "2⁴, which equals 16",
   C("Splitting in two, 4 times, multiplies by 2 four times: 2⁴ = 16.")+
   steps("Start with 1 bacterium","Each split multiplies the count by 2","After 4 splits: 1 × 2⁴ = 16 bacteria.")+
   U("This fast doubling is why a few germs on uncooked food can multiply alarmingly."),
   [("4², which equals 16","The value 16 is right, but the base that doubles is 2 acting 4 times, so it is 2⁴, not 4²."),
    ("2 × 4, which equals 8","Repeated splitting is multiplying, giving 2⁴ = 16, not 2 × 4 = 8."),
    ("2³, which equals 8","Three splits give 2³ = 8; the question asks for 4 splits, which is 2⁴ = 16.")]),

 ("EP","FUSION: A heater coil's resistance, in tiny units, is given as 10³. Written as an ordinary number, 10³ is:",
   "1000",
   C("10³ = 10 × 10 × 10 = 1000.")+
   steps("10³ = 10 × 10 × 10","10 × 10 = 100","100 × 10 = 1000.")+
   U("Resistances are often written as powers of ten to handle very large values neatly."),
   [("30","30 = 10 × 3; but 10³ means three 10s multiplied, giving 1000."),
    ("100","100 = 10²; one more factor of 10 gives 10³ = 1000."),
    ("10000","10 000 = 10⁴; here 10³ = 1000.")]),

 ("EP","Using the rule for the same base, 4⁵ ÷ 4⁵ equals:",
   "1",
   C("Subtracting equal exponents gives 4⁰, and any non-zero number to the power 0 is 1.")+
   steps("Same base: subtract exponents, 5 − 5 = 0","So 4⁵ ÷ 4⁵ = 4⁰","4⁰ = 1.")+
   U("Any equal-base number divided by itself is 1 — the powers cancel to zero."),
   [("0","Any non-zero number divided by itself is 1, not 0."),
    ("4","4⁵ ÷ 4⁵ = 4⁰ = 1, not 4¹ = 4."),
    ("4¹⁰","Division SUBTRACTS exponents (5 − 5 = 0); adding them would give the wrong 4¹⁰.")]),

 ("EP","The value of 2¹⁰ (two to the power ten), a number that often appears with computers, is:",
   "1024",
   C("Doubling ten times: 2¹⁰ = 1024.")+
   steps("2⁵ = 32","2¹⁰ = 2⁵ × 2⁵ = 32 × 32","32 × 32 = 1024.")+
   U("Computer memory counts in 2¹⁰ = 1024, which is why a 'kilobyte' is 1024 bytes."),
   [("100","100 = 10²; 2¹⁰ is far larger, equal to 1024."),
    ("20","20 = 2 × 10; but 2¹⁰ means ten 2s multiplied, equal to 1024."),
    ("512","512 = 2⁹; one more doubling gives 2¹⁰ = 1024.")]),

 ("EP","The number 10⁵ (ten to the power five) written out in full, the same as one lakh, is:",
   "1,00,000",
   C("10⁵ has five zeros after a 1, which is one lakh (1,00,000).")+
   steps("10⁵ = 10 × 10 × 10 × 10 × 10","That places five zeros after a 1","So 10⁵ = 1,00,000, one lakh.")+
   U("One lakh, written 10⁵, is how we count in hundreds of thousands in India."),
   [("10,000","Ten thousand is 10⁴, one zero short of 10⁵."),
    ("50","10⁵ means five factors of 10, equal to one lakh, not 10 × 5 = 50."),
    ("10,00,000","Ten lakh (one million) is 10⁶; here 10⁵ = 1,00,000.")]),
]

assert len(RE) == 25 and len(LA) == 25 and len(EC) == 25 and len(EP) == 25

# Interleave so no two consecutive questions share a chapter; Science/Maths alternate.
items = []
for i in range(25):
    items += [RE[i], LA[i], EC[i], EP[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=17263,
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
    split = "/".join(str(counts[c]) for c in ("RE", "LA", "EC", "EP"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Respiration in Organisms", "Lines & Angles",
                     "Electric Current & its Effects", "Exponents & Powers"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
