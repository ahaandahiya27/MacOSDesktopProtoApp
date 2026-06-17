# -*- coding: utf-8 -*-
# Boss Challenge Paper 12 — Nutrition in Animals · Soil · Data Handling · Exponents & Powers
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans into FUSION questions that blend a Science
# context (digestion, soil) with a Maths skill (mean/mode, standard form,
# laws of exponents). Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_12_<SHORT>_QuestionPaper.html  (pure HTML — questions + options, no answers)
#   Paper_12_<SHORT>_QuestionPaper.pdf
#   Paper_12_<SHORT>_Questions.md
#   Paper_12_<SHORT>_Solutions.html
import os, sys, shutil, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "12"
SHORT = "NutritionAnimals_Soil_DataHandling_Exponents"
TITLE = "Nutrition in Animals · Soil · Data Handling · Exponents & Powers"
LABELS = {
    "NA": "Nutrition in Animals",
    "SO": "Soil",
    "DH": "Data Handling",
    "EX": "Exponents & Powers",
}

# ---------- NUTRITION IN ANIMALS (25) — Science ----------
NA = [
 ("NA","Animals cannot make their own food and so depend on other living things; such organisms are called:",
   "heterotrophs",
   C("Heterotrophs are organisms that take in ready-made food from plants or other animals because they cannot prepare it themselves.")+
   steps("'Hetero' means other and 'troph' means feeding","So heterotrophs feed on others","All animals fall in this group.")+
   U("A lion, a cow and you are all heterotrophs eating food made first by plants."),
   [("autotrophs","Autotrophs like green plants make their own food, which animals cannot do."),
    ("producers","Producers are the green plants that make food; animals are consumers."),
    ("decomposers","Decomposers break down dead matter; not all food-eating animals are decomposers.")]),

 ("NA","The breaking down of complex food into simpler forms that the body can absorb is called:",
   "digestion",
   C("Digestion changes large, complex food pieces into small, simple substances that can pass into the blood.")+
   steps("Food eaten is too big to enter cells","The body breaks it into simple bits","These simple bits are then absorbed — this whole process is digestion.")+
   U("After a meal, digestion turns your roti into simple sugars your body can use."),
   [("egestion","Egestion is throwing out the undigested waste, not breaking food down."),
    ("absorption","Absorption is taking the simple food into blood, which happens after digestion."),
    ("ingestion","Ingestion is just taking food in through the mouth, before any breakdown.")]),

 ("NA","The teeth used mainly for biting and cutting food at the front of the mouth are the:",
   "incisors",
   C("Incisors are the flat, sharp front teeth that cut and bite pieces of food.")+
   steps("Look at the front of the mouth","The chisel-shaped flat teeth there are incisors","They cut food before the back teeth grind it.")+
   U("You use your incisors to bite cleanly into an apple."),
   [("molars","Molars are the broad back teeth used for grinding, not for biting in front."),
    ("canines","Canines are the pointed teeth used for tearing, not the cutting front teeth."),
    ("premolars","Premolars sit behind the canines and help grind, not cut at the front.")]),

 ("NA","The pointed teeth on each side, used for tearing and piercing food, are the:",
   "canines",
   C("Canines are the sharp, pointed teeth beside the incisors that tear and pierce food.")+
   steps("Move from the flat front teeth outward","The next pointed tooth is the canine","Its sharp tip tears tough food.")+
   U("A dog's long canines help it tear meat from a bone."),
   [("incisors","Incisors are the flat front teeth for cutting, not the pointed tearing ones."),
    ("molars","Molars are broad grinding teeth at the back, not pointed tearing teeth."),
    ("wisdom teeth","Wisdom teeth are the last molars; they grind rather than tear.")]),

 ("NA","The watery liquid mixed with food in the mouth that begins to digest starch is called:",
   "saliva",
   C("Saliva is made by salivary glands; it moistens food and starts breaking down starch into sugar.")+
   steps("Glands in the mouth release saliva","Saliva wets the food and contains a digestive juice","This juice begins acting on starchy food.")+
   U("Chewing rice for a while tastes slightly sweet because saliva is breaking its starch."),
   [("bile","Bile is made by the liver and acts on fats in the small intestine, not in the mouth."),
    ("mucus","Mucus protects the stomach lining; it does not begin starch digestion."),
    ("plasma","Plasma is the liquid part of blood, not a digestive juice in the mouth.")]),

 ("NA","Food is pushed down from the mouth to the stomach through a muscular tube called the:",
   "oesophagus (food pipe)",
   C("The oesophagus is the tube that carries swallowed food from the mouth down to the stomach.")+
   steps("Food is swallowed at the throat","It enters the food pipe behind the windpipe","Wave-like muscle movements push it to the stomach.")+
   U("When you swallow, the oesophagus squeezes the food down even if you are lying down."),
   [("trachea","The trachea (windpipe) carries air to the lungs, not food to the stomach."),
    ("small intestine","The small intestine comes after the stomach, not before it."),
    ("rectum","The rectum stores waste near the end of the gut, not swallowed food.")]),

 ("NA","The muscular movements of the food-pipe wall that push food forward are called:",
   "peristalsis",
   C("Peristalsis is the wave-like squeezing of the gut muscles that moves food along the digestive tract.")+
   steps("Muscles behind the food contract","Muscles ahead relax","This wave pushes the food forward, even upwards if needed.")+
   U("Peristalsis lets an astronaut swallow food normally even in weightlessness."),
   [("respiration","Respiration is releasing energy from food, not moving food along the gut."),
    ("circulation","Circulation is the flow of blood, not the pushing of food."),
    ("filtration","Filtration cleans the blood in the kidneys; it does not move food.")]),

 ("NA","The acid released in the stomach that kills germs and helps digest protein is:",
   "hydrochloric acid",
   C("The stomach makes hydrochloric acid, which kills many germs in food and creates the right conditions for protein digestion.")+
   steps("The stomach wall releases gastric juice","This juice contains hydrochloric acid","The acid kills germs and helps the protein-digesting juice work.")+
   U("This stomach acid is why most germs swallowed with food do not make you ill."),
   [("sulphuric acid","Sulphuric acid is a strong lab acid, not the one made in the stomach."),
    ("citric acid","Citric acid is found in lemons, not produced by the stomach."),
    ("carbonic acid","Carbonic acid forms in soft drinks; the stomach makes hydrochloric acid.")]),

 ("NA","Most of the absorption of digested food into the blood takes place in the:",
   "small intestine",
   C("The small intestine is where simple, digested food is absorbed into the blood through its inner wall.")+
   steps("Digestion is completed in the small intestine","Its inner wall has tiny finger-like folds","Through these the simple food passes into the blood.")+
   U("After breakfast, the sugars and other nutrients enter your blood mainly here."),
   [("stomach","The stomach mainly digests; little absorption of nutrients happens there."),
    ("large intestine","The large intestine mostly absorbs water, not the digested food."),
    ("liver","The liver makes bile and stores food; it is not where food is absorbed from the gut.")]),

 ("NA","The tiny finger-like projections in the small intestine that increase the surface for absorption are the:",
   "villi",
   C("Villi are small finger-like folds lining the small intestine that greatly increase its inner surface so more food is absorbed.")+
   steps("The inner wall is folded into many villi","This raises the area in contact with food","More area means faster, fuller absorption.")+
   U("Villi pack a huge absorbing surface into a small space, like a folded towel."),
   [("alveoli","Alveoli are tiny air sacs in the lungs, not folds in the intestine."),
    ("cilia","Cilia are hair-like structures, for example in the windpipe, not absorbing folds."),
    ("nephrons","Nephrons are filtering units in the kidney, not in the intestine.")]),

 ("NA","Bile, which helps in the digestion of fats, is made by the:",
   "liver",
   C("The liver makes bile, a juice that breaks large fat drops into tiny ones so they are easier to digest.")+
   steps("The liver produces bile","Bile is stored in the gall bladder","It is released into the small intestine to act on fats.")+
   U("A fatty meal needs plenty of bile from the liver to be digested smoothly."),
   [("pancreas","The pancreas makes digestive juices too, but bile comes from the liver."),
    ("stomach","The stomach makes acid and gastric juice, not bile."),
    ("kidney","The kidney filters blood to make urine; it does not make bile.")]),

 ("NA","Water from the undigested food is mainly absorbed back into the body in the:",
   "large intestine",
   C("The large intestine absorbs most of the remaining water from the undigested waste, leaving semi-solid faeces.")+
   steps("Undigested food reaches the large intestine watery","Its wall soaks up most of the water","The leftover becomes semi-solid waste.")+
   U("Too little water absorbed here causes loose motions; too much causes constipation."),
   [("small intestine","The small intestine absorbs digested food; the large intestine reclaims water."),
    ("oesophagus","The oesophagus only carries food down; it absorbs neither food nor water."),
    ("mouth","The mouth begins digestion; it does not absorb water from waste.")]),

 ("NA","Removal of the undigested, solid waste from the body through the anus is called:",
   "egestion",
   C("Egestion is the throwing out of the undigested solid waste from the body.")+
   steps("Some food cannot be digested","It moves to the end of the gut","It is pushed out through the anus — this is egestion.")+
   U("Going to the toilet to pass stool is the egestion step of digestion."),
   [("digestion","Digestion breaks food down; egestion removes what is left undigested."),
    ("absorption","Absorption takes simple food into blood; egestion removes solid waste."),
    ("excretion","Excretion removes waste like urine made inside cells, not undigested food.")]),

 ("NA","Grass-eating animals like the cow that quickly swallow grass and later chew the cud are called:",
   "ruminants",
   C("Ruminants are grass-eaters that first swallow food into a special stomach part and later bring it back to chew slowly as cud.")+
   steps("The cow swallows grass fast into the rumen","Later it returns the partly digested grass to the mouth","It chews this cud again to digest the tough grass.")+
   U("You can see a resting cow steadily chewing cud long after it has stopped grazing."),
   [("carnivores","Carnivores eat meat and do not chew cud."),
    ("omnivores","Omnivores eat both plants and animals but are not all cud-chewers."),
    ("decomposers","Decomposers break down dead matter; they are not cud-chewing grazers.")]),

 ("NA","In ruminants, the swallowed grass that is returned to the mouth to be chewed again is called the:",
   "cud",
   C("Cud is the partly digested grass that a ruminant brings back from its stomach to chew once more.")+
   steps("Grass is stored in the rumen","It softens there a while","It comes back as cud for slow, proper chewing.")+
   U("The slow side-to-side jaw movement of a cow is it grinding down its cud."),
   [("bile","Bile is a fat-digesting juice from the liver, not returned grass."),
    ("saliva","Saliva is the watery mouth juice, not the food brought back to chew."),
    ("rennet","Rennet is used to set milk into curd; it is not the chewed-again grass.")]),

 ("NA","Tiny one-celled Amoeba captures its food using finger-like extensions called:",
   "pseudopodia",
   C("Amoeba pushes out pseudopodia (false feet) to surround and trap a food particle.")+
   steps("Amoeba senses a food particle","It pushes out pseudopodia around it","The food is trapped inside and a food vacuole forms.")+
   U("Under a microscope you can watch an amoeba flow its pseudopodia around its prey."),
   [("villi","Villi are absorbing folds in our intestine, not parts of an amoeba."),
    ("cilia","Cilia are tiny beating hairs; amoeba uses pseudopodia, not cilia, to feed."),
    ("tentacles","Tentacles belong to animals like the hydra, not to the amoeba.")]),

 ("NA","Inside Amoeba, the food it has trapped is digested within a:",
   "food vacuole",
   C("After capturing food, Amoeba digests it inside a small bag-like space called a food vacuole.")+
   steps("Pseudopodia surround the food","A food vacuole forms around it","Digestive juices inside the vacuole break the food down.")+
   U("The food vacuole is the amoeba's tiny private 'stomach' for one meal."),
   [("stomach","An amoeba is a single cell and has no stomach; it uses a food vacuole."),
    ("gizzard","A gizzard is a grinding organ in birds, not a part of an amoeba."),
    ("rumen","The rumen is a cow's stomach part, not found in a one-celled amoeba.")]),

 ("NA","The broad, flat back teeth used for grinding and chewing food are the:",
   "molars",
   C("Molars are the wide, flat teeth at the back of the mouth that crush and grind food.")+
   steps("Food cut by the front teeth moves back","The broad molars press and grind it","This makes a soft paste easy to swallow.")+
   U("You feel your molars working hard when you chew a tough piece of chana."),
   [("incisors","Incisors are the flat front cutting teeth, not the broad grinding ones."),
    ("canines","Canines are pointed tearing teeth, not flat grinders."),
    ("milk teeth","Milk teeth are the first set of a child's teeth, not a grinding type.")]),

 ("NA","The first set of teeth that appear in young children and later fall out are called:",
   "milk teeth",
   C("Milk teeth are the first temporary set of teeth in children; they later fall out and are replaced by permanent teeth.")+
   steps("A baby grows its first set of teeth","These are the milk teeth","Around age six they begin to fall and permanent teeth grow.")+
   U("A child losing a front milk tooth soon grows a bigger permanent one in its place."),
   [("wisdom teeth","Wisdom teeth are the last permanent molars, not the first baby set."),
    ("permanent teeth","Permanent teeth are the second, lasting set, not the ones that fall out."),
    ("canine teeth","Canines are a type of tooth, not the name for the first temporary set.")]),

 ("NA","The muscular organ in the mouth that mixes food with saliva and helps in tasting is the:",
   "tongue",
   C("The tongue moves food around to mix it with saliva, helps in swallowing, and senses taste.")+
   steps("The tongue rolls food between the teeth","It mixes the food with saliva","Taste buds on it sense sweet, sour, salty and bitter.")+
   U("Your tongue lets you taste sweetness and also pushes food back to swallow it."),
   [("epiglottis","The epiglottis is a flap that covers the windpipe while swallowing, not the taster."),
    ("uvula","The uvula hangs at the back of the throat; it does not mix food or taste."),
    ("gall bladder","The gall bladder stores bile and is not in the mouth.")]),

 ("NA","Animals such as snakes that feed only on other animals are called:",
   "carnivores",
   C("Carnivores are animals that eat the flesh of other animals as their food.")+
   steps("Some animals eat only meat","They hunt or scavenge other animals","Such flesh-eaters are carnivores.")+
   U("A tiger is a carnivore because it feeds on the animals it hunts."),
   [("herbivores","Herbivores eat only plants, not other animals."),
    ("omnivores","Omnivores eat both plants and animals, not only animals."),
    ("autotrophs","Autotrophs make their own food and do not eat at all.")]),

 ("NA","Bile released by the liver is stored, before use, in a small sac called the:",
   "gall bladder",
   C("The gall bladder stores the bile made by the liver and releases it into the small intestine when fatty food arrives.")+
   steps("The liver keeps making bile","Bile is stored in the gall bladder","It is squeezed out into the intestine when needed.")+
   U("After a rich, oily meal the gall bladder releases stored bile to help digest the fat."),
   [("pancreas","The pancreas makes its own juice but does not store bile."),
    ("appendix","The appendix is a small pouch near the large intestine; it does not store bile."),
    ("spleen","The spleen helps with blood; it does not store bile.")]),

 ("NA","An animal like a human that eats both plants and other animals is called an:",
   "omnivore",
   C("Omnivores get their food from both plant and animal sources.")+
   steps("Some animals eat plant food","The same animals also eat animal food","Such mixed feeders are omnivores.")+
   U("People who eat both vegetables and meat are omnivores."),
   [("herbivore","A herbivore eats only plants, not a mix of plants and animals."),
    ("carnivore","A carnivore eats only other animals, not plants too."),
    ("scavenger","A scavenger feeds on dead animals; that is not the same as eating both groups.")]),

 ("NA","The process of taking food into the body through the mouth is called:",
   "ingestion",
   C("Ingestion is the very first step of nutrition — taking food in through the mouth.")+
   steps("Food is brought to the mouth","It is taken inside the body","This taking-in step is ingestion.")+
   U("Biting and putting a piece of fruit into your mouth is the ingestion step."),
   [("digestion","Digestion is breaking the food down, which comes after taking it in."),
    ("absorption","Absorption is passing simple food into blood, much later than ingestion."),
    ("assimilation","Assimilation is using the absorbed food in the body, the final step.")]),

 ("NA","The opening at the end of the digestive tract through which faeces leave the body is the:",
   "anus",
   C("The anus is the final opening of the food canal through which the solid waste (faeces) is removed.")+
   steps("Undigested waste collects near the end of the gut","It is stored in the rectum","It leaves the body through the anus.")+
   U("The faeces stored in the rectum are passed out through the anus during egestion."),
   [("mouth","The mouth takes food in; the anus lets solid waste out."),
    ("oesophagus","The oesophagus carries food down to the stomach; it is not the exit for waste."),
    ("nostril","The nostril is part of breathing, not of removing solid food waste.")]),
]

