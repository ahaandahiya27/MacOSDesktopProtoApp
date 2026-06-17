# -*- coding: utf-8 -*-
# Boss Challenge Paper 24 — Nutrition in Animals · Physical & Chemical Changes · Fractions & Decimals · Comparing Quantities
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans hard into FUSION — many Fractions & Decimals items are wrapped
# in a real Nutrition / digestion situation (a cow chewing cud, a fraction of a meal absorbed,
# decimal litres of saliva), and many Comparing-Quantities items are wrapped in a Physical &
# Chemical-Changes situation (the percentage mass gained when iron rusts, the ratio of zinc to
# iron in galvanising, the profit on selling crystallised salt). The child reads a Science
# context and applies a Maths skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_24_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_24_<SHORT>_QuestionPaper.pdf
#   Paper_24_<SHORT>_Questions.md
#   Paper_24_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "24"
SHORT = "NutritionAnimals_PhysChem_Fractions_Comparing"
TITLE = ("Nutrition in Animals · Physical & Chemical Changes · Fractions & Decimals · Comparing Quantities")
LABELS = {
    "NA": "Nutrition in Animals",
    "PC": "Physical & Chemical Changes",
    "FD": "Fractions & Decimals",
    "CQ": "Comparing Quantities",
}

# ---------- NUTRITION IN ANIMALS (25) — Science ----------
NA = [
 ("NA","The mode of nutrition in which an animal takes in solid or liquid food and breaks it down inside the body is called:",
   "holozoic nutrition",
   C("Holozoic nutrition is taking in whole food and digesting it inside the body, as animals do.")+
   steps("The animal eats solid or liquid food","The food is broken down inside the body","this whole-food feeding is holozoic nutrition.")+
   U("A dog eating and then digesting its meal is carrying out holozoic nutrition."),
   [("autotrophic nutrition","Autotrophs make their own food, like green plants; animals taking in food feed holozoically."),
    ("parasitic nutrition","A parasite feeds on a living host; an animal eating and digesting whole food is holozoic."),
    ("saprotrophic nutrition","Saprotrophs feed on dead, decaying matter outside the body; whole-food feeding is holozoic.")]),

 ("NA","Breaking food into smaller pieces by chewing, and then into simple substances the body can use, is called:",
   "digestion",
   C("Digestion is the breakdown of food into simple substances the body can absorb.")+
   steps("Large food cannot be used as it is","The body breaks it into simple soluble pieces","that breakdown is digestion.")+
   U("After a meal your body digests the food, turning bread into simple sugars it can absorb."),
   [("ingestion","Ingestion is just taking food IN through the mouth; breaking it down is digestion."),
    ("egestion","Egestion is removing undigested waste; breaking food into simple parts is digestion."),
    ("absorption","Absorption is soaking the digested food into the blood; the breakdown step is digestion.")]),

 ("NA","The sharp front teeth used for cutting and biting food are called:",
   "incisors",
   C("Incisors are the flat, sharp front teeth used to cut and bite food.")+
   steps("Look at the teeth right at the front","They are chisel-shaped for cutting","these are the incisors.")+
   U("You use your front incisors to take a clean bite out of an apple."),
   [("molars","Molars are the broad back teeth for grinding; the cutting front teeth are incisors."),
    ("canines","Canines are the pointed teeth for tearing; the flat cutting front teeth are incisors."),
    ("premolars","Premolars sit between canines and molars for grinding; the front cutting teeth are incisors.")]),

 ("NA","The broad, flat back teeth that grind and chew food into a paste are called:",
   "molars",
   C("Molars are the large flat back teeth used to grind and chew food.")+
   steps("Feel the teeth at the very back","They are wide and flat for grinding","these are the molars.")+
   U("You crush a hard nut by grinding it between your back molars."),
   [("incisors","Incisors are the sharp front cutting teeth; the broad grinding back teeth are molars."),
    ("canines","Canines are pointed tearing teeth; the flat grinding back teeth are molars."),
    ("milk teeth","'Milk teeth' is the first set of a child's teeth, not a grinding type; the grinders are molars.")]),

 ("NA","The watery liquid released into the mouth that begins the digestion of starchy food is:",
   "saliva",
   C("Saliva, made by salivary glands, moistens food and starts breaking down starch in the mouth.")+
   steps("Glands in the mouth release a watery liquid","It mixes with the chewed food","this saliva starts digesting starch.")+
   U("Chew a piece of bread for a while and it turns slightly sweet as saliva acts on its starch."),
   [("bile","Bile is made by the liver and works in the small intestine, not the mouth; the mouth fluid is saliva."),
    ("urine","Urine is a waste filtered by the kidneys, nothing to do with digesting food; the mouth fluid is saliva."),
    ("sweat","Sweat is released by the skin to cool the body; the digestive fluid in the mouth is saliva.")]),

 ("NA","The muscular tube that pushes the swallowed food down from the mouth to the stomach is the:",
   "oesophagus",
   C("The oesophagus, or food pipe, carries swallowed food from the throat down to the stomach.")+
   steps("Food is swallowed at the back of the mouth","A muscular tube squeezes it downward","that food pipe is the oesophagus.")+
   U("Food reaches your stomach because the oesophagus squeezes it down, even if you swallow lying down."),
   [("trachea","The trachea carries AIR to the lungs, not food; the food pipe is the oesophagus."),
    ("small intestine","The small intestine comes after the stomach; the tube from mouth to stomach is the oesophagus."),
    ("rectum","The rectum stores waste near the end of the gut; the pipe to the stomach is the oesophagus.")]),

 ("NA","Finger-like folds on the inner wall of the small intestine that greatly increase the surface for absorbing food are the:",
   "villi",
   C("Villi are tiny finger-like projections that hugely increase the small intestine's absorbing surface.")+
   steps("Digested food must be absorbed into the blood","The inner wall is folded into many tiny fingers","these villi give a vast surface for absorption.")+
   U("The millions of villi lining your small intestine act like a thick towel, soaking up digested food."),
   [("alveoli","Alveoli are air sacs in the LUNGS; the absorbing folds of the small intestine are villi."),
    ("incisors","Incisors are front teeth; the absorbing finger-like folds in the intestine are villi."),
    ("taste buds","Taste buds sense flavour on the tongue; the intestine's absorbing folds are villi.")]),

 ("NA","Animals such as cows and buffaloes that quickly swallow grass and later bring it back to chew slowly are called:",
   "ruminants",
   C("Ruminants, like cows, swallow grass fast and later return it to the mouth as cud to chew.")+
   steps("Grass is swallowed quickly into a special stomach part","Later it comes back up as cud","animals that chew cud this way are ruminants.")+
   U("A cow resting in the field, jaws moving steadily, is a ruminant chewing its cud."),
   [("carnivores","Carnivores eat meat and do not chew cud; the grass-and-cud animals are ruminants."),
    ("parasites","Parasites live on a host's body; cud-chewing grass eaters are ruminants."),
    ("decomposers","Decomposers break down dead matter; cows that chew cud are ruminants.")]),

 ("NA","The partly digested food that a cow brings back from its stomach to chew again is called:",
   "cud",
   C("Cud is the partly digested grass a ruminant returns to its mouth to chew thoroughly.")+
   steps("Grass is swallowed quickly and softened in the stomach","It is sent back up to the mouth","this returned mouthful is the cud.")+
   U("'Chewing the cud' describes a cow calmly re-chewing the grass it swallowed earlier."),
   [("bile","Bile is a digestive juice from the liver, not the returned food; the re-chewed food is cud."),
    ("saliva","Saliva is the watery fluid of the mouth; the partly digested food chewed again is the cud."),
    ("enamel","Enamel is the hard coating on teeth; the returned food a cow re-chews is cud.")]),

 ("NA","Amoeba, a single-celled animal, captures its food by putting out finger-like extensions of its body called:",
   "pseudopodia",
   C("Amoeba pushes out pseudopodia (false feet) to surround and trap its food.")+
   steps("Amoeba senses a food particle nearby","It stretches out arm-like extensions around it","these false feet are pseudopodia.")+
   U("Under a microscope an Amoeba is seen flowing out pseudopodia to engulf a tiny particle."),
   [("villi","Villi are absorbing folds in the human intestine; Amoeba's food-catching arms are pseudopodia."),
    ("cilia","Cilia are tiny beating hairs on some cells; Amoeba traps food with pseudopodia."),
    ("teeth","Amoeba has no teeth; it captures food with pseudopodia.")]),

 ("NA","After Amoeba surrounds its food, the food is enclosed and digested inside a:",
   "food vacuole",
   C("Amoeba digests its trapped food inside a bubble-like food vacuole.")+
   steps("The pseudopodia close around the food","The food is sealed in a tiny bubble","this food vacuole is where digestion happens.")+
   U("Inside an Amoeba a captured particle sits in a food vacuole while it is slowly digested."),
   [("stomach","Amoeba is a single cell with no stomach; it digests food in a food vacuole."),
    ("small intestine","A single-celled Amoeba has no intestine; digestion happens in its food vacuole."),
    ("gall bladder","The gall bladder stores bile in larger animals; Amoeba uses a food vacuole.")]),

 ("NA","The largest gland in the human body, which makes bile to help digest fats, is the:",
   "liver",
   C("The liver is the body's largest gland and produces bile, which helps digest fats.")+
   steps("Fats are hard to break down","A large gland makes a juice called bile to help","that gland is the liver.")+
   U("The liver, tucked under your right ribs, makes the bile that helps you digest oily food."),
   [("pancreas","The pancreas makes other digestive juices, but the bile-making largest gland is the liver."),
    ("kidney","Kidneys filter blood to make urine; bile is made by the liver."),
    ("salivary gland","Salivary glands make saliva in the mouth; bile is made by the much larger liver.")]),

 ("NA","The taking in of food into the body through the mouth is the step of digestion called:",
   "ingestion",
   C("Ingestion is the very first step — taking food into the body through the mouth.")+
   steps("Before anything else, food must enter the body","It is put into the mouth","this taking-in is ingestion.")+
   U("Putting a spoonful of rice into your mouth is ingestion, the start of the digestive journey."),
   [("egestion","Egestion is the LAST step — removing undigested waste; taking food in is ingestion."),
    ("absorption","Absorption is soaking digested food into the blood; taking food in by mouth is ingestion."),
    ("assimilation","Assimilation is the body using the absorbed food; the first taking-in step is ingestion.")]),

 ("NA","The removal of undigested, solid waste from the body is the digestive step called:",
   "egestion",
   C("Egestion is the final step of digestion — getting rid of undigested solid waste.")+
   steps("Not all food can be digested","The leftover solid waste must leave the body","this removal is egestion.")+
   U("Passing out the undigested remains of a meal as faeces is the step called egestion."),
   [("ingestion","Ingestion is taking food IN at the start; removing the waste at the end is egestion."),
    ("digestion","Digestion is breaking food down; the removal of undigested waste is egestion."),
    ("absorption","Absorption is taking digested food into the blood; removing solid waste is egestion.")]),

 ("NA","In the human digestive system, most of the absorption of digested food into the blood takes place in the:",
   "small intestine",
   C("The small intestine, lined with villi, is where most digested food is absorbed into the blood.")+
   steps("Food is fully digested into simple substances","It must pass into the blood","this absorption happens chiefly in the villi-lined small intestine.")+
   U("The long, coiled small intestine is where the goodness of your meal soaks into your blood."),
   [("stomach","The stomach mainly churns and partly digests food; most absorption is in the small intestine."),
    ("mouth","The mouth only chews and starts on starch; absorption of food happens in the small intestine."),
    ("large intestine","The large intestine mainly absorbs water; the digested food is absorbed in the small intestine.")]),

 ("NA","The main job of the large intestine is to absorb from the undigested food, before the waste is removed, the:",
   "water",
   C("The large intestine absorbs water from the leftover material, leaving a semi-solid waste.")+
   steps("Undigested food still holds much water","The large intestine soaks this water back","leaving a semi-solid waste to be egested.")+
   U("If the large intestine fails to absorb water properly, the result is watery stools, or diarrhoea."),
   [("oxygen","Oxygen is taken in by the lungs, not the gut; the large intestine absorbs water."),
    ("sunlight","Sunlight has no role inside the dark intestine; the large intestine absorbs water."),
    ("bile","Bile is added earlier by the liver; the large intestine's job is to absorb water.")]),

 ("NA","The pointed teeth, one on each side, used for tearing and piercing food are the:",
   "canines",
   C("Canines are the pointed teeth used to tear and pierce food, well developed in meat-eaters.")+
   steps("Beside the front cutting teeth sit sharp pointed teeth","They pierce and tear food","these are the canines.")+
   U("A dog's long, pointed canine teeth let it grip and tear its food."),
   [("incisors","Incisors are the flat front CUTTING teeth; the pointed tearing teeth are canines."),
    ("molars","Molars are the broad grinding back teeth; the pointed tearing teeth are canines."),
    ("premolars","Premolars grind food behind the canines; the pointed tearing teeth are the canines.")]),

 ("NA","The hard, white, shiny substance that covers and protects the outer surface of a tooth is:",
   "enamel",
   C("Enamel is the hard, protective outer covering of a tooth — the hardest material in the body.")+
   steps("The visible part of a tooth needs protection","It is coated with a very hard white layer","that layer is enamel.")+
   U("Brushing protects the enamel, the tough shiny coat that keeps your teeth from decaying."),
   [("saliva","Saliva is the watery fluid of the mouth, not a tooth covering; the hard coat is enamel."),
    ("bile","Bile is a digestive juice from the liver; the hard coating on teeth is enamel."),
    ("mucus","Mucus is a slimy protective fluid; the hard white tooth coating is enamel.")]),

 ("NA","The first set of teeth that appear in a young child and later fall out are called:",
   "milk teeth",
   C("Milk teeth are the first set in a young child, later replaced by permanent teeth.")+
   steps("A baby grows a first set of small teeth","These loosen and drop out in childhood","they are the milk teeth.")+
   U("A child losing a wobbly front tooth is shedding a milk tooth to make room for the permanent one."),
   [("wisdom teeth","Wisdom teeth are the last permanent molars of adulthood; the first set that fall out are milk teeth."),
    ("permanent teeth","Permanent teeth are the lasting second set; the first set that fall out are the milk teeth."),
    ("canines","Canines are a tooth type, not the first whole set; the first set are the milk teeth.")]),

 ("NA","The flap of tissue at the back of the mouth that helps in tasting food and in mixing it with saliva is the:",
   "tongue",
   C("The tongue mixes food with saliva, helps in swallowing, and carries the taste buds.")+
   steps("Food in the mouth must be tasted and moved about","A muscular organ rolls it and mixes saliva","that organ is the tongue.")+
   U("Your tongue tells you whether food is sweet or salty and pushes it around as you chew."),
   [("liver","The liver is a large gland that makes bile; tasting and mixing food is done by the tongue."),
    ("windpipe","The windpipe carries air to the lungs; tasting and mixing food is the tongue's job."),
    ("villus","A villus absorbs food in the intestine; tasting and mixing in the mouth is done by the tongue.")]),

 ("NA","The tiny structures on the surface of the tongue that let us sense the flavour of food are called:",
   "taste buds",
   C("Taste buds on the tongue detect the different flavours of food.")+
   steps("Different foods have different flavours","Tiny sensors on the tongue pick these up","these sensors are the taste buds.")+
   U("Your taste buds let you tell a sweet mango from a sour lemon the moment it touches your tongue."),
   [("villi","Villi absorb food in the small intestine; the flavour sensors on the tongue are taste buds."),
    ("incisors","Incisors are front cutting teeth, not flavour sensors; flavour comes from taste buds."),
    ("spiracles","Spiracles are breathing holes of insects; the flavour sensors on the tongue are taste buds.")]),

 ("NA","A cow can live on grass because tiny helpers in part of its stomach can digest the cellulose in grass. These helpers are:",
   "bacteria",
   C("Helpful bacteria in a ruminant's stomach break down the cellulose of grass, which the cow cannot do alone.")+
   steps("Grass is mostly tough cellulose","A cow's own juices cannot digest cellulose","but bacteria in its stomach can.")+
   U("A cow thrives on grass only because friendly bacteria in its gut unlock the cellulose for it."),
   [("viruses","Viruses cause disease and do not digest food; cellulose in a cow is broken down by bacteria."),
    ("its own teeth","Teeth only grind grass; the cellulose itself is digested by helpful bacteria."),
    ("its saliva","Saliva softens food but cannot digest cellulose; that is done by bacteria in the stomach.")]),

 ("NA","The simple sugar into which much of our starchy food is finally broken down for the body to use is:",
   "glucose",
   C("Starchy food is digested into glucose, the simple sugar the body uses for energy.")+
   steps("Bread and rice are full of starch","Digestion breaks starch into a simple sugar","that sugar is glucose.")+
   U("The quick energy you get from a meal of rice comes from the glucose it is broken down into."),
   [("starch","Starch is the food BEFORE digestion; it is broken DOWN into the simple sugar glucose."),
    ("bile","Bile is a digestive juice from the liver, not a sugar; starch is broken down to glucose."),
    ("enamel","Enamel is the hard coating of teeth; the simple sugar from starch is glucose.")]),

 ("NA","The acidic juice released by the stomach, which helps digest food and kills many germs in it, contains:",
   "hydrochloric acid",
   C("The stomach releases hydrochloric acid, which helps digestion and kills germs in the food.")+
   steps("The stomach needs an acid to act on food and germs","It releases a strong acid juice","this is hydrochloric acid.")+
   U("The burning feeling of acidity comes from the stomach's hydrochloric acid rising up."),
   [("lime water","Lime water is a clear test liquid for carbon dioxide, not a stomach juice; the stomach has hydrochloric acid."),
    ("bile","Bile from the liver is not acidic in this way; the stomach's germ-killing juice is hydrochloric acid."),
    ("saliva","Saliva acts in the mouth on starch; the acidic juice of the stomach is hydrochloric acid.")]),

 ("NA","The final step in which the absorbed, digested food is used by the body's cells to grow and release energy is called:",
   "assimilation",
   C("Assimilation is the using up of absorbed food by the body's cells for growth and energy.")+
   steps("Digested food is absorbed into the blood","The blood carries it to the cells","the cells use it — this is assimilation.")+
   U("The way a growing child builds muscle from a healthy meal is the body assimilating the food."),
   [("ingestion","Ingestion is taking food in at the START; the cells USING the food is assimilation."),
    ("egestion","Egestion removes undigested waste; the cells using absorbed food is assimilation."),
    ("digestion","Digestion breaks food down; the cells putting the absorbed food to use is assimilation.")]),
]

