# -*- coding: utf-8 -*-
# Boss Challenge Paper 50 — Weather, Climate & Adaptations · Nutrition in
# Animals · Integers · The Triangle & its Properties
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: leans hard into FUSION. A temperature falling below zero
# becomes an INTEGER subtraction; an average day/night temperature is a mean
# of signed numbers; a tooth count is reached by integer arithmetic; the
# angles of a triangle close to 180 are read from a Science-flavoured setting.
# The child meets a Science situation and reaches for a Maths skill.
# Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_50_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_50_<SHORT>_QuestionPaper.pdf
#   Paper_50_<SHORT>_Questions.md
#   Paper_50_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "50"
SHORT = "WeatherClimate_NutritionAnimals_Integers_Triangle"
TITLE = ("Weather, Climate & Adaptations · Nutrition in Animals · "
         "Integers · The Triangle & its Properties")
LABELS = {
    "WC": "Weather, Climate & Adaptations",
    "NA": "Nutrition in Animals",
    "IN": "Integers",
    "TR": "The Triangle & its Properties",
}

# ---------- WEATHER, CLIMATE & ADAPTATIONS (25) — several fused with Integers ----------
WC = [
 ("WC","The day-to-day state of the atmosphere at a place — its temperature, humidity and rainfall right now — is called the:",
   "weather",
   C("Weather is the short-term, day-to-day condition of the atmosphere: today it may be sunny, tomorrow rainy.")+
   steps("Look at the time-scale: it changes from hour to hour and day to day","that short-term atmospheric condition","is called the weather.")+
   U("A morning weather bulletin tells you whether to carry an umbrella to school today."),
   [("climate","Climate is the average weather over many years, not the day-to-day state described here."),
    ("humidity","Humidity is only one element of weather — the moisture in air — not the whole day-to-day condition."),
    ("season","A season spans months; the moment-to-moment atmospheric state is the weather.")]),

 ("WC","Taken over about 25 years, the average long-term pattern of weather at a place is called its:",
   "climate",
   C("Climate is the average weather of a region measured over a long time (about 25 years), so it changes only slowly.")+
   steps("Average the weather over many, many years","that long-term pattern of a place","is called its climate.")+
   U("We say a desert has a 'hot and dry climate' because that has been its long-term pattern, not just today."),
   [("weather","Weather is the short, day-to-day condition; the long-term average over 25 years is the climate."),
    ("temperature","Temperature is a single element measured; the long-term average pattern is the climate."),
    ("forecast","A forecast predicts a few days ahead; the long-term average of a place is its climate.")]),

 ("WC","The instrument used to measure the temperature of the air is a:",
   "thermometer",
   C("A thermometer measures temperature. A maximum–minimum thermometer records the day's highest and lowest readings.")+
   steps("We want to read how hot or cold the air is","the instrument that measures temperature","is the thermometer.")+
   U("The weather station's thermometer logs each day's high and low for the records."),
   [("rain gauge","A rain gauge measures how much rain has fallen, not the air temperature."),
    ("barometer","A barometer measures air pressure; temperature is read on a thermometer."),
    ("anemometer","An anemometer measures wind speed; the air's temperature is read on a thermometer.")]),

 ("WC","The amount of water vapour (moisture) present in the air is known as:",
   "humidity",
   C("Humidity is the moisture content of air. On a humid day sweat dries slowly because the air is already full of water vapour.")+
   steps("Notice the air feels sticky and sweat won't dry","that moisture in the air","is called humidity.")+
   U("Coastal cities feel sticky in summer because the sea makes the humidity high."),
   [("rainfall","Rainfall is water that has already fallen; moisture still in the air is humidity."),
    ("temperature","Temperature is how hot the air is; the water vapour in it is humidity."),
    ("pressure","Pressure is the push of air; the moisture content of air is humidity.")]),

 ("WC","A polar bear survives the freezing Arctic mainly because of its:",
   "thick fur and a layer of fat under the skin",
   C("Thick fur plus a fat (blubber) layer trap heat and insulate the polar bear against the bitter Arctic cold.")+
   steps("The Arctic is freezing, so the bear must keep body heat in","thick fur and an under-skin fat layer trap that heat","so these are its key cold adaptations.")+
   U("Seals and whales also carry thick blubber to stay warm in icy seas."),
   [("large ears that give off heat","Large heat-losing ears suit a hot desert; in the cold Arctic the bear must KEEP heat with fur and fat."),
    ("thin skin with little fur","Thin, bare skin would lose heat fast; the polar bear needs thick fur and fat to survive."),
    ("ability to store water in a hump","A water-storing hump is a camel's desert adaptation, not a polar-cold one.")]),

 ("WC","At dawn a hill station read −2 °C; by noon it had risen to 6 °C. The rise in temperature was:",
   "8 °C",
   C("A rise from −2 °C to 6 °C is found by subtracting: 6 − (−2) = 6 + 2 = 8, so the temperature rose by 8 °C.")+
   steps("Rise = final − start = 6 − (−2)","subtracting a negative adds: 6 + 2","= 8, so the rise is 8 °C.")+
   U("Mountain mornings start below zero and warm up fast once the sun is high."),
   [("4 °C","4 ignores the sign; from −2 up to 6 the gap is 6 + 2 = 8 °C, not 4."),
    ("6 °C","6 is just the noon reading; the rise is the difference 6 − (−2) = 8 °C."),
    ("−8 °C","A rise is positive; the temperature went up by 8 °C, not down.")]),

 ("WC","Birds like the Siberian crane fly thousands of kilometres to escape harsh winters. This seasonal journey is called:",
   "migration",
   C("Migration is the seasonal movement of animals to a more suitable place — birds leave freezing lands for warmer feeding grounds.")+
   steps("Winter makes the home region too harsh for food and warmth","the birds travel far to a better place each season","this seasonal journey is migration.")+
   U("Siberian cranes spend winter in India's wetlands, then return north for summer."),
   [("hibernation","Hibernation is a deep winter sleep in one place; flying away to a warmer region is migration."),
    ("adaptation","Adaptation is a built-in feature; the seasonal long-distance travel itself is migration."),
    ("camouflage","Camouflage is blending with surroundings; a seasonal journey to a warmer place is migration.")]),

 ("WC","The instrument that measures how much rain has fallen at a place is the:",
   "rain gauge",
   C("A rain gauge collects falling rain in a measuring cylinder so the rainfall can be read off in millimetres.")+
   steps("We want the depth of rain that has fallen","the funnel-and-cylinder instrument that collects it","is the rain gauge.")+
   U("Farmers check the rain gauge to know if their fields got enough water this week."),
   [("thermometer","A thermometer measures temperature, not the amount of rain — that is the rain gauge."),
    ("hygrometer","A hygrometer measures humidity in the air, not the rain collected — that is the rain gauge."),
    ("wind vane","A wind vane shows wind direction; collected rainfall is measured by the rain gauge.")]),

 ("WC","Animals of the hot, sandy desert, such as the camel, are mainly adapted to cope with:",
   "very little water and great heat",
   C("Deserts are hot and dry, so their animals are built to save water and bear heat — the camel stores fat in its hump and loses little water.")+
   steps("Deserts have scorching days and almost no water","so animals must conserve water and survive heat","that is the camel's main challenge.")+
   U("A camel can go many days without drinking, crossing the desert with ease."),
   [("freezing cold and ice","Freezing cold suits polar animals; desert animals face heat and dryness, not ice."),
    ("constant heavy rain","Heavy rain suits rainforest life; the desert is dry, so its animals save water."),
    ("deep shade and darkness","Deserts are bright and open; the real challenge is heat and scarce water.")]),

 ("WC","A tropical rainforest, found near the equator, has a climate that is:",
   "hot and very wet (humid) all year",
   C("Lying near the equator, tropical rainforests get strong sun and heavy rain, so they stay hot and humid throughout the year.")+
   steps("Near the equator the sun is strong all year","with frequent heavy rain","the climate stays hot and very humid.")+
   U("The Western Ghats and Amazon stay green and steamy the whole year round."),
   [("hot and very dry","Hot-and-dry describes a desert; rainforests get heavy rain, so they are hot and humid."),
    ("cold and snowy","Cold and snowy fits polar regions; the equatorial rainforest is hot and wet."),
    ("mild with four equal seasons","Sharp four-season change suits temperate lands; the rainforest is hot and humid year-round.")]),

 ("WC","On three winter mornings a town recorded −4 °C, 0 °C and 4 °C. The average (mean) of these temperatures is:",
   "0 °C",
   C("Average = (sum of readings) ÷ (number of readings). Here (−4 + 0 + 4) ÷ 3 = 0 ÷ 3 = 0 °C.")+
   steps("Add the readings: −4 + 0 + 4 = 0","divide by how many there are: 0 ÷ 3","= 0 °C, the average.")+
   U("Weather scientists average daily readings to describe a month's typical cold."),
   [("4 °C","4 is the warmest single reading, not the average; the mean of −4, 0, 4 is 0 °C."),
    ("−4 °C","−4 is the coldest single reading; the average of the three is 0 °C."),
    ("8 °C","8 wrongly adds without the negative; −4 + 0 + 4 = 0, so the mean is 0 °C.")]),

 ("WC","The huge flat ears of an elephant help it mainly to:",
   "lose extra body heat and stay cool",
   C("An elephant's large, thin ears carry many blood vessels; flapping them releases heat, cooling the animal in hot climates.")+
   steps("Big thin ears expose a lot of warm blood to the air","flapping them lets heat escape","so the ears help the elephant cool down.")+
   U("On a hot day an elephant fans its great ears like two living radiators."),
   [("hear sounds from far underwater","Elephants are land animals; the giant ears are mainly for losing heat, though they do aid hearing on land."),
    ("store water for the dry season","Elephants store no water in their ears; the ears help them shed heat and keep cool."),
    ("frighten away all predators","Ear-flapping can warn rivals, but the main job of the big ears is to release body heat.")]),

 ("WC","Which set lists only ELEMENTS of weather that a weather report describes?",
   "temperature, humidity, rainfall and wind",
   C("Weather is described by its elements — temperature, humidity, rainfall and wind — all of which can change day to day.")+
   steps("List what a weather report actually states each day","temperature, humidity, rainfall and wind speed/direction","these are the elements of weather.")+
   U("A TV weather slot reads out exactly these: temperature, humidity, chance of rain and wind."),
   [("rocks, soil and minerals","Rocks and soil belong to the land, not the atmosphere; weather elements are temperature, humidity, rainfall and wind."),
    ("rivers, lakes and oceans","Water bodies are landscape features, not daily weather elements like temperature and rainfall."),
    ("plants, animals and forests","Living things are not weather elements; the report covers temperature, humidity, rainfall and wind.")]),

 ("WC","The polar regions are far colder than the equator chiefly because there the Sun's rays:",
   "strike the ground very slantingly and spread out",
   C("Near the poles sunlight hits at a low slanting angle, spreading the same energy over a larger area, so it heats the ground far less.")+
   steps("At the poles the Sun stays low in the sky","its slanting rays spread the heat thinly over a wide area","so the poles receive far less warmth and stay cold.")+
   U("This slanting-sunlight idea explains why high latitudes never get tropical heat."),
   [("never reach the polar ground at all","Sunlight does reach the poles for months; it just arrives slanting and weak, so the poles stay cold."),
    ("are blocked completely by clouds","Clouds vary; the steady reason the poles are cold is the slanting, spread-out sunlight."),
    ("carry no heat energy near the poles","Sunlight always carries heat; near the poles it simply lands slanting and spreads thin.")]),

 ("WC","A penguin colony huddles tightly together in the Antarctic mainly to:",
   "share warmth and reduce heat loss",
   C("By packing close, penguins cut the cold surface each bird exposes, trapping warmth among them and surviving the brutal Antarctic cold.")+
   steps("Standing alone, each penguin loses heat fast to the freezing air","huddling shields most of each body and shares warmth","so huddling keeps the colony warm.")+
   U("In a blizzard, emperor penguins take turns moving to the warm middle of the huddle."),
   [("catch more fish on the ice","Fishing happens in the sea, not in a land huddle; huddling is about sharing warmth."),
    ("hide from the bright sunlight","Antarctic cold, not sunlight, is the threat; huddling conserves body heat."),
    ("lay their eggs more quickly","Huddling does not speed egg-laying; its purpose is to share warmth and cut heat loss.")]),

 ("WC","At midnight a polar station read −9 °C. By the next midday the temperature had risen by 5 degrees. The midday reading was:",
   "−4 °C",
   C("Starting at −9 °C and rising 5 degrees gives −9 + 5 = −4 °C — still below zero, but warmer than midnight.")+
   steps("New temperature = start + rise = −9 + 5","moving 5 steps up the number line from −9 lands on −4","so midday read −4 °C.")+
   U("Even a 'warm' polar noon can stay well below freezing."),
   [("−14 °C","−14 wrongly subtracts the rise; rising 5 from −9 gives −9 + 5 = −4 °C."),
    ("4 °C","4 forgets it began deep below zero; −9 + 5 = −4 °C, still negative."),
    ("−5 °C","−5 mis-adds by one; −9 + 5 is exactly −4 °C.")]),

 ("WC","A red-eyed tree frog and a toucan with a long light beak are animals you would expect to find in a:",
   "tropical rainforest",
   C("Bright tree frogs and big-beaked toucans are classic rainforest animals, adapted to its dense, wet, leafy world.")+
   steps("Recall their home: thick wet forest near the equator","frogs that climb trees, birds with showy beaks","this is the tropical rainforest.")+
   U("Documentaries on the Amazon show toucans and tree frogs among the high branches."),
   [("polar ice cap","The icy poles have no trees for tree frogs or toucans; these are rainforest animals."),
    ("sandy desert","The dry desert lacks the moisture these animals need; they belong to the rainforest."),
    ("grassland savanna","Open grassland suits grazers; the leafy tree frog and toucan belong to the rainforest.")]),

 ("WC","Over one week a city's noon temperatures had a highest reading of 9 °C and a lowest of −3 °C. The range (highest − lowest) was:",
   "12 °C",
   C("Range = highest − lowest = 9 − (−3) = 9 + 3 = 12, so the temperatures spanned 12 °C that week.")+
   steps("Range = highest − lowest = 9 − (−3)","subtracting a negative adds: 9 + 3","= 12 °C.")+
   U("Weather charts quote a daily 'range' to show how much the temperature swings."),
   [("6 °C","6 ignores the negative sign; 9 − (−3) = 9 + 3 = 12 °C."),
    ("9 °C","9 is just the highest reading; the range is 9 − (−3) = 12 °C."),
    ("−12 °C","A range (a gap) is positive; here it is 12 °C, not −12.")]),

 ("WC","Animals living in tropical rainforests often have very specific features, such as a monkey's long gripping tail, because:",
   "competition for food and space is very high there",
   C("Rainforests teem with life, so animals develop special features — strong tails, sharp beaks, bright colours — to compete for food, mates and living space.")+
   steps("Rainforests are packed with many species","each must find food and space among fierce competition","so they evolve special adaptations like gripping tails.")+
   U("Spider monkeys swing and hang by their tails to reach fruit other animals can't."),
   [("there is almost no life to compete with","Rainforests are crowded with life; the fierce competition is exactly why such adaptations arise."),
    ("the climate is freezing cold","Rainforests are hot and humid, not freezing; adaptations there meet competition, not cold."),
    ("there is no rainfall at all","Rainforests get heavy rain; the special features handle crowded competition, not dryness.")]),

 ("WC","Which statement correctly contrasts weather and climate?",
   "Weather can change within a day, while climate is the long-term average over years",
   C("Weather is short and changeable (today vs tomorrow); climate is the steady long-term average of a place over many years.")+
   steps("Weather = the atmosphere right now, changing day to day","climate = its average pattern over about 25 years","so weather is short-term, climate long-term.")+
   U("One rainy day doesn't change a desert's dry CLIMATE — it's just a day's WEATHER."),
   [("Weather is the 25-year average, while climate changes each hour","This swaps them: climate is the long-term average, weather is what changes hourly."),
    ("Weather and climate mean exactly the same thing","They differ in time-scale: weather is day-to-day, climate is the long-term average."),
    ("Climate refers only to rainfall, weather only to wind","Both cover all elements; the real difference is the time-scale, short vs long.")]),

 ("WC","A maximum–minimum thermometer is specially useful because it records the:",
   "highest and lowest temperatures reached in a period",
   C("A maximum–minimum thermometer remembers both the hottest and coldest readings reached, so the day's high and low can be read at once.")+
   steps("We want both extremes of the day, not just the current value","a max–min thermometer holds the highest and lowest reached","so it reports the day's high and low.")+
   U("A gardener checks the night's lowest reading to know if frost threatened the plants."),
   [("amount of rain that fell overnight","Rain is measured by a rain gauge; this thermometer records temperature extremes."),
    ("speed of the wind during the day","Wind speed needs an anemometer; the max–min thermometer records temperature highs and lows."),
    ("humidity of the air at sunrise","Humidity needs a hygrometer; this instrument records the highest and lowest temperatures.")]),

 ("WC","A desert fox has very large ears compared with an Arctic fox's small ears. The large ears mainly help the desert fox to:",
   "give off body heat and stay cool",
   C("Large thin ears expose plenty of warm blood to the air, releasing heat — vital for a fox in the hot desert; the Arctic fox keeps small ears to save heat.")+
   steps("Big ears lose heat; small ears keep heat","the desert is hot, so losing heat is helpful","so large ears keep the desert fox cool.")+
   U("Many desert animals — foxes, hares, elephants — sport big heat-shedding ears."),
   [("hear sounds from underground only","Big ears do sharpen hearing, but in the hot desert their main role is to release body heat."),
    ("store extra food for winter","Ears store no food; in the desert the large ears mainly shed heat to keep the fox cool."),
    ("swim quickly across rivers","Desert foxes rarely swim; the large ears are for losing heat, not swimming.")]),

 ("WC","The lion-tailed macaque, with its silver mane, lives in the rainforests of the:",
   "Western Ghats of India",
   C("The lion-tailed macaque is found in the tropical rainforests of the Western Ghats, where dense wet forest supplies its fruit and shelter.")+
   steps("Recall its rainforest home in India","the long wet ranges along the west coast","these are the Western Ghats.")+
   U("Conserving the Western Ghats protects the rare lion-tailed macaque's only home."),
   [("Thar Desert of Rajasthan","The Thar is a dry desert with no rainforest; the macaque lives in the wet Western Ghats."),
    ("Himalayan snow line","Snowy peaks are too cold for this rainforest monkey; it lives in the Western Ghats."),
    ("coastal mangrove swamps of Bengal","Mangroves are coastal salt swamps; the lion-tailed macaque belongs to the Western Ghats rainforest.")]),

 ("WC","Penguins, polar bears and seals all share thick fat layers under their skin because in their habitat the most important need is to:",
   "keep their body warm in extreme cold",
   C("Polar habitats are bitterly cold, so a thick fat (blubber) layer is the key insulation that keeps these animals' bodies warm.")+
   steps("Their world is freezing cold","a fat layer under the skin traps body heat","so blubber keeps them warm — the key adaptation.")+
   U("Blubber lets seals rest on Antarctic ice without freezing."),
   [("stay cool under a hot sun","Polar regions are cold, not hot; the fat layer keeps these animals warm, not cool."),
    ("float upright on dry sand","These are polar, not desert, animals; the blubber is for warmth in the cold."),
    ("store water for a long drought","Polar regions are not water-short; the fat layer's job is insulation against cold.")]),

 ("WC","On the same winter day a hill town read −6 °C and a coastal town read 11 °C. The coastal town was warmer than the hill town by:",
   "17 °C",
   C("Difference = 11 − (−6) = 11 + 6 = 17, so the coast was 17 °C warmer than the hill town.")+
   steps("Difference = warmer − colder = 11 − (−6)","subtracting a negative adds: 11 + 6","= 17 °C warmer.")+
   U("Coasts stay milder than hills because the sea warms and cools slowly."),
   [("5 °C","5 ignores the sign; 11 − (−6) = 11 + 6 = 17 °C, not 5."),
    ("11 °C","11 is just the coastal reading; the gap to −6 is 17 °C."),
    ("−17 °C","A 'warmer by' amount is positive; the coast was 17 °C warmer.")]),
]