# ---------- SOIL (25) — Science ----------
SO = [
 ("SO","The loose, top layer of the Earth's surface in which plants grow is called:",
   "soil",
   C("Soil is the thin, loose covering on the land in which plants put down their roots and grow.")+
   steps("Rocks slowly break into tiny bits","These bits mix with rotted plant and animal matter","Together they make the loose layer we call soil.")+
   U("The garden where you plant seeds is a layer of soil over the harder rock below."),
   [("humus","Humus is only the rotted-matter part of soil, not the whole layer."),
    ("clay","Clay is one kind of soil particle, not the entire top layer."),
    ("bedrock","Bedrock is the solid rock deep below the soil, not the loose top layer.")]),

 ("SO","The slow breaking down of rocks into tiny particles that helps form soil is called:",
   "weathering",
   C("Weathering is the gradual breaking of rocks into smaller and smaller pieces by sun, water, wind and living things.")+
   steps("Rocks heat and cool, and water seeps in","Cracks widen and pieces break off","Over a very long time this makes the fine particles of soil.")+
   U("Cracked rocks on a hillside slowly weathering are the first step in making new soil."),
   [("erosion","Erosion carries soil away; weathering is the breaking of rock that makes it."),
    ("evaporation","Evaporation turns water to vapour; it does not break rocks into soil."),
    ("percolation","Percolation is water sinking through soil, not the breaking of rock.")]),

 ("SO","A cut section showing the different layers of soil from the surface down is called the:",
   "soil profile",
   C("A soil profile is the side view of the soil layers, called horizons, arranged from the top down to the bedrock.")+
   steps("Dig deep and look at the side wall of the pit","You see bands of different colour and texture","This arrangement of layers is the soil profile.")+
   U("The colour bands you see in a roadside cutting are the soil profile of that place."),
   [("soil texture","Texture describes how coarse or fine the particles feel, not the layers."),
    ("humus layer","The humus layer is just the dark top part, not the whole set of layers."),
    ("water table","The water table is the underground level of water, not the layered profile.")]),

 ("SO","The dark, rotted remains of dead plants and animals that make the topsoil fertile is called:",
   "humus",
   C("Humus is the dark material formed from decayed plant and animal matter; it makes the topsoil rich in nutrients.")+
   steps("Dead leaves and animals fall on the soil","Tiny organisms rot them down","The dark, nutrient-rich remains are humus.")+
   U("A forest floor's dark, crumbly top layer is full of humus that feeds the trees."),
   [("clay","Clay is a mineral particle, not the rotted remains of living things."),
    ("gravel","Gravel is small stones, not decayed organic matter."),
    ("sand","Sand is large mineral grains, not rotted plant and animal matter.")]),

 ("SO","The uppermost soil layer, dark and rich in humus where most roots grow, is called the:",
   "topsoil",
   C("Topsoil is the top horizon, usually dark and full of humus, where plant roots and many small creatures live.")+
   steps("It is the layer right at the surface","It holds the most humus and minerals","Most roots and soil animals are found here.")+
   U("Farmers protect their topsoil because it is the layer that feeds the crops."),
   [("subsoil","Subsoil lies below the topsoil and is harder and poorer in humus."),
    ("bedrock","Bedrock is the solid rock at the very bottom, not the rich top layer."),
    ("parent rock","Parent rock is the broken rock near the bottom, not the dark surface soil.")]),

 ("SO","Soil that has the largest particles, lets water drain very fast and feels gritty is:",
   "sandy soil",
   C("Sandy soil is made of large particles with big gaps, so water drains through it quickly and it holds little water.")+
   steps("The particles are large with wide gaps","Water flows through the gaps easily","So sandy soil drains fast and dries quickly.")+
   U("A desert is mostly sandy soil, which is why rainwater sinks away so fast there."),
   [("clayey soil","Clayey soil has the smallest particles and holds water, the opposite of sandy."),
    ("loamy soil","Loamy soil is a balanced mix; it drains moderately, not very fast."),
    ("humus","Humus is rotted organic matter, not a soil type defined by particle size.")]),

 ("SO","Soil made of the smallest particles, which holds a lot of water and feels sticky when wet, is:",
   "clayey soil",
   C("Clayey soil has very fine particles packed closely, leaving tiny gaps that trap water, so it holds water well and drains slowly.")+
   steps("The particles are very small and packed tight","Water cannot pass quickly through the tiny gaps","So clayey soil holds water and feels sticky when wet.")+
   U("Potters use clayey soil because it holds together and keeps its shape when wet."),
   [("sandy soil","Sandy soil has large particles and drains fast, unlike water-holding clay."),
    ("loamy soil","Loamy soil is a balanced mix, not the finest, stickiest soil."),
    ("gravel","Gravel is made of small stones, far larger than fine clay particles.")]),

 ("SO","The soil considered best for growing most crops, a balanced mixture of sand, clay and humus, is:",
   "loamy soil",
   C("Loamy soil mixes sand, clay and humus in good proportion, so it drains well yet holds enough water and nutrients for crops.")+
   steps("It has some large sandy particles for drainage","Some fine clay particles to hold water","And humus for nutrients — a balance ideal for crops.")+
   U("Farmers prize loamy soil because most vegetables and grains grow well in it."),
   [("sandy soil","Sandy soil drains too fast and holds too little water for most crops."),
    ("clayey soil","Clayey soil holds too much water and can choke roots of many crops."),
    ("rocky soil","Rocky soil is full of stones and is poor for growing most crops.")]),

 ("SO","The downward movement of water through the soil is measured as the rate of:",
   "percolation",
   C("Percolation is how fast water sinks down through the soil; sandy soil has a high rate and clayey soil a low rate.")+
   steps("Pour water on top of the soil","Time how fast it sinks down","This speed is the percolation rate.")+
   U("A garden of sandy soil percolates fast, so it needs watering more often."),
   [("evaporation","Evaporation is water leaving the surface as vapour, not sinking down."),
    ("weathering","Weathering is the breaking of rock, not the sinking of water."),
    ("erosion","Erosion is the carrying away of soil, not the downward flow of water.")]),

 ("SO","Among sandy, clayey and loamy soils, the highest rate of water percolation is shown by:",
   "sandy soil",
   C("Because sandy soil has large particles and wide gaps, water sinks through it fastest, giving the highest percolation rate.")+
   steps("Compare the gaps between particles","Sandy soil has the widest gaps","So water percolates through it the fastest.")+
   U("Rainwater disappears quickly from sandy ground but stays as puddles on clay."),
   [("clayey soil","Clayey soil has the tiniest gaps, so it percolates slowest, not fastest."),
    ("loamy soil","Loamy soil percolates at a middle rate, slower than pure sandy soil."),
    ("all are equal","Particle size differs, so the rates are not equal; sandy is the fastest.")]),

 ("SO","The removal of the fertile topsoil by wind or flowing water is called soil:",
   "erosion",
   C("Soil erosion is the carrying away of the loose topsoil by wind or running water, which leaves the land poor for farming.")+
   steps("Wind or fast water moves over bare soil","It picks up and carries the loose top layer","The fertile topsoil is lost — this is erosion.")+
   U("Heavy rain on a bare hillside washes away topsoil, an example of soil erosion."),
   [("percolation","Percolation is water sinking into soil, not the soil being carried away."),
    ("weathering","Weathering breaks rock into soil; erosion removes the soil already formed."),
    ("pollution","Pollution is the adding of harmful matter, not the removal of topsoil.")]),

 ("SO","Planting trees and grass on bare land mainly helps the soil by:",
   "holding the soil and preventing erosion",
   C("Plant roots grip the soil and their cover slows wind and water, so the topsoil is held in place and erosion is reduced.")+
   steps("Roots bind the soil particles together","Leaves break the force of rain and wind","So the topsoil is held and erosion is prevented.")+
   U("Forests on hill slopes hold the soil and stop landslides during heavy rain."),
   [("making the soil drain faster","Plants slow water flow; they do not speed up drainage to protect soil."),
    ("turning sand into clay","Plants cannot change the particle size of the soil."),
    ("removing all humus","Plants add humus through fallen leaves; they do not remove it.")]),

 ("SO","Adding too much fertiliser, plastic and harmful chemicals to the land causes soil:",
   "pollution",
   C("Soil pollution is the adding of harmful substances like excess chemicals and plastic that damage the soil and the life in it.")+
   steps("Harmful chemicals and waste reach the soil","They poison the tiny soil organisms","The soil becomes unhealthy — this is soil pollution.")+
   U("Plastic bags buried in the ground stay for years and cause soil pollution."),
   [("erosion","Erosion is topsoil being carried away, not harmful matter being added."),
    ("weathering","Weathering is the natural breaking of rock, not pollution by chemicals."),
    ("percolation","Percolation is water sinking through soil, not soil being polluted.")]),

 ("SO","Which type of soil is most suitable for growing paddy (rice), which needs standing water?",
   "clayey soil",
   C("Paddy needs the field to hold water for a long time, and clayey soil holds water well, so it suits rice best.")+
   steps("Rice fields must stay flooded","Clayey soil holds water and drains slowly","So clayey soil keeps the field wet enough for paddy.")+
   U("Rice is grown in clayey, water-holding fields kept flooded for weeks."),
   [("sandy soil","Sandy soil drains too fast and cannot keep a rice field flooded."),
    ("loamy soil","Loamy soil drains moderately; for standing water clay is better suited."),
    ("rocky soil","Rocky soil cannot hold the standing water that paddy needs.")]),

 ("SO","The soil layer just below the topsoil, harder and containing little humus, is called the:",
   "subsoil",
   C("Subsoil lies under the topsoil; it is harder, lighter in colour and poorer in humus, with more minerals washed down from above.")+
   steps("Below the dark topsoil is a paler layer","It has little humus and is more compact","This layer is the subsoil.")+
   U("Deep roots of big trees reach down into the firmer subsoil for support."),
   [("topsoil","Topsoil is the dark, humus-rich surface layer above the subsoil."),
    ("bedrock","Bedrock is the solid rock at the very bottom, below the subsoil."),
    ("humus","Humus is decayed matter mainly in the topsoil, not a buried hard layer.")]),

 ("SO","The hard, solid rock found at the bottom of the soil profile is called the:",
   "bedrock",
   C("Bedrock is the unbroken solid rock at the base of the soil profile, beneath all the soil layers.")+
   steps("Below the topsoil and subsoil is broken rock","Below that is the solid, unbroken rock","This deepest hard layer is the bedrock.")+
   U("Builders dig down to the firm bedrock to lay the strong foundation of a tall tower."),
   [("topsoil","Topsoil is the loose, fertile surface layer, not the hard base."),
    ("humus","Humus is decayed matter in the topsoil, not solid rock at the bottom."),
    ("loam","Loam is a soil mixture near the surface, not the deep solid rock.")]),

 ("SO","Earthworms and tiny burrowing animals help the soil mainly by:",
   "making it loose and airy so water and air pass through",
   C("Earthworms tunnel through the soil, loosening it and making channels through which air and water can move to the roots.")+
   steps("Earthworms burrow through the soil","Their tunnels let air and water in","Loose, airy soil helps roots breathe and grow.")+
   U("Gardeners welcome earthworms because they keep the soil loose and healthy."),
   [("making it harder and packed","Earthworms loosen the soil; they do not pack it harder."),
    ("removing all its water","They help water move through, not remove all of it."),
    ("turning it into bedrock","Earthworms cannot turn loose soil into solid rock.")]),

 ("SO","The amount of water that a soil can hold after the extra has drained away is called its water:",
   "retention",
   C("Water retention (holding capacity) is how much water a soil keeps for plants once the surplus has drained off.")+
   steps("Pour water on the soil and let extra drain","Some water stays held in the tiny gaps","That held amount is the soil's water retention.")+
   U("Clayey soil's high water retention lets crops survive a few days without rain."),
   [("percolation","Percolation is how fast water sinks through, not how much is kept."),
    ("evaporation","Evaporation is water leaving as vapour, not water held by the soil."),
    ("erosion","Erosion is soil being carried away, not water being held.")]),

 ("SO","Clayey soil holds more water than sandy soil mainly because clay has:",
   "smaller particles with tinier gaps that trap water",
   C("Clay's very small particles pack tightly, leaving tiny gaps that hold water by attraction, so it retains more water than coarse sand.")+
   steps("Clay particles are very small","They pack close, leaving tiny gaps","Water is trapped in these tiny gaps, so clay holds more.")+
   U("After rain, a clay field stays wet long after a sandy field has dried out."),
   [("larger particles with wide gaps","Wide gaps drain water away; that describes sandy soil, which holds less."),
    ("more stones in it","Stones do not store water; it is the fine particles that hold it."),
    ("no gaps at all","There are tiny gaps in clay; those very gaps trap the water.")]),

 ("SO","Plants depend on soil mainly to provide them with anchorage and with:",
   "water and minerals",
   C("Soil holds the roots firmly (anchorage) and supplies the water and dissolved minerals the plant needs to grow.")+
   steps("Roots grip the soil for support","Soil holds water around the roots","Roots absorb this water with dissolved minerals.")+
   U("A potted plant wilts if its soil runs out of the water and minerals it supplies."),
   [("light for photosynthesis","Light comes from the Sun, not from the soil."),
    ("oxygen for the leaves","Leaves get gases from the air, not from the soil."),
    ("ready-made food","Soil supplies raw materials; the plant makes its own food in the leaves.")]),

 ("SO","Which property of soil decides how easily roots can push through and breathe in it?",
   "how loose and airy (well-aerated) the soil is",
   C("Loose, well-aerated soil has air spaces that let roots grow easily and take in the oxygen they need.")+
   steps("Loose soil has many air gaps","Roots push through the gaps easily","Air in the gaps lets the roots breathe.")+
   U("Gardeners loosen packed soil with a fork so roots can spread and breathe."),
   [("its colour","Colour hints at humus content but does not decide how roots push and breathe."),
    ("its smell","Smell does not control how easily roots grow through the soil."),
    ("its name","The name of a soil does not affect how roots move through it.")]),

 ("SO","A simple way to judge a soil's texture (sandy, clayey or loamy) is to:",
   "feel and rub a moist sample between the fingers",
   C("Rubbing a wet pinch of soil between the fingers tells texture: sandy feels gritty, clayey feels smooth and sticky, loamy feels in between.")+
   steps("Take a moist pinch of the soil","Rub it between your fingers","Gritty means sandy, sticky means clayey, in-between means loamy.")+
   U("A farmer quickly judges a field's soil by rubbing a damp lump between finger and thumb."),
   [("weigh it on a balance","Weight alone does not reveal whether soil is sandy, clayey or loamy."),
    ("smell it from far","Smell from a distance cannot tell the particle texture."),
    ("look at its colour only","Colour is a weak clue; the feel of the rubbed soil tells texture far better.")]),

 ("SO","The constant cover of growing plants protects soil chiefly because their leaves and roots:",
   "slow the rain and bind the soil, reducing erosion",
   C("A plant cover breaks the force of falling rain and the roots tie the soil together, so far less topsoil is washed or blown away.")+
   steps("Leaves catch the rain and lessen its impact","Roots bind the soil particles","So the topsoil stays put and erosion drops.")+
   U("A grassy slope loses little soil in a storm, unlike the bare slope beside it."),
   [("make the soil drain faster","Plant cover does not protect soil by speeding drainage."),
    ("add stones to the soil","Plants do not add stones; roots simply bind the existing soil."),
    ("stop weathering of rocks","Weathering of deep rock is not what plant cover prevents; it prevents erosion.")]),

 ("SO","If equal water is poured into a sandy and a clayey sample, the sandy sample will:",
   "let the water drain out faster",
   C("Sandy soil's large gaps let water pass through quickly, so the same amount of water drains out of it faster than out of clay.")+
   steps("Sand has wide gaps, clay has tiny gaps","Water moves quickly through wide gaps","So the sandy sample drains the water out first.")+
   U("This is why a sandy pot dries out far sooner than a clay pot after watering."),
   [("hold the water longer","Holding water longer describes clayey soil, not sandy soil."),
    ("turn the water into vapour","The water drains down; it is not turned into vapour by the soil."),
    ("not let any water pass","Sandy soil lets water pass very easily, not block it.")]),

 ("SO","In a percolation test, 200 mL of water drained through a soil sample in 20 minutes. The percolation rate is:",
   "10 mL per minute",
   C("Percolation rate is the volume of water that passes through in one minute, found by dividing the volume by the time.")+
   steps("Rate = volume ÷ time","= 200 mL ÷ 20 minutes","= 10 mL per minute.")+
   U("Students compare soils by measuring how many millilitres percolate each minute."),
   [("200 mL per minute","200 mL is the total water, not the amount per minute; divide by the 20 minutes."),
    ("20 mL per minute","20 is the number of minutes, not the rate; 200 ÷ 20 = 10."),
    ("4000 mL per minute","Multiplying volume by time is wrong; the rate is volume ÷ time = 10.")]),
]

