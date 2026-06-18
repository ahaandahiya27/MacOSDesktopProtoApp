# -*- coding: utf-8 -*-
# Boss Challenge Paper 36 — Nutrition in Animals · Heat
#                            · Algebraic Expressions · The Triangle & its Properties
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans into FUSION. A temperature rise is a SUBTRACTION; a row of
# equal-length intestines is a MULTIPLICATION; the food eaten by a herd is an ALGEBRAIC EXPRESSION;
# the corner angles of a triangular ramp obey the ANGLE-SUM rule. The child meets a Science
# situation and reaches for a Maths skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_36_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_36_<SHORT>_QuestionPaper.pdf
#   Paper_36_<SHORT>_Questions.md
#   Paper_36_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "36"
SHORT = "NutritionAnimals_Heat_AlgExpr_Triangle"
TITLE = ("Nutrition in Animals · Heat · "
         "Algebraic Expressions · The Triangle & its Properties")
LABELS = {
    "NA": "Nutrition in Animals",
    "HE": "Heat",
    "AE": "Algebraic Expressions",
    "TR": "The Triangle & its Properties",
}

# ---------- NUTRITION IN ANIMALS (25) — Science ----------
NA = [
 ("NA","The breaking down of the food we eat into simpler substances the body can absorb is called:",
   "digestion",
   C("Food is broken into simpler, soluble bits the body can take in — this whole process is digestion.")+
   steps("We eat food made of complex substances","the body breaks it into simpler, absorbable parts","this breaking-down process is digestion."),
   [("respiration","Respiration releases energy from absorbed food; the breakdown of food itself is digestion."),
    ("egestion","Egestion is throwing out the undigested waste; breaking food down is digestion."),
    ("absorption","Absorption is taking digested food into the blood; the breakdown step is digestion.")]),

 ("NA","The set of organs through which food passes, from the mouth to the anus, is together called the:",
   "alimentary canal",
   C("The long tube food travels through, mouth to anus, is the alimentary canal.")+
   steps("Food enters the mouth and leaves at the anus","in between it passes a long connected tube","this whole food tube is the alimentary canal."),
   [("wind pipe","The wind pipe carries air to the lungs, not food; the food tube is the alimentary canal."),
    ("blood vessel","Blood vessels carry blood, not food; food travels the alimentary canal."),
    ("spinal cord","The spinal cord is a bundle of nerves; the food tube is the alimentary canal.")]),

 ("NA","The hard, white structures in the mouth that cut, tear and grind food are the:",
   "teeth",
   C("Teeth cut, tear and grind food into smaller pieces inside the mouth.")+
   steps("Food must be broken up in the mouth","hard white structures bite and grind it","these are the teeth."),
   [("taste buds","Taste buds sense flavour; the food is cut and ground by the teeth."),
    ("tonsils","Tonsils sit at the back of the throat; food is chewed by the teeth."),
    ("lips","Lips hold food in; the cutting and grinding is done by the teeth.")]),

 ("NA","The watery liquid released in the mouth that wets food and begins to break down starch is:",
   "saliva",
   C("Saliva moistens food and its enzyme starts breaking starch into sugar in the mouth.")+
   steps("The mouth releases a watery liquid","it wets the food and acts on starch","this liquid is saliva."),
   [("bile","Bile comes from the liver and works on fats in the intestine, not starch in the mouth."),
    ("blood","Blood carries digested food away; the mouth's digestive liquid is saliva."),
    ("sweat","Sweat is released by the skin to cool the body, not to digest food.")]),

 ("NA","The muscular organ that mixes food with saliva and pushes it for swallowing is the:",
   "tongue",
   C("The tongue rolls food, mixes it with saliva and pushes it back to be swallowed.")+
   steps("Chewed food must be mixed and moved","a muscular organ rolls and pushes it","that organ is the tongue."),
   [("liver","The liver makes bile; the rolling and pushing of food is done by the tongue."),
    ("kidney","The kidney filters blood; mixing and pushing food is the tongue's job."),
    ("lung","The lungs handle air; the tongue mixes and pushes food.")]),

 ("NA","After being swallowed, food is carried from the mouth down to the stomach through the:",
   "food pipe (oesophagus)",
   C("The oesophagus, or food pipe, carries swallowed food down to the stomach.")+
   steps("Swallowed food must reach the stomach","it travels down a muscular tube","this tube is the food pipe, or oesophagus."),
   [("wind pipe","The wind pipe carries air to the lungs; food goes down the food pipe."),
    ("small intestine","The small intestine comes after the stomach; food first travels the food pipe."),
    ("large intestine","The large intestine is near the end; swallowed food first goes down the food pipe.")]),

 ("NA","The bag-like organ where food is churned with digestive juices and acid for a few hours is the:",
   "stomach",
   C("The stomach is a muscular bag that churns food with acid and juices.")+
   steps("Food from the food pipe enters a muscular bag","there it is churned with acid and juices","this organ is the stomach."),
   [("heart","The heart pumps blood; food is churned in the stomach."),
    ("brain","The brain controls the body; food churning happens in the stomach."),
    ("lung","The lungs exchange gases; food is churned in the stomach.")]),

 ("NA","Most of the digested food is absorbed into the blood through the walls of the:",
   "small intestine",
   C("The small intestine is where most digested food passes into the blood.")+
   steps("Digested food must enter the blood","this happens along a long, folded tube","that tube is the small intestine."),
   [("large intestine","The large intestine mainly absorbs water; food is absorbed in the small intestine."),
    ("stomach","The stomach churns food; most absorption is in the small intestine."),
    ("food pipe","The food pipe only carries food down; absorption is in the small intestine.")]),

 ("NA","The tiny finger-like projections lining the small intestine that increase the surface for absorbing food are called:",
   "villi",
   C("Villi are tiny finger-like folds that give the small intestine a huge surface to absorb food.")+
   steps("Absorption needs a large surface","the small intestine's wall has tiny finger-like folds","these folds are called villi."),
   [("alveoli","Alveoli are air sacs in the lungs; the intestine's folds are villi."),
    ("stomata","Stomata are pores on leaves, not in our intestine; the folds are villi."),
    ("nephrons","Nephrons are filtering units in the kidney; the intestinal folds are villi.")]),

 ("NA","The main job of the large intestine is to absorb water and some salts from the undigested:",
   "food waste",
   C("The large intestine takes back water and salts from the leftover undigested food.")+
   steps("Undigested food still holds water","the large intestine absorbs that water and salts","leaving a more solid waste behind."),
   [("fresh air","The large intestine handles food waste, not air."),
    ("clean blood","Blood is not passed into the intestine; it absorbs water from food waste."),
    ("chewed starch","Starch is digested earlier; the large intestine absorbs water from food waste.")]),

 ("NA","The semi-solid undigested waste is finally removed from the body through the:",
   "anus",
   C("Undigested waste leaves the body through the anus, in a step called egestion.")+
   steps("Some food cannot be digested","this waste collects at the end of the food tube","it is removed through the anus."),
   [("nose","The nose handles air; food waste leaves through the anus."),
    ("mouth","Food enters at the mouth; the undigested waste leaves through the anus."),
    ("skin","The skin loses sweat, not food waste; waste leaves through the anus.")]),

 ("NA","The body's biggest gland, which makes bile to help in the digestion of fats, is the:",
   "liver",
   C("The liver is the body's largest gland and it makes bile, which helps break down fats.")+
   steps("Fats need help to be digested","the body's largest gland makes a juice called bile","that gland is the liver."),
   [("pancreas","The pancreas also makes juices, but the largest gland that makes bile is the liver."),
    ("stomach","The stomach is an organ, not the bile-making gland; that is the liver."),
    ("kidney","The kidney filters blood; bile is made by the liver.")]),

 ("NA","Bile, which acts on fats during digestion, is made by the liver and stored in the:",
   "gall bladder",
   C("Bile made by the liver is stored in a small sac called the gall bladder until it is needed.")+
   steps("The liver makes bile all the time","it is kept in a small sac until needed","this storage sac is the gall bladder."),
   [("stomach","The stomach churns food; bile is stored in the gall bladder."),
    ("small intestine","Bile is released into the small intestine but stored in the gall bladder."),
    ("wind pipe","The wind pipe carries air; bile is stored in the gall bladder.")]),

 ("NA","The flat, broad front teeth used mainly for biting and cutting food are called:",
   "incisors",
   C("The sharp, flat front teeth that bite and cut food are the incisors.")+
   steps("Look at the broad front teeth","they slice into food when you bite","these cutting teeth are incisors."),
   [("molars","Molars are the broad back teeth for grinding, not the cutting front teeth."),
    ("canines","Canines are the pointed teeth for tearing; the flat front cutters are incisors."),
    ("premolars","Premolars sit further back for grinding; the front cutters are incisors.")]),

 ("NA","The pointed teeth, next to the front teeth, that are used for tearing and piercing food are the:",
   "canines",
   C("The sharp, pointed teeth beside the incisors that tear food are the canines.")+
   steps("Just beside the front teeth are pointed ones","they pierce and tear tough food","these are the canines."),
   [("incisors","Incisors are the flat cutting front teeth; the pointed tearing teeth are canines."),
    ("molars","Molars are flat grinding back teeth; the pointed tearing teeth are canines."),
    ("wisdom teeth","Wisdom teeth are the last molars at the back; the pointed teeth are canines.")]),

 ("NA","Cattle such as cows quickly swallow grass, store it, and later bring it back to the mouth to chew again; this returned food is called:",
   "cud",
   C("Cows store half-chewed grass and later bring it back as cud to chew slowly — they are ruminants.")+
   steps("A cow swallows grass fast into a stomach chamber","later it returns the food to the mouth","this returned, re-chewed food is the cud."),
   [("bile","Bile is a digestive juice from the liver, not the returned grass; that is cud."),
    ("saliva","Saliva is the watery mouth liquid, not the returned food, which is cud."),
    ("starch","Starch is a food substance; the grass a cow re-chews is called cud.")]),

 ("NA","Grass-eating animals like cows can digest the cellulose in grass with the help of certain microbes living in their:",
   "rumen (part of the stomach)",
   C("Microbes in the rumen, a stomach chamber of cattle, break down the cellulose in grass.")+
   steps("Grass is rich in tough cellulose","cattle hold a special stomach chamber, the rumen","microbes there digest the cellulose."),
   [("brain","The brain has no role in digesting grass; cellulose is broken down in the rumen."),
    ("lungs","The lungs handle air; grass cellulose is digested by microbes in the rumen."),
    ("teeth","Teeth grind grass but cannot digest cellulose; microbes in the rumen do that.")]),

 ("NA","The tiny single-celled animal Amoeba captures its food by pushing out finger-like extensions called:",
   "pseudopodia",
   C("Amoeba surrounds its food with pseudopodia — temporary 'false feet' that engulf the prey.")+
   steps("Amoeba has no mouth like ours","it pushes out finger-like extensions of its body","these 'false feet' are pseudopodia."),
   [("villi","Villi line our small intestine; Amoeba's false feet are pseudopodia."),
    ("cilia","Cilia are tiny hairs on some cells; Amoeba captures food with pseudopodia."),
    ("tentacles","Tentacles belong to animals like hydra; Amoeba uses pseudopodia.")]),

 ("NA","Within an Amoeba's body, the captured food is digested inside a small bubble-like bag known as the:",
   "food vacuole",
   C("Amoeba digests its captured food inside a tiny bag called the food vacuole.")+
   steps("Amoeba engulfs food into its body","the food is sealed in a tiny bubble","digestion happens in this food vacuole."),
   [("nucleus","The nucleus controls the cell; food is digested in the food vacuole."),
    ("villus","A villus is a fold in our intestine; Amoeba uses a food vacuole."),
    ("gall bladder","Amoeba has no gall bladder; it digests food in a food vacuole.")]),

 ("NA","The young of a human baby first feed only on their mother's:",
   "milk",
   C("Newborn babies and other young mammals feed on their mother's milk.")+
   steps("A newborn cannot chew solid food","it needs an easy, complete first food","that food is mother's milk."),
   [("grass","Babies cannot eat grass; their first food is mother's milk."),
    ("bread","Solid bread is for older children; a baby's first food is milk."),
    ("raw rice","Raw rice cannot be eaten by a baby; the first food is mother's milk.")]),

 ("NA","A cow's small intestine is very long because such a long tube gives more time and surface to digest tough:",
   "grass (plant food)",
   C("Grass is hard to digest, so grass-eaters have a long intestine for slow, thorough digestion.")+
   steps("Grass-eaters feed on tough plant material","this needs more time and surface to digest","so the small intestine is very long."),
   [("meat","Meat-eaters tend to have a SHORTER gut; the long gut suits tough grass."),
    ("milk","Milk is easy to digest and needs no long gut; the length suits tough grass."),
    ("water","Water needs no digesting; the long intestine helps digest tough grass.")]),

 ("NA","A child has 8 incisor teeth, each about 6 mm wide. The total width of all the incisors set side by side, found by 8 × 6, is:",
   "48 mm",
   C("Total width = number of teeth × width of each = 8 × 6 = 48 mm — a body measurement found by multiplication.")+
   steps("There are 8 incisors, each 6 mm wide","total width = 8 × 6","8 × 6 = 48, so 48 mm."),
   [("14 mm","14 just adds 8 + 6; the total width is 8 × 6 = 48 mm."),
    ("2 mm","2 subtracts 8 − 6; the total is 8 × 6 = 48 mm."),
    ("40 mm","40 is 8 × 5; with 6 mm each it is 8 × 6 = 48 mm.")]),

 ("NA","A cow's small intestine is about 40 m long and its large intestine about 10 m. The total length of both, found by 40 + 10, is:",
   "50 m",
   C("Total gut length = 40 + 10 = 50 m — a body measurement found by addition.")+
   steps("Small intestine is 40 m, large is 10 m","total = 40 + 10","40 + 10 = 50, so 50 m."),
   [("30 m","30 subtracts 40 − 10; the total of both is 40 + 10 = 50 m."),
    ("400 m","400 multiplies 40 × 10; the total length is 40 + 10 = 50 m."),
    ("4 m","4 divides 40 ÷ 10; the combined length is 40 + 10 = 50 m.")]),

 ("NA","The wave-like squeezing movement of the gut walls that pushes food forward through the food pipe and intestine is called:",
   "peristalsis",
   C("Peristalsis is the rhythmic muscular squeezing that moves food along the digestive tube.")+
   steps("Food must be pushed along the gut","the muscular walls squeeze in waves","this wave-like movement is peristalsis."),
   [("digestion","Digestion is the chemical breakdown; the muscular pushing is peristalsis."),
    ("absorption","Absorption is food entering the blood; the pushing movement is peristalsis."),
    ("respiration","Respiration releases energy; the wave-like food-pushing is peristalsis.")]),

 ("NA","The throwing out of undigested food as waste from the body is called:",
   "egestion",
   C("Egestion is the removal of the undigested, leftover food from the body.")+
   steps("Some food cannot be digested","it must be removed as waste","this removal is called egestion."),
   [("ingestion","Ingestion is taking food IN; throwing the waste out is egestion."),
    ("digestion","Digestion breaks food down; removing the undigested waste is egestion."),
    ("absorption","Absorption takes food into the blood; removing waste is egestion.")]),
]