# ---------- NUTRITION IN ANIMALS (25) — a few fused with Integers ----------
NA = [
 ("NA","Taking food into the body through the mouth is the step of nutrition called:",
   "ingestion",
   C("Ingestion is the very first step of nutrition — food is taken into the body through the mouth.")+
   steps("Trace the journey: food first enters the body","through the mouth","this taking-in step is ingestion.")+
   U("Every bite you swallow at the dinner table is the act of ingestion."),
   [("digestion","Digestion is the next step — breaking food down; taking it in through the mouth is ingestion."),
    ("egestion","Egestion is removing undigested waste at the end; taking food in is ingestion."),
    ("absorption","Absorption is taking digested food into the blood; taking food into the mouth is ingestion.")]),

 ("NA","The breaking down of complex food into simpler, soluble substances the body can use is called:",
   "digestion",
   C("Digestion breaks large, complex food molecules into small, soluble ones that the body can absorb and use.")+
   steps("Food taken in is too complex to absorb directly","it is broken into simple, soluble forms","this breakdown is digestion.")+
   U("Chewing bread and the gut's juices turn it into sugars your body can absorb."),
   [("ingestion","Ingestion is merely taking food in; breaking it into simpler forms is digestion."),
    ("assimilation","Assimilation is using absorbed food in cells; the breakdown step is digestion."),
    ("egestion","Egestion removes waste; breaking food into simpler substances is digestion.")]),

 ("NA","The wall of the food pipe and stomach pushes food forward by waves of muscle movement called:",
   "peristalsis",
   C("Peristalsis is the rhythmic wave of muscle contraction that squeezes food down the food pipe and along the gut.")+
   steps("Muscles in the gut wall contract in a wave","squeezing the food forward step by step","this wave-like movement is peristalsis.")+
   U("Peristalsis is why you can swallow even while lying down or upside-down."),
   [("digestion","Digestion is the chemical breakdown of food; the muscular pushing wave is peristalsis."),
    ("absorption","Absorption is food passing into blood; the squeezing wave that moves food is peristalsis."),
    ("respiration","Respiration releases energy in cells; the gut's pushing wave is peristalsis.")]),

 ("NA","The sharp, chisel-shaped front teeth used for biting and cutting food are the:",
   "incisors",
   C("Incisors are the flat, sharp front teeth that bite and cut food into pieces.")+
   steps("Look at the cutting front teeth","flat and chisel-edged for biting","these are the incisors.")+
   U("You use your incisors to bite cleanly into an apple."),
   [("canines","Canines are the pointed teeth beside the incisors, for tearing; the front cutters are incisors."),
    ("molars","Molars are the broad back teeth for grinding; the sharp front cutters are incisors."),
    ("premolars","Premolars grind and crush at the sides; the front biting teeth are the incisors.")]),

 ("NA","The pointed teeth next to the incisors, used mainly for tearing and piercing food, are the:",
   "canines",
   C("Canines are the sharp, pointed teeth beside the incisors, suited to tearing and piercing food.")+
   steps("Find the pointed teeth at the corners of the front","shaped to pierce and tear","these are the canines.")+
   U("A dog's long canine teeth let it tear chunks of meat."),
   [("incisors","Incisors are the flat front cutters; the pointed tearing teeth beside them are canines."),
    ("molars","Molars are broad grinders at the back; the pointed tearing teeth are canines."),
    ("premolars","Premolars crush and grind at the sides; the pointed corner teeth are canines.")]),

 ("NA","A young child has 20 milk teeth. An adult has 32 permanent teeth. The number of extra teeth an adult has is:",
   "12",
   C("Extra teeth = adult − child = 32 − 20 = 12, so an adult has 12 more teeth than a young child.")+
   steps("Extra = 32 − 20","subtract: 32 − 20 = 12","so there are 12 extra teeth in an adult.")+
   U("As you grow, more teeth come in at the back to chew tougher adult food."),
   [("52","52 wrongly adds 32 + 20; the EXTRA is the difference 32 − 20 = 12."),
    ("20","20 is the milk-teeth count; the extra over that, up to 32, is 12."),
    ("10","10 mis-subtracts; 32 − 20 is exactly 12.")]),

 ("NA","The watery juice in the mouth, called saliva, begins to digest:",
   "starch (carbohydrate)",
   C("Saliva contains an enzyme that starts breaking starch into sugar even while you chew, so digestion begins in the mouth.")+
   steps("Recall what saliva acts on as you chew","starch begins turning to sugar","so saliva digests starch.")+
   U("Chew plain rice or bread a while and it tastes faintly sweet — starch turning to sugar."),
   [("fat (oil)","Fat is digested mainly later in the small intestine, not by saliva; saliva starts on starch."),
    ("protein","Protein digestion begins in the stomach, not the mouth; saliva acts on starch."),
    ("water","Water needs no digesting; saliva's enzyme begins breaking down starch.")]),

 ("NA","Which organ — the body's largest gland — produces the bile that helps digest fats?",
   "liver",
   C("The liver is the body's largest gland; it secretes bile, which breaks fat into tiny droplets for easier digestion.")+
   steps("Recall the biggest gland that aids digestion","it makes bile to act on fats","that organ is the liver.")+
   U("Bile from the liver lets your gut handle oily, fried foods."),
   [("pancreas","The pancreas adds digestive juices too, but the LARGEST gland making bile is the liver."),
    ("stomach","The stomach is a muscular bag that churns food; the bile-making largest gland is the liver."),
    ("small intestine","The small intestine absorbs food; the largest gland, making bile, is the liver.")]),

 ("NA","Most of the digested food is absorbed into the blood through tiny finger-like projections in the small intestine called:",
   "villi",
   C("Villi are tiny finger-like folds lining the small intestine; they greatly increase its surface area so digested food is absorbed quickly.")+
   steps("Digested food must pass into the blood","tiny finger-like folds give a huge absorbing surface","these folds are the villi.")+
   U("The villi pack a tennis-court-worth of absorbing surface into your gut."),
   [("cilia","Cilia are tiny hairs in the windpipe; the absorbing folds of the gut are villi."),
    ("alveoli","Alveoli are air sacs in the lungs; the food-absorbing folds of the intestine are villi."),
    ("nephrons","Nephrons filter blood in the kidney; the gut's absorbing folds are villi.")]),

 ("NA","Animals such as cows and buffaloes that quickly swallow grass, then later bring it back to chew slowly, are called:",
   "ruminants",
   C("Ruminants (cows, buffaloes, goats) swallow grass into a special stomach part, then later return it to the mouth as 'cud' to chew thoroughly.")+
   steps("Grass is swallowed fast and stored","later it comes back up to be chewed as cud","such cud-chewing animals are ruminants.")+
   U("A cow resting in the field, jaw moving steadily, is chewing the cud."),
   [("carnivores","Carnivores eat meat and don't chew cud; grass-eating cud-chewers are ruminants."),
    ("parasites","Parasites live on a host; cud-chewing grass-eaters are ruminants."),
    ("decomposers","Decomposers break down dead matter; cud-chewing grazers are ruminants.")]),

 ("NA","The part of the digestive system where digested food is finally used by body cells for energy and growth is the step called:",
   "assimilation",
   C("Assimilation is the step where absorbed, digested food is used by cells to release energy, build the body and repair tissues.")+
   steps("Absorbed food reaches the body's cells","there it is used for energy and growth","this using-up step is assimilation.")+
   U("The protein you absorb is assimilated to build new muscle as you grow."),
   [("egestion","Egestion throws out undigested waste; using food in cells is assimilation."),
    ("ingestion","Ingestion takes food in; using absorbed food in cells is assimilation."),
    ("absorption","Absorption moves food into blood; its USE by cells is assimilation.")]),

 ("NA","The removal of undigested, unabsorbed food as faeces from the body is the step called:",
   "egestion",
   C("Egestion is the final step of nutrition — the undigested waste is removed from the body as faeces.")+
   steps("After absorption, some food stays undigested","this waste is pushed out of the body","that removal is egestion.")+
   U("Eating enough fibre keeps egestion regular and the gut healthy."),
   [("digestion","Digestion breaks food down; throwing out the undigested waste is egestion."),
    ("absorption","Absorption takes digested food into blood; removing the leftover waste is egestion."),
    ("excretion","Excretion removes wastes made by cells (like urine); removing undigested food is egestion.")]),

 ("NA","The single-celled animal Amoeba captures its food by pushing out finger-like extensions called:",
   "pseudopodia (false feet)",
   C("Amoeba flows out finger-like 'false feet' (pseudopodia) to surround and engulf food, trapping it in a food vacuole.")+
   steps("Amoeba has no mouth","it pushes out false feet to surround the food","these extensions are pseudopodia.")+
   U("Under a microscope you can watch an Amoeba ooze its pseudopodia around a prey speck."),
   [("villi","Villi are gut folds in larger animals; Amoeba's food-grabbing extensions are pseudopodia."),
    ("cilia","Cilia are tiny beating hairs; Amoeba captures food with finger-like pseudopodia."),
    ("tentacles","Tentacles belong to animals like hydra; Amoeba uses pseudopodia to grab food.")]),

 ("NA","Inside the stomach, the food is mixed with digestive juices that include a strong acid. This acid mainly:",
   "kills germs and helps the juices act",
   C("The stomach makes hydrochloric acid, which kills many swallowed germs and creates the acidic conditions its digestive enzymes need.")+
   steps("Food carries germs and needs the right conditions to be broken down","the stomach's acid kills germs and activates its juices","so the acid protects and aids digestion.")+
   U("That acid is why most germs in your food never make it past your stomach."),
   [("makes the food sweet","The stomach acid does not sweeten food; it kills germs and helps the digestive juices act."),
    ("cools the food down","Acid does not cool food; it kills germs and provides the acidic conditions for digestion."),
    ("adds water to the food","The acid's role is to kill germs and aid the juices, not to add water.")]),

 ("NA","A full set of permanent teeth in an adult human numbers 32. If 8 of these are incisors, the number that are NOT incisors is:",
   "24",
   C("Not-incisors = total − incisors = 32 − 8 = 24, so 24 of the 32 permanent teeth are not incisors.")+
   steps("Not-incisors = 32 − 8","subtract: 32 − 8 = 24","so 24 teeth are not incisors.")+
   U("Counting tooth types helps a dentist note which kinds need care."),
   [("40","40 wrongly adds 32 + 8; the not-incisors are the difference 32 − 8 = 24."),
    ("8","8 is the number of incisors themselves; the rest number 32 − 8 = 24."),
    ("16","16 mis-subtracts; 32 − 8 is exactly 24.")]),

 ("NA","Grass-eating animals can digest the tough cellulose of grass because their gut holds:",
   "helpful bacteria that break down cellulose",
   C("Grazers cannot digest cellulose alone; helpful bacteria living in a special part of their gut break it down for them.")+
   steps("Cellulose in grass is hard to digest","tiny bacteria in the animal's gut break it down","so these bacteria let grazers use grass.")+
   U("The bacteria in a cow's gut are why a cow thrives on grass that we cannot digest."),
   [("strong acid alone","Acid alone cannot break tough cellulose; helpful gut bacteria do that job in grazers."),
    ("no special help at all","Grazers DO need help; bacteria in their gut break down the cellulose for them."),
    ("extra sets of teeth","Teeth grind grass but can't digest cellulose; gut bacteria do the chemical breakdown.")]),

 ("NA","After Amoeba engulfs its food, the food is digested inside a small bubble-like structure called the:",
   "food vacuole",
   C("Once surrounded by pseudopodia, the food is enclosed in a food vacuole, where digestive juices break it down inside the Amoeba.")+
   steps("Pseudopodia trap the food in a bubble","digestion happens inside that bubble","this digesting bubble is the food vacuole.")+
   U("The Amoeba's food vacuole acts like a tiny private stomach for each meal."),
   [("nucleus","The nucleus controls the cell; food is digested in the food vacuole, not the nucleus."),
    ("villus","A villus is a gut fold in larger animals; Amoeba digests food in a food vacuole."),
    ("gall bladder","A gall bladder stores bile in big animals; Amoeba digests food in a food vacuole.")]),

 ("NA","The broad, flat back teeth used mainly for grinding and chewing food are the:",
   "molars",
   C("Molars are the wide, flat-topped teeth at the back of the jaw, built to grind and crush food before swallowing.")+
   steps("Find the broad flat teeth at the back","shaped to grind and crush","these are the molars.")+
   U("Your molars mash a mouthful of rice into a soft paste ready to swallow."),
   [("incisors","Incisors are the sharp front cutters; the broad back grinders are molars."),
    ("canines","Canines are the pointed tearing teeth; the flat grinding back teeth are molars."),
    ("milk teeth","'Milk teeth' is the first set as a whole; the broad grinding teeth are molars.")]),

 ("NA","Bile, which helps digest fats, is made in the liver and stored for release in the:",
   "gall bladder",
   C("Bile made by the liver is stored in the gall bladder and squeezed into the small intestine when fatty food arrives.")+
   steps("The liver makes bile","it is held in a small sac until needed","that storage sac is the gall bladder.")+
   U("The gall bladder releases stored bile when you eat a buttery meal."),
   [("stomach","The stomach churns food with acid; bile is stored in the gall bladder, not there."),
    ("pancreas","The pancreas makes its own juices; bile is stored in the gall bladder."),
    ("large intestine","The large intestine absorbs water; bile is stored in the gall bladder.")]),

 ("NA","Tooth decay (cavities) is caused when bacteria act on left-over food and produce:",
   "acids that damage the tooth",
   C("Bacteria feed on sugary food stuck on teeth and release acids; these acids slowly dissolve the hard tooth surface, making cavities.")+
   steps("Food left on teeth feeds bacteria","the bacteria release acids","these acids eat into the tooth, causing decay.")+
   U("Brushing after sweets removes the food bacteria need to make tooth-rotting acid."),
   [("bases that strengthen the tooth","Bases don't cause decay; bacteria make ACIDS that damage the tooth."),
    ("pure water that cleans the tooth","Water cleans, it doesn't rot teeth; decay comes from bacterial acids."),
    ("extra enamel on the tooth","Decay removes enamel, not adds it; bacterial acids cause the damage.")]),

 ("NA","The main job of the large intestine in digestion is to:",
   "absorb water from the undigested food",
   C("By the large intestine, useful food is gone; its main job is to absorb water from the remaining waste, leaving semi-solid faeces.")+
   steps("Digested food is already absorbed earlier","the watery waste reaches the large intestine","there water is reabsorbed, solidifying the waste.")+
   U("Drinking enough water keeps the large intestine from over-drying the waste."),
   [("digest proteins fully","Protein digestion happens earlier in the gut; the large intestine mainly absorbs water."),
    ("make bile for fats","Bile is made by the liver; the large intestine's job is to absorb water."),
    ("add acid to kill germs","Acid is added in the stomach; the large intestine absorbs water from the waste.")]),

 ("NA","Which sequence correctly orders the steps of nutrition in animals?",
   "ingestion → digestion → absorption → assimilation → egestion",
   C("Nutrition flows: food is taken in (ingestion), broken down (digestion), passed to blood (absorption), used by cells (assimilation), and waste removed (egestion).")+
   steps("Take food in, break it down, absorb it","use it in cells, then remove the waste","that order is ingestion → digestion → absorption → assimilation → egestion.")+
   U("Knowing this order helps you trace where a tummy upset might begin."),
   [("digestion → ingestion → egestion → absorption → assimilation","Food must be taken IN (ingestion) before it can be digested; the order starts with ingestion."),
    ("egestion → assimilation → absorption → digestion → ingestion","This is the steps in reverse; nutrition begins with ingestion, not egestion."),
    ("absorption → ingestion → digestion → assimilation → egestion","Absorption can't come first; food must be ingested and digested before it is absorbed.")]),

 ("NA","The tongue helps in eating by mixing food with saliva, in swallowing, and also in:",
   "sensing taste",
   C("Besides mixing food with saliva and pushing it for swallowing, the tongue carries taste buds that let us sense flavours.")+
   steps("List the tongue's jobs: it mixes food and helps swallowing","it also carries taste buds","so it senses taste.")+
   U("Your tongue's taste buds warn you instantly if milk has gone sour."),
   [("making bile for digestion","Bile is made by the liver, not the tongue; the tongue senses taste and mixes food."),
    ("absorbing digested food","Absorption happens in the intestine; the tongue's extra role is sensing taste."),
    ("producing the stomach's acid","The stomach makes its acid; the tongue mixes food and senses taste.")]),

 ("NA","A cow first swallows grass into a part of its stomach called the rumen and later chews the returned food, which is known as:",
   "cud",
   C("In ruminants, the partly-broken grass stored in the rumen is brought back to the mouth as 'cud' and chewed thoroughly at rest.")+
   steps("Grass is stored in the rumen first","later it returns to the mouth to be re-chewed","this returned food is called the cud.")+
   U("'Chewing the cud' even means thinking something over slowly, like a resting cow."),
   [("bile","Bile is a digestive juice from the liver; the re-chewed grass of a cow is the cud."),
    ("enamel","Enamel is the hard coat of a tooth; the returned grass that is re-chewed is the cud."),
    ("saliva","Saliva is the mouth's juice; the food a cow brings back to chew is the cud.")]),

 ("NA","Bile produced by the liver is stored, until it is needed for digesting fats, in a small sac called the:",
   "gall bladder",
   C("The liver makes bile continuously, but it is stored in the gall bladder and released into the small intestine when fatty food arrives.")+
   steps("Bile is made in the liver","but it is held in a small sac until fat needs digesting","that storage sac is the gall bladder.")+
   U("After a very oily meal the gall bladder squeezes out extra bile to help break the fat."),
   [("pancreas","The pancreas makes its own digestive juice; bile from the liver is stored in the gall bladder."),
    ("rumen","The rumen stores grass in cattle; bile in humans is stored in the gall bladder."),
    ("appendix","The appendix is a small dead-end tube of no clear digestive use; bile is stored in the gall bladder.")]),
]