# ---------- PHYSICAL & CHEMICAL CHANGES (25) — Science ----------
PC = [
 ("PC","A change in which no new substance is formed and which is usually easy to reverse is called a:",
   "physical change",
   C("A physical change forms no new substance and can often be reversed.")+
   steps("Check whether a new substance has been made","If only the shape or state changes, none has","so it is a physical change.")+
   U("Melting ice into water is a physical change — freeze it again and you get ice back."),
   [("chemical change","A chemical change makes a NEW substance and is hard to reverse; no new substance means physical."),
    ("nuclear change","A nuclear change alters the atom's core; an everyday no-new-substance change is physical."),
    ("permanent change","'Permanent' is not the term here; a no-new-substance, reversible change is a physical change.")]),

 ("PC","A change in which one or more new substances are formed, and which is usually hard to reverse, is called a:",
   "chemical change",
   C("A chemical change produces new substances and is generally difficult to reverse.")+
   steps("Look for a brand-new substance with new properties","If one has formed","the change is chemical.")+
   U("Burning paper to ash is a chemical change — you cannot turn the ash back into paper."),
   [("physical change","A physical change makes NO new substance and is often reversible; a new substance means chemical."),
    ("change of state","A change of state, like melting, is physical; forming a new substance is a chemical change."),
    ("temporary change","'Temporary' is not the term; forming a new, hard-to-reverse substance is a chemical change.")]),

 ("PC","The reddish-brown flaky substance that forms on iron left in damp air is called:",
   "rust",
   C("Rust is the reddish-brown coating formed when iron reacts with air and moisture.")+
   steps("Iron is left exposed to damp air","It slowly reacts with oxygen and water","forming the reddish-brown rust.")+
   U("An old iron gate left out in the rain becomes covered in flaky reddish-brown rust."),
   [("ash","Ash is the powder left after burning, not the coating on damp iron; that is rust."),
    ("chalk","Chalk is a white rock; the reddish-brown coating on damp iron is rust."),
    ("salt","Salt is a white seasoning; the reddish-brown layer that forms on iron is rust.")]),

 ("PC","For iron to rust, two things must be present together. They are:",
   "air (oxygen) and water",
   C("Rusting needs both oxygen from the air and moisture (water) acting on the iron.")+
   steps("Dry iron in dry air does not rust","Add both air and moisture","and the iron rusts.")+
   U("Iron tools kept dry and oiled stay shiny, because rust needs both air and water."),
   [("only dry air","Dry air alone does not rust iron; BOTH air and water are needed."),
    ("oil and grease","Oil and grease actually PREVENT rust by keeping air and water off; rust needs air and water."),
    ("sunlight and salt","Sunlight is not required; rusting needs air (oxygen) and water together.")]),

 ("PC","Iron is often coated with a layer of zinc to stop it rusting. This protective coating process is called:",
   "galvanisation",
   C("Galvanisation is coating iron with zinc to protect it from rusting.")+
   steps("Bare iron rusts in damp air","A layer of zinc is put over it to keep air and water off","this zinc-coating is galvanisation.")+
   U("Galvanised iron sheets used for roofs resist rust because of their protective zinc coating."),
   [("crystallisation","Crystallisation is forming crystals from a solution, not coating iron; the zinc coat is galvanisation."),
    ("rusting","Rusting is the very damage being prevented; coating iron with zinc is galvanisation."),
    ("evaporation","Evaporation is a liquid turning to vapour; coating iron with zinc is galvanisation.")]),

 ("PC","Pure, large crystals of a substance such as copper sulphate can be obtained from its solution by the process of:",
   "crystallisation",
   C("Crystallisation forms pure, well-shaped crystals as a hot solution slowly cools.")+
   steps("Dissolve the substance in hot water","Let the solution cool slowly","pure crystals grow out — crystallisation.")+
   U("Big blue crystals of copper sulphate are grown in the lab by crystallising its solution."),
   [("rusting","Rusting is iron reacting with air and water; growing pure crystals from solution is crystallisation."),
    ("galvanisation","Galvanisation is zinc-coating iron; obtaining pure crystals from a solution is crystallisation."),
    ("burning","Burning is a substance reacting with oxygen; forming pure crystals from solution is crystallisation.")]),

 ("PC","The souring of milk to form curd is an example of a:",
   "chemical change",
   C("Milk turning into curd makes a new substance and cannot be reversed — a chemical change.")+
   steps("Milk is acted on by tiny organisms","It turns into curd, a new substance","and cannot become fresh milk again — chemical change.")+
   U("Once milk has set into curd it can never be turned back into milk — a chemical change."),
   [("physical change","A physical change makes no new substance; curd is a new substance, so it is a chemical change."),
    ("change of state","A change of state is just solid–liquid–gas; making curd from milk is a chemical change."),
    ("reversible change","Souring of milk cannot be undone, so it is an irreversible, chemical change.")]),

 ("PC","The melting of ice into water is best described as a:",
   "physical change",
   C("Melting ice only changes water's state; no new substance forms, so it is physical.")+
   steps("Ice is solid water","Warming it turns it to liquid water","still water, no new substance — a physical change.")+
   U("An ice cube melting in a glass is a physical change; cool it again and you get ice back."),
   [("chemical change","A chemical change forms a NEW substance; ice and water are the same substance, so it is physical."),
    ("irreversible change","Melting is easily reversed by freezing, so it is a reversible, physical change."),
    ("burning change","No burning is involved; ice simply changing to water is a physical change.")]),

 ("PC","The burning of a candle is a chemical change because, as it burns, the wax turns into:",
   "new substances such as carbon dioxide and water vapour",
   C("Burning wax reacts with oxygen to form new substances — carbon dioxide and water vapour.")+
   steps("The wax reacts with oxygen as it burns","New substances are produced","mainly carbon dioxide and water vapour — a chemical change.")+
   U("A burning candle slowly disappears because its wax is turned into gases that drift away."),
   [("only melted wax that can be reused","Melting is physical, but BURNING wax makes new gases — a chemical change."),
    ("pure oxygen","Burning USES UP oxygen; it produces carbon dioxide and water vapour, not oxygen."),
    ("more solid wax","Wax is destroyed as it burns, not created; it becomes carbon dioxide and water vapour.")]),

 ("PC","Photosynthesis, in which a plant makes food, is considered a chemical change because it:",
   "forms a new substance (food)",
   C("Photosynthesis makes a brand-new substance — glucose food — so it is a chemical change.")+
   steps("A plant takes in carbon dioxide and water","Using sunlight it builds glucose","a new substance is formed — a chemical change.")+
   U("A leaf making sugar from air, water and sunlight is carrying out a chemical change."),
   [("only changes the leaf's colour","A colour change alone is not the point; photosynthesis makes a new substance, food."),
    ("simply melts the leaf","Nothing melts; photosynthesis forms a new substance, which makes it a chemical change."),
    ("can be easily reversed","Photosynthesis is not simply reversed; it forms a new substance — a chemical change.")]),

 ("PC","Cutting a sheet of paper into many small pieces is a physical change because:",
   "no new substance is formed, it is still paper",
   C("Cutting paper only changes its size and shape; it is still paper, so it is a physical change.")+
   steps("The paper is divided into smaller bits","Each bit is still paper","no new substance — a physical change.")+
   U("Tearing a page into confetti gives smaller paper, not a new material — a physical change."),
   [("a new substance called confetti is made","The pieces are still PAPER, not a new substance; cutting is a physical change."),
    ("the paper turns into ash","Ash comes from BURNING, not cutting; cut paper is still paper — physical change."),
    ("it can never be undone","Even though you cannot rejoin it perfectly, no new substance forms, so it is physical.")]),

 ("PC","Mixing baking soda with vinegar produces lots of bubbles of gas. This fizzing tells us a ____ has occurred:",
   "chemical change",
   C("The fizzing gas is a new substance, showing a chemical change has taken place.")+
   steps("Baking soda meets vinegar","They react and a new gas bubbles out","a new substance means a chemical change.")+
   U("The fizz when baking soda meets vinegar is a sign that a chemical change is happening."),
   [("physical change","A physical change makes no new substance; the new gas shows a chemical change."),
    ("change of state","No simple melting or boiling here — a new gas is made, so it is a chemical change."),
    ("no change at all","Bubbling gas clearly shows something new is forming — a chemical change.")]),

 ("PC","When magnesium ribbon is burned, it gives a bright white light and leaves a white powder. This white powder is a:",
   "new substance (magnesium oxide)",
   C("Burning magnesium forms a brand-new white substance, magnesium oxide — a chemical change.")+
   steps("Magnesium burns in air with a bright flame","It joins with oxygen","forming a new white powder, magnesium oxide.")+
   U("The dazzling white burn of magnesium leaves behind a white ash that is a new substance."),
   [("just melted magnesium","The white powder is NOT melted magnesium; it is a new substance, magnesium oxide."),
    ("the same magnesium ribbon","The shiny ribbon is gone, replaced by a new white powder — a chemical change."),
    ("plain water","No water is left; burning magnesium leaves the new substance magnesium oxide.")]),

 ("PC","Boiling water turning into steam is a physical change because the steam can be cooled back into water. Such a change is said to be:",
   "reversible",
   C("Boiling and condensing simply swap water between liquid and gas, so the change is reversible.")+
   steps("Water boils into steam","Cool the steam and it becomes water again","you can go back and forth — reversible.")+
   U("Steam from a kettle fogs a cold window and turns back to water drops — a reversible change."),
   [("irreversible","An irreversible change cannot be undone; water and steam swap back easily, so it is reversible."),
    ("chemical","Boiling makes no new substance — it is a physical change, and a reversible one."),
    ("permanent","The change is not permanent; steam readily turns back to water, so it is reversible.")]),

 ("PC","To stop iron from rusting, a common everyday method is to:",
   "paint or grease the iron surface",
   C("Painting or greasing keeps air and water off the iron, so it cannot rust.")+
   steps("Rust needs air and water touching the iron","A coat of paint or grease seals the surface","so air and water are kept away and rust is prevented.")+
   U("Iron gates are painted partly to look nice and partly to stop them rusting."),
   [("leave it out in the rain","Rain provides the water that CAUSES rust; to prevent rust you keep iron dry and coated."),
    ("sprinkle salty water on it","Salty water speeds up rusting; to prevent rust you paint or grease the iron."),
    ("bury it in damp soil","Damp soil supplies water and air to rust the iron; paint or grease prevents rust instead.")]),

 ("PC","The layer of gas high in the atmosphere that protects us from the Sun's harmful ultraviolet rays is the:",
   "ozone layer",
   C("The ozone layer high in the atmosphere absorbs much of the Sun's harmful ultraviolet rays.")+
   steps("The Sun sends harmful ultraviolet rays","High up, a layer of ozone gas soaks much of them up","this shield is the ozone layer.")+
   U("The ozone layer acts like a sunscreen for the whole Earth, blocking harmful ultraviolet rays."),
   [("rust layer","Rust is a coating on iron, not an atmospheric shield; the protective layer is ozone."),
    ("water vapour layer","Water vapour makes clouds; the shield against ultraviolet rays is the ozone layer."),
    ("smoke layer","Smoke pollutes the air; the protective high-altitude shield is the ozone layer.")]),

 ("PC","Dissolving common salt in water is a physical change because the salt can be got back by:",
   "evaporating the water",
   C("Evaporating the water leaves the salt behind unchanged, showing dissolving was a physical change.")+
   steps("Salt dissolves and seems to vanish in water","Heat the solution so the water evaporates","the salt is left behind — so it was a physical change.")+
   U("Sea salt is made by letting sea water evaporate in the Sun, leaving the salt behind."),
   [("burning the solution","Burning would not recover the salt; gently evaporating the water leaves the salt behind."),
    ("adding more salt","Adding salt does not recover the dissolved salt; evaporating the water does."),
    ("freezing it into ice","Freezing traps the salt in ice; to get the salt back you evaporate the water.")]),

 ("PC","The rusting of iron is a chemical change. The new substance formed when iron rusts is called:",
   "iron oxide",
   C("Rust is iron oxide, the new substance formed when iron reacts with oxygen and water.")+
   steps("Iron reacts with oxygen and moisture","A new reddish-brown substance forms","this new substance is iron oxide — rust.")+
   U("The flaky reddish-brown layer on an old nail is iron oxide, formed by rusting."),
   [("pure iron","Pure iron is the metal BEFORE rusting; the new substance formed is iron oxide."),
    ("zinc","Zinc is used to coat iron and prevent rust; the rust itself is iron oxide."),
    ("carbon dioxide","Carbon dioxide is a gas from burning and breathing; rust is the solid iron oxide.")]),

 ("PC","A change in which a new substance is formed is often shown by signs such as a change in colour, a fizz of gas, or:",
   "giving out heat or light",
   C("Chemical changes are often shown by colour change, gas, or the giving out of heat or light.")+
   steps("Watch the substance as it changes","Look for new colour, bubbling gas, or heat and light","these point to a chemical change.")+
   U("A burning matchstick gives out heat and light, a clear sign of a chemical change."),
   [("staying exactly the same","If nothing changes, there is no reaction; chemical changes show signs like heat or light."),
    ("becoming colder by melting","Melting is a physical change; chemical changes often GIVE OUT heat or light."),
    ("simply changing shape","A mere shape change is physical; a chemical change shows signs like heat or light.")]),

 ("PC","When wood is burned, the change is irreversible. This means the ash:",
   "cannot be turned back into wood",
   C("Burning wood is irreversible — the ash can never be changed back into the original wood.")+
   steps("Wood burns and turns to ash and gases","No simple step brings the wood back","so the change is irreversible.")+
   U("Once a log has burned to ash in the fire, there is no way to get the wood back."),
   [("can easily become wood again","Burning is irreversible; the ash can NOT be turned back into wood."),
    ("is just melted wood","Ash is a new substance, not melted wood; burning is an irreversible chemical change."),
    ("will cool back into a log","Cooling the ash gives only cold ash, never the original log; the change is irreversible.")]),

 ("PC","Stretching a rubber band so it grows longer, then letting it spring back, is a:",
   "physical change",
   C("Stretching a rubber band only changes its shape for a while; no new substance forms.")+
   steps("The band is pulled longer","Let go and it returns to its old shape","no new substance — a physical change.")+
   U("A rubber band that snaps back to size after stretching has undergone a physical change."),
   [("chemical change","A chemical change makes a new substance; a stretching band stays rubber — physical change."),
    ("irreversible change","The band springs back, so the change is reversible and physical, not irreversible."),
    ("burning change","No burning happens; stretching a rubber band is simply a physical change.")]),

 ("PC","Folding a paper boat and then unfolding the paper again shows that the change is:",
   "reversible and physical",
   C("Folding paper only changes its shape; unfolding undoes it, so it is a reversible physical change.")+
   steps("The flat paper is folded into a boat","Unfold it and the flat sheet returns","no new substance, easily undone — reversible and physical.")+
   U("A folded paper boat can be opened out flat again, showing a reversible physical change."),
   [("irreversible and chemical","No new substance is made and it can be undone, so it is reversible and physical."),
    ("chemical only","Folding makes no new substance; it is a physical, reversible change."),
    ("a burning change","No burning is involved; folding and unfolding paper is a reversible physical change.")]),

 ("PC","The setting of cement and the cooking of food are both examples of changes that are:",
   "chemical and irreversible",
   C("Both setting cement and cooking food form new substances that cannot be changed back — chemical and irreversible.")+
   steps("Cement sets into a new hard solid; food cooks into new substances","Neither can be returned to its starting state","so both are chemical and irreversible.")+
   U("Once cement has set hard or an egg has been cooked, there is no going back — chemical, irreversible changes."),
   [("physical and reversible","New substances form and cannot be undone, so these are chemical, irreversible changes."),
    ("only changes of state","These are not simple melting or freezing; new substances form, so they are chemical changes."),
    ("changes that give back the starting material","Neither set cement nor cooked food can return to its start — they are irreversible chemical changes.")]),

 ("PC","Galvanised iron resists rust better than ordinary iron because the zinc coating:",
   "keeps air and water away from the iron",
   C("The zinc layer seals the iron from air and moisture, so rusting cannot start.")+
   steps("Rust needs air and water on the iron","Zinc forms a barrier over the surface","keeping air and water away so the iron does not rust.")+
   U("A galvanised bucket lasts for years in the rain because its zinc coat shields the iron."),
   [("makes the iron heavier","Extra weight has nothing to do with rust; the zinc protects by keeping air and water off."),
    ("turns the iron into gold","Zinc does not change iron into gold; it simply shields it from air and water."),
    ("adds water to the iron","Adding water would CAUSE rust; the zinc keeps air and water away to prevent it.")]),

 ("PC","Dissolving sugar in a cup of tea is a physical change because the sugar:",
   "is still sugar and can be recovered by evaporating",
   C("Dissolved sugar is unchanged; evaporating the water leaves the same sugar, so it is a physical change.")+
   steps("Sugar seems to vanish as it dissolves","But it is still sugar, just spread through the tea","evaporate the water and the sugar returns — a physical change.")+
   U("Sweet tea tastes sugary because the sugar is still there, merely dissolved — a physical change."),
   [("turns into a brand-new substance","The sugar stays sugar; no new substance forms, so it is a physical change."),
    ("burns away into ash","Dissolving is not burning; the sugar is unchanged, so it is a physical change."),
    ("can never be got back again","Evaporating the water recovers the sugar, showing the change is physical and reversible.")]),
]