# ---------- DATA HANDLING (25) — Maths ----------
DH = [
 ("DH","To work out the mean of several readings, the correct step is to:",
   "divide the sum of the readings by how many there are",
   C("The mean is the total of all the values shared equally, so you add them and divide by the count.")+
   steps("Add up all the readings","Count how many readings there are","Mean = sum ÷ count.")+
   U("Your average test score is the total of your marks divided by the number of tests."),
   [("adding the numbers only","The sum alone is not the average; you must divide by the count."),
    ("multiplying all the numbers","Multiplying gives a product, not the mean."),
    ("picking the largest number","The largest value is the maximum, not the average.")]),

 ("DH","The mean of the numbers 4, 6 and 8 is:",
   "6",
   C("Add the numbers and divide by how many there are.")+
   steps("Sum = 4 + 6 + 8 = 18","Count = 3","Mean = 18 ÷ 3 = 6.")+
   U("Averaging three daily temperatures works exactly like this."),
   [("18","18 is the sum of the numbers, not their average."),
    ("8","8 is the largest value, not the mean."),
    ("3","3 is the count of numbers, not their average.")]),

 ("DH","The value that appears most often in a data set is called the:",
   "mode",
   C("The mode is the observation that occurs the greatest number of times in the data.")+
   steps("List how often each value appears","Find the one that appears most","That most frequent value is the mode.")+
   U("The shoe size a shop sells most often — its mode — is the size it stocks heavily."),
   [("mean","The mean is the average, not the most frequent value."),
    ("median","The median is the middle value when ordered, not the most frequent."),
    ("range","The range is the spread, not the value that repeats most.")]),

 ("DH","The mode of the data 2, 3, 3, 5, 3, 7 is:",
   "3",
   C("The mode is the value that occurs most often; here 3 appears three times, more than any other.")+
   steps("Count each: 3 appears three times","Other numbers appear once","So the mode is 3.")+
   U("If most students score 3 out of 10, then 3 is the mode of the class marks."),
   [("7","7 is the largest value, not the most frequent one."),
    ("2","2 appears only once; the mode 3 appears three times."),
    ("5","5 appears only once, so it is not the mode.")]),

 ("DH","When data values are arranged in order, the middle value is called the:",
   "median",
   C("The median is the central value once the data is put in increasing (or decreasing) order.")+
   steps("Arrange the values in order","Find the value exactly in the middle","That middle value is the median.")+
   U("To find a 'typical' price, lining up prices and taking the middle one gives the median."),
   [("mode","The mode is the most frequent value, not necessarily the middle one."),
    ("mean","The mean is the average, found by adding and dividing, not by position."),
    ("range","The range is the difference between the largest and smallest values.")]),

 ("DH","The median of the ordered data 3, 5, 7, 9, 11 is:",
   "7",
   C("With five values in order, the median is the third (middle) one.")+
   steps("There are 5 values, already in order","The middle position is the 3rd","The 3rd value is 7, so the median is 7.")+
   U("Among five lined-up runners' times, the middle time is the median time."),
   [("5","5 is the second value, not the middle of five values."),
    ("11","11 is the largest value, not the middle one."),
    ("9","9 is the fourth value; the middle of five is the third, which is 7.")]),

 ("DH","The difference between the highest and the lowest value in a data set is called the:",
   "range",
   C("The range measures the spread of data as the highest value minus the lowest value.")+
   steps("Find the largest value","Find the smallest value","Range = largest − smallest.")+
   U("The day's temperature range is the highest reading minus the lowest reading."),
   [("mean","The mean is the average, not the gap between extremes."),
    ("mode","The mode is the most frequent value, not the spread."),
    ("median","The median is the middle value, not the difference of the extremes.")]),

 ("DH","For the data 12, 7, 20, 5, 16 the range is:",
   "15",
   C("Range = highest value − lowest value.")+
   steps("Highest = 20, lowest = 5","Range = 20 − 5","= 15.")+
   U("If the coldest day was 5°C and the hottest 20°C, the range is 15°C."),
   [("20","20 is the highest value, not the range."),
    ("25","Adding 20 and 5 is wrong; the range is their difference, 15."),
    ("5","5 is the lowest value, not the difference between the extremes.")]),

 ("DH","A graph that shows information using pictures or symbols to stand for a number is called a:",
   "pictograph",
   C("A pictograph uses a picture or symbol, each standing for a fixed number, to show data in a simple, visual way.")+
   steps("Choose a symbol to stand for a number","Draw that many symbols for each item","More symbols mean a larger value.")+
   U("A chart using one apple-picture for 10 apples sold is a pictograph."),
   [("bar graph","A bar graph uses bars of different heights, not repeated symbols."),
    ("pie chart","A pie chart shows parts of a whole as slices, not repeated pictures."),
    ("line graph","A line graph joins points with a line; it does not use picture symbols.")]),

 ("DH","A graph that uses rectangular bars of equal width to compare quantities is a:",
   "bar graph",
   C("A bar graph shows data as bars of equal width whose heights (or lengths) stand for the values, making them easy to compare.")+
   steps("Each item gets a bar of equal width","The bar's height shows its value","Taller bars mean larger quantities.")+
   U("A bar graph of marks in each subject lets you see at a glance which is highest."),
   [("pictograph","A pictograph uses repeated symbols, not solid bars of equal width."),
    ("pie chart","A pie chart uses slices of a circle, not upright bars."),
    ("histogram of curves","Curves are for line graphs; a bar graph uses straight-sided bars.")]),

 ("DH","Marks are recorded as ||||  (four strokes) with the fifth stroke crossing them. These marks are called:",
   "tally marks",
   C("Tally marks count items quickly: each count is one stroke, and the fifth stroke is drawn across the previous four to make a group of five.")+
   steps("Draw one stroke for each item","On the fifth, cross the previous four","Groups of five make counting easy.")+
   U("A teacher counting raised hands with crossed groups of five is using tally marks."),
   [("bar marks","'Bar marks' is not a counting method; grouped strokes are tally marks."),
    ("decimal points","Decimal points separate whole and fractional parts, not counts."),
    ("Roman numerals","Roman numerals are a number system, not the stroke-counting method.")]),

 ("DH","A graph comparing two sets of data side by side using paired bars is called a:",
   "double bar graph",
   C("A double bar graph draws two bars side by side for each item, so two data sets (for example, boys and girls) can be compared together.")+
   steps("For each item draw two bars together","One bar for each data set","Compare the paired bars across items.")+
   U("A double bar graph of boys' and girls' marks shows both groups for every subject at once."),
   [("single bar graph","A single bar graph shows only one data set, not two side by side."),
    ("pictograph","A pictograph uses symbols and is not the paired-bar comparison graph."),
    ("pie chart","A pie chart splits one whole into slices; it does not pair two data sets as bars.")]),

 ("DH","When a coin is tossed once, the probability of getting a head is:",
   "1/2",
   C("A coin has two equally likely outcomes, head or tail, so the chance of a head is one out of two.")+
   steps("Possible outcomes: head, tail (2 of them)","Favourable outcome: head (1)","Probability = 1 ÷ 2 = 1/2.")+
   U("Tossing a coin to choose who bats first gives each side a 1/2 chance."),
   [("1","A probability of 1 would mean a head is certain, but a tail is also possible."),
    ("2","Probability is never more than 1; a chance cannot be 2."),
    ("0","A probability of 0 would mean a head is impossible, which is false.")]),

 ("DH","When an ordinary dice is rolled once, the probability of getting the number 4 is:",
   "1/6",
   C("A dice has six equally likely faces, so any one chosen number has a one-in-six chance.")+
   steps("Possible outcomes: 1,2,3,4,5,6 (6 of them)","Favourable outcome: just the 4 (1)","Probability = 1 ÷ 6 = 1/6.")+
   U("In a board game, the chance of rolling the exact 4 you need is 1/6."),
   [("1/4","The 4 is one of six faces, not one of four; the chance is 1/6."),
    ("4/6","Only one face shows 4, so the favourable count is 1, giving 1/6."),
    ("1/2","1/2 is the chance for a coin's head, not for one face of a six-faced dice.")]),

 ("DH","In a pictograph, one symbol stands for 5 books. To show 35 books, the number of symbols drawn is:",
   "7",
   C("Divide the total by the number each symbol stands for to find how many symbols to draw.")+
   steps("Each symbol = 5 books","Symbols needed = 35 ÷ 5","= 7 symbols.")+
   U("Designing a reading-chart, you draw 7 book-symbols to show 35 books read."),
   [("35","35 is the number of books, not the number of symbols at 5 each."),
    ("5","5 is what one symbol stands for, not the number of symbols needed."),
    ("30","30 ÷ 5 = 6 would show only 30 books; for 35 you need 7 symbols.")]),

 ("DH","Over five days a plant grew 2, 4, 3, 5 and 6 cm. Its average daily growth was:",
   "4 cm",
   C("The average growth is the total growth shared equally over the days.")+
   steps("Total = 2 + 4 + 3 + 5 + 6 = 20 cm","Number of days = 5","Average = 20 ÷ 5 = 4 cm.")+
   U("A gardener tracks 'average growth per day' to compare how well two plants are doing."),
   [("20 cm","20 cm is the total growth over all five days, not the daily average."),
    ("6 cm","6 cm is the largest single day's growth, not the average."),
    ("5 cm","5 cm is one day's growth, not the mean of all five.")]),

 ("DH","A weather record shows rainfall (mm) on four days as 10, 20, 15 and 15. The mean daily rainfall is:",
   "15 mm",
   C("Add the four rainfall amounts and divide by 4 to find the mean.")+
   steps("Sum = 10 + 20 + 15 + 15 = 60","Count = 4 days","Mean = 60 ÷ 4 = 15 mm.")+
   U("Weather reports quote 'average rainfall' worked out exactly this way."),
   [("60 mm","60 mm is the total rainfall over the four days, not the mean."),
    ("20 mm","20 mm is the wettest day's rainfall, not the average."),
    ("4 mm","4 is the number of days, not the mean rainfall.")]),

 ("DH","The leaves on six plants were counted as 5, 8, 8, 8, 10 and 6. The most common (mode) number of leaves is:",
   "8",
   C("The mode is the value that appears most often; 8 occurs three times here, more than any other.")+
   steps("Count each value: 8 appears three times","No other value repeats that often","So the mode is 8.")+
   U("A scientist reports the 'most common' count, the mode, when describing a sample of plants."),
   [("10","10 is the largest count, but it appears only once, so it is not the mode."),
    ("5","5 appears only once; the mode 8 appears three times."),
    ("6","6 appears only once, so it cannot be the mode.")]),

 ("DH","To compare the number of trees planted by boys and by girls in each of four years, the best graph is a:",
   "double bar graph",
   C("Two related data sets across the same categories are best shown by a double bar graph, with paired bars for each year.")+
   steps("There are two groups: boys and girls","The same four years apply to both","Paired bars per year make a double bar graph the clearest choice.")+
   U("School reports use a double bar graph to show two groups' figures over several years together."),
   [("single bar graph","A single bar graph shows just one group, not boys and girls together."),
    ("pictograph for one group","A pictograph for one group would not let you compare both at once."),
    ("line of best fit","A line of best fit is not part of Class 7 data handling for this comparison.")]),

 ("DH","If the mean of three numbers is 10, then the sum of the three numbers is:",
   "30",
   C("Mean = sum ÷ count, so the sum is the mean multiplied by the count.")+
   steps("Mean = 10 and count = 3","Sum = mean × count","= 10 × 3 = 30.")+
   U("Knowing the average and how many values lets you recover the total this way."),
   [("10","10 is the mean, not the sum of the three numbers."),
    ("3","3 is the count of numbers, not their sum."),
    ("13","Adding the mean and the count is wrong; multiply to get the sum, 30.")]),

 ("DH","The chance of an event that is certain to happen (like the Sun rising) is written as a probability of:",
   "1",
   C("An event that is sure to happen has the highest probability, which is 1.")+
   steps("All outcomes favour a certain event","Favourable ÷ total = total ÷ total","= 1, the probability of certainty.")+
   U("Saying an event 'will surely happen' means its probability is 1."),
   [("0","A probability of 0 means impossible, the opposite of certain."),
    ("1/2","1/2 is an even chance, not certainty."),
    ("100","Probability is at most 1; it is not written as 100.")]),

 ("DH","In 30 tosses of a coin, heads came up 18 times. The number of times tails came up is:",
   "12",
   C("Every toss is either a head or a tail, so subtract the heads from the total tosses.")+
   steps("Total tosses = 30","Heads = 18","Tails = 30 − 18 = 12.")+
   U("Recording experiment results, you find the missing count by subtracting from the total."),
   [("18","18 is the number of heads, not of tails."),
    ("48","Adding 30 and 18 is wrong; tails is the difference, 12."),
    ("30","30 is the total number of tosses, not the tails alone.")]),

 ("DH","A pictograph shows one tree-symbol for every 100 trees and there are 6 full symbols. The number of trees shown is:",
   "600",
   C("Multiply the number of symbols by the value each symbol stands for.")+
   steps("Each symbol = 100 trees","Symbols = 6","Trees = 6 × 100 = 600.")+
   U("Reading a forest pictograph, you multiply symbols by their key value to get the total."),
   [("106","Adding 6 and 100 is wrong; each symbol is worth 100, so multiply."),
    ("60","60 would be 6 × 10; here each symbol stands for 100, giving 600."),
    ("6","6 is the number of symbols, not the number of trees they represent.")]),

 ("DH","The mean mass of four soil samples is 50 g. If three of them are 40 g, 55 g and 45 g, the fourth sample's mass is:",
   "60 g",
   C("The four masses must total mean × count; subtract the three known masses to find the fourth.")+
   steps("Total = 50 × 4 = 200 g","Three known = 40 + 55 + 45 = 140 g","Fourth = 200 − 140 = 60 g.")+
   U("Lab workers back-calculate one missing reading from the average and the rest like this."),
   [("50 g","50 g is the mean, not the missing fourth value."),
    ("140 g","140 g is the total of the three known masses, not the fourth one."),
    ("200 g","200 g is the total of all four masses, not the single missing one.")]),

 ("DH","On a bar graph of rainfall in five cities, the city whose bar is the tallest is the one with the:",
   "greatest rainfall",
   C("In a bar graph the height of a bar shows the value, so the tallest bar marks the largest quantity.")+
   steps("Bar height stands for the value","The tallest bar is the highest value","So that city had the most rainfall.")+
   U("Reading a rainfall bar graph, you spot the wettest city by its tallest bar at a glance."),
   [("least rainfall","The shortest bar, not the tallest, shows the least rainfall."),
    ("average rainfall","No single bar shows the average; the tallest shows the greatest value."),
    ("no rainfall at all","A tall bar means a large amount, not zero rainfall.")]),
]