# ---------- INTEGERS (25) — pure Maths, a couple with a Science flavour ----------
IN = [
 ("IN","The collection of whole numbers together with their negatives — …, −3, −2, −1, 0, 1, 2, 3, … — is called the:",
   "integers",
   C("Integers are all the whole numbers and their negatives together with zero: …, −2, −1, 0, 1, 2, …")+
   steps("Take the whole numbers 0, 1, 2, 3, …","add in their negatives −1, −2, −3, …","this whole collection is the integers.")+
   U("A thermometer scale, reading both above and below zero, is a line of integers."),
   [("natural numbers","Natural numbers are only 1, 2, 3, …; adding zero and the negatives gives the integers."),
    ("fractions","Fractions are parts like 1/2; whole numbers with their negatives are the integers."),
    ("decimals","Decimals like 0.5 are not whole; the whole numbers with their negatives are the integers.")]),

 ("IN","Adding on the number line, (−7) + 4 comes to:",
   "−3",
   C("Adding a positive to a negative moves right on the number line: from −7, step 4 right to land on −3.")+
   steps("Start at −7 on the number line","move 4 steps to the right (adding 4)","you land on −3.")+
   U("Owing ₹7 then earning ₹4 leaves you ₹3 in debt — a balance of −3."),
   [("−11","−11 would be −7 + (−4); here we ADD +4, giving −7 + 4 = −3."),
    ("11","11 ignores the signs; −7 + 4 = −3, not 11."),
    ("3","3 forgets the start was negative; −7 + 4 lands on −3, below zero.")]),

 ("IN","The value of (−6) + (−5) is:",
   "−11",
   C("Adding two negatives makes a larger negative: −6 and −5 combine to −11.")+
   steps("Both numbers are negative","add their sizes 6 + 5 = 11 and keep the minus","so the answer is −11.")+
   U("Owing ₹6 and owing ₹5 more means owing ₹11 in all — a balance of −11."),
   [("−1","−1 wrongly subtracts; two negatives ADD in size, giving −11."),
    ("11","11 drops the minus; both numbers are negative, so the sum is −11."),
    ("1","1 ignores the signs; −6 + (−5) = −11.")]),

 ("IN","The value of 8 − (−3) is:",
   "11",
   C("Subtracting a negative is the same as adding its positive: 8 − (−3) = 8 + 3 = 11.")+
   steps("Subtracting a negative turns into addition","8 − (−3) = 8 + 3","= 11.")+
   U("Removing a ₹3 debt is like gaining ₹3 — your ₹8 grows to ₹11."),
   [("5","5 wrongly subtracts 3; the two minus signs make it 8 + 3 = 11."),
    ("−11","−11 has the wrong sign; 8 − (−3) = 8 + 3 = 11, a positive."),
    ("−5","−5 mis-handles the signs; 8 − (−3) equals 11.")]),

 ("IN","The value of (−4) − 6 is:",
   "−10",
   C("Subtracting 6 from −4 moves further left: from −4, step 6 left to land on −10.")+
   steps("Start at −4 on the number line","move 6 steps to the left (subtracting 6)","you land on −10.")+
   U("Being ₹4 in debt and spending ₹6 more leaves you ₹10 in debt — a balance of −10."),
   [("2","2 ignores the signs; −4 − 6 = −10, not 2."),
    ("−2","−2 wrongly adds; subtracting 6 from −4 gives −10."),
    ("10","10 drops the minus; −4 − 6 = −10, below zero.")]),

 ("IN","Multiplying a negative by a positive, (−5) × 3 equals:",
   "−15",
   C("A negative times a positive gives a negative: 5 × 3 = 15, and the single minus makes it −15.")+
   steps("Multiply the sizes: 5 × 3 = 15","one factor is negative, so the product is negative","giving −15.")+
   U("A drop of 5 °C each hour for 3 hours is a change of −15 °C."),
   [("15","15 misses the sign; a negative times a positive is negative, so −15."),
    ("−8","−8 adds instead of multiplying; (−5) × 3 = −15."),
    ("−2","−2 mishandles the numbers; (−5) × 3 = −15.")]),

 ("IN","When two negatives are multiplied together, (−6) × (−4) equals:",
   "24",
   C("A negative times a negative gives a positive: (−6) × (−4) = +24.")+
   steps("Multiply the sizes: 6 × 4 = 24","two negatives multiply to a positive","so the product is +24.")+
   U("Cancelling 6 debts of ₹4 each (a 'minus of a minus') gains you ₹24."),
   [("−24","−24 keeps a minus; two negatives multiply to a POSITIVE, +24."),
    ("−10","−10 adds instead of multiplying; (−6) × (−4) = 24."),
    ("10","10 mis-handles the numbers; (−6) × (−4) = 24.")]),

 ("IN","Dividing a negative by a positive, (−20) ÷ 5 gives:",
   "−4",
   C("A negative divided by a positive gives a negative: 20 ÷ 5 = 4, and the minus makes it −4.")+
   steps("Divide the sizes: 20 ÷ 5 = 4","one number is negative, so the result is negative","giving −4.")+
   U("Sharing a ₹20 loss equally among 5 friends is −₹4 each."),
   [("4","4 misses the sign; a negative divided by a positive is negative, so −4."),
    ("−15","−15 subtracts instead of dividing; (−20) ÷ 5 = −4."),
    ("−100","−100 multiplies instead of dividing; (−20) ÷ 5 = −4.")]),

 ("IN","The value of (−18) ÷ (−3) is:",
   "6",
   C("A negative divided by a negative gives a positive: (−18) ÷ (−3) = +6.")+
   steps("Divide the sizes: 18 ÷ 3 = 6","two negatives divide to a positive","so the result is +6.")+
   U("The 'minus of a minus' rule keeps signed division consistent across maths and science."),
   [("−6","−6 keeps a minus; a negative divided by a negative is POSITIVE, +6."),
    ("−21","−21 subtracts instead of dividing; (−18) ÷ (−3) = 6."),
    ("54","54 multiplies instead of dividing; (−18) ÷ (−3) = 6.")]),

 ("IN","The number that must be added to −9 to give 0 (its additive inverse) is:",
   "+9",
   C("The additive inverse of a number adds to it to make zero; for −9 that partner is +9, since −9 + 9 = 0.")+
   steps("We need −9 + ? = 0","the partner is the same size but opposite sign","that is +9.")+
   U("Adding a ₹9 credit to a ₹9 debt clears the account to zero."),
   [("−9","Adding −9 to −9 gives −18, not 0; the inverse is the opposite sign, +9."),
    ("0","Adding 0 leaves −9 unchanged; to reach 0 you must add +9."),
    ("18","Adding 18 to −9 gives +9, not 0; the additive inverse is +9.")]),

 ("IN","On the number line, of the two integers −3 and −7, the GREATER one is:",
   "−3",
   C("On the number line, numbers to the right are greater. −3 lies to the right of −7, so −3 is greater.")+
   steps("Mark −3 and −7 on the number line","−3 is to the right of −7","so −3 is the greater integer.")+
   U("A temperature of −3 °C is warmer (greater) than −7 °C."),
   [("−7","−7 lies further left, making it the SMALLER number; −3 is greater."),
    ("They are equal","−3 and −7 are different points; −3, being to the right, is greater."),
    ("Neither can be compared","Integers always compare on the number line; −3 is greater than −7.")]),

 ("IN","The greatest negative integer is:",
   "−1",
   C("Negative integers grow smaller as they go left; the one closest to zero, −1, is the greatest of them.")+
   steps("Negative integers are −1, −2, −3, …","the closest to zero is the greatest","that is −1.")+
   U("Just below zero on a thermometer, −1° is the warmest of all the below-zero marks."),
   [("0","0 is neither positive nor negative; the greatest NEGATIVE integer is −1."),
    ("−100","−100 is far to the left, a very small number; the greatest negative is −1."),
    ("There is none","There is a greatest negative integer — it is −1, nearest to zero.")]),

 ("IN","The integer that is neither positive nor negative is:",
   "0",
   C("Zero is the only integer that is neither positive nor negative; it sits exactly between them on the number line.")+
   steps("Positive integers are right of zero, negatives are left","zero itself sits at the centre","so 0 is neither positive nor negative.")+
   U("On a thermometer, 0° is the dividing mark between the warm and the freezing readings."),
   [("1","1 is a positive integer, to the right of zero; the neutral one is 0."),
    ("−1","−1 is a negative integer, to the left of zero; the neutral one is 0."),
    ("There is no such integer","There is one such integer — zero, neither positive nor negative.")]),

 ("IN","The predecessor of the integer −5 (the integer just before it) is:",
   "−6",
   C("The predecessor is one less, found by stepping left on the number line: one step left of −5 is −6.")+
   steps("Predecessor = one less = −5 − 1","stepping left from −5","gives −6.")+
   U("If a lift is at floor −5 (basements), the floor just below is −6."),
   [("−4","−4 is one MORE (the successor); the predecessor of −5 is −6."),
    ("4","4 ignores the sign; one less than −5 is −6."),
    ("6","6 ignores the sign; the integer just before −5 is −6.")]),

 ("IN","The product of any integer and (−1) is:",
   "the additive inverse of that integer",
   C("Multiplying an integer by −1 just flips its sign, giving its additive inverse: e.g. 7 × (−1) = −7 and (−4) × (−1) = 4.")+
   steps("Multiplying by −1 keeps the size but flips the sign","a number with its sign flipped is its opposite","that opposite is the additive inverse.")+
   U("Reversing a credit into an equal debit is just multiplying the amount by −1."),
   [("always 0","Multiplying by −1 isn't 0 unless the number is 0; it gives the number's opposite sign."),
    ("always −1","The result depends on the integer; n × (−1) = −n, the additive inverse, not always −1."),
    ("the same integer unchanged","Multiplying by −1 flips the sign; the number is unchanged only if it is 0.")]),

 ("IN","Because (−4) + (−7) gives the same result as (−7) + (−4), addition of integers is said to be:",
   "commutative",
   C("The commutative property means order doesn't change a sum: a + b = b + a holds for all integers.")+
   steps("Swapping the order of the two numbers","leaves the sum the same","this 'order doesn't matter' rule is the commutative property.")+
   U("Whether you add today's loss then yesterday's, or the reverse, the total is the same."),
   [("associative","The associative property is about regrouping three numbers; swapping two is commutative."),
    ("distributive","Distributive links multiplication over addition; swapping order of a sum is commutative."),
    ("closure","Closure means the sum is still an integer; the 'order doesn't matter' rule is commutative.")]),

 ("IN","The statement 3 × (4 + (−2)) = 3 × 4 + 3 × (−2) shows the property called:",
   "distributive",
   C("The distributive property lets multiplication spread over a sum: a × (b + c) = a × b + a × c.")+
   steps("The 3 outside is multiplied with each number inside the bracket","3 × 4 plus 3 × (−2)","this spreading rule is the distributive property.")+
   U("Distributing a price over several items is exactly this property at work."),
   [("commutative","Commutative is about swapping order; spreading multiplication over a sum is distributive."),
    ("associative","Associative is about regrouping; multiplying across a bracketed sum is distributive."),
    ("closure","Closure says the result stays an integer; the spreading rule is distributive.")]),

 ("IN","A diver is at −15 m (15 m below sea level) and rises 9 m. Her new position is:",
   "−6 m",
   C("New position = start + rise = −15 + 9 = −6, so she is still 6 m below sea level.")+
   steps("New depth = −15 + 9","move 9 steps up from −15 on the number line","landing on −6 m.")+
   U("Divers track signed depths so they ascend safely in stages."),
   [("−24 m","−24 wrongly subtracts the rise; rising 9 from −15 gives −15 + 9 = −6 m."),
    ("6 m","6 forgets she began below sea level; −15 + 9 = −6 m, still under water."),
    ("24 m","24 mis-adds the signs; −15 + 9 = −6 m.")]),

 ("IN","The successor of the integer −1 (the integer just after it) is:",
   "0",
   C("The successor is one more, found by stepping right on the number line: one step right of −1 is 0.")+
   steps("Successor = one more = −1 + 1","stepping right from −1","gives 0.")+
   U("A lift rising from floor −1 (one basement) reaches floor 0, the ground floor."),
   [("−2","−2 is one LESS (the predecessor); the successor of −1 is 0."),
    ("1","1 is two more than −1; the integer just after −1 is 0."),
    ("−1","−1 is the number itself; its successor, one more, is 0.")]),

 ("IN","Because the sum of any two integers is always again an integer, integers are said to be ____ under addition.",
   "closed",
   C("Closure under addition means adding any two integers always lands you on another integer — you never leave the set.")+
   steps("Add any two integers, e.g. −3 + 5 = 2","the answer is still an integer","so integers are closed under addition.")+
   U("Adding signed bank entries always gives another whole-rupee balance — closure in action."),
   [("open","'Open' is not the term; since the sum is always an integer, the set is closed under addition."),
    ("commutative","Commutative is about order of addition; staying within integers is closure."),
    ("distributive","Distributive links × over +; staying within the integers is closure.")]),

 ("IN","The value of 0 − 7 is:",
   "−7",
   C("Subtracting 7 from 0 steps 7 to the left of zero, landing on −7.")+
   steps("Start at 0","move 7 steps left (subtracting 7)","you land on −7.")+
   U("Spending ₹7 when you had nothing leaves you ₹7 in debt — a balance of −7."),
   [("7","7 misses the sign; 0 − 7 lands at −7, left of zero."),
    ("0","0 forgets the subtraction; 0 − 7 = −7, not 0."),
    ("−14","−14 doubles the 7; 0 − 7 is simply −7.")]),

 ("IN","Which of these integers is the SMALLEST?",
   "−12",
   C("On the number line the smallest number lies furthest left. Among −12, −5, 0 and 7, the leftmost is −12.")+
   steps("Place −12, −5, 0, 7 on the number line","the one furthest left is the smallest","that is −12.")+
   U("Of several below-zero temperatures, −12 °C is the coldest — the smallest reading."),
   [("−5","−5 lies right of −12, so it is larger; the smallest is −12."),
    ("0","0 is greater than every negative here; the smallest is −12."),
    ("7","7 is the largest, on the far right; the smallest is −12.")]),

 ("IN","Multiplying three signed numbers, (−2) × 5 × (−1) comes to:",
   "10",
   C("Multiply step by step: (−2) × 5 = −10, then −10 × (−1) = +10. An even count of minus signs gives a positive.")+
   steps("(−2) × 5 = −10","−10 × (−1) flips the sign to +10","so the product is 10.")+
   U("Two sign-flips cancel out — a handy check in signed-number calculations."),
   [("−10","−10 stops after the first step; multiplying by the final (−1) flips it to +10."),
    ("−7","−7 adds instead of multiplying; (−2) × 5 × (−1) = 10."),
    ("7","7 mis-handles the numbers; the product is 10.")]),

 ("IN","Grouping the numbers differently — (−2 + 3) + 5 gives the same sum as −2 + (3 + 5) — illustrates the property called:",
   "associative",
   C("The associative property of addition says the way three numbers are grouped does not change the sum: (a + b) + c = a + (b + c).")+
   steps("Add the first pair first, or the last pair first","the total comes out the same either way","this regrouping rule is the associative property.")+
   U("When adding a long column of figures, you may group them any way — the total is unchanged."),
   [("commutative","Commutative is about swapping order of two numbers; regrouping three is associative."),
    ("distributive","Distributive links × over +; regrouping a sum of three is the associative property."),
    ("closure","Closure says the sum stays an integer; regrouping three numbers is associative.")]),

 ("IN","At dawn the temperature was −4 °C and by noon it had risen to 9 °C. The total rise in temperature was:",
   "13 °C",
   C("The rise is the final reading minus the start: 9 − (−4) = 9 + 4 = 13 °C. Subtracting a negative adds it on.")+
   steps("Rise = final − start = 9 − (−4)","subtracting −4 is the same as adding 4: 9 + 4","= 13 °C.")+
   U("Weather reports give such a 'daily range' by subtracting the night low from the day high."),
   [("5 °C","5 °C comes from 9 − 4, forgetting the start was BELOW zero; 9 − (−4) = 13 °C."),
    ("−13 °C","The temperature went UP, so the rise is positive; 9 − (−4) = +13 °C."),
    ("36 °C","36 multiplies instead of subtracting; the rise is 9 − (−4) = 13 °C.")]),
]