NA_UC = [
 "Knowing digestion is how you understand what really happens to the food on your plate.",
 "Knowing the alimentary canal is how you trace a meal's whole journey through the body.",
 "Knowing what teeth do is why chewing well makes food easier to digest.",
 "Knowing saliva starts on starch is why bread tastes slightly sweet if you chew it long.",
 "Knowing the tongue's job is how you understand mixing and swallowing every mouthful.",
 "Knowing the food pipe is how you explain why food goes down, not into the lungs.",
 "Knowing the stomach churns food is why a heavy meal sits for a while before you feel light.",
 "Knowing the small intestine absorbs food is how nutrients from a meal reach your blood.",
 "Knowing about villi is how you picture the huge surface that soaks up your food.",
 "Knowing the large intestine reclaims water is why staying hydrated helps digestion.",
 "Knowing about the anus and egestion completes the story of where waste finally leaves.",
 "Knowing the liver makes bile is how you understand the body handling fatty food.",
 "Knowing the gall bladder stores bile is how you locate where bile waits before a meal.",
 "Knowing incisors cut food is why your front teeth do the first bite of an apple.",
 "Knowing canines tear food is why pointed teeth help with tougher, chewy bites.",
 "Knowing about cud is how you understand a cow chewing long after it has eaten.",
 "Knowing the rumen digests grass is how grass-eaters live on food we could not digest.",
 "Knowing Amoeba uses pseudopodia is how a single cell eats without a mouth.",
 "Knowing the food vacuole is how you picture digestion inside one tiny cell.",
 "Knowing babies drink milk is the simple science behind a newborn's only first food.",
 "Knowing why grass-eaters have long guts links body shape to the food an animal eats.",
 "Multiplying tooth width is how a dentist might estimate the span of your front teeth.",
 "Adding gut lengths is how a biologist totals the length of an animal's digestive tract.",
 "Knowing peristalsis is why you can even swallow while lying down or upside down.",
 "Knowing egestion is how you name the final step that clears undigested waste.",
]

