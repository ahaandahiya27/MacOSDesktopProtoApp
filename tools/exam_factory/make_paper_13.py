# -*- coding: utf-8 -*-
# Boss Challenge Paper 13 — Respiration in Organisms · Transportation in Animals & Plants
#                            · Fractions & Decimals · Perimeter & Area
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans hard into FUSION questions that blend a Science
# context (breathing rate, pulse, blood, transpiration, leaf surface) with a Maths
# skill (fractions, decimals, perimeter, area). Class-7 scope, simple wording,
# hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_13_<SHORT>_QuestionPaper.html  (pure HTML — questions + options, no answers)
#   Paper_13_<SHORT>_QuestionPaper.pdf
#   Paper_13_<SHORT>_Questions.md
#   Paper_13_<SHORT>_Solutions.html
import os, sys, shutil, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "13"
SHORT = "Respiration_Transportation_FractionsDecimals_PerimeterArea"
TITLE = "Respiration in Organisms · Transportation in Animals & Plants · Fractions & Decimals · Perimeter & Area"
LABELS = {
    "RO": "Respiration in Organisms",
    "TR": "Transportation in Animals & Plants",
    "FD": "Fractions & Decimals",
    "PA": "Perimeter & Area",
}

# ---------- RESPIRATION IN ORGANISMS (25) — Science ----------
RO = [
 ("RO","The process by which cells break down food to release energy is called:",
   "cellular respiration",
   C("Respiration is the breakdown of food, mainly glucose, inside cells to release the energy the body needs to live and work.")+
   steps("Food such as glucose is taken into the cell","Oxygen helps break it down","Energy, carbon dioxide and water are released.")+
   U("Every time you run or even think, your cells are respiring to power the work."),
   [("digestion","Digestion only breaks food into simpler bits; respiration releases the energy from them."),
    ("transpiration","Transpiration is loss of water vapour from plant leaves, not energy release."),
    ("photosynthesis","Photosynthesis builds food and stores energy; respiration releases it.")]),

 ("RO","The gas that living cells take in during normal breathing to release energy is:",
   "oxygen",
   C("In aerobic respiration cells use oxygen to break down glucose fully, releasing the most energy.")+
   steps("Air is drawn into the lungs","Oxygen passes into the blood","Cells use oxygen to burn glucose for energy.")+
   U("This is why a closed room full of people feels stuffy — the oxygen is being used up."),
   [("carbon dioxide","Carbon dioxide is breathed out as a waste of respiration, not taken in for it."),
    ("nitrogen","Nitrogen is the largest part of air but cells do not use it to release energy."),
    ("hydrogen","Hydrogen is not used by the body to break down food.")]),

 ("RO","Breakdown of glucose without oxygen, as in our muscles during heavy exercise, is called:",
   "anaerobic respiration",
   C("When oxygen runs short, muscle cells break glucose only partly without oxygen; this is anaerobic respiration.")+
   steps("During hard exercise oxygen reaches muscles too slowly","Glucose is broken down without oxygen","Lactic acid forms and energy is released.")+
   U("The ache in your legs after a sprint comes from lactic acid made this way."),
   [("aerobic respiration","Aerobic respiration needs oxygen; the muscle case here lacks enough oxygen."),
    ("complete combustion","There is no burning with a flame inside the body; it is a slow chemical change."),
    ("fermentation in plants","Fermentation is the yeast version; in our muscles it makes lactic acid, not alcohol.")]),

 ("RO","The partly-broken-down substance that builds up in muscles and causes cramps is:",
   "lactic acid",
   C("Anaerobic respiration in muscles produces lactic acid, whose build-up causes the cramp and ache after hard work.")+
   steps("Muscles run short of oxygen","Glucose breaks down to lactic acid","Lactic acid collects and the muscle aches.")+
   U("Resting and breathing deeply afterwards helps clear the lactic acid away."),
   [("alcohol","Alcohol is the product when yeast respires without oxygen, not human muscle."),
    ("glucose","Glucose is the food broken down, not the product that causes cramps."),
    ("carbon dioxide","Carbon dioxide is a gas breathed out; it does not collect in muscle as an ache.")]),

 ("RO","In yeast, anaerobic respiration produces carbon dioxide and:",
   "alcohol",
   C("Yeast respires without oxygen to make alcohol and carbon dioxide; this is fermentation.")+
   steps("Yeast is given sugar in dough or juice","Without oxygen it breaks the sugar down","Alcohol and carbon dioxide gas are made.")+
   U("Bread rises because the carbon dioxide from yeast puffs up the dough."),
   [("lactic acid","Lactic acid is the product in tired muscles, not in yeast."),
    ("oxygen","Oxygen is not produced; in fact yeast here works without it."),
    ("water only","Water alone is not the named product; alcohol forms with the carbon dioxide.")]),

 ("RO","The opening of the windpipe through which air enters from the throat begins at the:",
   "larynx",
   C("Air passes from the nose and throat into the larynx (voice box) and then down the trachea to the lungs.")+
   steps("Air enters through the nostrils","It passes the throat to the larynx","Then down the windpipe to the lungs.")+
   U("Your voice box, the larynx, also lets you talk as air passes through it."),
   [("stomach","The stomach handles food, not air; air goes down the windpipe instead."),
    ("kidney","The kidney filters blood; it is not part of the breathing path."),
    ("diaphragm","The diaphragm is the muscle below the lungs, not the air opening at the throat.")]),

 ("RO","The muscular sheet below the lungs that helps in breathing by moving up and down is the:",
   "diaphragm",
   C("The diaphragm is a dome-shaped muscle below the lungs; it flattens to pull air in and rises to push air out.")+
   steps("The diaphragm flattens and moves down","Chest space increases and air rushes in","It rises again and air is pushed out.")+
   U("Place a hand on your belly and breathe deeply — you can feel the diaphragm working."),
   [("ribs only","Ribs help, but the main muscle named for breathing is the diaphragm below them."),
    ("heart","The heart pumps blood; it does not move air in and out of the lungs."),
    ("liver","The liver makes bile and stores food; it has no role in breathing.")]),

 ("RO","Tiny balloon-like air sacs in the lungs where gases are exchanged with blood are called:",
   "alveoli",
   C("The lungs end in millions of tiny alveoli; their thin walls let oxygen pass into blood and carbon dioxide pass out.")+
   steps("Air reaches the tiny alveoli","Oxygen passes through their thin walls into blood","Carbon dioxide passes out to be breathed away.")+
   U("The huge number of alveoli gives the lungs a surface as large as a small room."),
   [("nephrons","Nephrons are filtering units of the kidney, not air sacs of the lungs."),
    ("stomata","Stomata are pores on leaves; alveoli are the air sacs in animal lungs."),
    ("villi","Villi line the small intestine to absorb food, not exchange gases.")]),

 ("RO","Insects such as a grasshopper take in air through small openings on the body called:",
   "spiracles",
   C("Insects breathe through tiny holes called spiracles that open into air tubes (tracheae) inside the body.")+
   steps("Air enters through spiracles on the sides","It travels through fine tracheal tubes","Tubes carry it straight to body cells.")+
   U("Because they breathe through spiracles, insects do not need lungs like we do."),
   [("gills","Gills are for fish and tadpoles in water, not for land insects."),
    ("lungs","Insects have no lungs; they use spiracles and tracheal tubes instead."),
    ("skin pores","Earthworms use moist skin, but insects use spiracles for breathing.")]),

 ("RO","Fish are able to breathe in water because they take in dissolved oxygen using their:",
   "gills",
   C("Fish gills are feathery and rich in blood vessels; they take dissolved oxygen from water as it flows over them.")+
   steps("Water enters through the fish's mouth","It flows over the gills","Dissolved oxygen passes into the blood there.")+
   U("This is why a fish kept in unaerated, stale water can suffocate."),
   [("lungs","Fish have gills, not lungs, to breathe the oxygen dissolved in water."),
    ("spiracles","Spiracles belong to insects, not fish."),
    ("skin only","Fish mainly use gills; skin alone cannot supply enough oxygen.")]),

 ("RO","An earthworm has no lungs or gills; it exchanges gases through its:",
   "moist skin",
   C("An earthworm breathes through its moist skin, where gases dissolve and pass in and out.")+
   steps("The skin is kept moist by mucus","Oxygen dissolves and passes inward","Carbon dioxide passes outward through the skin.")+
   U("This is why earthworms come to the surface when rain floods their burrows — to breathe."),
   [("gills","Earthworms have no gills; their moist skin does the gas exchange."),
    ("lungs","Earthworms have no lungs; they breathe through skin."),
    ("spiracles","Spiracles are insect openings, not found in earthworms.")]),

 ("RO","During exhalation in humans, the air breathed out is richer in:",
   "carbon dioxide",
   C("Breathed-out air carries the carbon dioxide that respiration produced, so it has more of this gas than the air taken in.")+
   steps("Cells make carbon dioxide while respiring","Blood carries it to the lungs","It is breathed out, making exhaled air rich in it.")+
   U("Limewater turns milky when you blow into it, showing the carbon dioxide you breathe out."),
   [("oxygen","Oxygen is used up by the body, so exhaled air has less oxygen, not more."),
    ("nitrogen","Nitrogen passes in and out almost unchanged; it is not what increases."),
    ("hydrogen","Hydrogen is not a product of breathing and is not in exhaled air.")]),

 ("RO","Plants carry out gas exchange in their leaves mainly through tiny pores called:",
   "stomata",
   C("Leaves have tiny pores called stomata that open and close to let gases move in and out.")+
   steps("Stomata open on the leaf surface","Carbon dioxide and oxygen pass through them","Guard cells control the opening.")+
   U("On a hot afternoon many stomata close to save water, slowing gas exchange."),
   [("alveoli","Alveoli are air sacs in animal lungs, not pores on a leaf."),
    ("spiracles","Spiracles are openings on insects, not plant leaves."),
    ("lenticels only","Lenticels are pores on stems; leaves mainly use stomata.")]),

 ("RO","Both day and night, all living cells of a plant carry out:",
   "respiration",
   C("Plants respire all the time, day and night, to release energy; photosynthesis happens only in light.")+
   steps("Cells always need energy to live","So respiration goes on day and night","Photosynthesis adds on only when there is light.")+
   U("This is why a tightly closed room with many plants can still feel low on oxygen at night."),
   [("photosynthesis","Photosynthesis needs light, so it stops at night; respiration does not."),
    ("transpiration only","Transpiration is water loss, not the energy-releasing process going on always."),
    ("germination","Germination is a seed sprouting, not the round-the-clock energy process.")]),

 ("RO","The normal breathing rate of a resting healthy adult is about:",
   "15–18 times per minute",
   C("At rest a healthy adult breathes in and out roughly 15 to 18 times each minute.")+
   steps("Count one breath as one in-and-out","At rest the body needs steady oxygen","This gives about 15–18 breaths a minute.")+
   U("Right after running, this rate shoots up as muscles demand more oxygen."),
   [("2–4 times per minute","That is far too slow to supply a resting adult's oxygen needs."),
    ("60–70 times per minute","That very fast rate happens only under great stress, not at rest."),
    ("100–110 times per minute","That is closer to a heart rate, not a resting breathing rate.")]),

 ("RO","When you exercise hard, your breathing rate increases mainly to:",
   "supply more oxygen and remove more carbon dioxide",
   C("Hard work makes muscles respire faster, so the body breathes faster to bring in more oxygen and clear extra carbon dioxide.")+
   steps("Muscles work hard and respire faster","They need more oxygen and make more carbon dioxide","Faster breathing meets both needs.")+
   U("This is why you pant after climbing stairs quickly."),
   [("warm up the lungs","Breathing is about gas exchange, not heating the lungs."),
    ("make more sweat","Sweat is cooling by the skin; it is not the reason breathing speeds up."),
    ("digest food faster","Breathing rate is tied to oxygen need, not to digesting food.")]),

 ("RO","A boy breathes 18 times each minute at rest. The number of breaths in 5 minutes is:",
   "90",
   C("Breaths per minute multiplied by the number of minutes gives the total breaths.")+
   steps("Breaths per minute = 18","Minutes = 5","Total = 18 × 5 = 90 breaths.")+
   U("Doctors estimate breathing over several minutes this way to avoid miscounting."),
   [("23","23 comes from adding 18 + 5; the breaths should be multiplied, not added."),
    ("85","85 is just below the correct product; 18 × 5 is exactly 90."),
    ("180","180 is 18 × 10, which would be 10 minutes, not 5.")]),

 ("RO","A girl takes 16 breaths a minute. If each breath moves 0.5 litre of air, the air moved in one minute is:",
   "8 litres",
   C("Multiply the air per breath by the number of breaths in a minute to get the total air moved.")+
   steps("Air per breath = 0.5 L","Breaths per minute = 16","Total = 0.5 × 16 = 8 litres.")+
   U("This is how the volume of air a person moves, called minute ventilation, is found."),
   [("16.5 litres","16.5 comes from adding 16 + 0.5; the values must be multiplied."),
    ("4 litres","4 is 0.5 × 8, but she takes 16 breaths, not 8."),
    ("32 litres","32 would be 2 L per breath; each breath is only 0.5 L.")]),

 ("RO","A patient breathes 20 times a minute. The fraction of an hour taken by one minute of this breathing is:",
   "1/60",
   C("There are 60 minutes in an hour, so one minute is one-sixtieth of an hour.")+
   steps("1 hour = 60 minutes","1 minute is 1 part out of 60","So the fraction is 1/60.")+
   U("Nurses chart readings as fractions of an hour when watching a patient closely."),
   [("1/20","20 is the breaths, not the minutes in an hour; the hour has 60 minutes."),
    ("1/24","24 is the hours in a day, not the minutes in an hour."),
    ("1/100","An hour is 60 minutes, not 100, so the fraction is 1/60.")]),

 ("RO","Out of 25 breaths, a child breathed only through the mouth for 5 of them. The fraction of mouth breaths is:",
   "1/5",
   C("Write the part over the whole and reduce the fraction to its lowest terms.")+
   steps("Mouth breaths = 5, total = 25","Fraction = 5/25","Divide top and bottom by 5 to get 1/5.")+
   U("Comparing such fractions helps a doctor see how often a child mouth-breathes."),
   [("5/20","The whole is 25 breaths, not 20, so the bottom number is wrong."),
    ("1/4","1/4 would be 5 out of 20; here the total is 25, giving 1/5."),
    ("5/100","5 out of 25 is not 5/100; reduced it is 1/5, not 1/20.")]),

 ("RO","A diver's air tank holds 12 litres and he uses 3/4 of it. The volume of air used is:",
   "9 litres",
   C("Find a fraction of a quantity by multiplying the fraction by the whole.")+
   steps("Tank = 12 L, fraction used = 3/4","3/4 × 12 = 36/4","= 9 litres used.")+
   U("Divers track tank fractions carefully so they always keep enough air to surface."),
   [("3 litres","3 L is 1/4 of the tank, the air left, not the air used."),
    ("4 litres","4 L would be 1/3 of the tank, which is not 3/4."),
    ("8 litres","8 L is 2/3 of 12; the fraction used is 3/4, giving 9 L.")]),

 ("RO","In limewater 0.4 of the bubbles came from carbon dioxide. Written as a percentage this is:",
   "40%",
   C("To turn a decimal into a percentage, multiply it by 100.")+
   steps("Decimal = 0.4","0.4 × 100 = 40","So 0.4 is 40%.")+
   U("Scientists report the share of a gas as a percentage so results are easy to compare."),
   [("4%","4% is 0.04; moving the decimal one place too few gives the wrong value."),
    ("0.4%","0.4% is 0.004; that is far smaller than the decimal 0.4."),
    ("400%","400% is 4.0, ten times too big for the decimal 0.4.")]),

 ("RO","A resting man breathes 15 times a minute; while jogging he breathes 24 times. The increase as a fraction of the resting rate is:",
   "3/5",
   C("Find the increase, then write it as a fraction of the resting rate and reduce.")+
   steps("Increase = 24 − 15 = 9","Fraction of resting = 9/15","Divide top and bottom by 3 to get 3/5.")+
   U("Coaches use such ratios to see how hard an activity makes the body work."),
   [("9/24","The increase is compared with the resting rate 15, not the jogging rate 24."),
    ("2/5","2/5 of 15 is 6, but the increase is 9, which is 3/5 of 15."),
    ("3/8","3/8 would compare 9 with 24; the question asks against the resting 15.")]),

 ("RO","A fish tank uses 2.5 litres of fresh water per hour for aeration. In 4 hours it uses:",
   "10 litres",
   C("Multiply the water used each hour by the number of hours.")+
   steps("Water per hour = 2.5 L","Hours = 4","Total = 2.5 × 4 = 10 litres.")+
   U("Aquarium keepers plan water changes by working out such totals in advance."),
   [("6.5 litres","6.5 comes from 2.5 + 4; the rate must be multiplied by the hours."),
    ("8 litres","8 would be 2 L per hour; the rate given is 2.5 L per hour."),
    ("9 litres","9 is close but 2.5 × 4 is exactly 10 litres.")]),

 ("RO","A runner's breaths-per-minute went from 16 at rest to 28 while sprinting. The total rise in breaths per minute is:",
   "12",
   C("Subtract the resting rate from the sprinting rate to find how much it rose.")+
   steps("Sprinting rate = 28, resting rate = 16","Rise = 28 − 16","= 12 breaths per minute.")+
   U("Coaches track this rise to see how demanding a sprint is on the lungs."),
   [("44","44 adds the two rates; the question asks for the rise, which is the difference."),
    ("28","28 is the sprinting rate itself, not the increase over rest."),
    ("10","10 is close but 28 − 16 is exactly 12.")]),
]