# ---------- THE TRIANGLE & ITS PROPERTIES (25) — pure Maths ----------
TR = [
 ("TR","Add up the three interior angles of any triangle and you will always get:",
   "180°",
   C("The three interior angles of a triangle always add up to 180°, no matter the triangle's shape or size.")+
   steps("Take any triangle and measure its three angles","their total is always the same","it is 180°.")+
   U("Knowing the three angles sum to 180° lets you find a missing angle at once."),
   [("90°","90° is the size of one right angle; the THREE angles of a triangle total 180°."),
    ("360°","360° is the angle sum of a four-sided quadrilateral; a triangle's is 180°."),
    ("270°","270° fits no standard rule here; a triangle's three angles always total 180°.")]),

 ("TR","Two angles of a triangle are 50° and 60°; its remaining third angle measures:",
   "70°",
   C("Since the three angles add to 180°, the third = 180° − (50° + 60°) = 180° − 110° = 70°.")+
   steps("Add the two known angles: 50 + 60 = 110","subtract from 180: 180 − 110","= 70°, the third angle.")+
   U("Surveyors find an unknown angle of a triangular plot using exactly this 180° rule."),
   [("110°","110° is the SUM of the two given angles, not the third; the third is 180 − 110 = 70°."),
    ("80°","80° mis-subtracts; 180 − (50 + 60) = 70°, not 80°."),
    ("90°","90° would need the others to total 90; here they total 110, so the third is 70°.")]),

 ("TR","A triangle with all three sides equal in length is called:",
   "an equilateral triangle",
   C("An equilateral triangle has all three sides equal — and, as a result, all three angles equal to 60°.")+
   steps("Check the sides: all three are equal","such a triangle is equilateral","and each of its angles is 60°.")+
   U("A road 'yield' sign is a neat equilateral triangle."),
   [("a scalene triangle","A scalene triangle has all sides DIFFERENT; all-equal sides make it equilateral."),
    ("an isosceles triangle","An isosceles triangle has only TWO equal sides; all three equal makes it equilateral."),
    ("a right triangle","A right triangle is defined by a 90° angle, not equal sides; all-equal sides make it equilateral.")]),

 ("TR","In an equilateral triangle, every one of the three equal interior angles measures:",
   "60°",
   C("An equilateral triangle has three equal angles; since they total 180°, each is 180° ÷ 3 = 60°.")+
   steps("All three angles are equal and total 180°","divide: 180 ÷ 3","each angle is 60°.")+
   U("The perfectly balanced 60° corners make equilateral shapes popular in design and trusses."),
   [("90°","90° is a right angle; an equilateral triangle's three equal angles are 60° each."),
    ("45°","45° would total only 135° for three; each equilateral angle is 60°."),
    ("180°","180° is the SUM of all three; each single equilateral angle is 60°.")]),

 ("TR","A triangle that has exactly two sides equal (and therefore two equal angles) is called:",
   "an isosceles triangle",
   C("An isosceles triangle has two equal sides, and the angles opposite those sides are also equal.")+
   steps("Count the equal sides: exactly two are equal","the angles opposite them are equal too","such a triangle is isosceles.")+
   U("Many roof gables are isosceles triangles, balanced about their central ridge."),
   [("an equilateral triangle","An equilateral triangle has ALL three sides equal; exactly two equal makes it isosceles."),
    ("a scalene triangle","A scalene triangle has NO sides equal; two equal sides make it isosceles."),
    ("a right triangle","A right triangle is named for its 90° angle, not equal sides; two equal sides make it isosceles.")]),

 ("TR","By the exterior-angle property, an exterior angle of a triangle equals the sum of which angles?",
   "opposite interior angles",
   C("The exterior angle property: an exterior angle of a triangle equals the sum of the two interior angles not next to it.")+
   steps("Extend one side to form an exterior angle","it equals the two interior angles far from it","so exterior angle = sum of the two opposite interior angles.")+
   U("This shortcut finds an exterior angle without first finding all three interior angles."),
   [("adjacent interior angles","The exterior angle pairs with its adjacent angle to make 180°; it EQUALS the two OPPOSITE interior angles."),
    ("all three interior angles","Those total 180°; an exterior angle equals only the two OPPOSITE interior angles."),
    ("equal halves of the right angle","No right angle is involved; the exterior angle equals the two opposite interior angles.")]),

 ("TR","In a triangle, an exterior angle measures 120° and one opposite interior angle is 70°. The other opposite interior angle is:",
   "50°",
   C("By the exterior-angle property, 120° = 70° + (other), so the other interior angle = 120° − 70° = 50°.")+
   steps("Exterior angle = sum of the two opposite interior angles","120 = 70 + x, so x = 120 − 70","= 50°.")+
   U("Builders use this rule to check a triangular brace without a full protractor sweep."),
   [("190°","190° wrongly adds; the exterior angle 120 EQUALS the sum, so the missing one is 120 − 70 = 50°."),
    ("60°","60° mis-subtracts; 120 − 70 = 50°, not 60°."),
    ("120°","120° is the exterior angle itself; the missing interior angle is 120 − 70 = 50°.")]),

 ("TR","A line drawn from a vertex of a triangle to the MIDPOINT of the opposite side is called a:",
   "median",
   C("A median joins a vertex to the midpoint of the opposite side; every triangle has three medians.")+
   steps("Start at a vertex","draw to the MIDPOINT of the opposite side","that segment is a median.")+
   U("The three medians cross at the centroid — a triangle's exact balance point."),
   [("altitude","An altitude meets the opposite side at a RIGHT angle, not its midpoint; the midpoint line is the median."),
    ("hypotenuse","The hypotenuse is the longest side of a right triangle; a vertex-to-midpoint line is the median."),
    ("bisector of a side","A side-bisector is any line cutting a side in half; the one FROM A VERTEX to the midpoint is the median.")]),

 ("TR","A perpendicular line drawn from a vertex of a triangle to the opposite side (the height) is called an:",
   "altitude",
   C("An altitude is the perpendicular distance from a vertex to the opposite side — the triangle's height from that vertex.")+
   steps("From a vertex drop a line meeting the opposite side at 90°","that perpendicular height","is the altitude.")+
   U("The altitude is the 'height' you use in the area formula ½ × base × height."),
   [("median","A median goes to the MIDPOINT, not at a right angle; the perpendicular height is the altitude."),
    ("hypotenuse","The hypotenuse is a side of a right triangle; the perpendicular height is the altitude."),
    ("exterior angle","An exterior angle is an angle, not a line; the perpendicular height is the altitude.")]),

 ("TR","In a right-angled triangle, the side opposite the right angle (the longest side) is called the:",
   "hypotenuse",
   C("The hypotenuse is the side opposite the 90° angle in a right triangle, and it is always the longest side.")+
   steps("Find the right angle","the side directly opposite it","is the hypotenuse, the longest side.")+
   U("A ladder leaning against a wall forms the hypotenuse of a right triangle with the ground and wall."),
   [("altitude","An altitude is a perpendicular height, not a side; the side opposite the right angle is the hypotenuse."),
    ("base","Any side can be a base; the specific side opposite the right angle is the hypotenuse."),
    ("median","A median is a vertex-to-midpoint line; the side opposite the right angle is the hypotenuse.")]),

 ("TR","By the Pythagoras property, a right triangle with legs 3 cm and 4 cm has a hypotenuse of:",
   "5 cm",
   C("Pythagoras: hypotenuse² = 3² + 4² = 9 + 16 = 25, so the hypotenuse = √25 = 5 cm.")+
   steps("Square the legs: 3² + 4² = 9 + 16 = 25","take the square root: √25","= 5 cm.")+
   U("The 3-4-5 triangle lets builders mark a perfect right angle with just a knotted rope."),
   [("7 cm","7 just adds 3 + 4; Pythagoras needs the squares: √(9 + 16) = 5 cm."),
    ("12 cm","12 multiplies 3 × 4; the hypotenuse is √(3² + 4²) = 5 cm."),
    ("25 cm","25 is the sum of the squares, not the side; the hypotenuse is √25 = 5 cm.")]),

 ("TR","For any triangle, adding the lengths of any two sides always gives a total that is:",
   "greater than the third side",
   C("The triangle inequality states that any two sides together must exceed the third side; otherwise the sides cannot close into a triangle.")+
   steps("Try to join three sticks into a triangle","two short ones must reach across the longest","so any two sides together exceed the third.")+
   U("If a fence side is longer than the other two combined, the triangular plot simply can't close."),
   [("equal to the third side","Equal-to would flatten the triangle into a line; the sum must be GREATER than the third side."),
    ("less than the third side","Less-than means the sides can't meet to form a triangle; the sum must be greater."),
    ("equal to 180°","180° is the ANGLE sum, not about side lengths; two sides together exceed the third.")]),

 ("TR","Which of these three lengths CANNOT form a triangle?",
   "3 cm, 4 cm, 8 cm",
   C("For a triangle, any two sides must sum to more than the third. Here 3 + 4 = 7, which is less than 8, so these lengths can't close into a triangle.")+
   steps("Check the two shortest: 3 + 4 = 7","compare with the longest: 7 < 8","since the sum is not greater than 8, no triangle forms.")+
   U("Carpenters test this rule before cutting, so the pieces actually meet."),
   [("5 cm, 6 cm, 9 cm","Here 5 + 6 = 11 > 9, so these CAN form a triangle; the impossible set is 3, 4, 8."),
    ("6 cm, 8 cm, 10 cm","Here 6 + 8 = 14 > 10 (a right triangle in fact), so these form a triangle; 3, 4, 8 cannot."),
    ("7 cm, 7 cm, 7 cm","Equal sides 7, 7, 7 form a fine equilateral triangle; the impossible set is 3, 4, 8.")]),

 ("TR","A triangle in which one angle is exactly 90° is called:",
   "a right-angled triangle",
   C("A right-angled triangle has one angle of exactly 90°; the other two angles then add up to 90°.")+
   steps("Spot the 90° angle (a square corner)","a triangle with such an angle","is a right-angled triangle.")+
   U("The corner where a wall meets the floor models a right-angled triangle."),
   [("an acute-angled triangle","An acute triangle has ALL angles below 90°; one exact 90° makes it right-angled."),
    ("an obtuse-angled triangle","An obtuse triangle has one angle ABOVE 90°; an exact 90° makes it right-angled."),
    ("an equilateral triangle","An equilateral triangle's angles are all 60°; a 90° angle makes it right-angled.")]),

 ("TR","In a right-angled triangle, one of the two non-right angles is 35°. The other non-right angle is:",
   "55°",
   C("The two non-right angles of a right triangle add to 90°, so the other = 90° − 35° = 55°.")+
   steps("The three angles total 180°; one is 90°","so the other two total 90°","35 + ? = 90 gives ? = 55°.")+
   U("Knowing one acute angle of a ramp instantly gives the other from this 90° rule."),
   [("145°","145° comes from 180 − 35, ignoring the right angle; the other acute angle is 90 − 35 = 55°."),
    ("65°","65° mis-subtracts; 90 − 35 = 55°, not 65°."),
    ("90°","90° is the right angle itself; the remaining acute angle is 90 − 35 = 55°.")]),

 ("TR","A triangle in which no two of the three sides are equal in length is called:",
   "a scalene triangle",
   C("A scalene triangle has no equal sides — all three are different — and so all three angles differ too.")+
   steps("Compare the three sides: all different","such a triangle has no equal sides","it is scalene.")+
   U("Most everyday triangular off-cuts of cloth or wood are scalene — no two sides match."),
   [("an equilateral triangle","An equilateral triangle has all three sides EQUAL; all different makes it scalene."),
    ("an isosceles triangle","An isosceles triangle has two equal sides; all sides different makes it scalene."),
    ("a right triangle","A right triangle is named for its 90° angle, not unequal sides; all-different sides make it scalene.")]),

 ("TR","In an isosceles triangle the two equal sides meet at the apex, and one base angle is 50°. The other base angle is:",
   "50°",
   C("In an isosceles triangle the two base angles (opposite the equal sides) are equal, so if one is 50°, the other is also 50°.")+
   steps("Isosceles → the two base angles are equal","one base angle is 50°","so the other base angle is also 50°.")+
   U("The matching base angles keep a symmetric roof gable perfectly balanced."),
   [("80°","80° would be the apex angle (180 − 50 − 50); the OTHER base angle equals the first, 50°."),
    ("130°","130° comes from 180 − 50; but the two BASE angles are equal, so the other is 50°."),
    ("100°","100° doubles wrongly; the equal base angles mean the other base angle is 50°.")]),

 ("TR","A triangle that has one angle greater than 90° is called:",
   "an obtuse-angled triangle",
   C("An obtuse-angled triangle has exactly one angle larger than 90° (an obtuse angle); the other two are acute.")+
   steps("Spot the angle wider than a square corner","one angle exceeds 90°","so the triangle is obtuse-angled.")+
   U("A wide, low triangular ramp often has an obtuse angle at its broad corner."),
   [("a right-angled triangle","A right triangle has an angle of exactly 90°; an angle GREATER than 90° makes it obtuse."),
    ("an acute-angled triangle","An acute triangle has all angles below 90°; an angle above 90° makes it obtuse."),
    ("an equilateral triangle","An equilateral triangle's angles are all 60°; an angle above 90° makes it obtuse.")]),

 ("TR","By the Pythagoras property, a right triangle with hypotenuse 13 cm and one leg 12 cm has the other leg equal to:",
   "5 cm",
   C("Pythagoras: leg² = hypotenuse² − known leg² = 13² − 12² = 169 − 144 = 25, so the leg = √25 = 5 cm.")+
   steps("Subtract the squares: 13² − 12² = 169 − 144 = 25","take the square root: √25","= 5 cm.")+
   U("The 5-12-13 set is another rope-and-peg trick for a true right angle on site."),
   [("1 cm","1 just does 13 − 12; Pythagoras needs the squares: √(169 − 144) = 5 cm."),
    ("25 cm","25 is the difference of the squares, not the side; the leg is √25 = 5 cm."),
    ("17 cm","17 wrongly adds the squares' idea; the missing leg is √(13² − 12²) = 5 cm.")]),

 ("TR","Every triangle has exactly three medians, and they all pass through a single common point called the:",
   "centroid",
   C("The three medians of any triangle meet at one point, the centroid, which is the triangle's centre of mass (balance point).")+
   steps("Draw all three medians","they cross at exactly one point","that point is the centroid.")+
   U("Balanced on a pin at its centroid, a cardboard triangle stays perfectly level."),
   [("hypotenuse","The hypotenuse is a side of a right triangle, not a point; the medians meet at the centroid."),
    ("right angle","A right angle is an angle, not the meeting point of medians; that point is the centroid."),
    ("vertex","A vertex is a corner; the single point where the three medians cross is the centroid.")]),

 ("TR","An equilateral triangle, having all angles equal, is a special case of which other type?",
   "isosceles triangle",
   C("Since an equilateral triangle has all three sides equal, it certainly has (at least) two equal sides, so it is also isosceles.")+
   steps("Isosceles needs at least two equal sides","an equilateral triangle has all three equal","so it satisfies the isosceles condition too.")+
   U("This nesting of types helps when sorting shapes by their properties."),
   [("scalene triangle","Scalene means all sides DIFFERENT; an equilateral triangle has all sides equal, so it is isosceles, not scalene."),
    ("right triangle","A right triangle needs a 90° angle; an equilateral triangle's angles are all 60°, so it is isosceles."),
    ("obtuse triangle","An obtuse triangle has an angle above 90°; the equilateral's 60° angles make it isosceles, not obtuse.")]),

 ("TR","A triangle's three angles are in the ratio 1 : 2 : 3; the biggest of them measures:",
   "90°",
   C("The parts total 1 + 2 + 3 = 6, sharing 180°, so one part = 30°. The largest, 3 parts, is 3 × 30° = 90°.")+
   steps("Total parts = 1 + 2 + 3 = 6","one part = 180 ÷ 6 = 30°","largest = 3 × 30 = 90°.")+
   U("A 1:2:3 triangle turns out to be right-angled — a neat fact from sharing 180° in ratio."),
   [("60°","60° is the MIDDLE angle (2 parts × 30°); the largest, 3 parts, is 90°."),
    ("120°","120° exceeds the possible here; with parts summing to 6 in 180°, the largest is 3 × 30 = 90°."),
    ("30°","30° is the SMALLEST angle (1 part); the largest, 3 parts, is 90°.")]),

 ("TR","By the Pythagoras property, a right triangle with legs 6 cm and 8 cm has a hypotenuse of:",
   "10 cm",
   C("Pythagoras: hypotenuse² = 6² + 8² = 36 + 64 = 100, so the hypotenuse = √100 = 10 cm.")+
   steps("Square the legs: 6² + 8² = 36 + 64 = 100","take the square root: √100","= 10 cm.")+
   U("The 6-8-10 triangle is just the 3-4-5 triangle doubled — handy for larger right angles."),
   [("14 cm","14 just adds 6 + 8; Pythagoras needs the squares: √(36 + 64) = 10 cm."),
    ("48 cm","48 multiplies 6 × 8; the hypotenuse is √(6² + 8²) = 10 cm."),
    ("100 cm","100 is the sum of the squares, not the side; the hypotenuse is √100 = 10 cm.")]),

 ("TR","A triangle in which all three angles are less than 90° is called:",
   "an acute-angled triangle",
   C("An acute-angled triangle has every one of its three angles smaller than 90°.")+
   steps("Check each angle is below 90°","all three are acute","so the triangle is acute-angled.")+
   U("An equilateral triangle, with three 60° angles, is one familiar acute-angled triangle."),
   [("a right-angled triangle","A right triangle has one 90° angle; with ALL angles below 90° it is acute-angled."),
    ("an obtuse-angled triangle","An obtuse triangle has one angle above 90°; all angles below 90° make it acute-angled."),
    ("a scalene triangle","'Scalene' describes side lengths, not angles; all angles below 90° make it acute-angled.")]),

 ("TR","In any triangle, the longest side always lies directly opposite the triangle's:",
   "largest angle",
   C("The biggest angle opens the widest, so the side facing it must stretch the farthest — the longest side lies opposite the largest angle.")+
   steps("A bigger angle spreads its two arms wider apart","the side joining those arms must be longer","so the longest side sits opposite the largest angle.")+
   U("In a right triangle the 90° angle is the largest, and the hypotenuse opposite it is the longest side."),
   [("smallest angle","The smallest angle faces the SHORTEST side; the longest side lies opposite the LARGEST angle."),
    ("right angle","Only right triangles have a right angle; in general the longest side faces the largest angle, whatever its size."),
    ("midpoint of the base","A midpoint is a point, not an angle; the longest side lies opposite the largest angle.")]),
]

# ---------- assemble: interleave so no two consecutive share a chapter ----------
assert all(len(b) == 25 for b in (WC, NA, IN, TR)), [len(WC), len(NA), len(IN), len(TR)]
items = []
for i in range(25):
    items += [WC[i], NA[i], IN[i], TR[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=50083,
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
    split = "/".join(str(counts[c]) for c in ("WC", "NA", "IN", "TR"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Weather, Climate & Adaptations",
                     "Nutrition in Animals",
                     "Integers",
                     "The Triangle & its Properties"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