# ---------- HEAT (25) — Science ----------
HE = [
 ("HE","A reliable measure of how hot or cold an object is, is given by its:",
   "temperature",
   C("Temperature is the proper measure of the degree of hotness or coldness of a body.")+
   steps("'Hot' and 'cold' are vague to the touch","we need a measured value","this measured hotness is the temperature."),
   [("weight","Weight is how heavy a thing is, not how hot it is; that is temperature."),
    ("length","Length is how long a thing is; hotness is measured by temperature."),
    ("colour","Colour does not measure hotness; temperature does.")]),

 ("HE","The instrument used to measure the temperature of a body is the:",
   "thermometer",
   C("A thermometer is the device made to measure temperature.")+
   steps("Temperature must be measured with a tool","that tool has a scale marked in degrees","it is called a thermometer."),
   [("barometer","A barometer measures air pressure, not temperature; that is a thermometer."),
    ("speedometer","A speedometer measures speed; temperature is read on a thermometer."),
    ("weighing scale","A weighing scale measures weight; temperature is read on a thermometer.")]),

 ("HE","The special thermometer used to measure the temperature of the human body is the:",
   "clinical thermometer",
   C("A clinical thermometer is designed to read human body temperature.")+
   steps("Body temperature is measured by a doctor","a special thermometer is used for this","it is the clinical thermometer."),
   [("laboratory thermometer","A laboratory thermometer reads a wide range for experiments, not body temperature."),
    ("maximum thermometer","That records the highest weather temperature, not the body's."),
    ("barometer","A barometer measures air pressure; body temperature needs a clinical thermometer.")]),

 ("HE","The normal temperature of a healthy human body is taken to be about:",
   "37°C",
   C("A healthy human body stays at roughly 37°C (about 98.6°F).")+
   steps("Doctors use a usual healthy value","on the Celsius scale this value is about 37","so normal body temperature is about 37°C."),
   [("0°C","0°C is the freezing point of water, far too cold for a living body, which is about 37°C."),
    ("100°C","100°C is the boiling point of water; the body is about 37°C."),
    ("50°C","50°C is too high for a healthy body; normal is about 37°C.")]),

 ("HE","Heat always flows on its own from a body at a higher temperature to one at a:",
   "lower temperature",
   C("Heat moves naturally from a hotter body to a colder one until both are equal.")+
   steps("Put a hot and a cold body together","heat leaves the hotter one","it flows to the body at lower temperature."),
   [("higher temperature","Heat does not flow uphill on its own; it goes to the LOWER temperature."),
    ("equal temperature","If they are already equal, no heat flows; heat flows toward the lower one."),
    ("greater weight","Weight does not decide heat flow; heat flows to the lower temperature.")]),

 ("HE","The way heat travels through a solid, such as along a metal spoon in hot tea, mainly by passing from particle to particle, is called:",
   "conduction",
   C("In solids, heat passes from one particle to the next without the particles travelling — this is conduction.")+
   steps("Heat enters one end of a solid","particles pass it on to their neighbours","this particle-to-particle transfer is conduction."),
   [("convection","Convection moves heat in liquids and gases by the fluid itself moving, not in a solid spoon."),
    ("radiation","Radiation needs no material and carries heat as rays; a spoon heats by conduction."),
    ("reflection","Reflection is light or heat bouncing off; heat through a spoon is conduction.")]),

 ("HE","Heat moves through liquids and gases by the actual movement of the warmed fluid itself; this way of travelling is called:",
   "convection",
   C("In fluids, warm portions rise and cooler ones sink, carrying heat — this is convection.")+
   steps("Heat a liquid or gas at the bottom","the warm fluid rises and cool fluid sinks","this circulating movement is convection."),
   [("conduction","Conduction passes heat particle to particle in solids, without the fluid moving."),
    ("radiation","Radiation carries heat as rays through empty space; moving fluid is convection."),
    ("freezing","Freezing is a liquid turning solid, not a way heat travels; that is convection.")]),

 ("HE","Heat from the Sun reaches the Earth across empty space without any material in between, by:",
   "radiation",
   C("Heat that travels without needing any medium, like sunlight through space, moves by radiation.")+
   steps("Between the Sun and Earth lies empty space","heat still reaches us across it","this medium-free transfer is radiation."),
   [("conduction","Conduction needs touching particles; empty space has none, so it is radiation."),
    ("convection","Convection needs a moving fluid; empty space has none, so it is radiation."),
    ("evaporation","Evaporation is a liquid turning to vapour, not how Sun's heat crosses space.")]),

 ("HE","Materials such as metals that let heat pass through them easily are called good:",
   "conductors of heat",
   C("Metals allow heat to pass through quickly, so they are good conductors of heat.")+
   steps("Some materials let heat pass easily","metals heat up quickly when warmed","such materials are good conductors of heat."),
   [("insulators of heat","Insulators RESIST heat; metals let heat pass, so they are conductors."),
    ("reflectors of heat","Reflectors bounce heat away; metals carry heat as conductors."),
    ("absorbers of light","That is about light, not heat flow; metals are conductors of heat.")]),

 ("HE","Materials such as wood, plastic and wool that do not let heat pass through easily are called:",
   "insulators",
   C("Poor conductors like wood and wool block the flow of heat and are called insulators.")+
   steps("Some materials resist the flow of heat","wood, plastic and wool barely warm through","such poor conductors are insulators."),
   [("conductors","Conductors let heat pass easily; wood and wool resist it, so they are insulators."),
    ("radiators","A radiator gives out heat; materials that block heat are insulators."),
    ("metals","Metals are good conductors; the poor conductors here are insulators.")]),

 ("HE","A handle made of wood or plastic is fixed to a metal cooking pan so that the cook's hand is protected, because such material is a poor:",
   "conductor of heat",
   C("Wood and plastic are poor conductors, so the heat does not pass quickly to the hand.")+
   steps("The metal pan gets very hot","wood or plastic barely lets heat through","so the handle stays cool — it is a poor conductor."),
   [("insulator of heat","Being a poor CONDUCTOR is the same as being a good INSULATOR — the option must name the poor conductor."),
    ("source of heat","The handle is not a heat source; it is chosen as a poor conductor."),
    ("reflector of light","Light reflection is not the point; the handle is a poor conductor of heat.")]),

 ("HE","In hot sunny weather we are advised to wear light-coloured clothes because light colours:",
   "reflect most of the heat",
   C("Light colours reflect away much of the Sun's heat, so they keep us cooler.")+
   steps("The Sun's heat falls on our clothes","light colours bounce most of it back","so light clothes keep us cooler in summer."),
   [("absorb most of the heat","DARK colours absorb heat; light colours REFLECT it, keeping us cool."),
    ("make their own heat","Clothes make no heat; light ones simply reflect the Sun's heat."),
    ("block all the air","Colour does not block air; light colours reflect heat.")]),

 ("HE","In cold winter weather we prefer dark-coloured clothes mainly because dark colours:",
   "absorb more heat",
   C("Dark colours soak up more of the Sun's heat, helping to keep us warm in winter.")+
   steps("In winter we want to feel warm","dark colours take in more of the Sun's heat","so dark clothes keep us warmer."),
   [("reflect more heat","Reflecting heat keeps you COOL; in winter dark colours ABSORB heat to warm us."),
    ("make their own heat","Clothes do not make heat; dark colours absorb the Sun's heat."),
    ("let in more rain","Colour does not control rain; dark colours absorb heat for warmth.")]),

 ("HE","Wearing two thin layers of clothing in winter is often warmer than one thick layer because air trapped between the layers is a poor:",
   "conductor of heat",
   C("Air trapped between layers is a poor conductor, so it slows the loss of body heat.")+
   steps("Two layers trap air between them","trapped air barely lets heat pass","so body heat is held in — air is a poor conductor."),
   [("source of heat","Trapped air makes no heat; it works by being a poor conductor."),
    ("good conductor of heat","If air were a GOOD conductor it would lose heat fast; it is a POOR conductor."),
    ("reflector of sound","Sound is not the point here; trapped air is a poor conductor of heat.")]),

 ("HE","On the Celsius scale, the temperature at which pure water freezes into ice is:",
   "0°C",
   C("Pure water freezes at 0°C on the Celsius scale.")+
   steps("Cool water until it turns to ice","note the temperature where this happens","on the Celsius scale it is 0°C."),
   [("100°C","100°C is where water BOILS, not freezes; freezing is 0°C."),
    ("37°C","37°C is normal body temperature; water freezes at 0°C."),
    ("50°C","50°C is just warm water; water freezes at 0°C.")]),

 ("HE","On the Celsius scale, the temperature at which pure water boils is:",
   "100°C",
   C("Pure water boils at 100°C on the Celsius scale at sea level.")+
   steps("Heat water until it boils into steam","note that temperature","on the Celsius scale it is 100°C."),
   [("0°C","0°C is where water FREEZES, not boils; boiling is 100°C."),
    ("37°C","37°C is body temperature; water boils at 100°C."),
    ("50°C","50°C is only warm; water boils at 100°C.")]),

 ("HE","The sea breeze that blows from the sea toward the land during the daytime is a result of heat transfer by:",
   "convection",
   C("By day, warm air over the land rises and cooler air flows in from the sea — a convection current.")+
   steps("By day the land heats faster than the sea","warm air over land rises and cool sea air moves in","this circulating air is a convection current."),
   [("conduction","Conduction is heat through solids; the moving air of a sea breeze is convection."),
    ("radiation","Radiation is heat rays; the breeze is moving air, which is convection."),
    ("freezing","Freezing is water turning to ice, not the cause of a sea breeze, which is convection.")]),

 ("HE","In a clinical thermometer, the silvery liquid that rises in the thin tube to show the temperature is traditionally:",
   "mercury",
   C("Many clinical thermometers use mercury, a silvery liquid metal, that expands and rises with heat.")+
   steps("A thermometer needs a liquid that expands with heat","a silvery liquid metal does this well","traditionally that liquid is mercury."),
   [("water","Water is not used; the silvery liquid in a traditional clinical thermometer is mercury."),
    ("oil","Oil is not the standard thermometer liquid; that is mercury."),
    ("milk","Milk is a food, not a thermometer liquid; the silvery liquid is mercury.")]),

 ("HE","A liquid in a thermometer rises up the tube when heated because, on heating, the liquid:",
   "expands",
   C("Heat makes the liquid expand, so it takes more room and rises up the narrow tube.")+
   steps("Heat is given to the liquid","its particles move apart and it takes more space","so it expands and rises in the tube."),
   [("contracts","Contracting would make it FALL; on heating the liquid expands and rises."),
    ("freezes","Freezing makes a solid; on heating the liquid expands."),
    ("disappears","The liquid does not vanish; on heating it expands and rises.")]),

 ("HE","The temperature of a cup of water rises from 25°C to 70°C when heated. The rise in temperature, found by 70 − 25, is:",
   "45°C",
   C("Rise = final − initial = 70 − 25 = 45°C — a heat change found by subtraction.")+
   steps("Initial temperature 25°C, final 70°C","rise = final − initial = 70 − 25","70 − 25 = 45, so a 45°C rise."),
   [("95°C","95 ADDS 70 + 25; the rise is 70 − 25 = 45°C."),
    ("70°C","70°C is only the final reading; the rise is 70 − 25 = 45°C."),
    ("25°C","25°C is only the start; the rise is 70 − 25 = 45°C.")]),

 ("HE","Tea cools from 80°C to 65°C while it stands. The fall in temperature, found by 80 − 65, is:",
   "15°C",
   C("Fall = start − end = 80 − 65 = 15°C — a cooling change found by subtraction.")+
   steps("Start 80°C, end 65°C","fall = 80 − 65","80 − 65 = 15, so a 15°C fall."),
   [("145°C","145 ADDS 80 + 65; the fall is 80 − 65 = 15°C."),
    ("65°C","65°C is only the final reading; the fall is 80 − 65 = 15°C."),
    ("80°C","80°C is only the start; the fall is 80 − 65 = 15°C.")]),

 ("HE","Two beakers of water are at 30°C and 50°C. Their average temperature, found by (30 + 50) ÷ 2, is:",
   "40°C",
   C("Average = (30 + 50) ÷ 2 = 80 ÷ 2 = 40°C — a heat reading found by averaging.")+
   steps("Add the two temperatures: 30 + 50 = 80","divide by 2 for the average","80 ÷ 2 = 40, so 40°C."),
   [("80°C","80 is just the SUM; the average is 80 ÷ 2 = 40°C."),
    ("20°C","20 is the difference 50 − 30; the average is (30 + 50) ÷ 2 = 40°C."),
    ("15°C","15 has no basis; the average is (30 + 50) ÷ 2 = 40°C.")]),

 ("HE","A doctor uses a clinical thermometer rather than a laboratory one for a patient because the clinical thermometer's scale is suited to the:",
   "narrow range around body temperature",
   C("A clinical thermometer is marked over the small range that human body temperature falls in, about 35°C to 42°C.")+
   steps("Body temperature only varies a little","the clinical thermometer's scale covers just that small range","so it reads the body accurately."),
   [("very wide range for hot experiments","That is the LABORATORY thermometer; the clinical one covers the narrow body range."),
    ("freezing range below 0°C","Bodies are not below 0°C; the clinical scale covers the body's narrow range."),
    ("range up to boiling water","Boiling ranges suit lab work; the clinical thermometer covers the body's narrow range.")]),

 ("HE","On a hot day, a steel chair feels hotter to the touch than a wooden one kept beside it because steel is a better:",
   "conductor of heat",
   C("Steel conducts heat to your hand faster than wood, so it feels hotter even at the same temperature.")+
   steps("Both chairs are at the same temperature","steel passes heat to your hand quickly","so it feels hotter — steel is a better conductor."),
   [("insulator of heat","An insulator would feel LESS hot; steel feels hotter because it is a better conductor."),
    ("source of heat","Neither chair makes heat; steel just conducts heat faster to the hand."),
    ("reflector of heat","Reflecting heat would keep it cool; steel feels hot because it conducts heat well.")]),

 ("HE","When you hold an ice cube, your hand feels cold because heat flows out of your warm hand and into the:",
   "colder ice",
   C("Heat always moves from the hotter body to the colder one, so it leaves your warm hand and enters the ice.")+
   steps("Your hand is warmer than the ice","heat flows from hot to cold","so heat leaves the hand for the colder ice, and the hand feels cold."),
   [("warmer air","Heat flows toward the COLDER object; the ice, not the warm air, takes heat from your hand."),
    ("hand from the ice","Cold does not flow in; rather heat flows OUT of the hand into the colder ice."),
    ("sunlight","Sunlight is a separate source; the cold feeling comes from heat leaving your hand into the ice.")]),
]