# ---------- FRACTIONS & DECIMALS (25) — Maths (with fusion stems) ----------
FD = [
 ("FD","The product of the fractions 2/3 and 3/5 is:",
   "2/5",
   C("Multiply fractions by multiplying the numerators and the denominators, then simplify.")+
   steps("Multiply tops and bottoms: (2×3)/(3×5) = 6/15","Divide top and bottom by 3","6/15 = 2/5.")+
   U("Two-thirds of three-fifths of a chocolate bar is two-fifths of the whole bar."),
   [("6/8","You must multiply 3×5 = 15 on the bottom, not add to 8; the answer is 6/15 = 2/5."),
    ("5/8","You do not add the fractions; multiplying gives 6/15, which simplifies to 2/5."),
    ("1/5","6/15 simplifies by dividing by 3 to give 2/5, not 1/5.")]),

 ("FD","A cow chews its cud for 3/4 of an hour. Written in minutes, 3/4 of an hour is:",
   "45 minutes",
   C("An hour is 60 minutes, so 3/4 of an hour is 3/4 × 60.")+
   steps("One hour = 60 minutes","3/4 × 60 = (3×60)/4 = 180/4","= 45 minutes.")+
   U("A cow that chews its cud for three-quarters of an hour spends 45 minutes at it."),
   [("30 minutes","30 minutes is only HALF an hour; 3/4 of an hour is 45 minutes."),
    ("34 minutes","3/4 is not 34 minutes; 3/4 × 60 = 45 minutes."),
    ("75 minutes","75 minutes is more than an hour; 3/4 of one hour is 45 minutes.")]),

 ("FD","The reciprocal of the fraction 5/8 is:",
   "8/5",
   C("The reciprocal of a fraction is found by turning it upside down.")+
   steps("Swap the numerator and denominator of 5/8","Top 5 goes below, bottom 8 goes above","giving 8/5.")+
   U("To divide by 5/8 you instead multiply by its reciprocal, 8/5."),
   [("5/8","The reciprocal is the fraction FLIPPED, so 8/5, not the same 5/8."),
    ("−5/8","A reciprocal is not the negative; flipping 5/8 gives 8/5."),
    ("13/8","You do not add the numbers; the reciprocal of 5/8 is 8/5.")]),

 ("FD","Of a meal, the small intestine absorbs 7/10 of the digested food. As a decimal, 7/10 is:",
   "0.7",
   C("A fraction with denominator 10 is written with one decimal place.")+
   steps("7/10 means 7 tenths","One tenth = 0.1","so 7 tenths = 0.7.")+
   U("If 7/10 of a meal's goodness is absorbed, that is 0.7 of it taken into the blood."),
   [("7.0","7.0 is seven whole units, far more than the fraction 7/10, which is 0.7."),
    ("0.07","0.07 is 7 hundredths; 7 tenths is 0.7."),
    ("0.10","0.10 is one tenth; SEVEN tenths is 0.7.")]),

 ("FD","The value of 0.6 × 0.3 is:",
   "0.18",
   C("Multiply the digits as whole numbers, then place the decimal point with the total decimal places.")+
   steps("6 × 3 = 18","0.6 and 0.3 have one decimal place each → two in all","so the answer is 0.18.")+
   U("A length of 0.6 m by a width of 0.3 m gives an area of 0.18 square metres."),
   [("1.8","1.8 has only one decimal place; multiplying two one-place decimals needs two, giving 0.18."),
    ("0.9","0.9 would be ADDING 0.6 and 0.3; multiplying gives 0.18."),
    ("18","18 ignores the decimal points; 0.6 × 0.3 = 0.18.")]),

 ("FD","Dividing the fraction 3/4 by 2 gives:",
   "3/8",
   C("Dividing by 2 is the same as multiplying by 1/2.")+
   steps("3/4 ÷ 2 = 3/4 × 1/2","Multiply: (3×1)/(4×2) = 3/8","so the answer is 3/8.")+
   U("Sharing three-quarters of a pizza equally between 2 people gives each three-eighths."),
   [("6/4","Dividing makes the share SMALLER, not larger; 3/4 ÷ 2 = 3/8."),
    ("3/2","3/2 is bigger than 3/4; dividing by 2 gives the smaller 3/8."),
    ("3/6","You multiply the denominator by 2, giving 8, not 6; the answer is 3/8.")]),

 ("FD","Converting the improper fraction 7/2 into a mixed number gives:",
   "3 1/2",
   C("Divide the numerator by the denominator to get the whole-number part and the remainder.")+
   steps("7 ÷ 2 = 3 remainder 1","The 3 is the whole part, the remainder 1 stays over 2","so 7/2 = 3 1/2.")+
   U("Seven half-litre bottles of milk make three and a half litres, that is 3 1/2 litres."),
   [("2 1/3","You divide 7 by 2, not 2 by something; 7/2 = 3 1/2."),
    ("7 1/2","7/2 is only three and a half, not seven and a half; it equals 3 1/2."),
    ("3 1/3","The remainder 1 is written over the denominator 2, giving 1/2, so 3 1/2.")]),

 ("FD","A glass holds 0.25 litre of saliva-like water. The total in 4 such glasses is:",
   "1 litre",
   C("Multiply the amount in one glass by the number of glasses.")+
   steps("Each glass = 0.25 L","4 × 0.25 = 1.00","so the total is 1 litre.")+
   U("Four quarter-litre glasses together fill exactly one full litre."),
   [("0.29 litre","You multiply, not add 4 to 0.25; 4 × 0.25 = 1 litre."),
    ("4.25 litres","4.25 would be adding 4 to 0.25; multiplying gives 1 litre."),
    ("0.1 litre","0.1 is far too little; 4 × 0.25 = 1 litre.")]),

 ("FD","The sum of the fractions 1/4 and 1/2 is:",
   "3/4",
   C("To add fractions, write them with the same denominator, then add the numerators.")+
   steps("1/2 = 2/4","1/4 + 2/4 = 3/4","so the sum is 3/4.")+
   U("A quarter of a cake plus a half of a cake together make three-quarters of a cake."),
   [("2/6","You do not add tops and bottoms separately; using a common denominator gives 3/4."),
    ("1/6","Adding makes the total bigger, not smaller; 1/4 + 1/2 = 3/4."),
    ("1/2","1/2 is just one of the fractions; the two together make 3/4.")]),

 ("FD","A ruminant's stomach has 4 chambers. If food spends 2/5 of its time in the first chamber, the fraction of time spent in the OTHER chambers is:",
   "3/5",
   C("The whole is 1; subtract the part in the first chamber from the whole.")+
   steps("Whole time = 1 = 5/5","Time elsewhere = 5/5 − 2/5","= 3/5.")+
   U("If 2/5 of the journey is in the first stomach chamber, the remaining 3/5 is spread through the rest."),
   [("2/5","2/5 is the part in the FIRST chamber; the rest is 1 − 2/5 = 3/5."),
    ("7/5","A fraction of the time cannot be more than the whole 5/5; the rest is 3/5."),
    ("1/5","Subtract 2/5 from the whole 5/5 to get 3/5, not 1/5.")]),

 ("FD","The value of 1/2 of 1/2 is:",
   "1/4",
   C("'Of' means multiply, so 1/2 of 1/2 is 1/2 × 1/2.")+
   steps("1/2 × 1/2","Multiply tops and bottoms: (1×1)/(2×2)","= 1/4.")+
   U("Half of a half-slice of bread is a quarter of the whole slice."),
   [("1","Multiplying two halves makes a SMALLER number, not 1; the answer is 1/4."),
    ("1/2","Half of a half is smaller than a half; it is 1/4."),
    ("2/4","2/4 simplifies to 1/2, which is too big; 1/2 of 1/2 is 1/4.")]),

 ("FD","Written as a fraction in its simplest form, the decimal 0.75 is:",
   "3/4",
   C("0.75 is 75 hundredths; simplify 75/100 by dividing top and bottom by 25.")+
   steps("0.75 = 75/100","Divide both by 25: 75÷25 = 3, 100÷25 = 4","so 0.75 = 3/4.")+
   U("Saying a bottle is 0.75 full is the same as saying it is three-quarters full."),
   [("7/5","0.75 is less than 1, but 7/5 is more than 1; 0.75 = 3/4."),
    ("75/10","75/10 equals 7.5, far too big; 0.75 = 75/100 = 3/4."),
    ("1/4","1/4 is 0.25, not 0.75; the decimal 0.75 equals 3/4.")]),

 ("FD","A grasshopper eats 2 1/2 grams of leaf each day. In 4 days it eats:",
   "10 grams",
   C("Multiply the daily amount by the number of days; first write 2 1/2 as 5/2.")+
   steps("2 1/2 = 5/2 g per day","5/2 × 4 = 20/2","= 10 grams.")+
   U("A grasshopper eating two-and-a-half grams a day gets through 10 grams in four days."),
   [("8 grams","8 g would ignore the half-gram each day; 2 1/2 × 4 = 10 grams."),
    ("6 1/2 grams","You multiply by 4, not add 4; 2 1/2 × 4 = 10 grams."),
    ("5 grams","5 g is only two days' food; over 4 days it is 10 grams.")]),

 ("FD","The product 0.2 × 0.2 is:",
   "0.04",
   C("Multiply 2 × 2 = 4, then count the decimal places to place the point.")+
   steps("2 × 2 = 4","Each factor has one decimal place → two places in the answer","so 0.2 × 0.2 = 0.04.")+
   U("A square tile 0.2 m on each side covers an area of 0.04 square metres."),
   [("0.4","0.4 has only one decimal place; two one-place decimals give two places, so 0.04."),
    ("4.0","4.0 ignores the decimals entirely; 0.2 × 0.2 = 0.04."),
    ("0.004","0.004 has three decimal places; the correct answer has two, 0.04.")]),

 ("FD","A leaf is divided so that 3/8 of it is eaten by a caterpillar. The fraction of the leaf left UNEATEN is:",
   "5/8",
   C("Subtract the eaten part from the whole leaf, which is 1 = 8/8.")+
   steps("Whole leaf = 8/8","Uneaten = 8/8 − 3/8","= 5/8.")+
   U("If a caterpillar eats three-eighths of a leaf, five-eighths of it is still left."),
   [("3/8","3/8 is the part EATEN; the part left is 8/8 − 3/8 = 5/8."),
    ("11/8","The leftover cannot be more than the whole leaf; it is 5/8."),
    ("1/8","Subtract 3/8 from the whole 8/8 to get 5/8, not 1/8.")]),

 ("FD","The fraction 1/5 written as a decimal is:",
   "0.2",
   C("Divide 1 by 5, or write 1/5 as an equivalent fraction over 10.")+
   steps("1/5 = 2/10","2/10 means 2 tenths","= 0.2.")+
   U("One-fifth of a litre of water is the same as 0.2 litre."),
   [("0.5","0.5 is one HALF, not one fifth; 1/5 = 0.2."),
    ("1.5","1.5 is more than one whole; 1/5 is the small value 0.2."),
    ("0.15","0.15 is fifteen hundredths; one fifth is 0.2.")]),

 ("FD","A glucose tablet weighs 0.5 gram. The number of such tablets in 3 grams is:",
   "6",
   C("Divide the total weight by the weight of one tablet.")+
   steps("Total = 3 g, each tablet = 0.5 g","3 ÷ 0.5 = 30 ÷ 5","= 6 tablets.")+
   U("From 3 grams of glucose you can make 6 half-gram tablets."),
   [("1.5","1.5 would be 3 × 0.5; to find how MANY you divide, giving 6."),
    ("3","3 is the total grams, not the number of half-gram tablets, which is 6."),
    ("12","12 would be dividing by 0.25; dividing 3 by 0.5 gives 6.")]),

 ("FD","The value of 2/3 ÷ 1/3 is:",
   "2",
   C("To divide by a fraction, multiply by its reciprocal.")+
   steps("2/3 ÷ 1/3 = 2/3 × 3/1","= 6/3","= 2.")+
   U("How many one-third pieces fit into two-thirds? Exactly 2."),
   [("2/9","You FLIP the second fraction before multiplying; 2/3 × 3/1 = 2, not 2/9."),
    ("1/2","1/2 is the reciprocal answer turned the wrong way; 2/3 ÷ 1/3 = 2."),
    ("3","Two-thirds holds two one-thirds, not three; the answer is 2.")]),

 ("FD","Rounded to one decimal place (one place after the point), the number 3.47 is:",
   "3.5",
   C("Look at the second decimal digit; if it is 5 or more, round the first decimal up.")+
   steps("3.47 — the second decimal is 7","7 is 5 or more, so round the tenths up","3.4 becomes 3.5.")+
   U("A reading of 3.47 on a scale is recorded as 3.5 when rounded to one decimal place."),
   [("3.4","Because the next digit 7 is 5 or more, you round UP to 3.5, not down to 3.4."),
    ("3.0","3.0 drops the decimal part wrongly; rounding 3.47 to one place gives 3.5."),
    ("4.0","4.0 over-rounds; to one decimal place 3.47 is 3.5.")]),

 ("FD","A nail loses 1/8 of its weight to rust each month. After it has lost rust for 3 months, the fraction of weight lost is:",
   "3/8",
   C("Losing 1/8 each month for 3 months adds up: 1/8 + 1/8 + 1/8.")+
   steps("Each month lost = 1/8","Three months: 1/8 + 1/8 + 1/8","= 3/8.")+
   U("A rusting nail that sheds an eighth of its weight monthly has lost three-eighths after 3 months."),
   [("1/8","1/8 is just ONE month's loss; over 3 months it is 3 × 1/8 = 3/8."),
    ("3/24","Adding 1/8 three times keeps the denominator 8, giving 3/8, not 3/24."),
    ("1/24","You ADD the losses, not multiply the fractions; the total is 3/8.")]),

 ("FD","The value of 0.9 − 0.45 is:",
   "0.45",
   C("Line up the decimal points and subtract, writing 0.9 as 0.90.")+
   steps("0.90 − 0.45","90 hundredths − 45 hundredths = 45 hundredths","= 0.45.")+
   U("If 0.9 litre of milk loses 0.45 litre, exactly 0.45 litre is left."),
   [("0.54","Take care to line up the points: 0.90 − 0.45 = 0.45, not 0.54."),
    ("0.5","0.5 is a rough guess; the exact answer is 0.90 − 0.45 = 0.45."),
    ("1.35","1.35 is the SUM, not the difference; 0.9 − 0.45 = 0.45.")]),

 ("FD","A fraction is multiplied by 1. The result is:",
   "the same fraction, unchanged",
   C("Multiplying any number by 1 leaves it unchanged; 1 is the multiplicative identity.")+
   steps("Take any fraction and multiply it by 1","Multiplying by 1 changes nothing","so the fraction stays the same.")+
   U("Three-quarters of a cake multiplied by 1 is still three-quarters of a cake."),
   [("always 1","Multiplying by 1 does not turn everything into 1; the fraction stays unchanged."),
    ("zero","Multiplying by 1, not 0, leaves the fraction unchanged, not zero."),
    ("the reciprocal of the fraction","Flipping happens when you multiply by the reciprocal; multiplying by 1 leaves it unchanged.")]),

 ("FD","An Amoeba splits a 0.8 mm food particle into 2 equal pieces. Each piece measures:",
   "0.4 mm",
   C("Divide the length by 2 to find each equal piece.")+
   steps("Total = 0.8 mm split into 2","0.8 ÷ 2 = 0.4","each piece is 0.4 mm.")+
   U("Cutting a 0.8 mm particle exactly in half gives two pieces of 0.4 mm each."),
   [("1.6 mm","1.6 mm is DOUBLE, not half; splitting 0.8 mm in two gives 0.4 mm."),
    ("0.6 mm","0.6 mm is not half of 0.8; 0.8 ÷ 2 = 0.4 mm."),
    ("0.16 mm","0.16 misplaces the decimal; 0.8 ÷ 2 = 0.4 mm.")]),

 ("FD","Which of these fractions is the greatest?",
   "3/4",
   C("Compare fractions by giving them a common denominator, here twelfths.")+
   steps("Write each over 12: 3/4 = 9/12, 2/3 = 8/12, 1/2 = 6/12","Compare the numerators 9, 8, 6","9/12 is largest, so 3/4 is greatest.")+
   U("Three-quarters of a glass holds more juice than two-thirds or one-half of the same glass."),
   [("2/3","2/3 = 8/12, which is less than 3/4 = 9/12; 3/4 is the greatest."),
    ("1/2","1/2 = 6/12 is the smallest of these; 3/4 is the greatest."),
    ("1/4","1/4 = 3/12 is far less than 3/4; 3/4 is the greatest.")]),

 ("FD","Subtracting 1/3 from 5/6 leaves the value:",
   "1/2",
   C("Use a common denominator of 6, then subtract the numerators.")+
   steps("1/3 = 2/6","5/6 − 2/6 = 3/6","= 1/2.")+
   U("Five-sixths of a strip with one-third cut off leaves half the strip."),
   [("4/3","You subtract, getting a smaller number; 5/6 − 1/3 = 1/2, not 4/3."),
    ("4/6","Write 1/3 as 2/6 first: 5/6 − 2/6 = 3/6 = 1/2, not 4/6."),
    ("1/3","Subtracting 1/3 from 5/6 leaves 1/2, not 1/3.")]),
]

