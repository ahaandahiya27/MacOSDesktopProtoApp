# -*- coding: utf-8 -*-
# Boss Challenge Paper 22 — Transportation in Animals & Plants · Acids, Bases & Salts ·
#                           Comparing Quantities · Perimeter & Area
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans hard into FUSION — many Comparing-Quantities and
# Perimeter-&-Area items are wrapped in a real Science situation (the percentage of an
# acid in a bottle, the ratio of a resting to an active heart rate, the surface area of a
# leaf that transpires, the perimeter of a rectangular field of crops). The child has to
# read a Science context and apply a Maths skill. Class-7 scope, simple wording, hard
# thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_22_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_22_<SHORT>_QuestionPaper.pdf
#   Paper_22_<SHORT>_Questions.md
#   Paper_22_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "22"
SHORT = "Transportation_AcidsBases_ComparingQuantities_PerimeterArea"
TITLE = ("Transportation in Animals & Plants · Acids, Bases & Salts · "
         "Comparing Quantities · Perimeter & Area")
LABELS = {
    "TR": "Transportation in Animals & Plants",
    "AB": "Acids, Bases & Salts",
    "CQ": "Comparing Quantities",
    "PA": "Perimeter & Area",
}

# ---------- TRANSPORTATION IN ANIMALS & PLANTS (25) — Science ----------
TR = [
 ("TR","The red fluid that flows through the body of animals, carrying food, oxygen and wastes, is called:",
   "blood",
   C("Blood is the body's transport fluid, carrying oxygen, food and wastes to and from every part.")+
   steps("The body must move materials between its parts","A flowing fluid does this carrying","That fluid is blood.")+
   U("When you cut your finger, the red blood that appears is the very fluid that feeds every cell."),
   [("bile","Bile is a digestive juice made by the liver; it does not flow round the body carrying oxygen."),
    ("urine","Urine is a liquid waste being removed from the body, not the fluid that transports food and oxygen."),
    ("saliva","Saliva is a watery juice in the mouth that helps digestion; it is not the body's transport fluid.")]),

 ("TR","The liquid part of blood, which is mostly water and carries the blood cells along, is called:",
   "plasma",
   C("Plasma is the pale yellow liquid part of blood in which the cells float and travel.")+
   steps("Blood is part liquid, part cells","The liquid part is mostly water with dissolved substances","This liquid is the plasma.")+
   U("When blood settles in a test tube, the clear straw-coloured layer on top is the plasma."),
   [("platelets","Platelets are tiny cell fragments that help clotting; they are not the liquid part of blood."),
    ("haemoglobin","Haemoglobin is the red pigment inside red cells, not the liquid that carries the cells."),
    ("lymph","Lymph is a separate pale fluid that drains the tissues; the liquid part of blood is plasma.")]),

 ("TR","The blood cells that carry oxygen, coloured red by the pigment haemoglobin, are the:",
   "red blood cells",
   C("Red blood cells are packed with haemoglobin, which grabs oxygen and carries it round the body.")+
   steps("Oxygen must reach every cell","Haemoglobin binds oxygen tightly","Red blood cells, full of haemoglobin, carry it.")+
   U("Blood looks red because the countless oxygen-carrying red blood cells in it are red."),
   [("white blood cells","White blood cells fight germs; it is the RED blood cells that carry oxygen."),
    ("platelets","Platelets help the blood to clot at a wound; they do not carry oxygen."),
    ("nerve cells","Nerve cells carry messages, not oxygen, and they are not part of the blood.")]),

 ("TR","The blood cells that protect the body by fighting against germs and disease are the:",
   "white blood cells",
   C("White blood cells defend the body, attacking and destroying invading germs.")+
   steps("Germs constantly try to enter the body","The blood carries defending cells","These germ-fighting cells are the white blood cells.")+
   U("When you have an infection, your body makes extra white blood cells to fight it off."),
   [("red blood cells","Red blood cells carry oxygen; it is the WHITE blood cells that fight germs."),
    ("platelets","Platelets seal wounds by helping the blood clot; they do not fight germs."),
    ("plasma","Plasma is the liquid that carries everything along; the germ-fighters are the white blood cells.")]),

 ("TR","The muscular organ that pumps blood all around the body without ever resting is the:",
   "heart",
   C("The heart is a muscular pump that pushes blood through the body again and again, all life long.")+
   steps("Blood must be kept moving everywhere","A pump is needed to push it","That tireless pump is the heart.")+
   U("Press two fingers to your wrist and the steady beat you feel is your heart pumping blood."),
   [("brain","The brain controls the body and thinking, but it does not pump the blood — the heart does."),
    ("stomach","The stomach digests food; it is not the pump that drives blood around the body."),
    ("lungs","The lungs take in air; the muscular pump that pushes the blood is the heart.")]),

 ("TR","The thin-walled blood vessels where the actual exchange of food, oxygen and wastes with the body cells happens are the:",
   "capillaries",
   C("Capillaries are the tiniest, thinnest blood vessels, where materials pass between blood and cells.")+
   steps("Materials must move between blood and cells","This needs very thin vessel walls","The thinnest vessels, the capillaries, allow it.")+
   U("Oxygen slips from the blood into your muscles through capillary walls only one cell thick."),
   [("arteries","Arteries are thick vessels that carry blood away from the heart; exchange happens in the capillaries."),
    ("veins","Veins carry blood back to the heart; the exchange with cells takes place in the capillaries."),
    ("nerves","Nerves carry signals, not blood; the exchange of materials happens in the capillaries.")]),

 ("TR","Blood vessels that carry blood AWAY from the heart, with thick, elastic walls, are called:",
   "arteries",
   C("Arteries carry blood away from the heart and have thick walls to take the high pressure.")+
   steps("Blood leaves the heart under strong pressure","Vessels carrying it need thick, strong walls","These outgoing vessels are the arteries.")+
   U("The strong throb you feel at your wrist is an artery carrying blood away from your heart."),
   [("veins","Veins carry blood BACK to the heart and have thinner walls; arteries carry it away."),
    ("capillaries","Capillaries are tiny exchange vessels; the thick vessels carrying blood from the heart are arteries."),
    ("nerves","Nerves carry messages, not blood; the outgoing blood vessels are the arteries.")]),

 ("TR","Blood vessels that carry blood BACK towards the heart, and which have valves to stop backflow, are called:",
   "veins",
   C("Veins return blood to the heart and have valves so the blood cannot flow backwards.")+
   steps("Blood returning to the heart is under low pressure","Valves are needed to stop it slipping back","These return vessels with valves are the veins.")+
   U("The bluish lines you can see on the back of your hand are veins carrying blood back to the heart."),
   [("arteries","Arteries carry blood AWAY from the heart and have no such valves; veins bring it back."),
    ("capillaries","Capillaries are the tiny exchange vessels; the return vessels with valves are the veins."),
    ("tendons","Tendons join muscle to bone; they are not blood vessels at all.")]),

 ("TR","Each single throb of an artery, felt where it runs close to the skin, is called the:",
   "pulse",
   C("The pulse is the throb in an artery caused by each beat of the heart pushing blood through.")+
   steps("The heart beats and pushes a wave of blood","The artery wall stretches with each push","That throb felt at the skin is the pulse.")+
   U("A doctor counts your pulse at the wrist to find out how fast your heart is beating."),
   [("reflex","A reflex is a sudden automatic action, like blinking; it is not the throb of an artery."),
    ("clot","A clot is a plug that stops bleeding; it is not the regular throb felt at the wrist."),
    ("nerve","A nerve carries signals; the throb of an artery with each heartbeat is the pulse.")]),

 ("TR","The number of times a healthy resting person's heart beats in one minute is closest to:",
   "about 72 times",
   C("A healthy adult heart at rest beats around 70 to 72 times every minute.")+
   steps("The heart beats steadily at rest","Counting beats for a whole minute","gives about 72 beats per minute.")+
   U("Counting your pulse for a minute while sitting quietly gives a number close to 72."),
   [("about 5 times","Only 5 beats a minute would be far too slow to keep a person alive."),
    ("about 300 times","300 beats a minute is impossibly fast for a resting human heart."),
    ("about 1000 times","1000 beats a minute is far beyond any human heart; the resting rate is around 72.")]),

 ("TR","The waste liquid produced when the kidneys filter the blood, and later passed out of the body, is:",
   "urine",
   C("Urine is the liquid waste the kidneys make by filtering wastes and extra water out of the blood.")+
   steps("Blood collects wastes from all over the body","The kidneys filter these wastes out","The filtered liquid waste is urine.")+
   U("Drinking lots of water makes you pass more urine as the kidneys flush out the extra."),
   [("plasma","Plasma is the useful liquid part of blood, not the waste that leaves the body."),
    ("bile","Bile is a digestive juice from the liver, not the waste filtered out by the kidneys."),
    ("sweat","Sweat is released through the skin; the liquid waste made by the kidneys is urine.")]),

 ("TR","The bean-shaped organs that filter wastes from the blood to form urine are the:",
   "kidneys",
   C("The kidneys clean the blood, removing wastes and extra water as urine.")+
   steps("Blood must be cleaned of its wastes","A filtering organ is needed","The two bean-shaped kidneys do this filtering.")+
   U("People whose kidneys fail must use a dialysis machine to clean their blood for them."),
   [("lungs","The lungs exchange gases with the air; the blood is filtered to make urine by the kidneys."),
    ("liver","The liver does many jobs, but it is the kidneys that filter the blood to form urine."),
    ("heart","The heart pumps the blood; it does not filter wastes — the kidneys do.")]),

 ("TR","In tall plants, water and dissolved minerals are carried UP from the roots to the leaves through tubes called:",
   "xylem",
   C("Xylem is the plant's pipework that carries water and minerals upward from the roots.")+
   steps("Roots absorb water and minerals from the soil","These must travel up to the leaves","Xylem tubes carry them upward.")+
   U("Stand a white flower in coloured water and the xylem carries the colour up into the petals."),
   [("phloem","Phloem carries FOOD made in the leaves; water and minerals go up through the xylem."),
    ("stomata","Stomata are tiny leaf pores for gases; the upward water tubes are the xylem."),
    ("roots hairs","Root hairs absorb water at the soil, but the long upward tubes inside the plant are the xylem.")]),

 ("TR","In a plant, the food made in the leaves is carried to all other parts through tubes called:",
   "phloem",
   C("Phloem carries the food made in the leaves to the rest of the plant, including downward to the roots.")+
   steps("Leaves make food by photosynthesis","This food must reach stem, roots and fruit","Phloem tubes carry it everywhere.")+
   U("The sweetness building up in a ripening fruit reaches it through the phloem from the leaves."),
   [("xylem","Xylem carries WATER UP from the roots; food from the leaves travels in the phloem."),
    ("stomata","Stomata are gas pores on the leaf; food is transported through the phloem tubes."),
    ("veins of the heart","Plants have no heart; the food-carrying tubes of a plant are the phloem.")]),

 ("TR","The loss of water as vapour from the leaves of a plant, mainly through the stomata, is called:",
   "transpiration",
   C("Transpiration is the escape of water vapour from a plant's leaves into the air.")+
   steps("Leaves hold water that turns to vapour","This vapour escapes through tiny stomata","This loss of water vapour is transpiration.")+
   U("Tie a clear bag over a leafy twig in sunlight and droplets of transpired water collect inside."),
   [("respiration","Respiration releases energy from food; transpiration is the loss of water vapour from leaves."),
    ("condensation","Condensation is vapour turning back to liquid; transpiration is water leaving the leaf as vapour."),
    ("germination","Germination is a seed sprouting into a seedling, not the loss of water from leaves.")]),

 ("TR","The pull created by transpiration from the leaves is important because it helps the plant to:",
   "draw water up from the roots",
   C("As water vapour leaves the leaves, it pulls more water up the xylem from the roots — the transpiration pull.")+
   steps("Water vapour escaping the leaves leaves a gap","This creates a suction in the xylem","That pull draws water up all the way from the roots.")+
   U("On a hot, breezy day a tree transpires fast, sucking up litres of water from the soil through its roots."),
   [("make its own food faster","Food is made using light in the leaf; transpiration's job is to help pull water up from the roots."),
    ("fight off germs","Transpiration does not fight germs; it pulls water up from the roots to the leaves."),
    ("store extra oxygen","Transpiration loses water vapour, not oxygen; its pull lifts water up from the roots.")]),

 ("TR","Water and minerals from the soil first enter a plant through the fine projections on its roots called:",
   "root hairs",
   C("Root hairs are tiny hair-like projections that hugely increase the surface for soaking up soil water.")+
   steps("Roots must absorb water and minerals","More surface means faster absorption","Tiny root hairs provide that surface.")+
   U("Pull up a seedling gently and the fuzzy fine root hairs that drink in soil water are visible near the tips."),
   [("flowers","Flowers are for making seeds; water and minerals enter through the root hairs, not the flowers."),
    ("stomata","Stomata exchange gases on the leaves; water from the soil enters through the root hairs."),
    ("fruits","Fruits hold seeds; the soil water enters the plant through the root hairs on the roots.")]),

 ("TR","The human heart is divided into how many chambers?",
   "four",
   C("The human heart has four chambers — two upper atria and two lower ventricles.")+
   steps("The heart keeps used and fresh blood apart","It needs separate receiving and pumping rooms","This gives four chambers in all.")+
   U("Doctors describe the heart's 'four-chambered' design when explaining how it keeps clean and used blood separate."),
   [("two","The human heart has FOUR chambers, not two; fish have a simpler heart, not humans."),
    ("one","A single chamber could not keep clean and used blood apart; the human heart has four."),
    ("six","The human heart has four chambers, not six.")]),

 ("TR","During hard exercise, the heartbeat and pulse rate of a person usually:",
   "increase",
   C("Working muscles need more oxygen, so the heart beats faster and the pulse rises during exercise.")+
   steps("Exercising muscles demand more oxygen","Blood must be pumped to them faster","So the heartbeat and pulse rate increase.")+
   U("After running up the stairs you can feel your heart pounding much faster than when you sat still."),
   [("decrease","Exercise speeds the heart UP to supply more oxygen; it does not slow it down."),
    ("stop completely","The heart never stops during exercise; it beats faster to meet the extra demand."),
    ("stay exactly the same","Active muscles need more blood, so the rate clearly rises; it does not stay the same.")]),

 ("TR","The tiny fragments in the blood that help it to clot and seal a cut are the:",
   "platelets",
   C("Platelets gather at a wound and help the blood to clot, plugging the cut so bleeding stops.")+
   steps("A cut would keep bleeding without help","Tiny fragments rush to the spot","These platelets help form a clot to seal it.")+
   U("A scab over a healing cut forms because platelets helped the blood clot at the wound."),
   [("red blood cells","Red blood cells carry oxygen; the clot-helping fragments are the platelets."),
    ("white blood cells","White blood cells fight germs; clotting is helped by the platelets."),
    ("nerve cells","Nerve cells carry messages and are not in the blood; clotting is helped by platelets.")]),

 ("TR","Single-celled animals such as Amoeba do not need a transport system because they:",
   "exchange materials directly with their surroundings",
   C("An Amoeba is so small that food, oxygen and wastes pass straight across its surface — no blood needed.")+
   steps("The whole cell touches its surroundings","Materials simply pass in and out across the surface","So no special transport system is needed.")+
   U("A tiny Amoeba in pond water gets oxygen straight through its surface, unlike a large animal with blood."),
   [("have a tiny heart of their own","An Amoeba has no heart; being tiny, it exchanges materials straight across its surface."),
    ("never need oxygen at all","An Amoeba does need oxygen; being small, it takes it in directly across its surface."),
    ("are made of xylem and phloem","Xylem and phloem are plant tissues; a single-celled Amoeba simply exchanges across its surface.")]),

 ("TR","The transport of water in a tall tree from the roots up to the topmost leaves moves mainly in which direction?",
   "upward",
   C("In the xylem, water travels upward from the roots all the way to the highest leaves.")+
   steps("Roots take in water at the bottom","Leaves at the top lose water and need more","So water moves upward through the xylem.")+
   U("A tall tree lifts water dozens of metres straight up from its roots to its highest leaves."),
   [("downward only","Water in the xylem moves UP to the leaves; it is food in the phloem that can move down."),
    ("in a circle inside one leaf","Water travels up the whole plant through the xylem, not round and round inside one leaf."),
    ("sideways out of the trunk","Water moves upward inside the xylem; it does not flow sideways out of the trunk.")]),

 ("TR","Sweating helps the human body mainly by:",
   "removing some waste and cooling the body",
   C("Sweat carries out a little salt and water waste and cools the body as it evaporates from the skin.")+
   steps("The skin releases sweat through tiny glands","Sweat carries out some salts and water","As it evaporates it also cools the body.")+
   U("On a hot day you sweat more, and the drying sweat cools your skin and removes some waste."),
   [("adding oxygen to the blood","Oxygen is taken in by the lungs, not added by sweating; sweat removes waste and cools the body."),
    ("digesting the food you eat","Digestion happens in the gut; sweating instead removes some waste and cools the body."),
    ("making the bones stronger","Bones are not strengthened by sweat; sweating removes some waste and cools the body.")]),

 ("TR","Compared with arteries, the walls of veins are generally:",
   "thinner",
   C("Veins carry blood at low pressure on its way back to the heart, so their walls are thinner than arteries'.")+
   steps("Arteries take high pressure from the heart and need thick walls","Veins carry returning blood at low pressure","So veins can have thinner walls.")+
   U("A nurse draws blood from a vein, whose thin wall is easy to reach, not from a deep thick-walled artery."),
   [("much thicker","Veins carry low-pressure blood, so their walls are THINNER than the thick-walled arteries."),
    ("made of bone","Vein walls are soft tissue, not bone; they are simply thinner than artery walls."),
    ("filled with air","Veins are filled with blood, not air; their walls are thinner than those of arteries.")]),

 ("TR","Plants need to absorb water and minerals from the soil mainly in order to:",
   "make food and stay healthy",
   C("Water joins in food-making and carries minerals the plant needs to grow and stay healthy.")+
   steps("Water is a raw material for photosynthesis","Minerals are needed for healthy growth","So the plant absorbs both from the soil.")+
   U("A plant left unwatered wilts and stops growing because it lacks the water and minerals it needs."),
   [("pump blood around","Plants have no blood to pump; they absorb water and minerals to make food and grow."),
    ("breathe out carbon dioxide","Plants take in water and minerals to grow, not to breathe out carbon dioxide."),
    ("change soil into stone","Plants cannot turn soil to stone; they absorb water and minerals to make food and grow.")]),
]