HE_UC = [
 "Knowing temperature is a true measure is why 'it feels hot' is replaced by a real reading.",
 "Knowing the thermometer is how you actually measure how hot or cold something is.",
 "Knowing the clinical thermometer is how a nurse checks if you are running a fever.",
 "Knowing 37°C is normal is how you tell a healthy reading from a fever.",
 "Knowing heat flows hot-to-cold is why a hot drink cools and an ice cube melts.",
 "Knowing conduction is why a metal spoon left in hot tea soon feels hot too.",
 "Knowing convection is why a room heater warms a whole room through moving air.",
 "Knowing radiation is how the Sun's warmth reaches you across empty space.",
 "Knowing metals are good conductors is why pots and pans are made of them.",
 "Knowing wood and wool are insulators is why we use them for handles and warm clothes.",
 "Knowing why pan handles are wood is everyday safety in the kitchen.",
 "Knowing light clothes reflect heat is why summer clothes are pale and cool.",
 "Knowing dark clothes absorb heat is why winter clothes are often dark and warm.",
 "Knowing trapped air insulates is why layered clothing keeps you warmer.",
 "Knowing water freezes at 0°C is a fixed point you use to read any thermometer.",
 "Knowing water boils at 100°C is the other fixed point of the Celsius scale.",
 "Knowing the sea breeze is convection is how you explain a cool coastal afternoon.",
 "Knowing mercury rises with heat is how a traditional thermometer shows temperature.",
 "Knowing liquids expand on heating is the very idea that makes a thermometer work.",
 "Subtracting temperatures is how you find how much a pot of water has warmed up.",
 "Subtracting temperatures is how you find how much a hot drink has cooled.",
 "Averaging temperatures is how you find a fair middle reading from two beakers.",
 "Knowing the clinical scale is narrow is why it suits the body's small range.",
 "Knowing steel conducts well is why a metal seat in the sun feels hotter than wood.",
 "Knowing heat leaves your hand into ice is why holding a cube makes your fingers feel cold.",
]