# ---------- TRANSPORTATION IN ANIMALS & PLANTS (25) — Science ----------
TR = [
 ("TR","The liquid that carries food, oxygen and wastes around the human body is:",
   "blood",
   C("Blood is the body's transport fluid; it carries oxygen, food, wastes and heat to where they are needed.")+
   steps("Blood flows through tubes called vessels","It picks up oxygen and food","It drops them off and carries wastes away.")+
   U("A cut bleeds because blood is flowing everywhere just under the skin."),
   [("bile","Bile only helps digest fats in the gut; it does not circulate around the body."),
    ("urine","Urine is a liquid waste leaving the body, not a transport fluid inside it."),
    ("saliva","Saliva works in the mouth to start digestion, not to transport around the body.")]),

 ("TR","The muscular organ that pumps blood around the body is the:",
   "heart",
   C("The heart is a muscular pump that pushes blood through the blood vessels again and again.")+
   steps("The heart squeezes, or beats","Each beat pushes blood out","The blood travels and returns to be pumped again.")+
   U("You can feel each pump as a heartbeat by placing a hand on your chest."),
   [("liver","The liver makes bile and stores food; it does not pump blood."),
    ("lungs","The lungs add oxygen to blood but do not pump it around."),
    ("kidney","The kidney filters blood; the heart is what pumps it.")]),

 ("TR","The red colour of blood and its ability to carry oxygen are due to:",
   "haemoglobin",
   C("Red blood cells contain haemoglobin, a red pigment that binds oxygen and carries it around the body.")+
   steps("Haemoglobin sits inside red blood cells","It grabs oxygen in the lungs","It releases the oxygen where the body needs it.")+
   U("People low in iron make less haemoglobin and feel tired — this is anaemia."),
   [("plasma","Plasma is the pale liquid part of blood; it does not give the red colour."),
    ("platelets","Platelets help blood clot at a cut; they do not carry oxygen."),
    ("white cells","White cells fight germs; haemoglobin in red cells carries oxygen.")]),

 ("TR","Blood vessels that carry blood away from the heart to the body are called:",
   "arteries",
   C("Arteries carry blood away from the heart; they have thick walls to take the high pressure of each pump.")+
   steps("The heart pumps blood out","Arteries carry it away under pressure","Their thick walls handle the force.")+
   U("The pulse you feel at the wrist is blood surging through an artery."),
   [("veins","Veins carry blood back to the heart, not away from it."),
    ("capillaries","Capillaries are the tiny vessels between arteries and veins, not the ones leaving the heart."),
    ("nerves","Nerves carry messages, not blood.")]),

 ("TR","Thin-walled vessels that carry blood back towards the heart and have valves are:",
   "veins",
   C("Veins return blood to the heart; their valves stop the blood from flowing backward.")+
   steps("Blood needs to return to the heart","Veins carry it back at low pressure","Valves keep it moving the right way.")+
   U("Valves in leg veins help push blood upward against gravity when you stand."),
   [("arteries","Arteries carry blood away from the heart and have no such valves."),
    ("capillaries","Capillaries are the tiny exchange vessels, not the return vessels with valves."),
    ("alveoli","Alveoli are air sacs in the lungs, not blood vessels.")]),

 ("TR","The tiny, thin vessels where oxygen and food pass from blood into cells are:",
   "capillaries",
   C("Capillaries are the smallest blood vessels; their very thin walls let oxygen and food pass into the cells.")+
   steps("Arteries branch into tiny capillaries","Their walls are only one cell thick","Oxygen and food pass through into cells.")+
   U("Capillaries are so fine that red cells must pass through them in single file."),
   [("arteries","Arteries are thick and carry blood away; exchange happens in capillaries."),
    ("veins","Veins return blood; the thin exchange vessels are capillaries."),
    ("tendons","Tendons join muscle to bone; they are not blood vessels.")]),

 ("TR","The number of times the heart beats in a minute is measured as the:",
   "pulse rate",
   C("Each heartbeat sends a surge through the arteries; counting these surges per minute gives the pulse rate.")+
   steps("Place fingers on the wrist artery","Count the surges for one minute","That count is the pulse rate.")+
   U("A doctor checks your pulse to see how fast and steady your heart is beating."),
   [("breathing rate","Breathing rate counts breaths, not heartbeats."),
    ("blood group","Blood group is a type of blood, not a count of beats."),
    ("blood pressure","Blood pressure is the force of blood, not the number of beats.")]),

 ("TR","The waste liquid made by the kidneys and stored before being passed out is:",
   "urine",
   C("Kidneys filter wastes and extra water from blood to form urine, which is stored in the bladder.")+
   steps("Blood passes through the kidneys","Wastes and extra water are filtered out","This forms urine, stored in the bladder.")+
   U("Drinking plenty of water makes the urine paler and helps flush wastes out."),
   [("bile","Bile helps digest fats; it is not the kidney's waste liquid."),
    ("sweat","Sweat leaves through the skin; urine is made by the kidneys."),
    ("plasma","Plasma is the liquid part of blood, not a waste to be passed out.")]),

 ("TR","Removal of waste products such as urea from the body is called:",
   "excretion",
   C("Excretion is the removal of harmful wastes, like urea, made by the body's cells.")+
   steps("Cells make wastes such as urea","Blood carries them to the kidneys","They are removed from the body as urine.")+
   U("Sweating on a hot day is another way the body excretes a little waste and water."),
   [("digestion","Digestion breaks down food; excretion removes wastes."),
    ("respiration","Respiration releases energy; it is not the removal of urea."),
    ("circulation","Circulation moves blood around; excretion is the removal step.")]),

 ("TR","Water and minerals move up from the roots to the leaves of a plant through the:",
   "xylem",
   C("Xylem is the plant's pipe-like tissue that carries water and minerals upward from roots to leaves.")+
   steps("Roots take in water and minerals","Xylem tubes carry them upward","They reach the leaves for use.")+
   U("Stand a white flower in coloured water and the petals slowly take the colour up the xylem."),
   [("phloem","Phloem carries food made in leaves, not water up from roots."),
    ("stomata","Stomata are leaf pores for gases, not tubes that carry water up."),
    ("cambium","Cambium is a growth layer; the water-carrying tubes are xylem.")]),

 ("TR","The food made in the leaves is carried to all other parts of the plant through the:",
   "phloem",
   C("Phloem carries the sugary food made in the leaves to the rest of the plant, in any direction needed.")+
   steps("Leaves make food by photosynthesis","Phloem tubes carry the food","It reaches roots, stems and fruits.")+
   U("Sweet sap rises in roots and fruits because phloem delivers food there."),
   [("xylem","Xylem carries water upward, not food made in leaves."),
    ("roots","Roots take in water; they do not carry food made in leaves."),
    ("bark","Bark is the protective outer layer, not the food-carrying tissue.")]),

 ("TR","The loss of water as vapour from the leaves of a plant is called:",
   "transpiration",
   C("Transpiration is the escape of water vapour mainly through the stomata of leaves.")+
   steps("Water reaches the leaves through xylem","Some escapes as vapour through stomata","This is called transpiration.")+
   U("A plastic bag tied over a leafy branch fogs up with the water it transpires."),
   [("respiration","Respiration releases energy; transpiration is water loss."),
    ("condensation","Condensation is vapour turning to liquid, the reverse of what leaves do here."),
    ("germination","Germination is a seed sprouting, not water loss from leaves.")]),

 ("TR","The pull created by transpiration helps the plant by:",
   "drawing water and minerals up from the roots",
   C("As water vapour leaves the leaves, it creates a pull that draws more water up the xylem from the roots.")+
   steps("Water leaves the leaves as vapour","This creates a suction in the xylem","Water and minerals are pulled up from the roots.")+
   U("Tall trees rely on this transpiration pull to lift water many metres high."),
   [("making food without sunlight","Food-making needs sunlight; transpiration is about pulling water up."),
    ("storing extra sugar","Transpiration moves water; storing sugar is a separate job."),
    ("killing harmful germs","Transpiration is water loss, not a defence against germs.")]),

 ("TR","In humans, blood is filtered to remove wastes by a pair of bean-shaped organs called the:",
   "kidneys",
   C("The two kidneys filter the blood, keeping useful things and removing wastes as urine.")+
   steps("Blood enters the kidneys","Wastes and extra water are filtered out","Clean blood returns and urine is formed.")+
   U("People whose kidneys fail may need a machine, called dialysis, to clean their blood."),
   [("lungs","Lungs exchange gases; the kidneys filter wastes from blood."),
    ("heart","The heart pumps blood; it does not filter wastes from it."),
    ("liver","The liver does many jobs, but blood is filtered to urine by the kidneys.")]),

 ("TR","A doctor counts 72 heartbeats in one minute. In half a minute the heart beats about:",
   "36 times",
   C("Half a minute is half the beats of a full minute, so divide the count by 2.")+
   steps("Beats per minute = 72","Half a minute is 1/2 of a minute","72 ÷ 2 = 36 beats.")+
   U("Counting for 30 seconds and doubling is a quick way nurses check the pulse."),
   [("144 times","144 is 72 × 2, the beats in two minutes, not half a minute."),
    ("70 times","70 is just two fewer than the minute count; halving gives 36."),
    ("18 times","18 is one-quarter of 72, which would be 15 seconds, not half a minute.")]),

 ("TR","A heart beats 75 times a minute. The number of beats in 3 minutes is:",
   "225",
   C("Multiply the beats per minute by the number of minutes.")+
   steps("Beats per minute = 75","Minutes = 3","Total = 75 × 3 = 225 beats.")+
   U("Fitness trackers add up beats over time exactly like this."),
   [("78","78 comes from 75 + 3; the values must be multiplied, not added."),
    ("150","150 is 75 × 2, the beats in two minutes, not three."),
    ("250","250 is too high; 75 × 3 is exactly 225.")]),

 ("TR","Of 80 heartbeats counted, 3/4 felt strong and the rest faint. The number of strong beats is:",
   "60",
   C("A fraction of a quantity is found by multiplying the fraction by the whole.")+
   steps("Total beats = 80, strong fraction = 3/4","3/4 × 80 = 240/4","= 60 strong beats.")+
   U("Doctors note the share of strong and faint beats to judge how the heart is working."),
   [("20","20 is 1/4 of 80, the faint beats, not the strong ones."),
    ("40","40 is half of 80; the strong fraction is 3/4, giving 60."),
    ("75","75 is not 3/4 of 80; three-quarters of 80 is exactly 60.")]),

 ("TR","A plant loses 0.6 litre of water by transpiration each day. In one week (7 days) it loses:",
   "4.2 litres",
   C("Multiply the daily water loss by the number of days.")+
   steps("Daily loss = 0.6 L","Days = 7","Total = 0.6 × 7 = 4.2 litres.")+
   U("Gardeners water more in summer because plants transpire more and lose this much."),
   [("0.42 litres","0.42 has the decimal one place too far left; 0.6 × 7 is 4.2."),
    ("6.7 litres","6.7 comes from 0.6 + 7 wrongly; the values must be multiplied."),
    ("42 litres","42 would be 6 L a day; the loss is only 0.6 L a day.")]),

 ("TR","A patient's normal pulse is 72 and after a walk it is 90. The increase as a fraction of the normal pulse is:",
   "1/4",
   C("Find the increase, then write it as a fraction of the normal pulse and reduce.")+
   steps("Increase = 90 − 72 = 18","Fraction of normal = 18/72","Divide top and bottom by 18 to get 1/4.")+
   U("Such ratios show how much an activity raises the heart's work."),
   [("18/90","The increase is compared with the normal pulse 72, not the new pulse 90."),
    ("1/5","1/5 of 72 is about 14, but the increase is 18, which is 1/4 of 72."),
    ("1/3","1/3 of 72 is 24, more than the increase of 18, which is 1/4.")]),

 ("TR","In 1 litre of blood, 0.45 litre is red cells. Written as a percentage, the red-cell part is:",
   "45%",
   C("Turn a decimal into a percentage by multiplying it by 100.")+
   steps("Decimal = 0.45","0.45 × 100 = 45","So 0.45 is 45%.")+
   U("This red-cell percentage, called the haematocrit, is checked in a blood test."),
   [("4.5%","4.5% is 0.045; the decimal point has been moved one place too far."),
    ("0.45%","0.45% is 0.0045, far smaller than the decimal 0.45."),
    ("55%","55% would be the plasma part; the red-cell part 0.45 is 45%.")]),

 ("TR","A tree's xylem carries 8 litres of water up daily and 3/8 of it reaches the topmost leaves. The water reaching the top is:",
   "3 litres",
   C("Multiply the fraction by the whole amount of water carried.")+
   steps("Water carried = 8 L, fraction = 3/8","3/8 × 8 = 24/8","= 3 litres reach the top.")+
   U("Knowing such shares helps explain why treetop leaves can wilt first in a drought."),
   [("5 litres","5 L is the part that does not reach the top (5/8), not the 3/8 that does."),
    ("8 litres","8 L is all the water carried; only 3/8 of it reaches the top."),
    ("11 litres","11 comes from 8 + 3; the fraction must be multiplied by 8.")]),

 ("TR","Blood plasma is about 9/10 water. Written as a decimal, this fraction is:",
   "0.9",
   C("To write a fraction as a decimal, divide the top number by the bottom number.")+
   steps("Fraction = 9/10","9 ÷ 10 = 0.9","So 9/10 is 0.9.")+
   U("Because plasma is almost all water, drinking enough keeps the blood flowing well."),
   [("0.09","0.09 is 9/100, not 9/10; the bottom is ten, not a hundred."),
    ("1.9","1.9 wrongly adds the 1 and the 0.9; nine-tenths is just 0.9."),
    ("9.0","9.0 is the whole number nine, not the fraction nine-tenths.")]),

 ("TR","A heart pumps 0.07 litre of blood per beat. In 100 beats it pumps:",
   "7 litres",
   C("Multiply the blood per beat by the number of beats.")+
   steps("Blood per beat = 0.07 L","Beats = 100","Total = 0.07 × 100 = 7 litres.")+
   U("This is how scientists estimate how much blood the heart moves in a given time."),
   [("0.7 litres","0.7 would be only 10 beats; multiplying by 100 moves the point two places."),
    ("70 litres","70 would be 0.7 L per beat; each beat pumps only 0.07 L."),
    ("17 litres","17 comes from adding wrongly; 0.07 × 100 is exactly 7.")]),

 ("TR","Of 1 litre of blood, red cells are 0.45 L and plasma 0.55 L. The plasma is more than the red cells by:",
   "0.1 litre",
   C("Subtract the smaller decimal from the larger to find the difference.")+
   steps("Plasma = 0.55 L, red cells = 0.45 L","Difference = 0.55 − 0.45","= 0.1 litre.")+
   U("Comparing such decimals shows how much of the blood is liquid versus cells."),
   [("1.0 litre","1.0 is the sum of the two parts, not the difference between them."),
    ("0.9 litre","0.9 is far too big; the two values differ by only one-tenth."),
    ("0.2 litre","0.55 − 0.45 is 0.10, not 0.20.")]),

 ("TR","The watery, pale-yellow part of blood that carries cells and dissolved food is called:",
   "plasma",
   C("Plasma is the liquid part of blood in which the blood cells float and dissolved food and wastes travel.")+
   steps("Blood is part cells and part liquid","The liquid part is plasma","It carries cells, food and wastes along.")+
   U("When blood is left to settle, the pale plasma rises above the heavier red cells."),
   [("haemoglobin","Haemoglobin is the red pigment inside red cells, not the liquid part."),
    ("urea","Urea is a waste carried in plasma, not the liquid itself."),
    ("bile","Bile is made by the liver to digest fats; it is not part of blood.")]),
]