# ---------- EXPONENTS & POWERS (25) — Maths ----------
EX = [
 ("EX","In the expression 2⁵, the number 2 is called the:",
   "base",
   C("In a power, the number that is multiplied repeatedly is the base, and the small raised number tells how many times.")+
   steps("2⁵ means 2 multiplied again and again","The repeated number is 2","So 2 is the base.")+
   U("Writing 10⁶ for a million, the base 10 is the number being multiplied."),
   [("exponent","The exponent is the small raised 5, not the base 2."),
    ("product","The product is the final answer, not the number being multiplied."),
    ("coefficient","There is no coefficient here; the repeated number is the base.")]),

 ("EX","In the expression 2⁵, the small raised number 5 is called the exponent or:",
   "power",
   C("The exponent (also called the power or index) tells how many times the base is multiplied by itself.")+
   steps("2⁵ has the small raised 5","It counts the number of times 2 is used","This raised number is the exponent, or power.")+
   U("In 10⁹ (a billion), the exponent 9 tells you ten is multiplied nine times."),
   [("base","The base is the number 2 being multiplied, not the raised number."),
    ("sum","The sum is the result of adding; the raised number is the exponent."),
    ("root","A root is the reverse of a power, not the raised number itself.")]),

 ("EX","The value of 2⁵ is:",
   "32",
   C("2⁵ means 2 multiplied by itself five times.")+
   steps("2 × 2 × 2 × 2 × 2","= 4 × 4 × 2","= 32.")+
   U("Doubling something five times in a row multiplies it by 32."),
   [("10","10 is 2 × 5, but a power means repeated multiplication, giving 32."),
    ("25","25 is 5², not 2⁵; the base and exponent are swapped."),
    ("16","16 is 2⁴; 2⁵ has one more factor of 2, giving 32.")]),

 ("EX","Using the law of exponents, 2³ × 2⁴ equals:",
   "2⁷",
   C("When powers with the same base are multiplied, the exponents are added.")+
   steps("Same base 2","Add the exponents: 3 + 4 = 7","So 2³ × 2⁴ = 2⁷.")+
   U("This rule lets scientists multiply huge powers of ten just by adding the exponents."),
   [("2¹²","Multiplying the exponents (3 × 4) is wrong; for a product you add them."),
    ("4⁷","The base stays 2, not 4; only the exponents are added."),
    ("2⁻¹","Subtracting the exponents is the rule for division, not multiplication.")]),

 ("EX","Using the law of exponents, 5⁶ ÷ 5² equals:",
   "5⁴",
   C("When powers with the same base are divided, the exponents are subtracted.")+
   steps("Same base 5","Subtract the exponents: 6 − 2 = 4","So 5⁶ ÷ 5² = 5⁴.")+
   U("Dividing powers of ten in scientific work just means subtracting the exponents."),
   [("5³","6 − 2 = 4, not 3; the result is 5⁴."),
    ("5⁸","Adding the exponents is for multiplication; division subtracts them."),
    ("1⁴","The base stays 5, not 1; only the exponents are subtracted.")]),

 ("EX","Using the law of exponents, (3²)³ equals:",
   "3⁶",
   C("When a power is raised to another power, the exponents are multiplied.")+
   steps("A power raised to a power","Multiply the exponents: 2 × 3 = 6","So (3²)³ = 3⁶.")+
   U("Compounding a growth that is itself repeated uses this 'power of a power' rule."),
   [("3⁵","Adding the exponents (2 + 3) is wrong; here they are multiplied."),
    ("9³","The base stays 3, not 9; the exponents 2 and 3 are multiplied."),
    ("3⁸","2 × 3 = 6, not 8; the result is 3⁶.")]),

 ("EX","Any non-zero number raised to the power zero, such as 7⁰, equals:",
   "1",
   C("By the laws of exponents, any non-zero number raised to the power zero is equal to 1.")+
   steps("7⁰ can be seen as 7ⁿ ÷ 7ⁿ","Any number divided by itself is 1","So 7⁰ = 1.")+
   U("This rule keeps the exponent laws consistent when the exponents cancel out."),
   [("0","A non-zero number to the power zero is 1, not 0."),
    ("7","7¹ is 7; 7⁰ equals 1, not the base itself."),
    ("70","Putting a zero after 7 is not how powers work; 7⁰ = 1.")]),

 ("EX","The value of 10⁴ is:",
   "10000",
   C("10⁴ means 10 multiplied by itself four times, which is 1 followed by four zeros.")+
   steps("10 × 10 × 10 × 10","= 1 followed by four zeros","= 10000.")+
   U("Powers of ten make it easy to write large round numbers like ten thousand."),
   [("40","40 is 10 × 4, but a power means repeated multiplication, giving 10000."),
    ("1000","1000 is 10³; 10⁴ has one more factor of 10, giving 10000."),
    ("100000","100000 is 10⁵, one factor of 10 too many; 10⁴ = 10000.")]),

 ("EX","In standard form (scientific notation), the number 4500 is written as:",
   "4.5 × 10³",
   C("Standard form writes a number as a value between 1 and 10 multiplied by a power of ten.")+
   steps("Place the decimal after the first digit: 4.5","Count places moved: 3 to the left","So 4500 = 4.5 × 10³.")+
   U("Scientists write big measurements in standard form so they are short and easy to compare."),
   [("45 × 10²","The first part must be between 1 and 10; 45 is too large."),
    ("4.5 × 10²","Moving the decimal three places needs 10³, not 10²."),
    ("0.45 × 10⁴","The first part 0.45 is less than 1, so it is not proper standard form.")]),

 ("EX","Written in standard form, the number 60000 is:",
   "6 × 10⁴",
   C("Standard form expresses the number as a digit between 1 and 10 times a power of ten.")+
   steps("Place the decimal after the 6","Count the places moved: 4","So 60000 = 6 × 10⁴.")+
   U("A distance of sixty thousand kilometres is neatly written as 6 × 10⁴ km."),
   [("6 × 10⁵","60000 needs four zeros after the 6, so the power is 10⁴, not 10⁵."),
    ("60 × 10³","The first part must be between 1 and 10; 60 is too large."),
    ("6 × 10³","6 × 10³ is only 6000; sixty thousand needs 10⁴.")]),

 ("EX","The number 3.2 × 10² written as an ordinary number is:",
   "320",
   C("Multiplying by 10² moves the decimal point two places to the right.")+
   steps("3.2 × 10²","Move the decimal 2 places right","= 320.")+
   U("Turning a scientific-form figure back into an everyday number works this way."),
   [("32","Moving the decimal only one place gives 32; 10² moves it two places."),
    ("3200","Moving three places gives 3200, but 10² moves it only two."),
    ("3.2","3.2 is the value before multiplying by 10²; multiplying gives 320.")]),

 ("EX","The value of (−2)³ is:",
   "−8",
   C("A negative number raised to an odd power stays negative, because there is an odd number of negative factors.")+
   steps("(−2)³ = (−2) × (−2) × (−2)","Two negatives make +4, times another −2","= −8.")+
   U("Odd powers of a negative quantity keep its sign, which matters in many formulas."),
   [("8","An odd power of a negative number is negative; (−2)³ = −8, not +8."),
    ("−6","(−2)³ is repeated multiplication, not (−2) × 3; it equals −8."),
    ("6","The base is negative and the power odd, so the result is −8.")]),

 ("EX","The value of (−2)⁴ is:",
   "16",
   C("A negative number raised to an even power is positive, because the negatives pair up.")+
   steps("(−2)⁴ = (−2) × (−2) × (−2) × (−2)","Each pair of negatives gives +","= 4 × 4 = 16.")+
   U("Even powers of a negative quantity turn the sign positive, a key sign rule."),
   [("−16","An even power of a negative number is positive; (−2)⁴ = +16."),
    ("8","8 is 2³, not the fourth power; (−2)⁴ = 16."),
    ("−8","The power is even, so the answer is positive 16, not negative.")]),

 ("EX","Which of these means 'three multiplied by itself five times'?",
   "3⁵",
   C("Repeated multiplication of a number by itself is written as that number raised to a power equal to how many times it is used.")+
   steps("The base is 3","It is used five times","So it is written 3⁵.")+
   U("Powers give a short way to write long repeated multiplications like 3 × 3 × 3 × 3 × 3."),
   [("5³","5³ means five multiplied three times, swapping base and exponent."),
    ("3 × 5","3 × 5 is just simple multiplication, not repeated multiplication of 3."),
    ("3 + 5","3 + 5 is addition, not a power.")]),

 ("EX","Expressed as a power of 2, the number 16 is:",
   "2⁴",
   C("Write 16 as repeated multiplication of 2 and count the factors.")+
   steps("16 = 2 × 2 × 2 × 2","That is 2 used four times","So 16 = 2⁴.")+
   U("Computer memory sizes are powers of 2, so writing them this way is natural."),
   [("2³","2³ is 8, not 16; 16 needs one more factor of 2."),
    ("4²","4² does equal 16, but written as a power of 2 it is 2⁴."),
    ("2⁵","2⁵ is 32, which is too large; 16 is 2⁴.")]),

 ("EX","A soil sample is found to contain about 1000000 tiny organisms. In standard form this count is:",
   "1 × 10⁶",
   C("Standard form writes the number as a value between 1 and 10 times a power of ten; one million is 1 followed by six zeros.")+
   steps("Count the zeros in 1000000: six","One million = 1 × 10⁶","So the count is 1 × 10⁶.")+
   U("Scientists report huge counts of soil microbes in standard form to keep them short."),
   [("1 × 10⁵","10⁵ is only one hundred thousand; a million has six zeros, so 10⁶."),
    ("10 × 10⁵","The first part must be between 1 and 10; 10 is too large."),
    ("1 × 10⁷","10⁷ is ten million, too big; one million is 1 × 10⁶.")]),

 ("EX","Using exponent laws, 10⁵ × 10³ equals:",
   "10⁸",
   C("Multiplying powers with the same base means adding the exponents.")+
   steps("Same base 10","Add exponents: 5 + 3 = 8","So 10⁵ × 10³ = 10⁸.")+
   U("Multiplying a hundred thousand by a thousand gives 10⁸, found just by adding exponents."),
   [("10¹⁵","Multiplying the exponents (5 × 3) is wrong; for a product you add them."),
    ("100⁸","The base stays 10, not 100; only the exponents are added."),
    ("10²","Subtracting the exponents is the rule for division, not multiplication.")]),

 ("EX","The reading 7.0 × 10³ grams is the same mass as:",
   "7000 grams",
   C("Multiplying 7.0 by 10³ moves the decimal three places to the right.")+
   steps("7.0 × 10³","Move the decimal 3 places right","= 7000 grams.")+
   U("A weight written in scientific form on a label can be read back as an everyday number this way."),
   [("700 grams","700 is 7 × 10²; multiplying by 10³ gives 7000."),
    ("70 grams","70 is 7 × 10¹; the power here is 10³, giving 7000."),
    ("70000 grams","70000 is 7 × 10⁴; 7.0 × 10³ is only 7000.")]),

 ("EX","Which number is the largest?",
   "2⁵",
   C("Work out each power and compare the results.")+
   steps("2⁵ = 32, 3² = 9","4² = 16, 5¹ = 5","32 is the largest, so 2⁵ is greatest.")+
   U("Comparing powers by their actual values shows that a small base with a big exponent can win."),
   [("3²","3² is 9, which is much less than 2⁵ = 32."),
    ("4²","4² is 16, still less than 2⁵ = 32."),
    ("5¹","5¹ is just 5, the smallest of these.")]),

 ("EX","The value of 1 raised to any power, such as 1⁰⁰, is:",
   "1",
   C("Multiplying 1 by itself any number of times always gives 1.")+
   steps("1 × 1 × 1 × ... any number of times","Each multiplication by 1 leaves it unchanged","So 1 to any power is 1.")+
   U("No matter how many times you multiply 1 by itself, the result stays 1."),
   [("100","The exponent counts factors; it is not stuck on the end. 1¹⁰⁰ = 1."),
    ("0","1 to any power is 1, never 0."),
    ("10","Multiplying 1 by itself can never grow beyond 1.")]),

 ("EX","Written as a single power, 6³ × 6² × 6 equals:",
   "6⁶",
   C("With the same base, add all the exponents; remember 6 by itself is 6¹.")+
   steps("Exponents are 3, 2 and 1","Add them: 3 + 2 + 1 = 6","So the product is 6⁶.")+
   U("Chaining several powers of the same base together just adds up their exponents."),
   [("6⁵","This forgets that the lone 6 is 6¹; the exponents add to 6, not 5."),
    ("6⁶ written as 18³","Multiplying base and exponents is wrong; just add the exponents to get 6⁶."),
    ("6⁷","3 + 2 + 1 = 6, not 7; the result is 6⁶.")]),

 ("EX","The distance is given as 9.3 × 10⁷ km. The exponent 7 tells you that the first part is multiplied by:",
   "10 multiplied by itself 7 times",
   C("In standard form, the power of ten shows how many times ten is multiplied, which fixes the size of the number.")+
   steps("The power is 10⁷","That is 10 multiplied by itself 7 times","So 9.3 is multiplied by ten million.")+
   U("Astronomers write the Sun's distance as 9.3 × 10⁷ miles, the 7 setting its scale."),
   [("7","The number is multiplied by 10⁷, not simply by 7."),
    ("70","70 is 7 × 10; the factor here is ten multiplied seven times, not 70."),
    ("10 added 7 times","The power means ten is multiplied (not added) seven times.")]),

 ("EX","Expressed as a power of 10, the number 1000 is:",
   "10³",
   C("Count the zeros in the number to find the power of ten.")+
   steps("1000 has three zeros","So it is 10 multiplied three times","1000 = 10³.")+
   U("Round numbers like a thousand are quickly written as a power of ten by counting zeros."),
   [("10²","10² is only 100; one thousand has three zeros, so 10³."),
    ("10⁴","10⁴ is ten thousand, too many zeros; 1000 is 10³."),
    ("3¹⁰","This swaps the base and exponent; 1000 is 10³, not 3¹⁰.")]),

 ("EX","The value of 3³ is:",
   "27",
   C("3³ means 3 multiplied by itself three times.")+
   steps("3 × 3 × 3","= 9 × 3","= 27.")+
   U("Stacking a cube 3 units on each side gives 3³ = 27 small cubes."),
   [("9","9 is 3², not 3³; one more factor of 3 gives 27."),
    ("6","6 is 3 × 2, but a power means repeated multiplication, giving 27."),
    ("33","Putting two 3s together is not how powers work; 3³ = 27.")]),

 ("EX","Written in standard form, the number 250000 is:",
   "2.5 × 10⁵",
   C("Standard form writes the number as a value between 1 and 10 multiplied by a power of ten.")+
   steps("Place the decimal after the first digit: 2.5","Count the places moved: 5","So 250000 = 2.5 × 10⁵.")+
   U("Large populations or distances are written this short way in science books."),
   [("25 × 10⁴","The first part must be between 1 and 10; 25 is too large."),
    ("2.5 × 10⁴","Moving the decimal five places needs 10⁵, not 10⁴."),
    ("2.5 × 10⁶","10⁶ would make 2500000; 250000 needs 10⁵.")]),
]

assert len(NA) == 25 and len(SO) == 25 and len(DH) == 25 and len(EX) == 25

# Interleave so no two consecutive questions share a chapter; Science/Maths alternate.
items = []
for i in range(25):
    items += [NA[i], SO[i], DH[i], EX[i]]
assert len(items) == 100

for a, b in zip(items, items[1:]):
    assert a[0] != b[0], (a[1], b[1])

if __name__ == "__main__":
    here = os.path.dirname(os.path.abspath(__file__))
    papers_dir = os.path.abspath(os.path.join(
        here, "..", "..", "desktopAhaan", "Resources", "BossChallengePapers"))
    os.chdir(papers_dir)

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=12107,
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
    split = "/".join(str(counts[c]) for c in ("NA", "SO", "DH", "EX"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