# ---------- ALGEBRAIC EXPRESSIONS (25) — Maths ----------
AE = [
 ("AE","An expression that is built from variables and numbers joined by operations, such as 3x + 5, is called an:",
   "algebraic expression",
   C("A combination of variables and numbers with operations, like 3x + 5, is an algebraic expression.")+
   steps("Take letters (variables) and numbers","join them with + , − , × or ÷","the result, like 3x + 5, is an algebraic expression."),
   [("equation","An equation has an EQUALS sign; 3x + 5 alone is an expression."),
    ("number line","A number line is a drawing of numbers, not an expression like 3x + 5."),
    ("fraction","A fraction is one number over another; 3x + 5 is an algebraic expression.")]),

 ("AE","In the term 7x, the fixed number 7 multiplying the variable x is called the:",
   "coefficient",
   C("The number multiplying the variable in a term is its coefficient; in 7x the coefficient is 7.")+
   steps("Look at the term 7x","the number multiplying x is 7","that multiplying number is the coefficient."),
   [("variable","The variable is x, the letter; the number 7 is the coefficient."),
    ("constant","A constant stands alone with no variable; 7 here multiplies x, so it is the coefficient."),
    ("exponent","An exponent is a small raised power; 7 in 7x is the coefficient.")]),

 ("AE","In the expression 4y + 9, the number 9 standing alone, with no variable attached, is called a:",
   "constant",
   C("A number with no variable attached, like 9 in 4y + 9, is a constant term.")+
   steps("Look at the parts of 4y + 9","the 9 has no letter with it","such a fixed number is a constant."),
   [("coefficient","A coefficient multiplies a variable; 9 stands alone, so it is a constant."),
    ("variable","A variable is a letter like y; 9 is a fixed number, a constant."),
    ("term with a variable","9 has no variable, so it is a constant, not a variable term.")]),

 ("AE","Terms that have exactly the same variable raised to the same power, such as 3x and 8x, are called:",
   "like terms",
   C("Terms with the same variable part, such as 3x and 8x, are like terms and can be added together.")+
   steps("Compare the variable parts of two terms","3x and 8x both have just x","same variable part means they are like terms."),
   [("unlike terms","Unlike terms have DIFFERENT variable parts; 3x and 8x match, so they are like terms."),
    ("constant terms","Constants have no variable; 3x and 8x have x, so they are like terms."),
    ("equations","An equation has an equals sign; 3x and 8x are like terms.")]),

 ("AE","The like terms 6a and 2a add together to give the single term:",
   "8a",
   C("Like terms add by adding their coefficients: 6a + 2a = (6 + 2)a = 8a.")+
   steps("6a and 2a are like terms","add the coefficients: 6 + 2 = 8","keep the variable: 8a."),
   [("8a²","Adding like terms does NOT change the power; 6a + 2a = 8a, not 8a²."),
    ("12a","12 is 6 × 2; adding gives 6 + 2 = 8, so 8a."),
    ("4a","4 is 6 − 2; adding gives 6 + 2 = 8, so 8a.")]),

 ("AE","The like terms 10m and 4m subtract to give:",
   "6m",
   C("Subtract like terms by subtracting coefficients: 10m − 4m = (10 − 4)m = 6m.")+
   steps("10m and 4m are like terms","subtract the coefficients: 10 − 4 = 6","keep the variable: 6m."),
   [("14m","14 ADDS 10 + 4; subtraction gives 10 − 4 = 6, so 6m."),
    ("6","The variable must stay; 10m − 4m = 6m, not just 6."),
    ("40m","40 multiplies 10 × 4; subtracting gives 6m.")]),

 ("AE","A pencil costs ₹x. The cost of buying 5 such pencils is written as the expression:",
   "5x",
   C("Five pencils at ₹x each cost 5 × x = 5x.")+
   steps("One pencil costs ₹x","five pencils cost 5 times as much","5 × x = 5x."),
   [("x + 5","x + 5 ADDS 5 rupees; five pencils cost 5 times x, which is 5x."),
    ("x − 5","x − 5 subtracts 5; five pencils cost 5x."),
    ("x ÷ 5","Dividing gives the cost of a fraction of a pencil; five pencils cost 5x.")]),

 ("AE","A number is taken as n. The phrase '7 more than the number' is written as the expression:",
   "n + 7",
   C("'7 more than n' means add 7 to n, giving n + 7.")+
   steps("Start with the number n","'7 more' means add 7","so the expression is n + 7."),
   [("7n","7n means 7 TIMES n, not 7 more than n; that is n + 7."),
    ("n − 7","n − 7 is 7 LESS than n; 7 more is n + 7."),
    ("7 − n","7 − n subtracts n from 7; '7 more than n' is n + 7.")]),

 ("AE","If a number is p, then 'three times the number' is written as the expression:",
   "3p",
   C("'Three times p' means 3 multiplied by p, written 3p.")+
   steps("Start with the number p","'three times' means multiply by 3","3 × p = 3p."),
   [("p + 3","p + 3 ADDS 3; three times is 3 × p = 3p."),
    ("p − 3","p − 3 subtracts 3; three times is 3p."),
    ("p ÷ 3","p ÷ 3 is a third of p; three times is 3p.")]),

 ("AE","The expression for 'a number x decreased by 4' is written as:",
   "x − 4",
   C("'Decreased by 4' means subtract 4, giving x − 4.")+
   steps("Start with the number x","'decreased by 4' means take 4 away","so the expression is x − 4."),
   [("x + 4","x + 4 INCREASES x; decreased by 4 is x − 4."),
    ("4 − x","4 − x subtracts x from 4; 'x decreased by 4' is x − 4."),
    ("4x","4x multiplies; decreasing x by 4 gives x − 4.")]),

 ("AE","An expression that contains exactly one term, such as 5xy, is called a:",
   "monomial",
   C("'Mono' means one — an expression of a single term, like 5xy, is a monomial.")+
   steps("Count the terms separated by + or −","5xy is a single term","one term means it is a monomial."),
   [("binomial","A binomial has TWO terms; 5xy is just one, so it is a monomial."),
    ("trinomial","A trinomial has THREE terms; 5xy has one, so it is a monomial."),
    ("equation","An equation needs an equals sign; 5xy is a one-term monomial.")]),

 ("AE","An expression made up of exactly two unlike terms, such as 3x + 5, is called a:",
   "binomial",
   C("'Bi' means two — an expression with two terms, like 3x + 5, is a binomial.")+
   steps("Count the terms in 3x + 5","there are two terms, 3x and 5","two terms means it is a binomial."),
   [("monomial","A monomial has ONE term; 3x + 5 has two, so it is a binomial."),
    ("trinomial","A trinomial has THREE terms; 3x + 5 has two, so it is a binomial."),
    ("constant","A constant is a single number; 3x + 5 is a two-term binomial.")]),

 ("AE","An expression containing exactly three terms, such as x² + 3x + 2, is called a:",
   "trinomial",
   C("'Tri' means three — an expression with three terms is a trinomial.")+
   steps("Count the terms in x² + 3x + 2","there are three separate terms","three terms means it is a trinomial."),
   [("binomial","A binomial has TWO terms; this has three, so it is a trinomial."),
    ("monomial","A monomial has ONE term; this has three, so it is a trinomial."),
    ("coefficient","A coefficient is a number multiplying a variable, not a count of terms.")]),

 ("AE","When x = 2, the value of the expression 3x + 1, found by putting 2 in place of x, is:",
   "7",
   C("Substitute x = 2: 3 × 2 + 1 = 6 + 1 = 7.")+
   steps("Replace x with 2 in 3x + 1","3 × 2 = 6, then 6 + 1","6 + 1 = 7."),
   [("9","9 would be 3 × 2 + 3; here it is 3 × 2 + 1 = 7."),
    ("5","5 forgets to multiply fully; 3 × 2 + 1 = 7."),
    ("8","8 would be 3 × 2 + 2; the constant is 1, so 7.")]),

 ("AE","When y = 5, the value of the expression 2y − 3 is:",
   "7",
   C("Substitute y = 5: 2 × 5 − 3 = 10 − 3 = 7.")+
   steps("Replace y with 5 in 2y − 3","2 × 5 = 10, then 10 − 3","10 − 3 = 7."),
   [("13","13 ADDS instead of subtracts: 10 + 3; it should be 10 − 3 = 7."),
    ("4","4 would be 2 × 5 − 6; the number subtracted is 3, giving 7."),
    ("10","10 forgets the − 3; 2 × 5 − 3 = 7.")]),

 ("AE","Simplifying the expression 4x + 3x by combining the like terms gives:",
   "7x",
   C("4x and 3x are like terms: 4x + 3x = (4 + 3)x = 7x.")+
   steps("4x and 3x have the same variable x","add coefficients: 4 + 3 = 7","keep the variable: 7x."),
   [("12x","12 multiplies 4 × 3; adding like terms gives 4 + 3 = 7, so 7x."),
    ("7x²","Adding like terms does not change the power; 4x + 3x = 7x, not 7x²."),
    ("x","The coefficient is not lost; 4x + 3x = 7x.")]),

 ("AE","In the expression 2x + 3y, the terms 2x and 3y cannot be added into one term because they are:",
   "unlike terms",
   C("2x and 3y have different variables, so they are unlike terms and cannot be combined.")+
   steps("Compare the variable parts: x and y","they are different letters","so 2x and 3y are unlike terms and stay apart."),
   [("like terms","Like terms have the SAME variable; x and y differ, so these are unlike terms."),
    ("constants","Both have variables, so neither is a constant; they are unlike terms."),
    ("equal terms","They are not equal; with different variables they are unlike terms.")]),

 ("AE","A cow eats k kg of fodder each day. The fodder a herd of 6 such cows eats in one day is the expression:",
   "6k",
   C("Six cows each eating k kg eat 6 × k = 6k kg — a Science situation written as an algebraic expression.")+
   steps("One cow eats k kg in a day","six cows eat 6 times as much","6 × k = 6k kg."),
   [("k + 6","k + 6 ADDS 6 kg; six cows eat 6 times k, which is 6k."),
    ("k − 6","k − 6 subtracts 6; six cows eat 6k."),
    ("k ÷ 6","Dividing gives a sixth of one cow's food; six cows eat 6k.")]),

 ("AE","A plant is now h cm tall and grows 2 cm taller. Its new height is written as the expression:",
   "h + 2",
   C("Adding 2 cm of growth to a height of h cm gives h + 2 — a Science change written algebraically.")+
   steps("The plant's height is h cm","it grows 2 cm more","new height = h + 2 cm."),
   [("2h","2h DOUBLES the height; growing 2 cm more gives h + 2."),
    ("h − 2","h − 2 makes it shorter; growing taller gives h + 2."),
    ("2 − h","2 − h subtracts the height from 2; the new height is h + 2.")]),

 ("AE","The breathing rate of a child rises from r breaths a minute by 5 breaths during play. The new rate is the expression:",
   "r + 5",
   C("Adding the rise of 5 to the resting rate r gives r + 5 — a Science change written as an expression.")+
   steps("Resting breathing rate is r","it rises by 5 during play","new rate = r + 5."),
   [("5r","5r MULTIPLIES the rate by 5; a rise of 5 gives r + 5."),
    ("r − 5","r − 5 lowers the rate; a rise gives r + 5."),
    ("5 − r","5 − r subtracts the rate from 5; the new rate is r + 5.")]),

 ("AE","Each test tube holds t mL of liquid. The total liquid in 4 identical test tubes is the expression:",
   "4t",
   C("Four tubes each holding t mL hold 4 × t = 4t mL — a lab quantity written algebraically.")+
   steps("One tube holds t mL","four tubes hold 4 times as much","4 × t = 4t mL."),
   [("t + 4","t + 4 ADDS 4 mL; four tubes hold 4 times t, which is 4t."),
    ("t − 4","t − 4 subtracts 4; four tubes hold 4t."),
    ("t ÷ 4","Dividing gives a quarter of one tube; four tubes hold 4t.")]),

 ("AE","The number of terms in the expression 5x² + 2x + 7 is:",
   "three",
   C("Counting the parts separated by + signs, 5x², 2x and 7 are three terms.")+
   steps("Look at the parts joined by + signs","they are 5x², 2x and 7","that is three terms."),
   [("one","There are three separate parts, not one; the expression has three terms."),
    ("two","There are three parts (5x², 2x, 7), not two; it has three terms."),
    ("five","Five is the coefficient of x², not the term count; there are three terms.")]),

 ("AE","When x = 3, the value of the expression x² (which means x × x) is:",
   "9",
   C("x² means x × x, so when x = 3 it is 3 × 3 = 9.")+
   steps("x² means x multiplied by itself","put x = 3: 3 × 3","3 × 3 = 9."),
   [("6","6 is 3 × 2 (or 3 + 3); x² is 3 × 3 = 9."),
    ("5","5 adds 3 + 2; x² is 3 × 3 = 9."),
    ("23","23 just sticks the digits together; x² is 3 × 3 = 9.")]),

 ("AE","The like terms in the expression 8p + 3q − 2p are 8p and −2p, which combine to give:",
   "6p",
   C("Combine the like terms in p: 8p − 2p = 6p; the 3q stays separate.")+
   steps("Pick the p-terms: 8p and −2p","8p − 2p = 6p","the unlike term 3q is left as it is."),
   [("9p","9 would be 8 + something; 8p − 2p = 6p."),
    ("6pq","Combining p-terms keeps the variable p, not pq; the answer is 6p."),
    ("11p","11 adds 8 + 3; the like p-terms give 8 − 2 = 6p.")]),

 ("AE","Each empty beaker has a mass of b grams. The total mass of 3 such beakers, with an extra 50 g of water added, is the expression:",
   "3b + 50",
   C("Three beakers weigh 3 × b = 3b grams, plus the 50 g of water gives 3b + 50 — a lab total written algebraically.")+
   steps("Three beakers weigh 3 × b = 3b grams","add the 50 g of water","total mass = 3b + 50 grams."),
   [("3b − 50","Water ADDS mass, so it is + 50, not − 50; the total is 3b + 50."),
    ("50b + 3","The number of beakers (3) multiplies b, and 50 is added: 3b + 50, not 50b + 3."),
    ("3b + 3","The extra mass is 50 g, not 3 g; the total is 3b + 50.")]),
]