# ---------- COMPARING QUANTITIES (25) — Maths (with fusion stems) ----------
CQ = [
 ("CQ","To convert the fraction 3/4 into a percentage, we multiply it by:",
   "100",
   C("A fraction is turned into a percentage by multiplying it by 100 and adding the % sign.")+
   steps("Percent means 'out of 100'","Multiply the fraction by 100","3/4 × 100 = 75%.")+
   U("A test score of 3 right out of 4 is 75% once you multiply the fraction by 100."),
   [("10","Multiplying by 10 gives a tenth-scale value, not a percentage; you multiply by 100."),
    ("4","Multiplying by the denominator 4 just gives back 3; to get a percentage multiply by 100."),
    ("1","Multiplying by 1 leaves the fraction unchanged; a percentage needs a factor of 100.")]),

 ("CQ","25% written as a fraction in its simplest form is:",
   "1/4",
   C("25% means 25 out of 100, which simplifies to one quarter.")+
   steps("25% = 25/100","Divide top and bottom by 25","= 1/4.")+
   U("A 25%-off sale takes away one quarter of the price, the same as the fraction 1/4."),
   [("1/2","1/2 is 50%, not 25%; one quarter is 25%."),
    ("25/10","25/10 is larger than 1, but 25% is less than a whole; it equals 1/4."),
    ("1/5","1/5 is 20%, not 25%; 25% simplifies to 1/4.")]),

 ("CQ","Finding 10% of 250 gives:",
   "25",
   C("10% of a number is one tenth of it, found by dividing by 10.")+
   steps("10% means 10 out of every 100","That is one tenth of the number","250 ÷ 10 = 25.")+
   U("A 10% tip on a 250-rupee bill is 25 rupees — just shift the decimal one place."),
   [("2.5","2.5 is 1% of 250, not 10%; 10% is ten times more, namely 25."),
    ("250","250 is the whole amount (100%), not 10% of it, which is 25."),
    ("50","50 is 20% of 250, not 10%; one tenth of 250 is 25.")]),

 ("CQ","A bottle of dilute acid contains 20% acid by volume in 500 mL of liquid. The volume of pure acid in it is:",
   "100 mL",
   C("20% of the 500 mL is acid, so multiply 500 by 20/100.")+
   steps("Acid is 20% of the liquid","20% of 500 mL = 500 × 20/100","= 100 mL of acid.")+
   U("Reading a label that says '20% acid' on a 500 mL bottle tells you 100 mL of it is pure acid."),
   [("20 mL","20 mL would be only 4% of 500 mL; 20% of 500 mL is 100 mL."),
    ("200 mL","200 mL is 40% of the bottle, not 20%; 20% of 500 mL is 100 mL."),
    ("400 mL","400 mL is 80% of the bottle; the 20% acid portion is just 100 mL.")]),

 ("CQ","The ratio 2 : 5 written as a percentage is:",
   "40%",
   C("Turn the ratio into the fraction 2/5, then multiply by 100 to get a percentage.")+
   steps("2 : 5 means the fraction 2/5","2/5 × 100","= 40%.")+
   U("If 2 of every 5 children walk to school, that is 40% of them."),
   [("25%","25% is the fraction 1/4, not 2/5; 2/5 is 40%."),
    ("20%","20% is 1/5; the ratio 2 : 5 gives the larger value 40%."),
    ("50%","50% is one half; 2 out of 5 is 40%, a little less than half.")]),

 ("CQ","If 60% of a class of 40 students passed a test, the number who passed is:",
   "24",
   C("Find 60% of 40 by multiplying 40 by 60/100.")+
   steps("60% of 40 = 40 × 60/100","= 40 × 0.6","= 24 students.")+
   U("If 60% of a 40-student class pass, that is 24 children who cleared the test."),
   [("16","16 is the number who FAILED (40% of 40); the 60% who passed is 24."),
    ("60","60 is the percentage, not the count; 60% of 40 students is 24."),
    ("30","30 would be 75% of the class, not 60%; 60% of 40 is 24.")]),

 ("CQ","A shirt marked at 800 rupees is sold at a 25% discount. The discount in rupees is:",
   "200",
   C("The discount is 25% of the marked price, found by multiplying 800 by 25/100.")+
   steps("Discount = 25% of 800","= 800 × 25/100","= 200 rupees off.")+
   U("A '25% off' tag on an 800-rupee shirt saves you 200 rupees at the counter."),
   [("25","25 is the percentage, not the rupees saved; 25% of 800 is 200 rupees."),
    ("600","600 is the PRICE you pay after the discount, not the discount itself, which is 200."),
    ("775","775 would be only a 25-rupee discount; 25% of 800 is 200 rupees off.")]),

 ("CQ","A resting heart beats 70 times a minute, and during exercise it beats 105 times a minute. The ratio of resting to exercise rate, in simplest form, is:",
   "2 : 3",
   C("Write the ratio 70 : 105 and divide both numbers by their common factor 35.")+
   steps("Resting : exercise = 70 : 105","Divide both by 35","= 2 : 3.")+
   U("Comparing a calm pulse of 70 with an active 105 shows a neat 2 : 3 ratio."),
   [("3 : 2","3 : 2 reverses the order; resting (70) to exercise (105) is the smaller-first 2 : 3."),
    ("7 : 10","7 : 10 is 70 : 100, not 70 : 105; dividing 70 : 105 by 35 gives 2 : 3."),
    ("1 : 2","1 : 2 would mean the rate doubled to 140; from 70 to 105 the ratio is 2 : 3.")]),

 ("CQ","To find the Simple Interest on a sum of money, we multiply the principal, the rate per year and the:",
   "time in years, then divide by 100",
   C("Simple Interest = (Principal × Rate × Time) ÷ 100, with time measured in years.")+
   steps("Take the principal, the yearly rate and the time","Multiply all three together","Divide by 100 to get the interest.")+
   U("To work out a year's bank interest you multiply the deposit by the rate by the time, then divide by 100."),
   [("number of coins, then add 100","Interest does not depend on a count of coins; it uses principal × rate × time ÷ 100."),
    ("temperature, then subtract 100","Temperature has nothing to do with interest, which is principal × rate × time ÷ 100."),
    ("rate again, then multiply by 100","You use the rate only once; the formula is principal × rate × time ÷ 100.")]),

 ("CQ","The Simple Interest on 2000 rupees for 1 year at 5% per year is:",
   "100 rupees",
   C("Use Interest = P × R × T ÷ 100 with P = 2000, R = 5, T = 1.")+
   steps("Interest = 2000 × 5 × 1 ÷ 100","= 10000 ÷ 100","= 100 rupees.")+
   U("Putting 2000 rupees in a 5% savings account earns you 100 rupees of interest in a year."),
   [("5 rupees","5 is just the rate; the interest on 2000 rupees at 5% for a year is 100 rupees."),
    ("1000 rupees","1000 would be 50% of the sum; at 5% for one year the interest is only 100 rupees."),
    ("2100 rupees","2100 is the total amount returned (principal + interest); the interest alone is 100 rupees.")]),

 ("CQ","A solution is made by mixing 30 mL of acid with 70 mL of water. The percentage of acid in the mixture is:",
   "30%",
   C("The acid is 30 mL out of a total of 100 mL, which is 30%.")+
   steps("Total volume = 30 + 70 = 100 mL","Acid fraction = 30/100","= 30%.")+
   U("Mixing 30 mL of acid into 70 mL of water gives a handy 30%-acid solution."),
   [("70%","70% is the WATER share; the acid, 30 mL out of 100 mL, is 30%."),
    ("3%","3% would be 3 mL of acid in 100 mL; here there are 30 mL, so 30%."),
    ("100%","100% would mean pure acid with no water; this mixture is only 30% acid.")]),

 ("CQ","If the price of a notebook rises from 20 rupees to 25 rupees, the percentage increase is:",
   "25%",
   C("Find the rise, divide it by the original price, and multiply by 100.")+
   steps("Increase = 25 − 20 = 5 rupees","As a fraction of the original: 5/20","5/20 × 100 = 25%.")+
   U("A notebook going from 20 to 25 rupees has gone up by 25% — a quarter of its old price."),
   [("5%","5 is the rise in rupees, not the percentage; 5 out of 20 is a 25% increase."),
    ("20%","20% of 20 is only 4 rupees; the actual rise of 5 rupees is a 25% increase."),
    ("125%","125% is the new price compared with the old; the INCREASE is 25%.")]),

 ("CQ","A fruit seller buys mangoes for 80 rupees and sells them for 100 rupees. The profit percent is:",
   "25%",
   C("Profit percent is the profit divided by the cost price, times 100.")+
   steps("Profit = 100 − 80 = 20 rupees","Profit % = 20/80 × 100","= 25%.")+
   U("Buying at 80 and selling at 100 rupees gives the seller a 25% profit on what was spent."),
   [("20%","20 is the profit in rupees; as a percentage of the 80-rupee cost it is 25%."),
    ("100%","100% profit would mean selling at 160 (double the cost); here the profit is 25%."),
    ("80%","80 is the cost price, not the profit percent; the profit is 25%.")]),

 ("CQ","Half of all the marks in an exam is the same as a percentage of:",
   "50%",
   C("One half means 50 out of every 100, which is 50%.")+
   steps("One half = 1/2","1/2 × 100","= 50%.")+
   U("Scoring half marks on a test is exactly a 50% result."),
   [("25%","25% is one quarter, not one half; one half is 50%."),
    ("100%","100% is the whole, full marks; one half of it is 50%."),
    ("75%","75% is three quarters; exactly one half is 50%.")]),

 ("CQ","Air is about 78% nitrogen. In a sealed jar holding 50 units of air, the units that are nitrogen are about:",
   "39",
   C("Find 78% of the 50 units by multiplying 50 by 78/100.")+
   steps("Nitrogen = 78% of 50","= 50 × 78/100","= 39 units.")+
   U("Since air is roughly 78% nitrogen, most of the air in any jar — about 39 of every 50 units — is nitrogen."),
   [("78","78 is the percentage, not the count; 78% of 50 units is about 39."),
    ("22","22 would be the share that is NOT nitrogen (about 22%); the nitrogen is about 39 units."),
    ("50","50 is all the air in the jar; only about 39 of those units are nitrogen.")]),

 ("CQ","The fraction 1/5 expressed as a percentage is:",
   "20%",
   C("Multiply 1/5 by 100 to turn it into a percentage.")+
   steps("1/5 × 100","= 100/5","= 20%.")+
   U("Getting 1 out of every 5 questions right is a 20% score."),
   [("5%","5% is the fraction 1/20, not 1/5; one fifth is 20%."),
    ("15%","15% is closer to 3/20, not 1/5; one fifth is exactly 20%."),
    ("50%","50% is one half; one fifth is the smaller 20%.")]),

 ("CQ","A 40-litre tank is 75% full of water. The volume of water it holds is:",
   "30 litres",
   C("Find 75% of 40 litres by multiplying 40 by 75/100.")+
   steps("Water = 75% of 40 L","= 40 × 75/100","= 30 litres.")+
   U("A 40-litre tank read as three-quarters full holds 30 litres of water."),
   [("10 litres","10 litres is the EMPTY part (25% of 40); the 75% of water is 30 litres."),
    ("75 litres","75 litres is more than the tank can hold; 75% of 40 litres is 30 litres."),
    ("40 litres","40 litres would be a completely full tank; at 75% full it holds 30 litres.")]),

 ("CQ","In a survey, 3 out of every 4 students said they like science. As a percentage, this is:",
   "75%",
   C("3 out of 4 is the fraction 3/4, which is 75%.")+
   steps("3 out of 4 = 3/4","3/4 × 100","= 75%.")+
   U("If 3 of every 4 classmates enjoy science, that is a 75% thumbs-up for the subject."),
   [("34%","34% comes from misreading '3 out of 4' as 34; the fraction 3/4 is 75%."),
    ("43%","43% has the digits swapped; 3 out of 4 is the fraction 3/4, which is 75%."),
    ("60%","60% is the fraction 3/5, not 3/4; three quarters is 75%.")]),

 ("CQ","If 1 metre = 100 centimetres, then 40 cm written as a percentage of 1 metre is:",
   "40%",
   C("40 cm out of 100 cm is the fraction 40/100, which is 40%.")+
   steps("1 metre = 100 cm","40 cm as a fraction of 100 cm = 40/100","= 40%.")+
   U("A 40 cm ribbon is 40% of a full metre."),
   [("4%","4% would be only 4 cm in a metre; 40 cm is 40% of a metre."),
    ("60%","60% would be 60 cm; the 40 cm length is 40% of the metre."),
    ("400%","400% is four whole metres; 40 cm is well under a metre, namely 40%.")]),

 ("CQ","Two quantities are in the ratio 3 : 7 and the larger one is 35. The smaller one is:",
   "15",
   C("Each ratio part equals 35 ÷ 7 = 5, so the smaller quantity is 3 parts of 5.")+
   steps("The 7 parts equal 35, so 1 part = 5","The smaller is 3 parts","3 × 5 = 15.")+
   U("Sharing in the ratio 3 : 7 where the bigger share is 35 means the smaller share is 15."),
   [("5","5 is the value of just ONE part; the smaller quantity is 3 parts, namely 15."),
    ("21","21 is 3 × 7, which mixes the numbers up; the smaller quantity is 3 × 5 = 15."),
    ("10","10 would be 2 parts, but the smaller share is 3 parts of 5, which is 15.")]),

 ("CQ","A pure sample of a salt is found to be 90% pure in a 200 g packet. The mass of pure salt is:",
   "180 g",
   C("Find 90% of 200 g by multiplying 200 by 90/100.")+
   steps("Pure salt = 90% of 200 g","= 200 × 90/100","= 180 g.")+
   U("A 200 g packet of salt labelled '90% pure' actually holds 180 g of pure salt."),
   [("90 g","90 is the percentage, not the grams; 90% of 200 g is 180 g."),
    ("20 g","20 g would be the 10% impurity; the pure salt is 180 g."),
    ("200 g","200 g would be a perfectly pure packet; at 90% purity the pure salt is 180 g.")]),

 ("CQ","A cricketer scores 45 runs out of his team's total of 180. His contribution as a percentage of the team total is:",
   "25%",
   C("Express 45 out of 180 as a fraction and multiply by 100.")+
   steps("Contribution = 45/180","Simplify: 45/180 = 1/4","1/4 × 100 = 25%.")+
   U("Scoring 45 of a team's 180 runs means one batter made a quarter — 25% — of the total."),
   [("45%","45 is the runs scored, not the percentage; 45 out of 180 is 25%."),
    ("20%","20% of 180 is 36, not 45; 45 out of 180 is exactly 25%."),
    ("75%","75% would be 135 runs; 45 out of 180 is the smaller 25%.")]),

 ("CQ","Out of a 50-question Boss Challenge paper, a student answers 44 correctly. Their score as a percentage is:",
   "88%",
   C("Express 44 out of 50 as a fraction and convert to a percentage.")+
   steps("Score = 44/50","Multiply by 100: 44/50 × 100","= 88%.")+
   U("Getting 44 of 50 questions right on a paper is a strong 88% score."),
   [("44%","44 is the number correct, not the percentage; 44 out of 50 is 88%."),
    ("80%","80% of 50 is 40, not 44; 44 out of 50 is 88%."),
    ("94%","94% of 50 would be 47 correct; 44 correct out of 50 is 88%.")]),

 ("CQ","The marked price of a toy is 500 rupees and it is sold at 360 rupees. The discount percent is:",
   "28%",
   C("Find the discount in rupees, divide by the marked price, and multiply by 100.")+
   steps("Discount = 500 − 360 = 140 rupees","As a fraction: 140/500","140/500 × 100 = 28%.")+
   U("A toy dropping from 500 to 360 rupees has been cut by 28% of its marked price."),
   [("140%","140 is the discount in rupees, not the percent; 140 out of 500 is a 28% discount."),
    ("72%","72% is the fraction of the price you still PAY (360/500); the discount is 28%."),
    ("36%","36% comes from misreading 360 as the discount; the actual discount is 28%.")]),

 ("CQ","A dilute solution is labelled 15% salt by mass in a 200 g sample. The mass of pure salt it contains is:",
   "30 g",
   C("Find 15% of the 200 g sample by multiplying 200 by 15/100.")+
   steps("Salt = 15% of 200 g","= 200 × 15/100","= 30 g of salt.")+
   U("A 200 g brine sample labelled '15% salt' actually holds 30 g of dissolved salt."),
   [("15 g","15 is the percentage, not the grams; 15% of 200 g is 30 g."),
    ("170 g","170 g would be the water part (85%); the salt is 15% of 200 g, namely 30 g."),
    ("3 g","3 g would be 1.5% of 200 g; 15% of 200 g is 30 g.")]),
]