# ---------- COMPARING QUANTITIES (25) — Maths (with fusion stems) ----------
CQ = [
 ("CQ","The ratio 20 to 30, written in its simplest form, is:",
   "2 : 3",
   C("Simplify a ratio by dividing both numbers by their highest common factor.")+
   steps("20 : 30, both divide by 10","20÷10 = 2, 30÷10 = 3","so the ratio is 2 : 3.")+
   U("Mixing 20 mL of one juice with 30 mL of another is a 2 : 3 mix."),
   [("3 : 2","The order matters: 20 comes first, so it is 2 : 3, not 3 : 2."),
    ("20 : 30","A ratio should be in simplest form; 20 : 30 reduces to 2 : 3."),
    ("10 : 15","10 : 15 still has a common factor of 5; fully simplified it is 2 : 3.")]),

 ("CQ","Written as a percentage, the fraction 1/4 is:",
   "25%",
   C("To turn a fraction into a percentage, multiply it by 100.")+
   steps("1/4 × 100","= 100/4","= 25, so 25%.")+
   U("A quarter of a class being absent means 25% of the class is away."),
   [("14%","1/4 is not 14%; multiplying by 100 gives 25%."),
    ("4%","4% comes from 4/100; the fraction 1/4 is 25%."),
    ("40%","40% is 2/5, not 1/4; one quarter is 25%.")]),

 ("CQ","When iron rusts, a 50 g bar gains 10 g of extra weight. This gain, as a percentage of the original weight, is:",
   "20%",
   C("Percentage gain = (gain ÷ original) × 100.")+
   steps("Gain = 10 g, original = 50 g","(10 ÷ 50) × 100 = (1/5) × 100","= 20%.")+
   U("An iron bar that puts on a fifth of its weight as rust has gained 20%."),
   [("10%","10 g out of 50 g is a FIFTH, which is 20%, not 10%."),
    ("50%","50% would be a 25 g gain; gaining 10 g of 50 g is 20%."),
    ("40%","40% would be a 20 g gain; the 10 g gain is 20% of 50 g.")]),

 ("CQ","A shopkeeper buys a jar of crystallised salt for ₹80 and sells it for ₹100. The profit is:",
   "₹20",
   C("Profit = selling price − cost price.")+
   steps("Selling price = ₹100, cost price = ₹80","Profit = 100 − 80","= ₹20.")+
   U("Buying at ₹80 and selling at ₹100 leaves a profit of ₹20."),
   [("₹180","₹180 is the SUM of the two prices, not the profit; profit = 100 − 80 = ₹20."),
    ("₹100","₹100 is the selling price; the profit is selling minus cost = ₹20."),
    ("₹80","₹80 is the cost price; the profit is ₹100 − ₹80 = ₹20.")]),

 ("CQ","To find 10% of 250, you calculate:",
   "25",
   C("Ten percent of a number is one tenth of it.")+
   steps("10% means 10/100 = 1/10","1/10 of 250 = 250 ÷ 10","= 25.")+
   U("A 10% discount on a ₹250 item takes ₹25 off the price."),
   [("250","250 is the whole amount, not 10% of it, which is 25."),
    ("2.5","2.5 is 1% of 250; ten percent is 25."),
    ("100","100 is not 10% of 250; one tenth of 250 is 25.")]),

 ("CQ","In a galvanised coating, zinc and iron are used in the ratio 1 : 4. If 2 kg of zinc is used, the iron used is:",
   "8 kg",
   C("In the ratio 1 : 4, the iron is 4 times the zinc.")+
   steps("Zinc : iron = 1 : 4","Iron = 4 × zinc = 4 × 2 kg","= 8 kg.")+
   U("With a 1 : 4 zinc-to-iron mix, every 2 kg of zinc goes with 8 kg of iron."),
   [("0.5 kg","Iron is 4 TIMES the zinc, not a quarter of it; 4 × 2 = 8 kg."),
    ("6 kg","Iron is 4 × 2 = 8 kg, not 6 kg; do not just add to the zinc."),
    ("2 kg","Equal amounts would be a 1 : 1 ratio; for 1 : 4 the iron is 8 kg.")]),

 ("CQ","The fraction 3/5 written as a percentage is:",
   "60%",
   C("Multiply the fraction by 100 to get the percentage.")+
   steps("3/5 × 100","= 300/5","= 60, so 60%.")+
   U("If 3 out of every 5 students passed, then 60% of them passed."),
   [("35%","3/5 is not 35%; multiplying by 100 gives 60%."),
    ("53%","Do not just read off the digits; 3/5 × 100 = 60%."),
    ("30%","30% is 3/10, not 3/5; three-fifths is 60%.")]),

 ("CQ","A pen costs ₹40. After a price rise of 25%, its new price is:",
   "₹50",
   C("Find 25% of the price and add it on.")+
   steps("25% of 40 = (25/100) × 40 = 10","New price = 40 + 10","= ₹50.")+
   U("A ₹40 pen that goes up by a quarter now costs ₹50."),
   [("₹65","25% of 40 is 10, not 25; the new price is 40 + 10 = ₹50."),
    ("₹45","A 25% rise adds 10 (a quarter of 40), not 5; the new price is ₹50."),
    ("₹30","A price RISE makes it dearer, not cheaper; the new price is ₹50.")]),

 ("CQ","A digestive juice is 30% acid. In 200 mL of this juice, the amount of acid is:",
   "60 mL",
   C("Find 30% of 200 mL.")+
   steps("30% means 30/100","(30/100) × 200 = 30 × 2","= 60 mL.")+
   U("If a 200 mL sample of stomach juice is 30% acid, it holds 60 mL of acid."),
   [("30 mL","30 is the percentage, not the amount; 30% of 200 mL is 60 mL."),
    ("200 mL","200 mL is the WHOLE juice; only 30% of it, 60 mL, is acid."),
    ("6 mL","6 mL is 3% of 200; thirty percent is 60 mL.")]),

 ("CQ","The percentage 50% written as a fraction in its simplest form is:",
   "1/2",
   C("A percentage is a fraction out of 100, then simplified.")+
   steps("50% = 50/100","Divide top and bottom by 50","= 1/2.")+
   U("Saying half the class is present is the same as saying 50% is present."),
   [("1/5","1/5 is 20%, not 50%; fifty percent is 1/2."),
    ("5/10","5/10 is correct but NOT in simplest form; reduced it is 1/2."),
    ("50/1","50/1 is fifty whole units, far too big; 50% is 1/2.")]),

 ("CQ","A cow's feed is mixed with grain and hay in the ratio 2 : 3. The total number of equal parts in the mix is:",
   "5 parts",
   C("Add the numbers in the ratio to find the total parts.")+
   steps("Ratio 2 : 3 means 2 parts grain, 3 parts hay","Total parts = 2 + 3","= 5 parts.")+
   U("A 2 : 3 feed mix is divided into 5 equal parts in all."),
   [("6 parts","You ADD the ratio numbers, not multiply; 2 + 3 = 5 parts."),
    ("23 parts","The ratio 2 : 3 is not 23; the total is 2 + 3 = 5 parts."),
    ("1 part","The two amounts together make 5 parts, not 1.")]),

 ("CQ","A toy marked ₹200 is sold at a 15% discount. The discount amount is:",
   "₹30",
   C("The discount is 15% of the marked price.")+
   steps("15% of 200 = (15/100) × 200","= 15 × 2","= ₹30.")+
   U("A 15% off sale on a ₹200 toy saves you ₹30."),
   [("₹15","₹15 is the percentage number, not 15% of 200, which is ₹30."),
    ("₹170","₹170 is the price AFTER the discount; the discount itself is ₹30."),
    ("₹185","₹185 is not the discount; 15% of 200 is ₹30.")]),

 ("CQ","Out of 25 nails, 5 have rusted. The percentage of nails that have rusted is:",
   "20%",
   C("Percentage = (part ÷ whole) × 100.")+
   steps("Rusted = 5 out of 25","(5 ÷ 25) × 100 = (1/5) × 100","= 20%.")+
   U("If 5 of 25 nails in a box have rusted, then 20% of them are rusty."),
   [("5%","5 out of 25 is a FIFTH, which is 20%, not 5%."),
    ("25%","25% would be 1 in 4; 5 out of 25 is 1 in 5, which is 20%."),
    ("50%","50% would be half rusted; 5 of 25 is only 20%.")]),

 ("CQ","A buffalo's milk is 8% cream. The mass of cream in 50 kg of this milk is:",
   "4 kg",
   C("Find 8% of 50 kg.")+
   steps("8% means 8/100","(8/100) × 50 = 8 × 0.5","= 4 kg.")+
   U("From 50 kg of milk that is 8% cream, you can get 4 kg of cream."),
   [("8 kg","8 is the percentage, not the mass; 8% of 50 kg is 4 kg."),
    ("40 kg","40 kg would be 80%; eight percent of 50 kg is 4 kg."),
    ("0.8 kg","0.8 kg is too little; 8% of 50 kg is 4 kg.")]),

 ("CQ","The simple interest on ₹500 at 10% per year for 1 year is:",
   "₹50",
   C("Simple interest for one year is the principal times the rate percentage.")+
   steps("10% of 500 = (10/100) × 500","= 10 × 5","= ₹50 for one year.")+
   U("Putting ₹500 in an account paying 10% a year earns ₹50 of interest in that year."),
   [("₹500","₹500 is the money invested, not the interest, which is ₹50."),
    ("₹10","₹10 is just the rate number; 10% of ₹500 is ₹50."),
    ("₹100","₹100 would be 20%; at 10% for one year the interest is ₹50.")]),

 ("CQ","A salt solution is made by dissolving 25 g of salt in water to make 100 g of solution. The percentage of salt is:",
   "25%",
   C("Percentage of salt = (mass of salt ÷ mass of solution) × 100.")+
   steps("Salt = 25 g, solution = 100 g","(25 ÷ 100) × 100","= 25%.")+
   U("Dissolving 25 g of salt to make 100 g of solution gives a 25% salt solution."),
   [("75%","75% would be the WATER's share; the salt is 25 g of 100 g, so 25%."),
    ("2.5%","2.5% would be 2.5 g of salt; here it is 25 g of 100 g, so 25%."),
    ("100%","100% would be pure salt; 25 g in 100 g of solution is 25%.")]),

 ("CQ","If 3 oranges cost ₹15, then at the same rate 5 oranges cost:",
   "₹25",
   C("Find the cost of one orange, then multiply by 5.")+
   steps("One orange = 15 ÷ 3 = ₹5","Five oranges = 5 × 5","= ₹25.")+
   U("At ₹5 each, buying 5 oranges costs ₹25."),
   [("₹20","₹20 is the cost of 4 oranges; 5 oranges at ₹5 each cost ₹25."),
    ("₹45","₹45 would be 9 oranges; 5 oranges cost ₹25."),
    ("₹75","₹75 multiplies 15 by 5 wrongly; first find one orange (₹5), so 5 cost ₹25.")]),

 ("CQ","A shopkeeper buys a bag for ₹120 and sells it at a loss of ₹20. The selling price is:",
   "₹100",
   C("On a loss, selling price = cost price − loss.")+
   steps("Cost price = ₹120, loss = ₹20","Selling price = 120 − 20","= ₹100.")+
   U("Selling a ₹120 bag at a ₹20 loss means letting it go for ₹100."),
   [("₹140","A loss means selling for LESS, so 120 − 20 = ₹100, not more."),
    ("₹20","₹20 is the loss, not the selling price, which is ₹100."),
    ("₹120","₹120 is the cost price; after a ₹20 loss the selling price is ₹100.")]),

 ("CQ","During cooking, 40% of the water in a pot of 500 mL boils away. The volume of water that boils away is:",
   "200 mL",
   C("Find 40% of 500 mL.")+
   steps("40% means 40/100","(40/100) × 500 = 40 × 5","= 200 mL.")+
   U("If 40% of half a litre of water boils off, 200 mL has gone."),
   [("40 mL","40 is the percentage, not the volume; 40% of 500 mL is 200 mL."),
    ("300 mL","300 mL is the water LEFT (60%); the amount boiled away is 200 mL."),
    ("500 mL","500 mL is all the water; only 40% of it, 200 mL, boils away.")]),

 ("CQ","The ratio of the number of incisors (8) to the number of molars (12) in an adult's set of teeth, in simplest form, is:",
   "2 : 3",
   C("Simplify 8 : 12 by dividing both by their highest common factor, 4.")+
   steps("8 : 12, both divide by 4","8÷4 = 2, 12÷4 = 3","so the ratio is 2 : 3.")+
   U("Comparing 8 incisors with 12 molars gives a simplified ratio of 2 : 3."),
   [("8 : 12","8 : 12 is correct but NOT simplified; dividing by 4 gives 2 : 3."),
    ("3 : 2","Incisors (8) come first, so the ratio is 2 : 3, not 3 : 2."),
    ("4 : 6","4 : 6 still shares a factor of 2; fully simplified it is 2 : 3.")]),

 ("CQ","An item costing ₹250 is sold at a profit of 20%. The profit in rupees is:",
   "₹50",
   C("Profit = 20% of the cost price.")+
   steps("20% of 250 = (20/100) × 250","= (1/5) × 250","= ₹50.")+
   U("A 20% profit on a ₹250 item is ₹50."),
   [("₹20","₹20 is just the rate number; 20% of ₹250 is ₹50."),
    ("₹300","₹300 is the SELLING price (cost + profit); the profit itself is ₹50."),
    ("₹200","₹200 is not 20% of 250; the profit is ₹50.")]),

 ("CQ","Half of a class are boys. Written as a percentage, the boys make up:",
   "50%",
   C("Half means one out of two, which as a percentage is 50%.")+
   steps("Half = 1/2","1/2 × 100","= 50%.")+
   U("If half a class are boys, then 50% of the class are boys."),
   [("25%","25% is a quarter, not a half; half is 50%."),
    ("100%","100% would be the whole class; half is 50%."),
    ("12%","12% is far less than a half; half is 50%.")]),

 ("CQ","A 40 kg sack of grain loses 10% of its mass to spoilage. The mass lost is:",
   "4 kg",
   C("Find 10% of 40 kg.")+
   steps("10% means 1/10","1/10 of 40 = 40 ÷ 10","= 4 kg.")+
   U("A 40 kg sack that spoils by 10% has lost 4 kg."),
   [("10 kg","10 is the percentage number, not the mass; 10% of 40 kg is 4 kg."),
    ("36 kg","36 kg is the grain REMAINING; the mass lost is 4 kg."),
    ("400 kg","400 kg is far more than the whole sack; 10% of 40 kg is 4 kg.")]),

 ("CQ","The decimal 0.45 written as a percentage is:",
   "45%",
   C("Multiply a decimal by 100 to turn it into a percentage.")+
   steps("0.45 × 100","= 45","so 0.45 = 45%.")+
   U("Saying 0.45 of the marks were scored is the same as scoring 45%."),
   [("4.5%","Multiply by 100, not 10; 0.45 × 100 = 45%."),
    ("0.45%","0.45% is a hundred times too small; 0.45 = 45%."),
    ("450%","450% multiplies by 1000; 0.45 × 100 = 45%.")]),

 ("CQ","A 200 g portion of food contains 50 g of protein. The percentage of protein in the food is:",
   "25%",
   C("Percentage of protein = (mass of protein ÷ total mass) × 100.")+
   steps("Protein = 50 g, total = 200 g","(50 ÷ 200) × 100 = (1/4) × 100","= 25%.")+
   U("A 200 g meal with 50 g of protein is one-quarter protein, that is 25%."),
   [("50%","50% would be 100 g of protein; 50 g out of 200 g is 25%."),
    ("4%","4% would be 8 g of protein; 50 g of 200 g is 25%."),
    ("75%","75% would be the share that is NOT protein; the protein itself is 25%.")]),
]

items = []
for i in range(25):
    items += [NA[i], FD[i], PC[i], CQ[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=24917,
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
    split = "/".join(str(counts[c]) for c in ("NA", "PC", "FD", "CQ"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Nutrition in Animals",
                     "Physical & Chemical Changes",
                     "Fractions & Decimals",
                     "Comparing Quantities"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