AE_UC = [
 "Knowing what an algebraic expression is lets you write a rule with letters instead of words.",
 "Knowing the coefficient is how you read how many of a quantity a term stands for.",
 "Knowing a constant is how you spot the fixed part of an expression that never changes.",
 "Knowing like terms is the key skill for tidying up any algebraic expression.",
 "Adding like terms is how you shorten 6a + 2a into a single neat 8a.",
 "Subtracting like terms is how you simplify a difference like 10m − 4m.",
 "Writing 5x for five pencils is how shopping totals turn into algebra.",
 "Writing n + 7 is how '7 more than a number' becomes a usable expression.",
 "Writing 3p is how 'three times a number' is captured in algebra.",
 "Writing x − 4 is how 'decreased by 4' is set down as an expression.",
 "Naming a monomial is how you classify a one-term expression at a glance.",
 "Naming a binomial is how you describe a two-term expression like 3x + 5.",
 "Naming a trinomial is how you describe a three-term expression like x² + 3x + 2.",
 "Substituting a value is how you turn an expression into an actual number.",
 "Substituting into 2y − 3 is the everyday skill of plugging in and computing.",
 "Simplifying 4x + 3x is how you reduce an expression to its shortest form.",
 "Knowing unlike terms stay apart is how you avoid the classic 2x + 3y mistake.",
 "Writing 6k for a herd's fodder is how a farmer turns feeding into algebra.",
 "Writing h + 2 for a plant's growth links a Science change to an expression.",
 "Writing r + 5 for a faster breathing rate shows Science data as algebra.",
 "Writing 4t for four test tubes is how a lab total becomes an expression.",
 "Counting terms is how you describe and classify any expression precisely.",
 "Knowing x² means x times x is how you read powers inside an expression.",
 "Combining like terms among unlike ones is real-world algebra tidying.",
 "Writing 3b + 50 is how a lab total with a fixed extra becomes one neat expression.",
]