# ---------- ACIDS, BASES & SALTS (25) — Science ----------
AB = [
 ("AB","Substances that taste sour and turn blue litmus paper red are called:",
   "acids",
   C("Acids taste sour and change blue litmus to red.")+
   steps("Test the substance with litmus","If blue litmus goes red and it tastes sour","it is an acid.")+
   U("The sourness of a lemon comes from the acid it contains, which would turn blue litmus red."),
   [("bases","Bases taste bitter and turn RED litmus blue — the opposite of an acid."),
    ("salts","Salts are usually neutral and form when an acid and a base react; they are not the sour acids."),
    ("metals","Metals are shiny solids like iron and copper, not the sour substances that redden litmus.")]),

 ("AB","Substances that taste bitter, feel soapy and turn red litmus paper blue are called:",
   "bases",
   C("Bases taste bitter, feel slippery and turn red litmus to blue.")+
   steps("Test the substance with litmus","If red litmus goes blue and it feels soapy","it is a base.")+
   U("Soap feels slippery and is mildly basic, which is why it can turn red litmus blue."),
   [("acids","Acids taste sour and turn BLUE litmus red — the opposite of a base."),
    ("salts","Salts form when acids and bases react and are usually neutral, not bitter bases."),
    ("sugars","Sugar is sweet and neutral; the bitter, soapy substances that blue red litmus are bases.")]),

 ("AB","The special paper or dye used to tell whether a substance is acidic or basic is called a/an:",
   "indicator",
   C("An indicator changes colour to show whether something is an acid or a base.")+
   steps("Acids and bases differ in nature","A substance that changes colour with them is needed","Such a colour-changing tester is an indicator.")+
   U("Dip litmus, an indicator, into a liquid and its colour tells you at once if the liquid is acidic or basic."),
   [("thermometer","A thermometer measures temperature, not whether a substance is acidic or basic."),
    ("magnet","A magnet attracts iron; it cannot tell an acid from a base — an indicator does that."),
    ("filter","A filter separates solids from liquids; it does not show acidity — an indicator does.")]),

 ("AB","Litmus, the common indicator, is obtained from a plant-like organism called a:",
   "lichen",
   C("Litmus is a natural dye extracted from lichens.")+
   steps("Litmus is a natural colouring","It comes from a living source","That source is the lichen.")+
   U("The familiar blue and red litmus papers in the lab are made from a dye taken from lichens."),
   [("rose","Rose petals give other natural indicators, but the litmus dye comes from lichens."),
    ("mango","Mango is a fruit, not the source of litmus; litmus is taken from lichens."),
    ("mushroom","A mushroom is a fungus, but the litmus dye specifically comes from lichens.")]),

 ("AB","Turmeric, used as a natural indicator, turns which colour when added to a base?",
   "red",
   C("Yellow turmeric turns red in a base, which is how it acts as an indicator.")+
   steps("Turmeric is normally yellow","Add it to a basic substance","and it turns red.")+
   U("A yellow turmeric stain on cloth turning red when soap is rubbed on shows the soap is basic."),
   [("blue","Turmeric does not turn blue; in a base the yellow turmeric turns red."),
    ("green","Turmeric stays roughly yellow in acids and turns red in bases, not green."),
    ("black","Turmeric does not blacken with a base; it turns red.")]),

 ("AB","When an acid and a base are mixed in the right amounts, they cancel each other to form a salt and water. This reaction is called:",
   "neutralisation",
   C("Neutralisation is the reaction in which an acid and a base react to give a salt and water.")+
   steps("An acid and a base have opposite natures","Mixed together they cancel each other","forming a salt and water — neutralisation.")+
   U("Taking a mild antacid neutralises excess stomach acid, easing the burning feeling."),
   [("condensation","Condensation is vapour turning to liquid; an acid and base reacting is neutralisation."),
    ("evaporation","Evaporation is a liquid turning to vapour, not an acid and base cancelling out."),
    ("respiration","Respiration releases energy from food; the acid-base reaction is neutralisation.")]),

 ("AB","The sour taste of curd and lemon juice is due to the presence of:",
   "acids",
   C("Curd and lemon juice are sour because they contain acids.")+
   steps("Sour taste is the clue","Sourness comes from acids","so these foods contain acids.")+
   U("Lemon juice tastes sharp and sour because of the citric acid it contains."),
   [("bases","Bases taste bitter, not sour; the sour taste of lemon and curd comes from acids."),
    ("salts","Most salts are not sour; the sourness of lemon and curd is due to acids."),
    ("oils","Oils are greasy and not sour; the sour taste comes from the acids present.")]),

 ("AB","The acid present in the stomach that helps digest food is:",
   "hydrochloric acid",
   C("The stomach makes hydrochloric acid, which helps break down food and kills germs.")+
   steps("The stomach needs an acid to digest food","That acid also kills swallowed germs","It is hydrochloric acid.")+
   U("A burning feeling of 'acidity' comes from too much hydrochloric acid in the stomach."),
   [("citric acid","Citric acid is found in lemons, not made by the stomach; the stomach makes hydrochloric acid."),
    ("acetic acid","Acetic acid is the acid in vinegar; the stomach's digestive acid is hydrochloric acid."),
    ("carbonic acid","Carbonic acid is in fizzy drinks; the acid in the stomach is hydrochloric acid.")]),

 ("AB","A common base used in the laboratory, also found in window-cleaning liquids, is:",
   "sodium hydroxide",
   C("Sodium hydroxide is a strong, common laboratory base.")+
   steps("Bases include hydroxides of metals","A very common laboratory one","is sodium hydroxide.")+
   U("Sodium hydroxide, a strong base, is handled with care in the lab because it is caustic."),
   [("hydrochloric acid","Hydrochloric acid is an ACID, not a base; a common base is sodium hydroxide."),
    ("citric acid","Citric acid is the acid in citrus fruits, not a base; sodium hydroxide is the base."),
    ("vinegar","Vinegar is an acidic liquid; the common base named here is sodium hydroxide.")]),

 ("AB","When an acid reacts completely with a base, the products are always a salt and:",
   "water",
   C("Neutralisation of an acid by a base always produces a salt and water.")+
   steps("Acid + base react and cancel out","They form a salt","and water as the second product.")+
   U("Mixing the right amounts of an acid and a base leaves behind only a salt dissolved in water."),
   [("oxygen","Neutralisation gives a salt and water, not oxygen gas."),
    ("an acid","The acid is used UP in neutralisation; the products are a salt and water, not more acid."),
    ("a metal","No metal is produced; an acid neutralising a base gives a salt and water.")]),

 ("AB","An ant sting causes burning because the ant injects an acid. Rubbing a mild base such as baking soda on it helps because the base:",
   "neutralises the acid",
   C("The mild base reacts with the ant's acid and cancels it, easing the sting.")+
   steps("The sting injects an acid that burns","A mild base is rubbed on","It neutralises the acid, relieving the sting.")+
   U("Dabbing baking soda paste on an ant or bee sting calms the burning by neutralising the acid."),
   [("adds more acid to the skin","Adding more acid would worsen the sting; a base instead neutralises the acid."),
    ("makes the skin colder","The relief comes from neutralising the acid chemically, not from cooling the skin."),
    ("washes germs away","The base eases the sting by neutralising the injected acid, not by washing off germs.")]),

 ("AB","Bee stings are acidic, while wasp stings are basic. A wasp sting is best soothed by rubbing on a mild:",
   "acid such as vinegar",
   C("A wasp sting is basic, so a mild acid like vinegar neutralises it.")+
   steps("A wasp sting is basic in nature","A mild acid will cancel a base","so vinegar (an acid) soothes a wasp sting.")+
   U("Vinegar dabbed on a wasp sting eases it because the acid neutralises the sting's basic nature."),
   [("base such as baking soda","Baking soda (a base) suits an ACIDIC bee sting; a basic wasp sting needs a mild acid."),
    ("salt water only","Plain salt water is roughly neutral; a basic wasp sting is better soothed by a mild acid."),
    ("more wasp venom","Adding venom would worsen it; a mild acid like vinegar neutralises the basic sting.")]),

 ("AB","A substance that is neither acidic nor basic, like pure water, is described as:",
   "neutral",
   C("A neutral substance is neither acid nor base and does not change litmus colour.")+
   steps("It does not redden blue litmus","It does not blue red litmus","so it is neutral, like pure water.")+
   U("Pure water is neutral, which is why neither blue nor red litmus changes colour in it."),
   [("strongly acidic","A strongly acidic substance would redden blue litmus; pure water leaves litmus unchanged — it is neutral."),
    ("strongly basic","A strongly basic substance would blue red litmus; pure water is neutral, changing neither."),
    ("sour","Sourness means an acid; pure water is tasteless and neutral, neither acid nor base.")]),

 ("AB","Soil that is too acidic for crops can be treated by the farmer by adding:",
   "lime (a base) to the soil",
   C("Adding lime, a base, neutralises the excess acid and makes the soil suitable for crops.")+
   steps("Acidic soil harms many crops","A base will neutralise the acid","Farmers add lime, a base, to fix it.")+
   U("Farmers spread lime over too-acidic fields so the soil's acid is neutralised and crops grow better."),
   [("more acid to the soil","Adding acid would make the soil even more acidic; a base such as lime is needed."),
    ("plenty of sugar","Sugar does not change soil acidity; the cure for acidic soil is a base like lime."),
    ("common salt","Common salt does not neutralise the soil's acid; lime, a base, does the job.")]),

 ("AB","Litmus paper is described as a natural indicator. When dipped in lemon juice, blue litmus will turn:",
   "red",
   C("Lemon juice is acidic, and acids turn blue litmus red.")+
   steps("Lemon juice contains acid","Acids turn blue litmus red","so the blue paper goes red.")+
   U("Dipping blue litmus into lemon juice and seeing it turn red proves the juice is acidic."),
   [("green","Litmus does not turn green; an acid turns blue litmus red."),
    ("stay blue","Blue litmus stays blue only in neutral or basic liquids; in acidic lemon juice it turns red."),
    ("black","Litmus does not blacken in lemon juice; the acid turns blue litmus red.")]),

 ("AB","When a base turns red litmus blue and an acid turns blue litmus red, but the substance changes NEITHER colour, the substance is:",
   "neutral",
   C("If a substance leaves both red and blue litmus unchanged, it is neither acid nor base — it is neutral.")+
   steps("An acid would redden blue litmus","A base would blue red litmus","Changing neither means the substance is neutral.")+
   U("Common salt solution leaves both litmus colours unchanged, showing it is neutral."),
   [("a strong acid","A strong acid would redden the blue litmus; leaving both unchanged means it is neutral."),
    ("a strong base","A strong base would blue the red litmus; changing neither means it is neutral."),
    ("a mixture of both at once","Changing neither colour simply means the substance is neutral, not a mix of strong acid and base.")]),

 ("AB","The white substance left behind when an acid and a base react and the water is then dried off is the:",
   "salt",
   C("Neutralisation gives a salt and water; drying off the water leaves the solid salt behind.")+
   steps("Acid + base give a salt dissolved in water","Drying off the water","leaves the solid salt.")+
   U("Common table salt can be made by neutralising an acid with a base and then drying off the water."),
   [("acid","The acid is used up during neutralisation; what remains after drying is the salt."),
    ("base","The base is used up too; the dried solid left behind is the salt."),
    ("indicator","An indicator only shows colour change; the dried solid product of neutralisation is the salt.")]),

 ("AB","An antacid tablet relieves stomach acidity because it contains a mild:",
   "base",
   C("Antacids contain a mild base that neutralises the excess acid in the stomach.")+
   steps("Acidity is caused by too much stomach acid","A mild base can neutralise it","so antacids contain a mild base.")+
   U("Swallowing a chalky antacid eases a burning stomach by neutralising the extra acid with a mild base."),
   [("acid","Adding more acid would worsen acidity; an antacid works by adding a mild BASE."),
    ("salt only","Plain salt would not neutralise the acid; an antacid contains a mild base."),
    ("sugar","Sugar does not neutralise stomach acid; the active part of an antacid is a mild base.")]),

 ("AB","Vinegar, used in the kitchen, is a dilute form of:",
   "acetic acid",
   C("Vinegar is a dilute solution of acetic acid, which gives it its sour taste and sharp smell.")+
   steps("Vinegar is sour and sharp-smelling","Its sourness comes from an acid","that acid is acetic acid.")+
   U("The sour tang of vinegar on chips comes from the acetic acid it contains."),
   [("sodium hydroxide","Sodium hydroxide is a strong base; vinegar is sour because it is dilute acetic acid."),
    ("hydrochloric acid","Hydrochloric acid is found in the stomach; kitchen vinegar is dilute acetic acid."),
    ("lime water","Lime water is basic; vinegar is acidic, being dilute acetic acid.")]),

 ("AB","Citrus fruits such as oranges and lemons are sour because they contain:",
   "citric acid",
   C("Citrus fruits owe their sour taste to citric acid.")+
   steps("Oranges and lemons taste sour","Sourness means an acid","and the acid in citrus fruit is citric acid.")+
   U("Squeezing a fresh orange gives a sour juice rich in citric acid."),
   [("hydrochloric acid","Hydrochloric acid is the stomach's acid, not the one in fruit; citrus fruits have citric acid."),
    ("a base","A base would taste bitter, not sour; citrus fruits are sour because of citric acid."),
    ("acetic acid","Acetic acid is in vinegar; the sour acid in oranges and lemons is citric acid.")]),

 ("AB","Lime water is a well-known example of a:",
   "base",
   C("Lime water is a base; it turns red litmus blue and is used to test for carbon dioxide.")+
   steps("Lime water turns red litmus blue","Turning red litmus blue marks a base","so lime water is a base.")+
   U("Bubbling your breath through lime water turns it milky, a classic test that uses this base."),
   [("strong acid","A strong acid would redden blue litmus; lime water is a base, turning red litmus blue."),
    ("neutral liquid","Lime water is not neutral; it is basic, turning red litmus blue."),
    ("salt solution","Lime water behaves as a base, not just a neutral salt solution.")]),

 ("AB","If too much acid and too much base are exactly balanced in a neutralisation, the final mixture is:",
   "neutral",
   C("When acid and base are balanced exactly, they cancel out and leave a neutral mixture.")+
   steps("Equal strengths of acid and base react","They neutralise each other fully","leaving a neutral mixture.")+
   U("A perfectly balanced neutralisation leaves a solution that no longer affects litmus — it is neutral."),
   [("still strongly acidic","Exact balancing cancels the acid; the result is neutral, not strongly acidic."),
    ("still strongly basic","Exact balancing cancels the base too; the result is neutral, not strongly basic."),
    ("explosive","A balanced neutralisation simply gives a neutral salt solution, not an explosion.")]),

 ("AB","When testing many household items, baking soda solution would turn red litmus:",
   "blue",
   C("Baking soda is a mild base, and bases turn red litmus blue.")+
   steps("Baking soda is mildly basic","Bases turn red litmus blue","so the red paper goes blue.")+
   U("Dipping red litmus in baking soda solution and seeing it turn blue shows the soda is basic."),
   [("red, with no change","Red litmus stays red only in acids or neutral liquids; in basic baking soda it turns blue."),
    ("colourless","Litmus does not lose its colour; in a base the red litmus turns blue."),
    ("yellow","Litmus does not turn yellow; baking soda, being basic, turns red litmus blue.")]),

 ("AB","The main reason we should NOT taste laboratory acids and bases to identify them is that they:",
   "can be corrosive and harmful",
   C("Many lab acids and bases are corrosive and can burn the mouth, so we use indicators instead.")+
   steps("Strong acids and bases attack living tissue","Tasting them could burn the mouth","so we identify them safely with indicators.")+
   U("In the lab you never taste chemicals; a strip of litmus safely tells you if it is acid or base."),
   [("taste too sweet","The danger is not sweetness; lab acids and bases can be corrosive and harmful."),
    ("are always neutral","They are not neutral; many are strong and corrosive, which is exactly why we never taste them."),
    ("would turn into water","Tasting does not turn them to water; they are simply too corrosive and harmful to taste.")]),

 ("AB","When carbon dioxide gas is bubbled through clear lime water, the lime water turns:",
   "milky white",
   C("Carbon dioxide reacts with lime water to form a white substance, turning it milky.")+
   steps("Lime water is a clear basic liquid","Carbon dioxide bubbled through it reacts","forming a white solid that makes it milky.")+
   U("Breathing out through a straw into lime water turns it milky, proving your breath has carbon dioxide."),
   [("bright red","Lime water does not turn red with carbon dioxide; it turns milky white."),
    ("deep blue","Carbon dioxide turns lime water milky white, not blue."),
    ("colourless and clear","Lime water starts clear; carbon dioxide makes it milky, so it does not stay clear.")]),
]