# ---------- FRACTIONS & DECIMALS (25) — Maths ----------
FD = [
 ("FD","The fraction 6/8 written in its lowest terms is:",
   "3/4",
   C("A fraction is in lowest terms when the top and bottom share no common factor other than 1.")+
   steps("Find the common factor of 6 and 8, which is 2","Divide both by 2","6/8 = 3/4.")+
   U("Recipes are easy to read as 3/4 cup rather than 6/8 cup."),
   [("6/8","6/8 is correct in value but not yet reduced; dividing by 2 gives 3/4."),
    ("2/4","2/4 is wrong; dividing 6 and 8 by 2 gives 3/4, not 2/4."),
    ("4/3","4/3 has the numbers flipped; the value 6/8 reduces to 3/4.")]),

 ("FD","The decimal 0.25 written as a fraction in lowest terms is:",
   "1/4",
   C("Read the decimal as hundredths, then reduce the fraction.")+
   steps("0.25 = 25/100","Divide top and bottom by 25","= 1/4.")+
   U("A quarter of a pizza is exactly 0.25 of the whole pizza."),
   [("25/10","0.25 is 25 hundredths, so the bottom is 100, not 10."),
    ("1/2","1/2 is 0.5, twice as big as 0.25."),
    ("2/5","2/5 is 0.4, not 0.25.")]),

 ("FD","Which of these fractions is the largest?",
   "3/4",
   C("Compare fractions by giving them the same bottom number or by converting to decimals.")+
   steps("1/2 = 0.5, 2/3 ≈ 0.67, 3/4 = 0.75, 3/5 = 0.6","Compare the decimals","0.75 is the biggest, so 3/4 is largest.")+
   U("Comparing fractions helps you pick the better deal, like 3/4 off versus 2/3 off."),
   [("2/3","2/3 is about 0.67, less than 0.75 of 3/4."),
    ("1/2","1/2 is 0.5, the smallest here."),
    ("3/5","3/5 is 0.6, less than 3/4.")]),

 ("FD","The sum 1/4 + 1/2 equals:",
   "3/4",
   C("To add fractions, write them with the same bottom number, then add the tops.")+
   steps("1/2 = 2/4","1/4 + 2/4 = 3/4","So the sum is 3/4.")+
   U("Adding a quarter cup and a half cup of flour gives three-quarters of a cup."),
   [("2/6","You cannot just add tops and bottoms; the correct sum is 3/4."),
    ("1/6","1/6 is far too small; a half plus a quarter is more than a half."),
    ("2/4","2/4 is only one-half; adding the extra quarter gives 3/4.")]),

 ("FD","The product 2/3 × 3/4 equals:",
   "1/2",
   C("Multiply the tops together and the bottoms together, then reduce.")+
   steps("2 × 3 = 6 and 3 × 4 = 12","So the product is 6/12","6/12 reduces to 1/2.")+
   U("Two-thirds of three-quarters of a chocolate bar is exactly half the bar."),
   [("5/7","You add neither tops nor bottoms in multiplying; the answer is 1/2."),
    ("6/7","6/7 wrongly adds the bottoms; multiply them to get 12, giving 1/2."),
    ("2/4","2/4 is correct in value but not reduced; in lowest terms it is 1/2.")]),

 ("FD","Dividing by a fraction is the same as multiplying by its:",
   "reciprocal",
   C("To divide by a fraction, flip it (its reciprocal) and multiply.")+
   steps("Take the dividing fraction","Flip top and bottom to get its reciprocal","Multiply by that reciprocal.")+
   U("Sharing 3 chocolates into half-pieces means 3 ÷ 1/2 = 3 × 2 = 6 pieces."),
   [("square","Squaring multiplies a number by itself; dividing uses the reciprocal."),
    ("double","Doubling is not the rule; you multiply by the flipped fraction."),
    ("opposite","The opposite (negative) is for adding; division uses the reciprocal.")]),

 ("FD","The value of 1/2 ÷ 1/4 is:",
   "2",
   C("Divide by flipping the second fraction and multiplying.")+
   steps("1/2 ÷ 1/4 = 1/2 × 4/1","= 4/2","= 2.")+
   U("A half-litre bottle fills two quarter-litre cups, which is 1/2 ÷ 1/4 = 2."),
   [("1/8","1/8 comes from multiplying instead of flipping the second fraction."),
    ("1/2","1/2 ignores the division; flipping and multiplying gives 2."),
    ("4","4 forgets to divide by the 2; the correct value is 2.")]),

 ("FD","The decimal 3.45 rounded to one decimal place (the nearest tenth) is:",
   "3.5",
   C("Look at the digit after the tenths place; if it is 5 or more, round the tenths up.")+
   steps("Tenths digit is 4, next digit is 5","Since 5 rounds up","3.45 becomes 3.5.")+
   U("Shopkeepers round prices to the nearest tenth of a rupee this way."),
   [("3.4","3.4 rounds down, but the next digit 5 means we round up to 3.5."),
    ("3.0","3.0 drops the tenths entirely, which is rounding to a whole number."),
    ("4.5","4.5 wrongly rounds the whole number; only the tenths place changes here.")]),

 ("FD","The product 0.2 × 0.3 equals:",
   "0.06",
   C("Multiply as whole numbers, then place the decimal point to match the total decimal places.")+
   steps("2 × 3 = 6","There are 1 + 1 = 2 decimal places","So the answer is 0.06.")+
   U("Working out part of a part, like 0.2 of 0.3 of a tank, uses this rule."),
   [("0.6","0.6 has only one decimal place; two factors of tenths give hundredths, 0.06."),
    ("6","6 ignores the decimal points entirely."),
    ("0.5","0.5 comes from adding 0.2 + 0.3; the question multiplies them.")]),

 ("FD","The value of 4.5 ÷ 0.5 is:",
   "9",
   C("Make the divisor a whole number by multiplying both numbers by 10, then divide.")+
   steps("Multiply both by 10: 45 ÷ 5","45 ÷ 5 = 9","So 4.5 ÷ 0.5 = 9.")+
   U("How many half-litre glasses fill 4.5 litres? Exactly 9."),
   [("0.9","0.9 misplaces the decimal; dividing by 0.5 makes the answer bigger, 9."),
    ("2.25","2.25 comes from dividing by 2, but 0.5 means halving, so the result doubles."),
    ("90","90 multiplies by 100 instead of 10; the correct answer is 9.")]),

 ("FD","Three-fifths written as a decimal is:",
   "0.6",
   C("To write a fraction as a decimal, divide the top number by the bottom number.")+
   steps("3/5 means 3 ÷ 5","3 ÷ 5 = 0.6","So 3/5 = 0.6.")+
   U("Saying 0.6 of a job is done means three-fifths is finished."),
   [("0.35","0.35 just writes the digits 3 and 5; you must divide 3 by 5."),
    ("0.5","0.5 is 1/2, not 3/5."),
    ("0.06","0.06 has the decimal one place too far; 3 ÷ 5 is 0.6.")]),

 ("FD","The improper fraction 7/2 written as a mixed number is:",
   "3 1/2",
   C("Divide the top by the bottom; the quotient is the whole part and the remainder is the new top.")+
   steps("7 ÷ 2 = 3 remainder 1","Whole part 3, remainder 1 over 2","So 7/2 = 3 1/2.")+
   U("Three and a half glasses of juice is 7/2 glasses written as a mixed number."),
   [("2 1/3","The numbers have been swapped; 7 ÷ 2 gives 3 remainder 1."),
    ("3 1/3","The leftover is 1 out of 2, so the fraction is 1/2, not 1/3."),
    ("7 1/2","7 1/2 keeps the 7 wrongly; 7/2 is only three and a half.")]),

 ("FD","The value of 2/5 of 60 is:",
   "24",
   C("Find a fraction of a number by multiplying the fraction by the number.")+
   steps("2/5 × 60 = 120/5","120 ÷ 5 = 24","So 2/5 of 60 is 24.")+
   U("If 2/5 of 60 students walk to school, that is 24 students."),
   [("12","12 is 1/5 of 60; the question asks for two-fifths, which is 24."),
    ("30","30 is half of 60; two-fifths is less than half."),
    ("150","150 multiplies wrongly; two-fifths of 60 cannot be bigger than 60.")]),

 ("FD","The decimal 0.125 written as a fraction in lowest terms is:",
   "1/8",
   C("Read the decimal as thousandths, then reduce the fraction.")+
   steps("0.125 = 125/1000","Divide top and bottom by 125","= 1/8.")+
   U("One-eighth of a cake is the same as 0.125 of it."),
   [("1/4","1/4 is 0.25, twice as big as 0.125."),
    ("125/10","0.125 is 125 thousandths, so the bottom is 1000, not 10."),
    ("1/5","1/5 is 0.2, not 0.125.")]),

 ("FD","Which decimal is the smallest: 0.3, 0.03, 0.33, 0.303?",
   "0.03",
   C("Line up the decimal points and compare place by place from the left.")+
   steps("Tenths: 0.03 has 0 tenths, the rest have at least 3 tenths","0 tenths is the least","So 0.03 is the smallest.")+
   U("Comparing decimals like this helps you find the cheapest price per gram."),
   [("0.3","0.3 has 3 tenths, more than the 0 tenths of 0.03."),
    ("0.303","0.303 has 3 tenths, larger than 0.03."),
    ("0.33","0.33 has 3 tenths, the largest tenths here.")]),

 ("FD","The sum 0.75 + 0.5 equals:",
   "1.25",
   C("Line up the decimal points and add, filling missing places with zeros.")+
   steps("Write 0.75 + 0.50","Add: 75 + 50 hundredths = 125 hundredths","= 1.25.")+
   U("Three-quarters of a metre plus half a metre of ribbon is 1.25 metres."),
   [("0.80","0.80 wrongly adds only the visible digits; aligning places gives 1.25."),
    ("1.20","1.20 forgets the extra 0.05; the true sum is 1.25."),
    ("12.5","12.5 misplaces the decimal point by one place.")]),

 ("FD","The reciprocal of 3/7 is:",
   "7/3",
   C("The reciprocal of a fraction is found by swapping its top and bottom numbers.")+
   steps("Take 3/7","Swap top and bottom","The reciprocal is 7/3.")+
   U("Dividing by 3/7 is the same as multiplying by its reciprocal 7/3."),
   [("3/7","A number's reciprocal is its flip, not itself, unless it is 1."),
    ("-3/7","The reciprocal flips the fraction; it does not make it negative."),
    ("1/3","1/3 only flips part of the fraction; both numbers must swap to 7/3.")]),

 ("FD","A rope is 2.5 m long. If 0.75 m is cut off, the remaining length is:",
   "1.75 m",
   C("Subtract the part cut off from the whole length, lining up the decimal points.")+
   steps("Whole = 2.50 m, cut = 0.75 m","2.50 − 0.75","= 1.75 m left.")+
   U("Tailors subtract decimals like this to know how much cloth is left."),
   [("1.25 m","1.25 subtracts too much; 2.50 − 0.75 is 1.75, not 1.25."),
    ("3.25 m","3.25 adds the cut piece instead of subtracting it."),
    ("2.25 m","2.25 takes away only 0.25; the cut is 0.75, leaving 1.75.")]),

 ("FD","The value of 1 1/2 + 2 1/4 is:",
   "3 3/4",
   C("Add the whole numbers, then add the fractions using a common bottom number.")+
   steps("Wholes: 1 + 2 = 3","Fractions: 1/2 + 1/4 = 2/4 + 1/4 = 3/4","Total = 3 3/4.")+
   U("One and a half hours plus two and a quarter hours is three and three-quarter hours."),
   [("3 2/6","You cannot add fraction bottoms; 1/2 + 1/4 is 3/4, giving 3 3/4."),
    ("3 1/4","3 1/4 forgets that 1/2 is 2/4; the fractions add to 3/4."),
    ("4","4 rounds up wrongly; the exact sum is three and three-quarters.")]),

 ("FD","The decimal 0.6 written as a percentage is:",
   "60%",
   C("To change a decimal into a percentage, multiply it by 100.")+
   steps("0.6 × 100 = 60","Add the percent sign","So 0.6 = 60%.")+
   U("A test score of 0.6 of the marks is the same as 60%."),
   [("6%","6% is 0.06; the decimal point has moved one place too few."),
    ("0.6%","0.6% is 0.006, far smaller than the decimal 0.6."),
    ("600%","600% is 6.0, ten times too big for 0.6.")]),

 ("FD","The value of 0.4 + 0.45 is:",
   "0.85",
   C("Line up the decimal points and add, treating 0.4 as 0.40.")+
   steps("Write 0.40 + 0.45","Add hundredths: 40 + 45 = 85","= 0.85.")+
   U("Adding two part-litre measures, 0.4 L and 0.45 L, gives 0.85 L."),
   [("0.49","0.49 wrongly adds 0.4 + 0.09; the second number is 0.45."),
    ("0.85 ÷ 2","Halving is not asked; the simple sum is 0.85."),
    ("4.45","4.45 misreads 0.4 as 4; the sum of the two decimals is 0.85.")]),

 ("FD","What fraction of 1 hour is 20 minutes?",
   "1/3",
   C("Write the part over the whole, using the same unit, then reduce.")+
   steps("1 hour = 60 minutes","Fraction = 20/60","Divide top and bottom by 20 to get 1/3.")+
   U("A 20-minute break in a 1-hour class is one-third of the class time."),
   [("1/20","20 is the minutes taken, not the bottom; the hour has 60 minutes."),
    ("20/100","An hour is 60 minutes, not 100, so 20/60 reduces to 1/3."),
    ("1/2","Half an hour is 30 minutes; 20 minutes is one-third.")]),

 ("FD","The value of 5/6 − 1/3 is:",
   "1/2",
   C("Use a common bottom number, subtract the tops, then reduce.")+
   steps("1/3 = 2/6","5/6 − 2/6 = 3/6","3/6 reduces to 1/2.")+
   U("If 5/6 of a tank is full and 1/3 is used, half the tank remains."),
   [("4/3","You cannot subtract across different bottoms directly; the answer is 1/2."),
    ("4/6","4/6 comes from subtracting wrongly; 5/6 − 2/6 is 3/6 = 1/2."),
    ("1/3","1/3 is the amount subtracted, not the result, which is 1/2.")]),

 ("FD","Anu spent 0.35 of her money and saved the rest. The decimal part she saved is:",
   "0.65",
   C("The whole is 1; subtract the spent part to find the saved part.")+
   steps("Whole = 1.00","Saved = 1.00 − 0.35","= 0.65.")+
   U("Tracking spending as decimals of the whole helps you see how much you keep."),
   [("0.75","0.75 subtracts only 0.25; she spent 0.35, leaving 0.65."),
    ("0.35","0.35 is the part spent, not the part saved."),
    ("1.35","1.35 adds the spent part instead of subtracting it from 1.")]),

 ("FD","The value of 7/10 written as a decimal is:",
   "0.7",
   C("A fraction with ten on the bottom becomes a one-place decimal.")+
   steps("7/10 means 7 ÷ 10","Dividing by ten moves the point one place","= 0.7.")+
   U("Saying 0.7 of the marks is the same as seven-tenths of them."),
   [("7.0","7.0 is the whole number seven, not seven-tenths."),
    ("0.07","0.07 is 7/100; the bottom here is ten, giving 0.7."),
    ("0.17","0.17 just joins the digits 1 and 7; 7 ÷ 10 is 0.7.")]),
]