# ---------- THE TRIANGLE & ITS PROPERTIES (25) — Maths ----------
TR = [
 ("TR","A closed figure made by three line segments joined end to end is called a:",
   "triangle",
   C("Three line segments joined end to end form a closed three-sided figure — a triangle.")+
   steps("Join three line segments end to end","they close up into a figure","a three-sided closed figure is a triangle."),
   [("square","A square has FOUR sides; a three-sided figure is a triangle."),
    ("circle","A circle is a curved closed figure with no straight sides; three segments make a triangle."),
    ("rectangle","A rectangle has four sides; three segments make a triangle.")]),

 ("TR","A triangle has three sides, three corners and three:",
   "angles",
   C("Each corner of a triangle holds an angle, so a triangle has three angles.")+
   steps("A triangle has three corners","an angle sits at each corner","so there are three angles."),
   [("circles","A triangle has no circles; at its three corners are three angles."),
    ("curves","A triangle's sides are straight, not curves; it has three angles."),
    ("diagonals","A triangle has no diagonals inside it; it has three angles.")]),

 ("TR","A triangle in which all three sides are equal in length is called an:",
   "equilateral triangle",
   C("When all three sides are equal, the triangle is equilateral.")+
   steps("Compare the three sides","all three are the same length","such a triangle is equilateral."),
   [("isosceles triangle","An isosceles triangle has only TWO equal sides; all three equal is equilateral."),
    ("scalene triangle","A scalene triangle has all sides DIFFERENT; all three equal is equilateral."),
    ("right triangle","A right triangle is named for a 90° angle, not equal sides; all equal is equilateral.")]),

 ("TR","A triangle in which exactly two sides are equal in length is called an:",
   "isosceles triangle",
   C("A triangle with two equal sides is isosceles.")+
   steps("Compare the three sides","exactly two of them are equal","such a triangle is isosceles."),
   [("equilateral triangle","An equilateral triangle has ALL three sides equal; two equal is isosceles."),
    ("scalene triangle","A scalene triangle has NO equal sides; two equal is isosceles."),
    ("obtuse triangle","Obtuse is about an angle over 90°, not equal sides; two equal sides is isosceles.")]),

 ("TR","A triangle in which all three sides are of different lengths is called a:",
   "scalene triangle",
   C("When no two sides are equal, the triangle is scalene.")+
   steps("Compare the three sides","all three lengths are different","such a triangle is scalene."),
   [("equilateral triangle","An equilateral triangle has all sides EQUAL; all different is scalene."),
    ("isosceles triangle","An isosceles triangle has two equal sides; all different is scalene."),
    ("right triangle","A right triangle is named for a 90° angle; all sides different is scalene.")]),

 ("TR","A triangle that has one of its angles exactly equal to 90° is called a:",
   "right-angled triangle",
   C("A triangle with one 90° angle is a right-angled triangle.")+
   steps("Look at the three angles","one of them is exactly 90°","such a triangle is right-angled."),
   [("acute-angled triangle","In an acute triangle ALL angles are under 90°; one 90° angle makes it right-angled."),
    ("obtuse-angled triangle","An obtuse triangle has an angle OVER 90°; exactly 90° makes it right-angled."),
    ("equilateral triangle","An equilateral triangle's angles are all 60°; a 90° angle makes it right-angled.")]),

 ("TR","A triangle in which each of the three angles is less than 90° is called an:",
   "acute-angled triangle",
   C("When all three angles are below 90°, the triangle is acute-angled.")+
   steps("Check all three angles","each one is less than 90°","such a triangle is acute-angled."),
   [("right-angled triangle","A right triangle has one 90° angle; all under 90° is acute-angled."),
    ("obtuse-angled triangle","An obtuse triangle has one angle over 90°; all under 90° is acute-angled."),
    ("scalene triangle","Scalene is about unequal sides, not angles; all angles under 90° is acute-angled.")]),

 ("TR","A triangle in which one angle is greater than 90° is called an:",
   "obtuse-angled triangle",
   C("A triangle with one angle larger than 90° is obtuse-angled.")+
   steps("Look at the three angles","one of them is more than 90°","such a triangle is obtuse-angled."),
   [("acute-angled triangle","In an acute triangle all angles are UNDER 90°; one over 90° is obtuse-angled."),
    ("right-angled triangle","A right triangle's special angle is exactly 90°; over 90° is obtuse-angled."),
    ("equilateral triangle","An equilateral triangle's angles are all 60°; one over 90° is obtuse-angled.")]),

 ("TR","The three angles inside any triangle always add up to exactly:",
   "180°",
   C("The angle-sum property says the three interior angles of any triangle total 180°.")+
   steps("Take any triangle","add its three interior angles","the total is always 180°."),
   [("90°","90° is a single right angle; the THREE angles of a triangle total 180°."),
    ("360°","360° is the angle sum of a four-sided figure; a triangle's three angles total 180°."),
    ("270°","270° has no basis; a triangle's three angles always add to 180°.")]),

 ("TR","Two angles of a triangle are 50° and 60°. Using the angle-sum rule, the third angle is:",
   "70°",
   C("Third angle = 180° − (50° + 60°) = 180° − 110° = 70°.")+
   steps("Two angles add to 50 + 60 = 110°","the three must total 180°","180 − 110 = 70, so the third is 70°."),
   [("110°","110° is just the SUM of the two given angles; the third is 180 − 110 = 70°."),
    ("80°","80° does not fit; 180 − (50 + 60) = 70°."),
    ("90°","90° does not fit the totals; the third angle is 180 − 110 = 70°.")]),

 ("TR","Each angle of an equilateral triangle measures, since the three equal angles share 180°:",
   "60°",
   C("Equilateral angles are equal and total 180°, so each is 180° ÷ 3 = 60°.")+
   steps("All three angles are equal and total 180°","divide: 180 ÷ 3","180 ÷ 3 = 60, so each is 60°."),
   [("90°","90° each would total 270°; equal angles of an equilateral are 180 ÷ 3 = 60°."),
    ("45°","45° each would total 135°; each equilateral angle is 60°."),
    ("30°","30° each would total 90°; each equilateral angle is 60°.")]),

 ("TR","In a right-angled triangle, one angle is 90° and another is 40°. The third angle is:",
   "50°",
   C("Third angle = 180° − (90° + 40°) = 180° − 130° = 50°.")+
   steps("Two angles add to 90 + 40 = 130°","the three must total 180°","180 − 130 = 50, so 50°."),
   [("130°","130° is just the SUM of the two given angles; the third is 180 − 130 = 50°."),
    ("40°","40° repeats a given angle; the third is 180 − 130 = 50°."),
    ("60°","60° does not fit the totals; 180 − 130 = 50°.")]),

 ("TR","A line drawn from one vertex of a triangle straight to the mid-point of the opposite side is called a:",
   "median",
   C("A median runs from a corner to the middle of the opposite side.")+
   steps("Pick a corner of the triangle","draw to the MIDDLE of the opposite side","this segment is a median."),
   [("altitude","An altitude is the PERPENDICULAR height from a vertex, not the line to the mid-point."),
    ("base","The base is a side of the triangle, not a line from a vertex to a mid-point."),
    ("hypotenuse","The hypotenuse is the longest side of a right triangle, not the vertex-to-midpoint line.")]),

 ("TR","The perpendicular distance from a vertex of a triangle to the line of its opposite side is called the:",
   "altitude (height)",
   C("The altitude is the perpendicular drop from a vertex to the opposite side — the triangle's height.")+
   steps("Pick a vertex of the triangle","drop a PERPENDICULAR to the opposite side","this perpendicular height is the altitude."),
   [("median","A median goes to the MID-POINT, not at a right angle; the perpendicular one is the altitude."),
    ("hypotenuse","The hypotenuse is a side of a right triangle, not the perpendicular height."),
    ("perimeter","The perimeter is the boundary length, not the perpendicular height, which is the altitude.")]),

 ("TR","In a right-angled triangle, the longest side, lying opposite the right angle, is called the:",
   "hypotenuse",
   C("The side opposite the 90° angle in a right triangle is the longest side, the hypotenuse.")+
   steps("Find the 90° angle in the triangle","the side facing it is the longest","that side is the hypotenuse."),
   [("median","A median is a line to a mid-point, not the longest side; that is the hypotenuse."),
    ("altitude","The altitude is the height, not a side; the longest side is the hypotenuse."),
    ("base","The base is any chosen side; the side opposite the right angle is the hypotenuse.")]),

 ("TR","By the Pythagoras property, in a right triangle the square on the hypotenuse equals the sum of the squares on the other two:",
   "sides",
   C("Pythagoras: (hypotenuse)² = sum of the squares of the other two sides.")+
   steps("Take a right-angled triangle","square the hypotenuse","it equals the squares of the other two sides added."),
   [("angles","The property is about side LENGTHS squared, not angles; it uses the other two sides."),
    ("medians","Medians are not part of Pythagoras; the rule uses the other two sides."),
    ("altitudes","Altitudes are not in this rule; Pythagoras uses the other two sides.")]),

 ("TR","A right triangle has legs of 3 cm and 4 cm. By Pythagoras, since 3² + 4² = 9 + 16 = 25, the hypotenuse is:",
   "5 cm",
   C("Hypotenuse² = 3² + 4² = 9 + 16 = 25, so the hypotenuse = √25 = 5 cm.")+
   steps("3² + 4² = 9 + 16 = 25","the hypotenuse squared is 25","√25 = 5, so 5 cm."),
   [("7 cm","7 just ADDS 3 + 4; Pythagoras gives √(9 + 16) = √25 = 5 cm."),
    ("12 cm","12 multiplies 3 × 4; the hypotenuse is √25 = 5 cm."),
    ("25 cm","25 is the hypotenuse SQUARED; the hypotenuse itself is √25 = 5 cm.")]),

 ("TR","The exterior angle of a triangle is equal to the sum of the two interior opposite angles. If those two are 45° and 65°, the exterior angle is:",
   "110°",
   C("Exterior angle = sum of the two interior opposite angles = 45° + 65° = 110°.")+
   steps("Add the two interior opposite angles","45 + 65 = 110","so the exterior angle is 110°."),
   [("20°","20 SUBTRACTS 65 − 45; the exterior angle is the SUM, 45 + 65 = 110°."),
    ("70°","70° would be 180 − 110, the third interior angle, not the exterior angle, which is 110°."),
    ("90°","90° does not match; the exterior angle equals 45 + 65 = 110°.")]),

 ("TR","Adding the lengths of any two sides of a triangle always gives a total greater than the remaining:",
   "third side",
   C("Triangle inequality: any two sides together are longer than the remaining third side.")+
   steps("Take any two sides of a triangle","add their lengths","the total is greater than the third side."),
   [("longest angle","The rule compares side LENGTHS, not angles; two sides exceed the third side."),
    ("perimeter","The perimeter is all three sides; two of them exceed only the third side."),
    ("area","Area is a surface measure, not a length; two sides exceed the third side.")]),

 ("TR","Can a triangle be drawn with sides 2 cm, 3 cm and 8 cm? Because 2 + 3 = 5 is not greater than 8, such a triangle is:",
   "not possible",
   C("Triangle inequality fails: 2 + 3 = 5 is less than 8, so these sides cannot form a triangle.")+
   steps("Add the two shorter sides: 2 + 3 = 5","compare with the longest: 5 is less than 8","since it is not greater, the triangle is not possible."),
   [("possible and equilateral","The sides are unequal and the inequality fails, so no triangle forms at all."),
    ("possible and right-angled","The sides cannot even form a triangle, since 2 + 3 is not greater than 8."),
    ("possible and isosceles","No two sides are equal and the inequality fails; no triangle is possible.")]),

 ("TR","An equilateral triangular sign has each side 9 cm long. Its perimeter, found by 3 × side, is:",
   "27 cm",
   C("Perimeter of an equilateral triangle = 3 × side = 3 × 9 = 27 cm.")+
   steps("All three sides are 9 cm","perimeter = 3 × 9","3 × 9 = 27, so 27 cm."),
   [("18 cm","18 is only two sides (2 × 9); a triangle has three, giving 3 × 9 = 27 cm."),
    ("12 cm","12 ADDS 9 + 3; the perimeter is 3 × 9 = 27 cm."),
    ("81 cm","81 is 9 × 9 (an area-like product); the perimeter is 3 × 9 = 27 cm.")]),

 ("TR","A triangular plot has sides 12 m, 15 m and 13 m. The fencing needed once around it (its perimeter), found by 12 + 15 + 13, is:",
   "40 m",
   C("Perimeter = sum of all sides = 12 + 15 + 13 = 40 m.")+
   steps("Add all three sides","12 + 15 + 13","the total is 40, so 40 m."),
   [("27 m","27 leaves out one side; all three give 12 + 15 + 13 = 40 m."),
    ("25 m","25 adds only two sides; all three give 40 m."),
    ("180 m","180 confuses this with the angle sum; the perimeter is 12 + 15 + 13 = 40 m.")]),

 ("TR","An isosceles triangle has two equal angles. If its third (unequal) angle is 80°, then each of the two equal angles is:",
   "50°",
   C("The two equal angles share 180° − 80° = 100°, so each is 100° ÷ 2 = 50°.")+
   steps("Three angles total 180°; one is 80°","the two equal ones share 180 − 80 = 100°","100 ÷ 2 = 50, so each is 50°."),
   [("100°","100° is the SUM the two equal angles share; each one is 100 ÷ 2 = 50°."),
    ("80°","80° is the unequal third angle, not the equal ones, which are 50° each."),
    ("40°","40° each would total 80° with the 80° apex = 160°, not 180°; each is 50°.")]),

 ("TR","A ladder leaning on a wall makes a right-angled triangle with the ground. The right angle is formed between the wall and the:",
   "ground",
   C("The wall stands vertical and the ground is horizontal, so they meet at the right angle of the triangle.")+
   steps("The wall is upright, the ground is flat","upright and flat meet at 90°","so the right angle is between the wall and the ground."),
   [("ladder","The ladder is the sloping hypotenuse; the right angle is between wall and ground."),
    ("sky","The sky is not a side of the triangle; the right angle is between wall and ground."),
    ("sun","The Sun is not part of the triangle; the right angle is between wall and ground.")]),

 ("TR","A triangle can never have two right angles, because two 90° angles already total 180°, leaving nothing for the:",
   "third angle",
   C("Since all three angles must total 180°, two right angles use up the whole 180°, so the third angle would be 0° — impossible.")+
   steps("All three angles total 180°","two right angles already make 90 + 90 = 180°","that leaves 0° for the third angle, which cannot be."),
   [("first angle","The first angle is one of the two 90° angles; what is left with nothing is the third angle."),
    ("longest side","The rule is about angles totalling 180°, not sides; nothing is left for the third angle."),
    ("perimeter","The perimeter is a length, not an angle; two right angles leave nothing for the third angle.")]),
]