# ---------- PERIMETER & AREA (25) — Maths (with fusion stems) ----------
PA = [
 ("PA","The perimeter of a rectangle is found using the formula:",
   "2 × (length + breadth)",
   C("Perimeter is the total distance round a shape; for a rectangle it is twice the sum of length and breadth.")+
   steps("A rectangle has two lengths and two breadths","Add one length and one breadth, then double","Perimeter = 2 × (length + breadth).")+
   U("To fence a rectangular garden you need 2 × (length + breadth) metres of fencing."),
   [("length × breadth","Length × breadth gives the AREA, not the perimeter; perimeter is 2 × (length + breadth)."),
    ("length + breadth","Length + breadth is only half the way round; the full perimeter doubles it."),
    ("4 × length","4 × length fits a SQUARE, not a rectangle; a rectangle's perimeter is 2 × (length + breadth).")]),

 ("PA","The area of a rectangle is found using the formula:",
   "length × breadth",
   C("Area measures the surface covered; for a rectangle it is length multiplied by breadth.")+
   steps("Area counts the unit squares inside","For a rectangle these fill rows and columns","Area = length × breadth.")+
   U("To find how much carpet covers a rectangular room you multiply its length by its breadth."),
   [("2 × (length + breadth)","That formula gives the PERIMETER, the distance round; the area is length × breadth."),
    ("length + breadth","Adding length and breadth gives a distance, not an area; area is length × breadth."),
    ("4 × side","4 × side is the perimeter of a square, not the area of a rectangle.")]),

 ("PA","A rectangular field of crops is 30 m long and 20 m wide. Its area is:",
   "600 square metres",
   C("Multiply length by breadth to get the area of the rectangular field.")+
   steps("Area = length × breadth","= 30 m × 20 m","= 600 square metres.")+
   U("A 30 m by 20 m plot covers 600 square metres of ground for growing crops."),
   [("100 square metres","100 is roughly the half-perimeter, not the area; area is 30 × 20 = 600 square metres."),
    ("50 square metres","50 is just length plus breadth, a distance; the area is 30 × 20 = 600 square metres."),
    ("600 metres","Area is measured in SQUARE metres, not metres; the field's area is 600 square metres.")]),

 ("PA","The perimeter of a square of side 7 cm is:",
   "28 cm",
   C("A square has four equal sides, so its perimeter is 4 times the side.")+
   steps("Perimeter of a square = 4 × side","= 4 × 7 cm","= 28 cm.")+
   U("To border a square photo of side 7 cm you need 28 cm of tape all round."),
   [("14 cm","14 cm is only 2 × 7, two sides; a square has four sides, giving 28 cm."),
    ("49 cm","49 is 7 × 7, the AREA in square cm, not the perimeter, which is 28 cm."),
    ("7 cm","7 cm is just one side; the whole way round the square is 28 cm.")]),

 ("PA","A square tile measures 6 cm along each side. The surface area of one such tile is:",
   "36 square cm",
   C("The area of a square is the side multiplied by itself.")+
   steps("Area of a square = side × side","= 6 cm × 6 cm","= 36 square cm.")+
   U("A square tile of side 6 cm covers 36 square cm of floor."),
   [("24 square cm","24 is 4 × 6, the PERIMETER in cm, not the area; the area is 6 × 6 = 36 square cm."),
    ("12 square cm","12 is just 6 + 6, a distance; the area is 6 × 6 = 36 square cm."),
    ("36 cm","Area is in SQUARE cm, not cm; the square's area is 36 square cm.")]),

 ("PA","The area of a triangle is found using the formula:",
   "1/2 × base × height",
   C("A triangle's area is half the product of its base and its height.")+
   steps("A triangle is half of a rectangle on the same base and height","Take base × height","then halve it: 1/2 × base × height.")+
   U("To find the area of a triangular flag you take half of its base times its height."),
   [("base × height","Base × height gives the whole rectangle; a triangle is HALF of that."),
    ("base + height","Adding base and height gives a length, not an area; area is 1/2 × base × height."),
    ("2 × base × height","That is twice too big; a triangle's area is 1/2 × base × height.")]),

 ("PA","A triangle has a base of 10 cm and a height of 6 cm. Its area is:",
   "30 square cm",
   C("Use area = 1/2 × base × height for the triangle.")+
   steps("Area = 1/2 × base × height","= 1/2 × 10 × 6","= 30 square cm.")+
   U("A triangular piece of card with a 10 cm base and 6 cm height covers 30 square cm."),
   [("60 square cm","60 is base × height; a triangle is HALF of that, namely 30 square cm."),
    ("16 square cm","16 is just base plus height, a distance; the area is 1/2 × 10 × 6 = 30 square cm."),
    ("30 cm","Area is in SQUARE cm, not cm; the triangle's area is 30 square cm.")]),

 ("PA","A leaf is roughly rectangular, 8 cm long and 3 cm wide. The surface area through which it can transpire on one side is about:",
   "24 square cm",
   C("Treat the leaf as a rectangle and multiply length by breadth.")+
   steps("Area = length × breadth","= 8 cm × 3 cm","= 24 square cm.")+
   U("A bigger leaf surface, like this 24 square cm leaf, can transpire more water than a tiny one."),
   [("11 square cm","11 is length plus breadth, a distance; the area is 8 × 3 = 24 square cm."),
    ("22 square cm","22 is the PERIMETER, 2 × (8 + 3); the transpiring area is 8 × 3 = 24 square cm."),
    ("24 cm","Area is in SQUARE cm, not cm; the leaf's surface area is 24 square cm.")]),

 ("PA","The distance all the way around the edge of any flat shape is called its:",
   "perimeter",
   C("Perimeter is the total length of the boundary of a flat shape.")+
   steps("Walk right round the edge of a shape","Add up the lengths of all its sides","That total distance is the perimeter.")+
   U("Walking once round the boundary of a park measures its perimeter."),
   [("area","Area is the surface a shape covers inside; the distance round the edge is the perimeter."),
    ("volume","Volume is the space a solid takes up; a flat shape's boundary length is its perimeter."),
    ("diameter","Diameter is a line across a circle; the distance round any flat shape is its perimeter.")]),

 ("PA","The amount of surface that a flat shape covers is called its:",
   "area",
   C("Area measures how much flat surface a shape covers, counted in square units.")+
   steps("A shape covers part of a surface","We measure that covered surface in square units","This measure is the area.")+
   U("The area of a wall tells the painter how much paint is needed to cover it."),
   [("perimeter","Perimeter is the distance round the edge; the surface covered inside is the area."),
    ("height","Height is one measurement up a shape; the surface it covers is its area."),
    ("mass","Mass is how much matter a thing has; the flat surface a shape covers is its area.")]),

 ("PA","A square plot of land has a side of 25 m. The length of fencing needed to go right around it is:",
   "100 m",
   C("The fencing equals the perimeter of the square, which is 4 times the side.")+
   steps("Perimeter of a square = 4 × side","= 4 × 25 m","= 100 m of fencing.")+
   U("To fence a square 25 m field on all sides you need 100 m of wire."),
   [("50 m","50 m is only 2 sides; all four sides of a 25 m square total 100 m."),
    ("625 m","625 is 25 × 25, the AREA in square metres, not the fencing length, which is 100 m."),
    ("25 m","25 m is just one side; the fence goes round all four, totalling 100 m.")]),

 ("PA","One square metre is equal to how many square centimetres?",
   "10000",
   C("Since 1 m = 100 cm, a square metre is 100 × 100 = 10000 square cm.")+
   steps("1 m = 100 cm","Area: 1 m × 1 m = 100 cm × 100 cm","= 10000 square cm.")+
   U("A floor area given in square metres becomes a much bigger number — 10000 times — in square cm."),
   [("100","100 is how many centimetres are in a metre (length), not square cm in a square metre, which is 10000."),
    ("1000","1000 mixes up the powers; 100 × 100 gives 10000 square cm in a square metre."),
    ("1000000","1000000 square cm is a square metre confused with bigger units; the correct value is 10000.")]),

 ("PA","A rectangular sheet is 12 cm long and 5 cm wide. Its perimeter is:",
   "34 cm",
   C("Perimeter = 2 × (length + breadth) for the rectangle.")+
   steps("Perimeter = 2 × (12 + 5)","= 2 × 17","= 34 cm.")+
   U("Putting a border tape round a 12 cm by 5 cm sheet needs 34 cm of tape."),
   [("60 cm","60 is 12 × 5, the AREA in square cm, not the perimeter, which is 34 cm."),
    ("17 cm","17 is just length plus breadth (half way round); the full perimeter is 34 cm."),
    ("24 cm","24 would be 2 × 12 alone; the perimeter uses both sides: 2 × (12 + 5) = 34 cm.")]),

 ("PA","If the side of a square is doubled, its perimeter becomes:",
   "twice as large",
   C("Perimeter is 4 × side, so doubling the side doubles the perimeter.")+
   steps("Perimeter = 4 × side","Double the side, and 4 × (2 × side) = 2 × (4 × side)","so the perimeter doubles.")+
   U("A square photo frame with sides twice as long needs twice as much border, but four times the glass."),
   [("four times as large","The AREA grows four times when the side doubles; the perimeter only doubles."),
    ("the same as before","Doubling the side clearly changes the perimeter — it becomes twice as large."),
    ("half as large","A bigger side gives a bigger perimeter; doubling the side doubles, not halves, it.")]),

 ("PA","If the side of a square is doubled, its area becomes:",
   "four times as large",
   C("Area is side × side, so doubling the side multiplies the area by 2 × 2 = 4.")+
   steps("Area = side × side","Double the side: (2 × side) × (2 × side)","= 4 × (side × side), four times the area.")+
   U("A square tile with sides twice as long covers four times as much floor."),
   [("twice as large","The PERIMETER only doubles; the area grows four times when the side doubles."),
    ("the same as before","Doubling the side changes the area greatly — it becomes four times as large."),
    ("eight times as large","Eight times would suit a doubled cube's volume; a square's area grows four times.")]),

 ("PA","The area of a rectangle is 48 square cm and its length is 8 cm. Its breadth is:",
   "6 cm",
   C("Breadth = area ÷ length, since area is length × breadth.")+
   steps("Area = length × breadth, so breadth = area ÷ length","= 48 ÷ 8","= 6 cm.")+
   U("Knowing a rectangle's area and one side lets you work back to the other side — here 6 cm."),
   [("40 cm","40 is 48 − 8, a wrong subtraction; breadth is found by 48 ÷ 8 = 6 cm."),
    ("384 cm","384 is 48 × 8, far too big; breadth is area ÷ length = 48 ÷ 8 = 6 cm."),
    ("8 cm","8 cm is the given length; the breadth works out to 48 ÷ 8 = 6 cm.")]),

 ("PA","A square field has an area of 81 square metres. The length of each side is:",
   "9 m",
   C("The side of a square is the number which multiplied by itself gives the area.")+
   steps("Area = side × side = 81","Find the number whose square is 81","9 × 9 = 81, so the side is 9 m.")+
   U("A square plot of 81 square metres measures 9 m along each side."),
   [("40.5 m","40.5 is half of 81, not its square root; the side whose square is 81 is 9 m."),
    ("18 m","18 is 2 × 9; the side of an 81 square metre square is 9 m, not 18 m."),
    ("81 m","81 is the area, not the side; the side is the square root of 81, which is 9 m.")]),

 ("PA","The perimeter of a rectangular sheet of paper used for an experiment is 26 cm and its length is 8 cm. Its breadth is:",
   "5 cm",
   C("Half the perimeter is length + breadth, so subtract the length from it.")+
   steps("Half perimeter = 26 ÷ 2 = 13 cm = length + breadth","Breadth = 13 − 8","= 5 cm.")+
   U("Knowing the perimeter and length of a sheet lets you find the missing breadth — here 5 cm."),
   [("18 cm","18 is 26 − 8, but you must first halve the perimeter; the breadth is 13 − 8 = 5 cm."),
    ("13 cm","13 is length + breadth together; subtracting the 8 cm length leaves a breadth of 5 cm."),
    ("3 cm","3 cm comes from a wrong subtraction; half the perimeter (13) minus 8 gives 5 cm.")]),

 ("PA","A wire of length 24 cm is bent into a square. The length of each side of the square is:",
   "6 cm",
   C("The wire forms the perimeter, so divide its length by the 4 equal sides.")+
   steps("Perimeter of the square = 24 cm","A square has 4 equal sides","Each side = 24 ÷ 4 = 6 cm.")+
   U("Bending a 24 cm wire into a square gives four equal sides of 6 cm each."),
   [("12 cm","12 is 24 ÷ 2, which would give only two sides; a square's side is 24 ÷ 4 = 6 cm."),
    ("24 cm","24 cm is the whole wire (the perimeter); each of the four sides is 24 ÷ 4 = 6 cm."),
    ("8 cm","8 cm would suit a triangle (24 ÷ 3); a square's side is 24 ÷ 4 = 6 cm.")]),

 ("PA","Two rectangular plots have the same area, but the first is long and narrow while the second is nearly square. Their perimeters are:",
   "not necessarily equal",
   C("Equal areas can have very different perimeters depending on the shape of the rectangle.")+
   steps("Area fixes length × breadth, not the shape","A long thin rectangle has a bigger perimeter","so equal areas need not give equal perimeters.")+
   U("A long thin plot needs more fencing than a nearly-square plot of the very same area."),
   [("always exactly equal","Equal area does NOT force equal perimeter; a long thin plot has a larger perimeter."),
    ("always zero","A real plot has a real boundary, so its perimeter is never zero."),
    ("always four times the area","Perimeter and area are different measures; one is not simply four times the other.")]),

 ("PA","A path of width 1 m runs around the inside edge of a square room of side 10 m. The OUTER side of the square room is:",
   "10 m",
   C("The room's outer side is given as 10 m; the path lies inside that boundary.")+
   steps("The square room measures 10 m on each side","The path runs along the inside","so the outer side stays 10 m.")+
   U("When a border is drawn inside a square room, the room's own outer side is unchanged at 10 m."),
   [("8 m","8 m would be the inner square left after a 1 m path on both sides; the outer side is still 10 m."),
    ("12 m","12 m would add the path outside; here the path is INSIDE, so the outer side stays 10 m."),
    ("1 m","1 m is the width of the path, not the side of the room, which is 10 m.")]),

 ("PA","A rectangular garden is 15 m long and 10 m wide. The cost of fencing it at 5 rupees per metre is:",
   "250 rupees",
   C("First find the perimeter, then multiply by the cost per metre.")+
   steps("Perimeter = 2 × (15 + 10) = 50 m","Cost = 50 m × 5 rupees","= 250 rupees.")+
   U("Fencing a 15 m by 10 m garden at 5 rupees a metre costs 250 rupees in all."),
   [("750 rupees","750 would use the AREA (150) × 5; fencing uses the perimeter (50 m), giving 250 rupees."),
    ("50 rupees","50 m is the perimeter in metres, not the cost; at 5 rupees a metre it costs 250 rupees."),
    ("125 rupees","125 would be half the perimeter × 5; the full 50 m at 5 rupees is 250 rupees.")]),

 ("PA","The area covered by 4 square tiles, each of side 10 cm, laid together is:",
   "400 square cm",
   C("Each tile covers side × side; multiply one tile's area by the number of tiles.")+
   steps("One tile = 10 × 10 = 100 square cm","Four tiles = 4 × 100","= 400 square cm.")+
   U("Four 10 cm tiles laid together cover 400 square cm of floor."),
   [("40 square cm","40 is 4 × 10, a length; the four tiles cover 4 × 100 = 400 square cm."),
    ("100 square cm","100 square cm is just ONE tile; four of them cover 400 square cm."),
    ("160 square cm","160 mixes up perimeter (4 × 40); four 10 cm tiles cover 400 square cm.")]),

 ("PA","A rope long enough to go exactly once around a square garden of side 12 m would have a length of:",
   "48 m",
   C("The rope length equals the perimeter, which is 4 times the side for a square.")+
   steps("Perimeter = 4 × side","= 4 × 12 m","= 48 m of rope.")+
   U("A rope laid right round a 12 m square garden measures 48 m."),
   [("24 m","24 m is only two sides; right around the square is 4 × 12 = 48 m."),
    ("144 m","144 is 12 × 12, the AREA in square metres, not the rope length, which is 48 m."),
    ("12 m","12 m is one side; the rope must wrap all four sides, totalling 48 m.")]),

 ("PA","A rectangular vegetable bed is 9 m long and 4 m wide. The area available for planting is:",
   "36 square metres",
   C("Multiply length by breadth to find the planting area of the rectangular bed.")+
   steps("Area = length × breadth","= 9 m × 4 m","= 36 square metres.")+
   U("A 9 m by 4 m vegetable bed gives 36 square metres of ground for sowing seeds."),
   [("13 square metres","13 is length plus breadth, a distance; the area is 9 × 4 = 36 square metres."),
    ("26 square metres","26 is the PERIMETER, 2 × (9 + 4); the planting area is 9 × 4 = 36 square metres."),
    ("36 metres","Area is in SQUARE metres, not metres; the bed's area is 36 square metres.")]),
]

items = []
for i in range(25):
    items += [TR[i], CQ[i], AB[i], PA[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=22613,
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
    split = "/".join(str(counts[c]) for c in ("TR", "CQ", "AB", "PA"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Transportation in Animals & Plants",
                     "Acids, Bases & Salts",
                     "Comparing Quantities",
                     "Perimeter & Area"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