# ---------- PERIMETER & AREA (25) — Maths ----------
PA = [
 ("PA","The perimeter of a square of side 6 cm is:",
   "24 cm",
   C("The perimeter of a square is the total length around it, which is four times one side.")+
   steps("All four sides are equal, each 6 cm","Perimeter = 4 × side","= 4 × 6 = 24 cm.")+
   U("You need 24 cm of lace to edge a square card of side 6 cm."),
   [("12 cm","12 cm is only two sides; a square has four equal sides."),
    ("36 cm","36 is 6 × 6, which is the area, not the perimeter."),
    ("30 cm","30 is 5 sides; a square has exactly 4 sides, giving 24 cm.")]),

 ("PA","The area of a square of side 6 cm is:",
   "36 cm²",
   C("The area of a square is side multiplied by side.")+
   steps("Side = 6 cm","Area = side × side","= 6 × 6 = 36 cm².")+
   U("A square tile of side 6 cm covers 36 cm² of floor."),
   [("24 cm²","24 is 4 × 6, which is the perimeter, not the area."),
    ("12 cm²","12 is 6 + 6, neither the area nor the perimeter."),
    ("18 cm²","18 has no meaning here; the area is 6 × 6 = 36.")]),

 ("PA","The area of a rectangle 8 cm long and 5 cm wide is:",
   "40 cm²",
   C("The area of a rectangle is length multiplied by width.")+
   steps("Length = 8 cm, width = 5 cm","Area = length × width","= 8 × 5 = 40 cm².")+
   U("A book cover 8 cm by 5 cm covers 40 cm² of paper."),
   [("26 cm²","26 is the perimeter 2 × (8 + 5), not the area."),
    ("13 cm²","13 is 8 + 5; area needs multiplication, giving 40."),
    ("80 cm²","80 doubles the area wrongly; 8 × 5 is 40.")]),

 ("PA","The perimeter of a rectangle 8 cm long and 5 cm wide is:",
   "26 cm",
   C("The perimeter of a rectangle is twice the sum of its length and width.")+
   steps("Length + width = 8 + 5 = 13","Perimeter = 2 × 13","= 26 cm.")+
   U("A photo frame 8 cm by 5 cm needs 26 cm of wood around it."),
   [("40 cm","40 is 8 × 5, the area, not the perimeter."),
    ("13 cm","13 is only one length plus one width; go around all four sides."),
    ("52 cm","52 doubles the perimeter; 2 × (8 + 5) is 26.")]),

 ("PA","A triangular scarf has a base of 14 cm and a height of 9 cm. Its area works out to:",
   "63 cm²",
   C("The area of a triangle is half the base times the height.")+
   steps("Base = 14 cm, height = 9 cm","Area = 1/2 × base × height","= 1/2 × 14 × 9 = 63 cm².")+
   U("A triangular bunting flag is cut to a fixed area like this to save cloth."),
   [("126 cm²","126 forgets the one-half; a triangle is half of base × height."),
    ("23 cm²","23 is base + height; area needs 1/2 × base × height."),
    ("63 cm","The unit of area is cm², not cm; the number 63 is right but the unit is wrong.")]),

 ("PA","The area of a parallelogram with base 12 cm and height 5 cm is:",
   "60 cm²",
   C("The area of a parallelogram is base times height.")+
   steps("Base = 12 cm, height = 5 cm","Area = base × height","= 12 × 5 = 60 cm².")+
   U("A slanted garden bed shaped like a parallelogram covers base × height of ground."),
   [("30 cm²","30 halves it like a triangle; a parallelogram is base × height, not half."),
    ("17 cm²","17 is base + height, not base × height."),
    ("34 cm²","34 is the perimeter idea, not the area of 12 × 5 = 60.")]),

 ("PA","A tile maker needs to know how many square centimetres make up one whole square metre. The answer is:",
   "10000 cm²",
   C("Since 1 m = 100 cm, a square metre is 100 cm × 100 cm.")+
   steps("1 m = 100 cm","1 m² = 100 × 100 cm²","= 10000 cm².")+
   U("Floor tiles are sold by the square metre, each holding 10000 cm²."),
   [("100 cm²","100 cm² is only 10 cm × 10 cm, not a full square metre."),
    ("1000 cm²","1000 cm² is too small; a square metre holds 10000 cm²."),
    ("1000000 cm²","That is a square metre in square millimetres, not square centimetres.")]),

 ("PA","A square photo frame is built from 36 cm of wooden beading all around. Each side of the frame is:",
   "9 cm",
   C("Divide the perimeter by 4 to find one side of a square.")+
   steps("Perimeter = 4 × side","Side = 36 ÷ 4","= 9 cm.")+
   U("Knowing the perimeter of a square frame lets you cut each side equally."),
   [("18 cm","18 is half the perimeter, which is two sides, not one."),
    ("4 cm","4 is the number of sides, not the side length, which is 9."),
    ("36 cm","36 is the whole perimeter; one side is a quarter of it, 9 cm.")]),

 ("PA","The width of a rectangle of area 48 cm² and length 8 cm is:",
   "6 cm",
   C("Width is the area divided by the length.")+
   steps("Area = length × width","Width = 48 ÷ 8","= 6 cm.")+
   U("If you know a garden's area and one side, you can work out the other side."),
   [("40 cm","40 subtracts instead of divides; 48 ÷ 8 is 6."),
    ("384 cm","384 multiplies area by length; you should divide to get 6."),
    ("16 cm","16 is double; 48 ÷ 8 gives 6, not 16.")]),

 ("PA","A rectangle measuring 10 cm by 4 cm is reshaped into a square using the same length of boundary. The square's side becomes:",
   "7 cm",
   C("A square's side is its equal perimeter divided by 4.")+
   steps("Rectangle perimeter = 2 × (10 + 4) = 28 cm","Square keeps the same perimeter, 28 cm","Side = 28 ÷ 4 = 7 cm.")+
   U("Two shapes can share a boundary length yet enclose different areas."),
   [("10 cm","10 cm is the rectangle's length, not the square's side."),
    ("14 cm","14 is half the perimeter, two sides, not one side of the square."),
    ("28 cm","28 is the whole perimeter; the square's side is a quarter of it.")]),

 ("PA","A path of area 30 m² costs ₹20 per square metre to pave. The total cost is:",
   "₹600",
   C("Multiply the area by the cost of each square metre.")+
   steps("Area = 30 m²","Cost per m² = ₹20","Total = 30 × 20 = ₹600.")+
   U("Builders work out paving costs by multiplying area by the rate per square metre."),
   [("₹50","₹50 adds 30 + 20; cost needs area times rate, giving ₹600."),
    ("₹150","₹150 divides instead of multiplying; 30 × 20 is ₹600."),
    ("₹6000","₹6000 multiplies by 200; the rate is ₹20, giving ₹600.")]),

 ("PA","A wire of length 40 cm is bent into a square. The area of the square is:",
   "100 cm²",
   C("The wire's length is the perimeter; find the side, then the area.")+
   steps("Side = 40 ÷ 4 = 10 cm","Area = side × side","= 10 × 10 = 100 cm².")+
   U("A fixed length of fencing encloses the most area when bent into a square."),
   [("40 cm²","40 is the wire length (perimeter), not the area, which is 100."),
    ("160 cm²","160 is 40 × 4, not the area; first find the side, 10 cm."),
    ("10 cm²","10 is the side length; the area is 10 × 10 = 100.")]),

 ("PA","A leaf is shaped like a rectangle 4 cm by 3 cm. Its surface area on one side is:",
   "12 cm²",
   C("Treat the leaf as a rectangle and multiply length by width.")+
   steps("Length = 4 cm, width = 3 cm","Area = 4 × 3","= 12 cm².")+
   U("Bigger leaf area means more surface for sunlight and for losing water by transpiration."),
   [("14 cm²","14 is the perimeter 2 × (4 + 3), not the area."),
    ("7 cm²","7 is 4 + 3; area needs multiplication, giving 12."),
    ("12 cm","The unit of area is cm², not cm.")]),

 ("PA","A rectangular field is 50 m long and 30 m wide. The length of fence to go around it once is:",
   "160 m",
   C("The fence length is the perimeter, twice the sum of length and width.")+
   steps("Length + width = 50 + 30 = 80 m","Perimeter = 2 × 80","= 160 m.")+
   U("Farmers buy fencing by working out the field's perimeter like this."),
   [("1500 m","1500 is the area 50 × 30, measured in m², not the fence length."),
    ("80 m","80 is one length plus one width; the fence goes around all four sides."),
    ("320 m","320 doubles the perimeter; 2 × 80 is 160 m.")]),

 ("PA","The area of a square garden of side 0.5 m is:",
   "0.25 m²",
   C("Area of a square is side times side, even when the side is a decimal.")+
   steps("Side = 0.5 m","Area = 0.5 × 0.5","= 0.25 m².")+
   U("A small square seed-bed of side half a metre covers a quarter of a square metre."),
   [("1 m²","1 m² would need a side of 1 m; a 0.5 m side gives 0.25 m²."),
    ("2 m²","2 m² is far too big for a half-metre square."),
    ("0.5 m²","0.5 is the side, not the area; 0.5 × 0.5 is 0.25.")]),

 ("PA","A rectangular plant tray is 1.2 m by 0.5 m. Its area is:",
   "0.6 m²",
   C("Multiply length by width, keeping track of the decimal places.")+
   steps("Length = 1.2 m, width = 0.5 m","Area = 1.2 × 0.5","= 0.6 m².")+
   U("Nursery owners size their seedling trays by area to fit a bench."),
   [("1.7 m²","1.7 adds 1.2 + 0.5; area needs multiplication, giving 0.6."),
    ("6 m²","6 misplaces the decimal; 1.2 × 0.5 is 0.6, not 6."),
    ("0.06 m²","0.06 has the point one place too far; the area is 0.6 m².")]),

 ("PA","Half of a rectangular leaf 6 cm by 4 cm is shaded. The shaded area is:",
   "12 cm²",
   C("Find the whole area, then take one-half of it.")+
   steps("Whole area = 6 × 4 = 24 cm²","Shaded = 1/2 × 24","= 12 cm².")+
   U("Scientists estimate how much of a leaf is damaged by shading a fraction like this."),
   [("24 cm²","24 cm² is the whole leaf; only half of it is shaded, so 12 cm²."),
    ("10 cm²","10 is the perimeter idea, not half the area of 24."),
    ("6 cm²","6 cm² is one-quarter; half of 24 is 12.")]),

 ("PA","A square plot has an area of 81 m². The length of its side is:",
   "9 m",
   C("The side of a square is the number that multiplies by itself to give the area.")+
   steps("Side × side = 81","9 × 9 = 81","So the side is 9 m.")+
   U("Knowing a square field's area lets a farmer find each side to fence it."),
   [("40.5 m","40.5 is half of 81; the side is the square root, 9 m."),
    ("81 m","81 m is the area number, not the side; the side is 9 m."),
    ("18 m","18 is 2 × 9; the side that squares to 81 is 9, not 18.")]),

 ("PA","A rectangular pond cover is 3/4 m long and 1/2 m wide. Its area is:",
   "3/8 m²",
   C("Multiply the two fraction side lengths to get the area.")+
   steps("Area = 3/4 × 1/2","Multiply tops and bottoms: 3/8","So the area is 3/8 m².")+
   U("Garden covers cut to fraction sizes have areas worked out this way."),
   [("5/6 m²","5/6 wrongly adds the fractions; area needs multiplication, giving 3/8."),
    ("3/4 m²","3/4 is just the length; multiplying by the width 1/2 gives 3/8."),
    ("1/2 m²","1/2 is just the width; the area 3/4 × 1/2 is 3/8.")]),

 ("PA","A garden bed of area 24 m² has 1/3 of it planted with roses. The rose area is:",
   "8 m²",
   C("Take the given fraction of the total area.")+
   steps("Total area = 24 m², fraction = 1/3","1/3 × 24 = 24/3","= 8 m².")+
   U("Gardeners split a bed into fractions to plan how much of each plant to grow."),
   [("12 m²","12 is half of 24; one-third is 8 m²."),
    ("3 m²","3 is the divisor, not the share; 24 ÷ 3 is 8."),
    ("21 m²","21 is 24 − 3; one-third of 24 is 8, not 21.")]),

 ("PA","Two identical square tiles of side 5 cm are placed side by side to form a rectangle. The rectangle's area is:",
   "50 cm²",
   C("Add the two equal square areas, or treat the join as one rectangle.")+
   steps("Each square area = 5 × 5 = 25 cm²","Two squares = 25 + 25","= 50 cm².")+
   U("Tilers add tile areas this way to cover a floor."),
   [("25 cm²","25 cm² is just one tile; two tiles give double, 50 cm²."),
    ("20 cm²","20 cm² is the perimeter of one tile, not the area of two."),
    ("100 cm²","100 cm² would be four tiles; two tiles give 50 cm².")]),

 ("PA","A square field of side 20 m needs fencing on all sides. At ₹15 per metre, the fencing cost is:",
   "₹1200",
   C("Find the perimeter, then multiply by the cost per metre.")+
   steps("Perimeter = 4 × 20 = 80 m","Cost = 80 × ₹15","= ₹1200.")+
   U("Estimating fence cost means combining perimeter with the price per metre."),
   [("₹300","₹300 uses only one side (20 m); fencing goes around all four."),
    ("₹6000","₹6000 uses the area 400 m²; fencing depends on the perimeter, 80 m."),
    ("₹1380","₹1380 adds wrongly; 80 × 15 is exactly ₹1200.")]),

 ("PA","The base of a triangle whose area is 24 cm² and height is 8 cm is:",
   "6 cm",
   C("Rearrange the triangle area rule: base equals twice the area divided by the height.")+
   steps("Area = 1/2 × base × height","24 = 1/2 × base × 8 = 4 × base","Base = 24 ÷ 4 = 6 cm.")+
   U("Knowing a triangular plot's area and height lets you find its base."),
   [("3 cm","3 cm forgets to double; 24 ÷ 4 gives the base 6 cm."),
    ("12 cm","12 cm skips the half; with the 1/2 the base is 6 cm."),
    ("16 cm","16 comes from 24 − 8; the rule needs division, giving 6.")]),

 ("PA","A leaf-shaped paper covers 3/5 of a rectangular sheet of area 100 cm². The leaf area is:",
   "60 cm²",
   C("Take the given fraction of the whole sheet's area.")+
   steps("Sheet area = 100 cm², fraction = 3/5","3/5 × 100 = 300/5","= 60 cm².")+
   U("Estimating the area of an odd shape as a fraction of a known rectangle is a handy trick."),
   [("40 cm²","40 cm² is 2/5 of the sheet, the uncovered part, not the 3/5 leaf."),
    ("20 cm²","20 cm² is 1/5; the leaf covers 3/5, giving 60 cm²."),
    ("35 cm²","35 just joins the digits 3 and 5; 3/5 of 100 is 60.")]),

 ("PA","A rectangular vegetable patch is 9 m long and 4 m wide. How much greater is its area than its perimeter (as numbers)?",
   "10",
   C("Work out the area and the perimeter separately, then find the difference of the numbers.")+
   steps("Area = 9 × 4 = 36, Perimeter = 2 × (9 + 4) = 26","Difference = 36 − 26","= 10.")+
   U("Comparing area and perimeter shows why a fixed fence can still hold very different areas."),
   [("62","62 adds the area and perimeter; the question asks for their difference."),
    ("36","36 is the area alone, not how much it exceeds the perimeter."),
    ("13","13 is 9 + 4; the difference between 36 and 26 is 10.")]),
]

assert len(RO) == 25 and len(TR) == 25 and len(FD) == 25 and len(PA) == 25

# Interleave so no two consecutive questions share a chapter; Science/Maths alternate.
items = []
for i in range(25):
    items += [RO[i], FD[i], TR[i], PA[i]]
assert len(items) == 100

for a, b in zip(items, items[1:]):
    assert a[0] != b[0], (a[1], b[1])

if __name__ == "__main__":
    here = os.path.dirname(os.path.abspath(__file__))
    papers_dir = os.path.abspath(os.path.join(
        here, "..", "..", "desktopAhaan", "Resources", "BossChallengePapers"))
    os.chdir(papers_dir)

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=13109,
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
    split = "/".join(str(counts[c]) for c in ("RO", "TR", "FD", "PA"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