TR_UC = [
 "Knowing a triangle is three joined segments is the start of all triangle geometry.",
 "Knowing a triangle has three angles is how you connect its corners to its angle sum.",
 "Knowing the equilateral triangle is how you describe a perfectly even three-sided sign.",
 "Knowing the isosceles triangle is how you name a shape with two matching sides.",
 "Knowing the scalene triangle is how you describe a triangle with no equal sides.",
 "Knowing the right triangle is how you spot the 90°-corner shape in ramps and ladders.",
 "Knowing the acute triangle is how you classify one whose every angle is sharp.",
 "Knowing the obtuse triangle is how you name one with a single wide angle.",
 "Knowing angles sum to 180° is the single most useful triangle fact you will reuse.",
 "Finding a missing angle is the everyday use of the 180° angle-sum rule.",
 "Knowing each equilateral angle is 60° is a fact you reuse in design and tiling.",
 "Finding the third angle of a right triangle is a quick 180°-minus-the-rest sum.",
 "Knowing the median is how you locate a balancing line of a triangular shape.",
 "Knowing the altitude is how you measure a triangle's height for its area.",
 "Knowing the hypotenuse is how you name the longest side of a right triangle.",
 "Knowing Pythagoras links the three sides of every right-angled triangle.",
 "Using the 3-4-5 triangle is how builders check a corner is truly square.",
 "Knowing the exterior-angle rule is a shortcut for finding angles without the full sum.",
 "Knowing the triangle inequality is how you tell which side lengths can form a triangle.",
 "Testing 2-3-8 is how you quickly reject side lengths that cannot make a triangle.",
 "Finding an equilateral perimeter is how you edge a triangular sign with tape.",
 "Adding three sides is exactly how you measure fencing for a triangular plot.",
 "Splitting the equal angles is how you solve an isosceles triangle from one angle.",
 "Seeing a leaning ladder as a right triangle is everyday geometry in action.",
 "Knowing why two right angles are impossible deepens your grip on the 180° rule.",
]


def _with_uc(lst, ucs):
    assert len(lst) == len(ucs) == 25, (len(lst), len(ucs))
    out = []
    for it, uc in zip(lst, ucs):
        code, stem, correct, html, distr = it
        out.append((code, stem, correct, html + U(uc), distr))
    return out


NA = _with_uc(NA, NA_UC)
HE = _with_uc(HE, HE_UC)
AE = _with_uc(AE, AE_UC)
TR = _with_uc(TR, TR_UC)

items = []
for i in range(25):
    items += [NA[i], HE[i], AE[i], TR[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=36911,
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
    split = "/".join(str(counts[c]) for c in ("NA", "HE", "AE", "TR"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Nutrition in Animals",
                     "Heat",
                     "Algebraic Expressions",
                     "The Triangle & its Properties"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
