# -*- coding: utf-8 -*-
# Boss Challenge Paper 40 — Weather, Climate & Adaptations · Transportation in
# Animals & Plants · Data Handling · Rational Numbers
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: leans into FUSION. A week of recorded temperatures becomes a
# MEAN; a string of rainfall readings becomes a MODE and a RANGE; a beating heart
# becomes a set of PULSE readings whose MEDIAN we find; the fraction of blood that
# is plasma becomes a RATIONAL NUMBER; a falling winter temperature becomes a
# NEGATIVE rational. The child meets a Science situation and reaches for a Maths
# skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_40_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_40_<SHORT>_QuestionPaper.pdf
#   Paper_40_<SHORT>_Questions.md
#   Paper_40_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "40"
SHORT = "Weather_Transportation_DataHandling_RationalNumbers"
TITLE = ("Weather, Climate & Adaptations · Transportation in Animals & Plants · "
         "Data Handling · Rational Numbers")
LABELS = {
    "WC": "Weather, Climate & Adaptations",
    "TR": "Transportation in Animals & Plants",
    "DH": "Data Handling",
    "RN": "Rational Numbers",
}

# ---------- WEATHER, CLIMATE & ADAPTATIONS (25) — Science ----------
WC = [
 ("WC","The day-to-day state of the air at a place — its heat, rain and wind on that very day — is called the:",
   "weather",
   C("Weather is the short, day-to-day story of the air: today it may be sunny, tomorrow rainy.")+
   steps("Look at the air at one place today","note its heat, rain, wind, humidity right now","that snapshot is the weather.")+
   U("A morning weather report tells you whether to carry an umbrella to school today."),
   [("climate","Climate is the long-run average over many years, not the state on a single day."),
    ("season","A season is a long stretch of months; weather can change within a single day."),
    ("atmosphere","The atmosphere is the blanket of air itself, not its changing daily condition.")]),

 ("WC","The average pattern of the weather of a place, worked out over a long period of many years, is its:",
   "climate",
   C("Climate is the weather averaged over a long time — it tells you what a place is usually like.")+
   steps("Record the weather of a place for many years","average all those readings","the steady pattern that appears is the climate.")+
   U("We call Rajasthan hot and dry by its climate, even though one day there might be cloudy."),
   [("weather","Weather is just one day's air; climate is the long-term average of many years."),
    ("forecast","A forecast is a guess about tomorrow's weather, not a many-year average."),
    ("humidity","Humidity is only the moisture in the air, one small part of the whole climate.")]),

 ("WC","At a weather station, the instrument used to measure how hot or cold the air is, is the:",
   "thermometer",
   C("A thermometer reads temperature — the hotness of the air — in degrees Celsius.")+
   steps("Air warms or cools the liquid in the thermometer","the liquid rises or falls in the thin tube","the mark it reaches is the temperature.")+
   U("A nurse uses the same kind of thermometer to check if you have a fever."),
   [("rain gauge","A rain gauge measures rainfall in millimetres, not temperature."),
    ("barometer","A barometer measures air pressure, not how hot or cold the air is."),
    ("wind vane","A wind vane only shows the direction the wind blows from.")]),

 ("WC","Rainfall at a place is collected and measured in millimetres using a:",
   "rain gauge",
   C("A rain gauge is a measuring jar that catches falling rain so we can read its depth in millimetres.")+
   steps("Rain falls into the open funnel of the gauge","it collects in a marked tube below","the level reached gives the rainfall in mm.")+
   U("Farmers watch rain-gauge readings to decide when their fields have had enough water."),
   [("thermometer","A thermometer measures temperature, not the amount of rain."),
    ("hygrometer","A hygrometer measures humidity in the air, not collected rainfall."),
    ("anemometer","An anemometer measures wind speed, not rainfall.")]),

 ("WC","The maximum and minimum readings noted each day at a weather station describe one element of weather, namely the:",
   "temperature",
   C("The highest and lowest readings of the day are both about temperature — how hot the air gets and how cool it falls.")+
   steps("The hottest moment of the day gives the maximum","the coolest moment gives the minimum","both are values of temperature.")+
   U("Newspapers print a city's max and min temperature side by side every morning."),
   [("rainfall","Rainfall is measured in mm by a rain gauge, not as a max and min temperature."),
    ("wind speed","Wind speed is measured by an anemometer, not by max and min readings."),
    ("humidity","Humidity is the moisture in the air, a different element from temperature.")]),

 ("WC","Polar bears survive the freezing Arctic chiefly because of a thick layer of fat and dense fur, which work as:",
   "insulation against the cold",
   C("Fat and thick fur trap body heat and keep the cold out — that trapping is called insulation.")+
   steps("Body heat tries to escape into the icy air","the thick fat and fur slow that escape","so the bear stays warm — they insulate it.")+
   U("A woollen sweater keeps you warm the same way — by trapping your body heat."),
   [("camouflage from prey","White fur does hide the bear, but fat and fur mainly keep it warm, not hidden."),
    ("a store of water","Fat is a store of energy and an insulator, not a water tank for the bear."),
    ("better eyesight","A fur coat has nothing to do with how well the bear sees.")]),

 ("WC","The polar regions stay bitterly cold all year mainly because the Sun's rays reach them very:",
   "slantingly, so they spread out",
   C("Near the poles the Sun stays low, so its rays strike at a slant and spread their heat thinly over a large area.")+
   steps("At the poles the Sun never rises high","its rays hit the ground at a steep slant","the same heat is spread over more ground, so it warms little.")+
   U("This is why a torch held slanting lights a wide, dim patch instead of a small bright spot."),
   [("directly from overhead","Overhead, direct rays heat strongly — that happens at the equator, not the poles."),
    ("only at night","The pole has months of daylight; the cold is from slanting rays, not from darkness."),
    ("after passing through water","The rays do not pass through water before reaching the poles.")]),

 ("WC","A region near the equator that stays hot and receives heavy rain almost all year is a:",
   "tropical rainforest",
   C("Tropical rainforests sit near the equator, where it is hot and wet round the year, so life bursts everywhere.")+
   steps("Near the equator the Sun is strong all year","heavy rain falls in every month","the hot, wet climate grows a dense rainforest.")+
   U("The Western Ghats and the Amazon are tropical rainforests packed with countless species."),
   [("polar region","Polar regions are freezing and dry, the opposite of a hot, wet rainforest."),
    ("desert","A desert is hot but very dry, while a rainforest is hot and very wet."),
    ("grassland","A grassland has a long dry season and few trees, unlike a dense rainforest.")]),

 ("WC","Animals of the tropical rainforest, such as monkeys and toucans, are adapted to a climate that is:",
   "hot and humid all year",
   C("Rainforest animals are built for steady heat and dampness — the climate barely changes through the year.")+
   steps("The rainforest stays hot and wet every month","animals there never face cold winters","so they are adapted to constant heat and humidity.")+
   U("That is why a rainforest monkey would struggle if moved to a cold mountain top."),
   [("cold and dry","Cold and dry suits polar animals, not rainforest ones that live in heat and damp."),
    ("hot and dry","Hot and dry describes a desert; the rainforest is hot but very wet."),
    ("cool with snow","Snowy, cool conditions belong to mountains and poles, not the rainforest.")]),

 ("WC","Penguins of the Antarctic often crowd together into a tight huddle mainly to:",
   "reduce heat loss and stay warm",
   C("Bunched together, penguins shield one another from the icy wind and share warmth, losing far less body heat.")+
   steps("Standing alone, a penguin loses heat to the freezing wind","crowding together blocks the wind and traps warmth","so the huddle keeps every bird warmer.")+
   U("People in a freezing bus stop instinctively bunch together for the same warmth."),
   [("catch more fish","Huddling on ice has nothing to do with catching fish in the sea."),
    ("see predators better","A tight huddle does not improve eyesight or lookout for predators."),
    ("lay more eggs","Crowding for warmth does not change how many eggs a penguin lays.")]),

 ("WC","The streamlined body and webbed feet of a penguin are adaptations that help it mainly to:",
   "swim well in water",
   C("A smooth, streamlined shape slips easily through water, and webbed feet act like paddles — together they make the penguin a strong swimmer.")+
   steps("Water resists a clumsy shape","a streamlined body cuts through it easily","webbed feet push like paddles, so the penguin swims fast.")+
   U("Swimmers wear smooth caps and divers wear flippers for the very same reason."),
   [("fly high in the air","Penguins cannot fly; their body is shaped for swimming, not flying."),
    ("dig deep burrows","Webbed feet are poor for digging; they are made for paddling in water."),
    ("climb tall trees","A streamlined, web-footed body is useless for climbing trees.")]),

 ("WC","The very large beak of a toucan helps it reach distant fruit and also helps the bird to:",
   "lose extra body heat",
   C("Blood flowing through the toucan's big beak releases heat to the air, helping the bird cool down in the hot forest.")+
   steps("The toucan lives in a hot rainforest","its large beak has many blood vessels near the surface","heat escapes from the beak, cooling the bird.")+
   U("An elephant's big ears do the same job — shedding heat to keep it cool."),
   [("store food for winter","The beak does not store food; rainforest birds face no cold winter."),
    ("dig into the soil","A toucan's beak is for reaching fruit and shedding heat, not digging soil."),
    ("make a loud warning light","A beak cannot make light; it helps feed the bird and lose heat.")]),

 ("WC","The thick white fur of a polar bear, besides keeping it warm, also helps the bear by acting as:",
   "camouflage against the snow",
   C("White fur on white snow makes the bear hard to see, so it can creep up on prey unnoticed — that hiding is camouflage.")+
   steps("The Arctic is covered in white snow","the bear's white fur matches that snow","so the bear blends in and is hard to spot.")+
   U("A soldier's snow-coloured uniform hides them on a snowy slope in exactly this way."),
   [("a source of food","Fur insulates and hides the bear; it is not eaten as food."),
    ("a swimming float","White fur helps the bear blend in, not float; fat aids buoyancy more."),
    ("a way to fly","Fur has nothing to do with flying, which polar bears cannot do.")]),

 ("WC","Some birds fly thousands of kilometres each year to escape harsh weather and find food; this seasonal journey is called:",
   "migration",
   C("Migration is the long seasonal journey animals make to flee bad weather and reach a place with food and milder conditions.")+
   steps("Harsh winter weather makes food scarce","the birds fly far to a warmer place","this regular seasonal travel is called migration.")+
   U("Siberian cranes flying to India's wetlands each winter are migrating birds."),
   [("hibernation","Hibernation is a long winter sleep in one place, not a journey to another."),
    ("camouflage","Camouflage is blending in to hide; it is not a seasonal journey."),
    ("adaptation","Adaptation is any feature suited to the surroundings; the seasonal journey itself has its own name, migration.")]),

 ("WC","Weather can change within a single day, but to describe the climate of a place we average its weather over at least about:",
   "twenty-five years",
   C("Climate is judged over a long stretch — scientists average a place's weather over many years, commonly twenty-five or more.")+
   steps("One day's weather tells little about the usual pattern","collect weather records for decades","averaging about 25 years reveals the climate.")+
   U("Saying a city has a hot, dry climate rests on many years of records, not last week's heat."),
   [("twenty-five hours","A single day cannot reveal a climate; climate needs many years of data."),
    ("two or three days","A few days show weather, not the long-term climate of a place."),
    ("six months","Half a year still misses the full yearly cycle repeated over many years.")]),

 ("WC","On a normal sunny day, the maximum temperature is usually recorded in the:",
   "afternoon",
   C("The ground keeps soaking up the Sun's heat through the morning, so the air is hottest in the early afternoon.")+
   steps("The Sun heats the ground all morning","the warmed ground keeps heating the air","the peak comes in the afternoon, giving the maximum.")+
   U("This is why outdoor games are best avoided in the hot mid-afternoon of summer."),
   [("early morning","Early morning, just after the cool night, is usually the coldest, not hottest."),
    ("midnight","At midnight the Sun is long gone and the air is cool, not at its maximum."),
    ("just before sunrise","Just before sunrise is typically the coolest moment, giving the minimum.")]),

 ("WC","Humidity, an element of weather, tells us the amount present in the air of:",
   "water vapour",
   C("Humidity measures how much invisible water vapour the air holds — high humidity makes a day feel sticky.")+
   steps("Air always carries some invisible water vapour","humidity measures how much is present","more vapour means higher humidity.")+
   U("On a humid day sweat dries slowly, so you feel hot and sticky."),
   [("dust","Dust is solid specks in the air; humidity is about water vapour, not dust."),
    ("oxygen","Oxygen is a gas we breathe; humidity measures water vapour, not oxygen."),
    ("smoke","Smoke is pollution; humidity is the moisture content of the air.")]),

 ("WC","Elephants living in hot regions have very large ears that they flap mainly to help them:",
   "throw off body heat and cool down",
   C("An elephant's huge ears are full of blood vessels; flapping them fans the blood and releases heat, cooling the animal.")+
   steps("The elephant lives where it is very hot","its big ears carry lots of blood near the surface","flapping fans them and sheds heat, cooling the body.")+
   U("A toucan's large beak cools it the same way — by shedding heat to the air."),
   [("hear very distant sounds","Big ears help shed heat; an elephant's hearing does not depend on their size for cooling."),
    ("store extra water","Ears do not store water; they help the elephant lose heat."),
    ("scare away lions","Flapping ears mainly cool the elephant rather than serve as a weapon.")]),

 ("WC","An animal that stays active mainly at night and rests by day to avoid the daytime heat is said to be:",
   "nocturnal",
   C("Nocturnal animals come out at night, when it is cooler, and sleep through the hot day.")+
   steps("The day is too hot and bright for some animals","they rest in burrows by day","they hunt and move at night — they are nocturnal.")+
   U("Desert foxes and owls are nocturnal, avoiding the burning daytime sun."),
   [("migratory","A migratory animal travels long distances seasonally; that is not about night activity."),
    ("aquatic","An aquatic animal lives in water; being nocturnal is about being active at night."),
    ("herbivorous","Herbivorous means plant-eating, which says nothing about night activity.")]),

 ("WC","Both the Arctic in the north and the Antarctic in the south share a climate that is:",
   "extremely cold and windy",
   C("The two polar regions are Earth's coldest places — freezing, windy, and ice-covered nearly all year.")+
   steps("The poles get only slanting, weak sunlight","so they never warm up","both stay extremely cold and windy.")+
   U("Explorers heading to either pole pack the same heavy gear against the bitter cold."),
   [("hot and rainy","Hot and rainy describes the tropics, the exact opposite of the icy poles."),
    ("mild and pleasant","The poles are harsh and freezing, never mild and pleasant."),
    ("dry and very hot","Dry and very hot describes a desert; the poles are dry but bitterly cold.")]),

 ("WC","Which everyday choice depends most directly on the weather of that particular day?",
   "the clothes you decide to wear",
   C("What you wear today follows today's weather — a raincoat for rain, light cotton for heat.")+
   steps("Check the weather of the day","cold and rainy means warm, waterproof clothes","hot and sunny means light clothes — the choice follows the weather.")+
   U("You grab an umbrella on a cloudy morning because of that day's weather forecast."),
   [("your date of birth","Your birth date is fixed and has nothing to do with today's weather."),
    ("the language you speak","The language you speak does not change with the day's weather."),
    ("your house number","A house number is fixed and unrelated to the weather.")]),

 ("WC","A sandy desert can be scorching by day yet cold at night mainly because the dry sand and air:",
   "heat up and cool down very fast",
   C("With little moisture to hold heat, desert sand warms quickly under the Sun and loses that heat just as fast after dark.")+
   steps("Dry sand and air hold heat poorly","under the strong Sun they heat up fast by day","after sunset they lose heat fast, so the night turns cold.")+
   U("Desert travellers carry both light day-clothes and warm wraps for the cold night."),
   [("trap heat like a thick blanket","Moist places trap heat; dry desert air does the opposite, losing heat fast."),
    ("make their own heat","Sand cannot create heat; it only gains and loses the Sun's heat."),
    ("block the Sun completely","The desert Sun is not blocked; it heats the sand strongly by day.")]),

 ("WC","The single great source of energy that drives nearly all the changes we group together as weather is the:",
   "Sun",
   C("The Sun's heat warms the air, water and land unevenly, and that uneven heating sets winds, clouds and rain in motion.")+
   steps("The Sun heats land and sea unevenly","warm air rises and moist air forms clouds","this restless heating drives all weather.")+
   U("No Sun would mean no winds, no rain, no weather at all on Earth."),
   [("the Moon","The Moon mainly causes tides; it does not power the weather like the Sun does."),
    ("the soil","Soil stores some heat but does not supply the energy that drives weather; the Sun does."),
    ("the rivers","Rivers carry water but are themselves part of a cycle powered by the Sun.")]),

 ("WC","Two animals well adapted to life in a tropical rainforest are the:",
   "toucan and the monkey",
   C("Toucans and monkeys both thrive in the hot, wet, tree-filled rainforest — built for climbing, leaping and finding fruit.")+
   steps("The rainforest is hot, wet and full of tall trees","toucans fly among branches and monkeys leap between them","both are adapted to rainforest life.")+
   U("On a forest visit you would expect toucans and monkeys high in the canopy, not on the ground."),
   [("polar bear and the penguin","Polar bears and penguins live in freezing polar regions, not the hot rainforest."),
    ("camel and the desert fox","Camels and desert foxes are adapted to dry deserts, not wet rainforests."),
    ("yak and the snow leopard","Yaks and snow leopards live on cold mountains, not in tropical rainforests.")]),

 ("WC","Camouflage helps an animal survive mainly by letting it:",
   "blend with its surroundings to avoid being seen",
   C("Camouflage means matching the colour or pattern of the surroundings, so predators or prey cannot easily spot the animal.")+
   steps("The animal's colour matches its background","it becomes hard to pick out","so it hides from enemies or sneaks up on prey.")+
   U("A green grasshopper sitting on a green leaf is almost invisible — that is camouflage."),
   [("run much faster than others","Camouflage is about blending in to hide, not about running speed."),
    ("make loud warning calls","A warning call draws attention; camouflage works by staying unseen."),
    ("store food for the winter","Storing food is unrelated to blending in with the surroundings.")]),
]

# ---------- TRANSPORTATION IN ANIMALS & PLANTS (25) — Science ----------
TR = [
 ("TR","The red fluid that carries digested food, oxygen and wastes to every part of our body is the:",
   "blood",
   C("Blood is the body's delivery fluid — it ferries oxygen, food and wastes to and from every cell.")+
   steps("Cells everywhere need oxygen and food","blood picks these up and flows to them","it also carries away their wastes — it transports everything.")+
   U("A blood test can reveal your health because blood touches every part of the body."),
   [("urine","Urine is liquid waste leaving the body; it does not deliver food and oxygen."),
    ("sweat","Sweat cools the skin and removes a little salt; it does not transport food to cells."),
    ("saliva","Saliva begins digestion in the mouth; it does not circulate around the body.")]),

 ("TR","The red colour of our blood comes from a special pigment carried inside the red blood cells, called:",
   "haemoglobin",
   C("Haemoglobin is a red pigment in red blood cells that grabs oxygen and gives blood its colour.")+
   steps("Red blood cells must carry oxygen","they are packed with the pigment haemoglobin","haemoglobin binds oxygen and looks red, colouring the blood.")+
   U("People low in haemoglobin feel tired because their blood carries less oxygen — this is anaemia."),
   [("chlorophyll","Chlorophyll is the green pigment in plants, not the red pigment in blood."),
    ("plasma","Plasma is the pale liquid part of blood; the red colour comes from haemoglobin."),
    ("platelet","Platelets help blood clot; they are not the pigment that colours blood red.")]),

 ("TR","The pale yellow liquid part of blood, in which the blood cells float and are carried along, is the:",
   "plasma",
   C("Plasma is the watery, pale-yellow fluid of blood; the red and white cells float and travel in it.")+
   steps("Blood is part cells, part liquid","the liquid is the plasma","the cells float in plasma and are carried by it.")+
   U("Donated plasma is given to patients to help replace lost blood fluid."),
   [("haemoglobin","Haemoglobin is the red pigment inside cells, not the liquid the cells float in."),
    ("platelets","Platelets are tiny cell pieces that clot blood, not the liquid part of blood."),
    ("marrow","Marrow is the tissue inside bones that makes blood cells, not part of the blood fluid.")]),

 ("TR","The tiny blood cells that help blood clot and seal a cut so bleeding stops are the:",
   "platelets",
   C("Platelets rush to a wound and clump together to form a clot, plugging the leak and stopping the bleeding.")+
   steps("A cut breaks a blood vessel","platelets gather at the wound","they clump and clot, sealing the cut so bleeding stops.")+
   U("The scab that forms over a healing graze starts as a platelet clot."),
   [("red blood cells","Red blood cells carry oxygen; they do not form the clot that stops bleeding."),
    ("white blood cells","White blood cells fight germs; clotting is the job of platelets."),
    ("nerve cells","Nerve cells carry messages; they have nothing to do with clotting blood.")]),

 ("TR","The muscular organ that keeps pumping to push blood around the whole body is the:",
   "heart",
   C("The heart is a tireless muscular pump that squeezes again and again to keep blood circulating.")+
   steps("Blood must keep moving to reach all cells","the heart squeezes to push it out","it relaxes to refill, then pumps again — a steady pump.")+
   U("When you run, your heart pumps faster so your muscles get more oxygen."),
   [("lung","The lung adds oxygen to blood; the pumping is done by the heart."),
    ("kidney","The kidney filters wastes from blood; it does not pump the blood around."),
    ("stomach","The stomach digests food; it does not pump blood through the body.")]),

 ("TR","The 'lub-dub' sound that a doctor hears through a stethoscope on the chest is produced by the:",
   "closing of the heart valves",
   C("Each lub and dub is the snap of valves shutting inside the beating heart, keeping blood flowing one way.")+
   steps("The heart's valves open to let blood through","they shut to stop it flowing back","each shut makes a sound — the lub-dub of a heartbeat.")+
   U("A doctor counts these sounds to measure your heart rate during a check-up."),
   [("air rushing into the lungs","Breathing sounds come from the lungs; lub-dub comes from the heart's valves."),
    ("food moving in the stomach","Stomach gurgles are unrelated to the heart's lub-dub sound."),
    ("blood being made in bones","Blood is made quietly in marrow; the lub-dub is the heart valves closing.")]),

 ("TR","Blood vessels that carry blood away from the heart to the rest of the body are the:",
   "arteries",
   C("Arteries are the outgoing pipes — they carry blood pumped out of the heart to the body's organs.")+
   steps("The heart pumps blood out under pressure","this blood enters the arteries","arteries carry it away from the heart to all organs.")+
   U("Doctors feel your pulse on an artery in the wrist as blood surges through it."),
   [("veins","Veins carry blood back to the heart; arteries carry it away from the heart."),
    ("capillaries","Capillaries are the tiny vessels joining arteries to veins, not the outgoing pipes."),
    ("nerves","Nerves carry messages, not blood; arteries carry blood away from the heart.")]),

 ("TR","Blood vessels that carry blood from the body back towards the heart are the:",
   "veins",
   C("Veins are the return pipes — they bring blood from the body back to the heart.")+
   steps("Blood drops off oxygen and food in the body","this used blood must return to the heart","it travels back through the veins.")+
   U("The bluish lines you see on the back of your hand are veins returning blood."),
   [("arteries","Arteries carry blood away from the heart; veins bring it back."),
    ("capillaries","Capillaries are the tiny connecting vessels, not the ones returning blood to the heart."),
    ("windpipe","The windpipe carries air to the lungs, not blood back to the heart.")]),

 ("TR","Arteries and veins are linked by extremely thin-walled vessels where food and oxygen pass to the cells; these are the:",
   "capillaries",
   C("Capillaries are the narrowest vessels; their thin walls let oxygen and food slip out to the cells and wastes slip in.")+
   steps("Arteries branch into ever-thinner vessels","the thinnest are the capillaries","their thin walls let exchange happen, then they join into veins.")+
   U("Oxygen reaches your muscles through capillaries so fine that cells line up one by one to pass."),
   [("arteries","Arteries are thick outgoing vessels; the thin exchange vessels are capillaries."),
    ("veins","Veins are the return vessels; the tiny exchange vessels are capillaries."),
    ("valves","A valve is a one-way flap inside the heart and veins, not a vessel that links them.")]),

 ("TR","How many times the heart beats during one full minute is known as the:",
   "heart rate (pulse rate)",
   C("Heart rate, or pulse rate, simply counts the heartbeats in one minute.")+
   steps("Each squeeze of the heart is one beat","count the beats in sixty seconds","that count is the heart rate.")+
   U("A fitness watch shows your heart rate climbing as you run faster."),
   [("blood pressure","Blood pressure is the push of blood on vessel walls, not the count of beats per minute."),
    ("body temperature","Body temperature is how warm you are, measured in degrees, not beats per minute."),
    ("breathing depth","Breathing depth is about the lungs; heart rate counts heartbeats.")]),

 ("TR","We can feel a pulse at the wrist because, with every heartbeat, an artery there:",
   "throbs as blood is pushed through it",
   C("Each heartbeat sends a surge of blood, making the artery swell and throb — that throb is the pulse.")+
   steps("The heart pumps a fresh burst of blood","this surge stretches the artery wall","the wall throbs once per beat — you feel the pulse.")+
   U("Pressing two fingers on your wrist lets you count your pulse during exercise."),
   [("fills with air","Arteries carry blood, not air; the pulse is the surge of blood, not air."),
    ("turns blue","An artery throbs with each beat; it does not change colour to make a pulse."),
    ("stops moving briefly","The pulse is felt because the artery throbs with blood, not because it stops.")]),

 ("TR","The pair of bean-shaped organs that filter wastes out of the blood and make urine are the:",
   "kidneys",
   C("The two kidneys clean the blood, removing wastes and extra water to form urine.")+
   steps("Blood carries dissolved wastes","it flows through the kidneys","they filter out wastes and water as urine, sending clean blood on.")+
   U("Drinking enough water helps the kidneys flush wastes out smoothly as urine."),
   [("lungs","Lungs remove carbon dioxide as a gas; the kidneys filter wastes from blood into urine."),
    ("heart","The heart pumps blood; it does not filter wastes to make urine."),
    ("liver","The liver does many jobs, but filtering blood to form urine is done by the kidneys.")]),

 ("TR","Plants take in water and dissolved minerals from the soil mainly through their:",
   "roots",
   C("Roots, with their many tiny root hairs, soak up water and minerals from the soil.")+
   steps("Water and minerals sit in the soil","root hairs spread through the soil and absorb them","the roots pass them up into the plant.")+
   U("Watering the base of a plant works because the roots, not the leaves, drink it up."),
   [("leaves","Leaves make food and release water vapour; absorbing soil water is the roots' job."),
    ("flowers","Flowers make seeds; they do not absorb water and minerals from the soil."),
    ("fruits","Fruits hold and protect seeds; they do not take in water from the soil.")]),

 ("TR","The tube-like tissue that carries water and minerals upward from the roots to the leaves is the:",
   "xylem",
   C("Xylem is the plant's water pipeline, carrying water and minerals upward from root to leaf.")+
   steps("Roots absorb water","xylem tubes run up the stem","they carry the water all the way up to the leaves.")+
   U("The faint lines you see in a leaf are veins full of water-carrying xylem."),
   [("phloem","Phloem carries food made in leaves; xylem carries water up from the roots."),
    ("root hair","A root hair absorbs water at the root tip; the upward pipeline is the xylem."),
    ("stomata","Stomata are tiny leaf pores for gas exchange, not the upward water pipeline.")]),

 ("TR","The tissue that carries food made in the leaves to all other parts of the plant is the:",
   "phloem",
   C("Phloem is the plant's food delivery line, carrying sugar made in the leaves to roots, stem and fruit.")+
   steps("Leaves make food by photosynthesis","this food enters the phloem","phloem carries it to every part that needs it, even the roots.")+
   U("A sweet, growing fruit is fed by sugar delivered through the phloem."),
   [("xylem","Xylem carries water upward; food made in leaves is carried by the phloem."),
    ("stomata","Stomata are pores for gases; carrying food is the job of the phloem."),
    ("bark","Bark is the protective outer layer; food is carried inside by the phloem.")]),

 ("TR","The loss of water as vapour from the surface of a plant's leaves is called:",
   "transpiration",
   C("Transpiration is the escape of water vapour from tiny leaf pores — like the plant gently breathing out water.")+
   steps("Water reaches the leaves through the xylem","some escapes as vapour through tiny pores","this water loss from leaves is transpiration.")+
   U("A potted plant covered with a clear bag shows misty drops — water lost by transpiration."),
   [("respiration","Respiration releases energy from food; transpiration is the loss of water vapour."),
    ("germination","Germination is a seed sprouting into a seedling, not water leaving the leaves."),
    ("digestion","Digestion breaks down food; transpiration is water vapour escaping from leaves.")]),

 ("TR","Transpiration is useful to a tall tree because the water escaping from the leaves helps to:",
   "pull more water up from the roots",
   C("As water leaves the top of the tree, it tugs the whole water column upward, drawing fresh water up from the roots — the transpiration pull.")+
   steps("Water vapour escapes from the leaves at the top","this creates a gentle suction in the xylem","the suction pulls more water up from the roots.")+
   U("This pull lifts water dozens of metres up a tall tree with no pump at all."),
   [("push food down to the roots","Pushing food down is the phloem's job; transpiration pulls water up the xylem."),
    ("make the leaves heavier","Losing water vapour makes leaves lighter, not heavier; it helps draw water up."),
    ("store water in the stem","Transpiration moves water out and pulls more up; it does not store water in the stem.")]),

 ("TR","Sweating in humans removes a little water and salt from the body and, importantly, also helps to:",
   "cool the body down",
   C("As sweat dries off the skin, it carries away heat, so sweating helps keep the body from overheating.")+
   steps("On a hot day the body warms up","sweat glands release water onto the skin","as it evaporates it takes heat away, cooling the body.")+
   U("After running you sweat and then feel cooler as the sweat dries off your skin."),
   [("warm the body up","Sweating cools the body by evaporation; it does not warm it up."),
    ("add oxygen to the blood","Oxygen enters through the lungs, not through sweating from the skin."),
    ("digest the food faster","Sweating controls body heat; it has nothing to do with digesting food.")]),

 ("TR","A tiny single-celled animal such as Amoeba has no blood or heart because it exchanges gases and food:",
   "directly through its surface by diffusion",
   C("An Amoeba is so small that oxygen and food can simply seep straight through its surface, so it needs no transport system.")+
   steps("The Amoeba is a single tiny cell","every part is close to the surface","oxygen and food diffuse straight in, so no blood is needed.")+
   U("This is why microscopic pond creatures live perfectly well without any heart at all."),
   [("through a long network of veins","An Amoeba has no veins; it is tiny enough to exchange gases directly through its surface."),
    ("by pumping with a small heart","An Amoeba has no heart; substances simply diffuse through its surface."),
    ("using green chlorophyll","Chlorophyll is for making food in plants; the Amoeba exchanges gases by diffusion.")]),

 ("TR","After delivering oxygen to the body, the dark, oxygen-poor blood returns to the heart and is then sent to the:",
   "lungs to pick up oxygen",
   C("Oxygen-poor blood is pumped to the lungs, where it loads up on fresh oxygen before going back out to the body.")+
   steps("Used blood returns dark and oxygen-poor","the heart pumps it to the lungs","there it picks up oxygen and turns bright red again.")+
   U("This is why a deep breath of fresh air helps your blood reload with oxygen."),
   [("stomach to pick up food","Food is added through digestion, but oxygen-poor blood goes to the lungs for oxygen."),
    ("kidneys to add water","Kidneys remove wastes; oxygen-poor blood is sent to the lungs for oxygen."),
    ("skin to pick up sunlight","Human blood is not refreshed by sunlight on the skin; it goes to the lungs.")]),

 ("TR","Oxygen-rich blood flowing out to the body is usually:",
   "bright red",
   C("Blood loaded with oxygen is a vivid bright red, while oxygen-poor blood is darker.")+
   steps("Haemoglobin grabs oxygen in the lungs","oxygen-rich haemoglobin is bright red","so oxygen-rich blood looks bright red.")+
   U("Blood from a fresh cut looks bright red because it is rich in oxygen from the air."),
   [("dark bluish","Dark, dull blood is oxygen-poor; oxygen-rich blood is bright red."),
    ("colourless","Blood is never colourless; oxygen-rich blood is bright red from haemoglobin."),
    ("green","Green is the colour of plant chlorophyll, not of oxygen-rich blood.")]),

 ("TR","Into how many separate chambers is the human heart divided?",
   "four",
   C("The human heart has four chambers — two upper and two lower — which keep oxygen-rich and oxygen-poor blood from mixing.")+
   steps("The heart has an upper pair and a lower pair","two upper chambers receive blood","two lower chambers pump it out — four in all.")+
   U("Doctors use a four-chambered model of the heart to explain how blood flows through it."),
   [("two","A two-chambered heart belongs to fish; the human heart has four chambers."),
    ("three","A three-chambered heart belongs to frogs; the human heart has four."),
    ("one","A single chamber could not separate the blood flows; the human heart has four.")]),

 ("TR","Which tissue carries water upward in a plant — xylem or phloem?",
   "xylem",
   C("Xylem is the upward water pipeline; phloem carries food, so the water-carrier is the xylem.")+
   steps("Water enters at the roots","it must travel up to the leaves","the xylem is the tissue that carries it upward.")+
   U("A cut flower drinks dyed water up its xylem, slowly turning its petals that colour."),
   [("phloem","Phloem carries food downward and around; water is carried upward by the xylem."),
    ("both equally","The two tissues have different jobs; water upward is specifically the xylem."),
    ("neither","One tissue does carry water up — the xylem; it is not neither.")]),

 ("TR","On a hot, dry, windy day a plant loses water by transpiration:",
   "faster than on a cool, calm day",
   C("Heat, dryness and wind all speed up evaporation from the leaves, so transpiration is faster in such weather.")+
   steps("Heat and dry air make water evaporate quickly","wind sweeps the vapour away from the leaf","so the plant transpires faster on a hot, dry, windy day.")+
   U("Gardeners water plants more on hot, windy days because they lose water so fast."),
   [("slower than on a cool day","Heat speeds evaporation, so transpiration is faster, not slower, on a hot day."),
    ("at exactly the same rate always","Transpiration changes with the weather; it is not the same on every day."),
    ("only at night","Transpiration is fastest in the warm, bright, windy daytime, not only at night.")]),

 ("TR","The blood cells that defend the body by fighting germs and clearing infections are the:",
   "white blood cells",
   C("White blood cells are the body's soldiers — they hunt down and destroy germs that get into the blood.")+
   steps("Germs sometimes enter the blood","white blood cells detect them","they attack and clear the germs, defending the body.")+
   U("Your white-cell count rises when you fight an infection, which a blood test can show."),
   [("red blood cells","Red blood cells carry oxygen with haemoglobin; fighting germs is the white cells' job."),
    ("platelets","Platelets help blood clot to stop bleeding; defending against germs is done by white blood cells."),
    ("plasma","Plasma is the liquid that carries the cells; the germ-fighting is done by white blood cells.")]),
]

# ---------- DATA HANDLING (25) — Maths (many fused with Science data) ----------
DH = [
 ("DH","Facts or figures collected together, such as a week's recorded temperatures, are together called:",
   "data",
   C("Data is simply a collection of facts or numbers gathered for a purpose.")+
   steps("You record a number each day","you collect many such numbers","this collection of figures is called data.")+
   U("A weather station's daily temperature readings make up a set of data."),
   [("a graph","A graph is a picture of data; the collected figures themselves are the data."),
    ("an average","An average is one number worked out from data, not the collection itself."),
    ("a survey","A survey is the act of collecting; the figures it gathers are the data.")]),

 ("DH","Adding up all the observations and dividing by how many there are gives the:",
   "mean (average)",
   C("The mean spreads the total evenly across all the observations — it is the everyday average.")+
   steps("Add all the values to get the total","count how many values there are","divide the total by the count to get the mean.")+
   U("A cricketer's batting average is the mean of the runs scored across many innings."),
   [("mode","The mode is the most frequent value, not the total divided by the count."),
    ("median","The median is the middle value when ordered, not the sum divided by the count."),
    ("range","The range is the highest minus the lowest value, not an average.")]),

 ("DH","Over 5 days the maximum temperatures were 30, 32, 31, 29 and 33 degrees C. Their mean temperature is:",
   "31 degrees C",
   C("Add the five readings and divide by 5 to get the average temperature for the week.")+
   steps("Add: 30+32+31+29+33 = 155","there are 5 readings","mean = 155 / 5 = 31 degrees C.")+
   U("A forecaster reports the week's average temperature exactly this way."),
   [("33 degrees C","33 is the highest single reading, not the average of all five."),
    ("29 degrees C","29 is the lowest single reading, not the mean of the five."),
    ("155 degrees C","155 is the total of all readings; the mean is that total divided by 5.")]),

 ("DH","In a set of observations, the value that occurs most often is called the:",
   "mode",
   C("The mode is the most frequent value — the one that appears the greatest number of times.")+
   steps("List how many times each value appears","find the value with the highest count","that most-repeated value is the mode.")+
   U("A shoe shop checks the mode of sizes sold to stock the most-wanted size."),
   [("mean","The mean is the average; the mode is the most frequently occurring value."),
    ("median","The median is the middle value when ordered, not the most frequent one."),
    ("range","The range is the spread from lowest to highest, not the most common value.")]),

 ("DH","On a week's rainfall record the value 0 mm appears on 4 of the 7 days, more often than any other. The mode of the rainfall is:",
   "0 mm",
   C("The mode is the most frequent reading, and 0 mm shows up more times than any other amount.")+
   steps("Count how often each rainfall value appears","0 mm appears on 4 days, the most","so the mode is 0 mm.")+
   U("This tells you that, most days that week, it simply did not rain at all."),
   [("7 mm","7 is the number of days, not the most common rainfall value, which is 0 mm."),
    ("4 mm","4 is how many days were dry, not the rainfall value; the mode reading is 0 mm."),
    ("the highest rainfall","The mode is the most frequent value, which here is 0 mm, not the highest.")]),

 ("DH","When all the observations are arranged in order, the value that lies right in the middle is the:",
   "median",
   C("The median is the middle value once the data are lined up in order, with as many below it as above.")+
   steps("Arrange the values from lowest to highest","find the one in the very middle","that central value is the median.")+
   U("To find the typical income, the median is often used because it sits in the middle."),
   [("mean","The mean is the total divided by the count, not the middle value when ordered."),
    ("mode","The mode is the most frequent value, not the central one when arranged in order."),
    ("range","The range is the difference between the largest and smallest, not the middle value.")]),

 ("DH","The five temperatures 28, 30, 31, 33, 35 degrees C are already in order. Their median is:",
   "31 degrees C",
   C("With five ordered values, the median is the third one — the value with two below and two above.")+
   steps("There are 5 ordered values","the middle one is the 3rd value","that is 31 degrees C — the median.")+
   U("Reporting the median temperature ignores one freak hot day pulling the average up."),
   [("28 degrees C","28 is the smallest value, not the middle one; the median is 31."),
    ("35 degrees C","35 is the largest value, not the central one; the median is 31."),
    ("32 degrees C","32 is not even in the list; the middle of these five values is 31.")]),

 ("DH","The difference between the highest and the lowest values in a set of data is called the:",
   "range",
   C("The range shows how spread out the data are — it is the largest value minus the smallest.")+
   steps("Find the highest value","find the lowest value","subtract: highest minus lowest gives the range.")+
   U("A weather report giving a day's high and low lets you work out the temperature range."),
   [("mean","The mean is the average value, not the gap between highest and lowest."),
    ("median","The median is the middle value, not the spread from lowest to highest."),
    ("mode","The mode is the most frequent value, not the difference between extremes.")]),

 ("DH","On one day the maximum temperature was 36 degrees C and the minimum was 24 degrees C. The temperature range that day was:",
   "12 degrees C",
   C("The range is simply the highest reading minus the lowest reading.")+
   steps("Highest = 36 degrees C","lowest = 24 degrees C","range = 36 - 24 = 12 degrees C.")+
   U("A big day-night range like this is common in deserts, which heat and cool quickly."),
   [("60 degrees C","60 is the sum of the two readings; the range is their difference, 12."),
    ("36 degrees C","36 is the maximum reading itself, not the difference from the minimum."),
    ("24 degrees C","24 is the minimum reading itself, not the range, which is 36 - 24.")]),

 ("DH","A bar graph shows data using bars that all have the same width but different:",
   "heights (lengths)",
   C("In a bar graph every bar is equally wide; it is the height of each bar that shows the size of its value.")+
   steps("Each category gets a bar of equal width","the value decides how tall the bar is","taller bars mean larger values.")+
   U("A bar graph of weekly rainfall lets you see at a glance which day was wettest."),
   [("widths","The widths are kept equal; it is the heights that differ to show the values."),
    ("colours","Colours may differ for clarity, but the value is shown by the bar's height."),
    ("shapes","All bars are the same rectangular shape; their heights show the values.")]),

 ("DH","A pictograph shows the collected data chiefly by means of:",
   "pictures or symbols",
   C("A pictograph uses little pictures, each standing for a fixed number, to show the data.")+
   steps("Choose a symbol to stand for a set number","draw as many symbols as needed for each category","the rows of pictures show the data.")+
   U("A pictograph of fruit sold, with one apple-picture for every 10 apples, is easy to read."),
   [("only words","A pictograph uses pictures or symbols, not just written words."),
    ("a single number","A pictograph shows data with rows of symbols, not one lone number."),
    ("straight lines only","Lines belong to a line graph; a pictograph uses pictures or symbols.")]),

 ("DH","On a pictograph one bird-symbol stands for 10 birds. Four such symbols therefore stand for:",
   "40 birds",
   C("Each symbol equals 10 birds, so you multiply the number of symbols by 10.")+
   steps("One symbol = 10 birds","there are 4 symbols","4 x 10 = 40 birds.")+
   U("Reading a pictograph key correctly is the skill behind every infographic you see."),
   [("4 birds","4 is the number of symbols; each symbol stands for 10, so the total is 40."),
    ("14 birds","You multiply, not add; 4 symbols of 10 each make 40, not 14."),
    ("10 birds","10 is what one symbol stands for; four symbols stand for 40.")]),

 ("DH","When a fair coin is tossed once, the chance (probability) that it shows heads is:",
   "1/2",
   C("A coin has two equally likely sides, so the chance of heads is one out of two.")+
   steps("There are 2 possible results: heads or tails","both are equally likely","so the probability of heads is 1 out of 2, that is 1/2.")+
   U("This is why tossing a coin is a fair way to decide who bats first in cricket."),
   [("1","A probability of 1 means certain; heads is not certain, its chance is 1/2."),
    ("0","A probability of 0 means impossible; heads can happen, so it is not 0."),
    ("2","Probability is never more than 1; the chance of heads is 1/2.")]),

 ("DH","An event that is absolutely certain to happen has a probability of:",
   "1",
   C("Probability runs from 0 (impossible) to 1 (certain); a sure event scores the full 1.")+
   steps("Impossible events have probability 0","certain events are sure to occur","so a certain event has probability 1.")+
   U("The Sun rising tomorrow is treated as a certain event, with probability 1."),
   [("0","A probability of 0 means impossible, the opposite of certain."),
    ("1/2","A probability of 1/2 means an even chance, not a certain event."),
    ("100","Probability never exceeds 1; a certain event has probability 1, not 100.")]),

 ("DH","A patient's heart-rate readings over five checks were 70, 72, 74, 72 and 72 beats per minute. The mode of these readings is:",
   "72",
   C("The mode is the most frequent reading, and 72 appears three times, more than any other.")+
   steps("Count each value: 70 once, 74 once, 72 three times","72 occurs most often","so the mode is 72.")+
   U("A nurse spotting a repeated 72 reading sees the patient's steady resting heart rate."),
   [("70","70 appears only once; the most frequent reading is 72."),
    ("74","74 appears only once; the value that repeats most is 72."),
    ("360","360 is the sum of all readings, not the most frequent value, which is 72.")]),

 ("DH","On a bar graph of a week's rainfall, the tallest bar represents the day that had the:",
   "most rainfall",
   C("A taller bar means a larger value, so the tallest rainfall bar marks the wettest day.")+
   steps("Bar height shows the rainfall amount","the tallest bar is the largest amount","so it marks the day with the most rain.")+
   U("A glance at such a graph instantly shows which day to expect floods or delays."),
   [("least rainfall","The shortest bar shows the least rainfall; the tallest shows the most."),
    ("most sunshine","The graph shows rainfall, not sunshine; the tallest bar means the most rain."),
    ("highest temperature","This is a rainfall graph, so the tallest bar means most rain, not heat.")]),

 ("DH","Find the average of these five whole numbers: 0, 1, 2, 3 and 4. It is:",
   "2",
   C("Add the five numbers and divide by 5 to find their average.")+
   steps("Add: 0+1+2+3+4 = 10","there are 5 numbers","mean = 10 / 5 = 2.")+
   U("Averaging evenly spaced numbers like this gives the middle one, here 2."),
   [("10","10 is the total of the numbers; the mean is that total divided by 5, which is 2."),
    ("5","5 is how many numbers there are, not their average, which is 2."),
    ("4","4 is the largest of the numbers, not the mean of all five.")]),

 ("DH","Five pulse readings, arranged in order, are 68, 72, 72, 76 and 80. The median (middle value) is:",
   "72",
   C("With five ordered readings, the median is the third one — the value in the centre.")+
   steps("The readings are already in order","the middle of five is the 3rd value","that 3rd value is 72 — the median.")+
   U("Using the median pulse ignores one unusually high or low reading at an end."),
   [("68","68 is the smallest reading, not the central one; the median is 72."),
    ("80","80 is the largest reading, not the middle one; the median is 72."),
    ("76","76 is the fourth reading, not the central third one, which is 72.")]),

 ("DH","Double bar graphs are especially useful because they let you:",
   "compare two sets of data side by side",
   C("A double bar graph puts two related bars together for each category, so two data sets can be compared at a glance.")+
   steps("Each category gets two bars, one per data set","the bars stand side by side","comparing their heights compares the two sets.")+
   U("A double bar graph can compare last year's and this year's rainfall month by month."),
   [("hide one set of data","A double bar graph shows both sets clearly; it does not hide either one."),
    ("show only a single value","It is built to compare two sets, not to show just one value."),
    ("replace all numbers with one bar","It uses paired bars to compare data, not a single combined bar.")]),

 ("DH","An ordinary six-faced die is rolled once. The probability of getting a number greater than 6 is:",
   "0",
   C("A die only shows 1 to 6, so a number greater than 6 can never come up — it is impossible.")+
   steps("The faces are 1, 2, 3, 4, 5, 6","none of these is greater than 6","an impossible event has probability 0.")+
   U("Knowing some outcomes are impossible helps you judge fair chances in any game."),
   [("1","A probability of 1 means certain; this event is impossible, so its probability is 0."),
    ("6","Probability is never above 1; an impossible event scores 0, not 6."),
    ("1/6","1/6 is the chance of one particular face; a number above 6 has chance 0.")]),

 ("DH","To find the mean monthly rainfall over a full year, you divide the year's total rainfall by:",
   "12",
   C("A year has 12 months, so the mean monthly rainfall is the yearly total shared over 12 months.")+
   steps("Add up the rainfall of all 12 months","that is the yearly total","divide it by 12 to get the mean per month.")+
   U("This is how a region's average monthly rainfall is reported in a geography book."),
   [("7","7 is the number of days in a week, not the months in a year; you divide by 12."),
    ("365","365 is the number of days in a year; for monthly mean you divide by 12 months."),
    ("1","Dividing by 1 changes nothing; the mean monthly figure needs dividing by 12.")]),

 ("DH","The sum of six temperature readings is 180 degrees C. Their mean is found by computing:",
   "180 / 6 = 30 degrees C",
   C("The mean is the total divided by the number of readings.")+
   steps("The total of the readings is 180","there are 6 readings","mean = 180 / 6 = 30 degrees C.")+
   U("Climate scientists average many readings exactly this way to report a region's heat."),
   [("180 x 6 = 1080","You divide the total by the count for a mean, not multiply, so it is 180/6."),
    ("180 + 6 = 186","Adding the count to the total does not give a mean; you divide, getting 30."),
    ("180 - 6 = 174","Subtracting the count is not how a mean works; divide 180 by 6 to get 30.")]),

 ("DH","Arranging a list of marks from lowest to highest is the natural first step when you want to find the:",
   "median",
   C("The median is the middle value, and you can only see which value is in the middle after lining the data up in order.")+
   steps("The median is the central value","you cannot tell the centre of a jumbled list","so you first arrange the data in order, then pick the middle.")+
   U("A teacher orders the class marks before reading off the middle (median) score."),
   [("mode","The mode is the most frequent value; you can count it without ordering the data."),
    ("mean","The mean is the total divided by the count; the order of the numbers does not matter."),
    ("range","The range needs only the largest and smallest values, not a full ordering for the middle.")]),

 ("DH","A class recorded each student's favourite season. The season chosen by the greatest number of students is the:",
   "mode of the data",
   C("The mode is the choice that occurs most often, so the most popular season is the mode.")+
   steps("Count how many chose each season","find the season with the highest count","that most-chosen season is the mode.")+
   U("Shops use the mode of customer choices to decide which item to stock most."),
   [("mean of the data","Seasons are not numbers to average; the most-chosen one is the mode, not a mean."),
    ("range of the data","Range is a difference between number values; the favourite season is the mode."),
    ("median of the data","Median is a middle number; the most-popular category is the mode.")]),

 ("DH","If the mean of four numbers is 25, then the total (sum) of those four numbers must be:",
   "100",
   C("Since the mean is the total divided by the count, the total equals the mean multiplied by the count.")+
   steps("Mean = total / count","so total = mean x count","total = 25 x 4 = 100.")+
   U("Working backwards from an average like this is how you check a missing reading."),
   [("25","25 is the mean of the four numbers, not their total, which is 25 x 4 = 100."),
    ("29","29 is just the mean plus the count; the total is the mean times the count, 100."),
    ("4","4 is how many numbers there are, not their sum, which is 100.")]),
]

# ---------- RATIONAL NUMBERS (25) — Maths (some fused with Science) ----------
RN = [
 ("RN","Any value that can be expressed as p/q, with p and q integers and q not equal to zero, is termed a:",
   "rational number",
   C("Any number you can write as one integer over another non-zero integer is a rational number.")+
   steps("Take two integers, p and q, with q not zero","write them as the fraction p/q","every such number is a rational number.")+
   U("Sharing 3 rotis equally among 4 friends gives each 3/4, a rational number."),
   [("a whole number only","Whole numbers are rational, but rational numbers also include fractions like 3/4."),
    ("an odd number","Being odd is about whole numbers; a rational number is any p/q with q not zero."),
    ("a number that cannot be a fraction","A rational number is exactly one that can be written as a fraction p/q.")]),

 ("RN","In the rational number 3/7, the number 7 written below the line is called the:",
   "denominator",
   C("The bottom number of a fraction is the denominator; it tells into how many equal parts the whole is split.")+
   steps("A fraction has a top and a bottom number","the bottom number is the denominator","in 3/7 the denominator is 7.")+
   U("Cutting a cake into 7 equal slices makes 7 the denominator of each slice, 1/7."),
   [("numerator","The numerator is the top number, here 3; the bottom number 7 is the denominator."),
    ("quotient","A quotient is the answer to a division; the bottom of a fraction is the denominator."),
    ("remainder","A remainder is left over after division; the bottom number is the denominator.")]),

 ("RN","Every integer is also a rational number, because any integer can be written as a fraction with denominator:",
   "1",
   C("An integer like 5 equals 5/1, so it fits the p/q form with denominator 1 — making it rational.")+
   steps("Take any integer, say 5","write it as 5/1","since 1 is a non-zero integer, 5 is rational too.")+
   U("This is why the counting numbers you use every day all count as rational numbers."),
   [("0","A denominator can never be 0; an integer is written over 1 to make it a fraction."),
    ("2","Writing over 2 would change the value; an integer equals itself over 1."),
    ("the integer itself","Writing an integer over itself gives 1, not the integer; the denominator is 1.")]),

 ("RN","The standard (lowest) form of the rational number 6/8 is:",
   "3/4",
   C("Divide the top and bottom by their largest common factor to reach the simplest equal fraction.")+
   steps("Both 6 and 8 share the factor 2","divide top and bottom by 2: 6/8 = 3/4","3 and 4 share no factor, so 3/4 is lowest form.")+
   U("Recipes are easier read in lowest form, like 3/4 cup rather than 6/8 cup."),
   [("6/8","6/8 is correct in value but not in lowest form; it simplifies to 3/4."),
    ("12/16","12/16 is an even bigger equal fraction, not the simplest one, which is 3/4."),
    ("2/4","2/4 simplifies further to 1/2 and is not equal to 6/8; the lowest form is 3/4.")]),

 ("RN","Which is the greater rational number: -3/4 or -1/4 ?",
   "-1/4",
   C("On the number line, numbers further right are greater; -1/4 sits closer to zero than -3/4, so it is greater.")+
   steps("Both are negative, so the one nearer zero is larger","-1/4 is nearer zero than -3/4","therefore -1/4 is greater.")+
   U("Owing Rs 1 (-1) is better than owing Rs 3 (-3) — the smaller debt is the greater value."),
   [("-3/4","-3/4 lies further from zero on the left, so it is the smaller, not the greater, value."),
    ("they are equal","-3/4 and -1/4 are different points on the line; -1/4 is the greater of the two."),
    ("neither, both are zero","Neither is zero; both are negative, and -1/4 is the greater of them.")]),

 ("RN","On the number line, the rational number -2/3 lies between:",
   "-1 and 0",
   C("Since -2/3 is negative but smaller in size than 1, it sits just to the left of zero, between -1 and 0.")+
   steps("-2/3 is negative, so it is left of 0","its size 2/3 is less than 1","so it falls between -1 and 0.")+
   U("Marking everyday quantities like -2/3 of a degree below zero needs this placement."),
   [("0 and 1","-2/3 is negative, so it lies to the left of 0, not between 0 and 1."),
    ("-2 and -1","Its size 2/3 is less than 1, so it sits between -1 and 0, not between -2 and -1."),
    ("1 and 2","A negative number can never lie between two positive numbers like 1 and 2.")]),

 ("RN","The additive inverse (the opposite) of the rational number 5/9 is:",
   "-5/9",
   C("The additive inverse of a number is the one that adds to it to give 0; for 5/9 that is -5/9.")+
   steps("We need a number that added to 5/9 gives 0","that number is -5/9","check: 5/9 + (-5/9) = 0.")+
   U("Earning Rs 5 then spending Rs 5 leaves you at zero — opposites cancel out."),
   [("9/5","9/5 is the reciprocal (it multiplies to 1), not the additive inverse of 5/9."),
    ("5/9","Adding 5/9 to itself gives 10/9, not 0; the additive inverse is -5/9."),
    ("0","0 is the result of adding a number to its inverse, not the inverse of 5/9 itself.")]),

 ("RN","A winter morning temperature of -8 degrees C rises by 3 degrees C. The new reading, as a rational number, is:",
   "-5 degrees C",
   C("Rising 3 degrees from -8 moves 3 steps towards warmer, landing at -5 degrees C.")+
   steps("Start at -8 degrees C","add 3 for the rise: -8 + 3","that gives -5 degrees C.")+
   U("This is how a weather app updates a sub-zero temperature as the morning warms up."),
   [("-11 degrees C","Adding 3 makes it warmer, not colder; -8 + 3 is -5, not -11."),
    ("11 degrees C","You add only 3 degrees, not jump to a positive 11; the answer is -5."),
    ("5 degrees C","The reading is still below zero after a 3-degree rise from -8, giving -5.")]),

 ("RN","The sum 1/2 + 1/3 equals:",
   "5/6",
   C("To add fractions you give them a common denominator, then add the tops.")+
   steps("The common denominator of 2 and 3 is 6","1/2 = 3/6 and 1/3 = 2/6","3/6 + 2/6 = 5/6.")+
   U("Adding 1/2 a cup and 1/3 a cup of water means pouring in 5/6 of a cup in all."),
   [("2/5","You cannot add tops and bottoms straight across; with a common denominator it is 5/6."),
    ("1/5","Adding the two fractions makes more, not less; the correct sum is 5/6."),
    ("1/6","1/6 is the difference 1/2 - 1/3, not the sum, which is 5/6.")]),

 ("RN","The value of 3/4 - 1/2 is:",
   "1/4",
   C("Give both fractions the same denominator, then subtract the tops.")+
   steps("Make denominators equal: 1/2 = 2/4","subtract: 3/4 - 2/4","that leaves 1/4.")+
   U("If 3/4 of a tank is full and you use 1/2 a tank, then 1/4 of the tank is left."),
   [("2/2","Subtracting leaves less than you started with; 3/4 - 1/2 is 1/4, not 2/2."),
    ("1/2","1/2 is what you took away, not what remains; 3/4 - 1/2 leaves 1/4."),
    ("3/8","You do not multiply the bottoms when subtracting; with a common denominator it is 1/4.")]),

 ("RN","The product 2/3 x 6/5 equals (in lowest form):",
   "4/5",
   C("Multiply the tops together and the bottoms together, then simplify.")+
   steps("Multiply tops: 2 x 6 = 12; bottoms: 3 x 5 = 15","that gives 12/15","both divide by 3, so 12/15 = 4/5.")+
   U("Scaling a recipe by 6/5 of a 2/3-cup amount uses exactly this fraction multiplication."),
   [("12/15","12/15 is correct in value but not in lowest form; it simplifies to 4/5."),
    ("8/15","You multiply 2 x 6 = 12 on top, not 2 x 4; the product is 12/15 = 4/5."),
    ("2/5","To multiply you do not just shrink the top; 2/3 x 6/5 works out to 4/5.")]),

 ("RN","The reciprocal of the rational number 4/7 is:",
   "7/4",
   C("The reciprocal of a fraction is found by flipping it — swapping the top and bottom.")+
   steps("Take 4/7","swap top and bottom to get 7/4","check: 4/7 x 7/4 = 1, as a reciprocal should.")+
   U("Dividing by 4/7 is the same as multiplying by its reciprocal 7/4."),
   [("-4/7","-4/7 is the additive inverse, not the reciprocal; the reciprocal flips it to 7/4."),
    ("4/7","A number times its reciprocal is 1; 4/7 x 4/7 is not 1, so the reciprocal is 7/4."),
    ("1/4","You flip the whole fraction, not just keep the bottom; the reciprocal is 7/4.")]),

 ("RN","The value of 5/6 divided by 1/2 is:",
   "5/3",
   C("To divide by a fraction, multiply by its reciprocal.")+
   steps("Dividing by 1/2 means multiplying by 2/1","5/6 x 2/1 = 10/6","10/6 simplifies to 5/3.")+
   U("Asking how many 1/2-litre cups fill a 5/6-litre jug uses this same division."),
   [("5/12","Dividing by 1/2 makes the result larger, not smaller; 5/6 / (1/2) = 5/3."),
    ("1/2","1/2 is what you divided by, not the answer; the result is 5/3."),
    ("10/6","10/6 is correct in value but not in lowest form; it simplifies to 5/3.")]),

 ("RN","Between any two different rational numbers, how many other rational numbers can you find?",
   "infinitely many",
   C("No matter how close two rational numbers are, you can always squeeze another between them — so there are endless ones.")+
   steps("Take any two rational numbers","their average lies between them and is also rational","you can repeat this forever, so there are infinitely many.")+
   U("This is why a ruler can, in principle, be marked with ever-finer fractional lines."),
   [("none","You can always take the average of two rationals, so there is never none between them."),
    ("exactly one","Once you find one between them, you can find another between those — so it is endless."),
    ("exactly ten","The count is not fixed at ten; you can always fit in more, so it is infinitely many.")]),

 ("RN","If plasma makes up 11/20 of a sample of blood, then the blood cells (the rest) make up:",
   "9/20",
   C("The whole sample is 1, that is 20/20, so the cells are the whole minus the plasma part.")+
   steps("The whole is 20/20","subtract the plasma: 20/20 - 11/20","that leaves 9/20 for the cells.")+
   U("Doctors describe blood as roughly half plasma and half cells using fractions like these."),
   [("11/20","11/20 is the plasma share; the cells are the remaining part, 9/20."),
    ("31/20","You subtract from the whole, not add; the cells are 20/20 - 11/20 = 9/20."),
    ("1/20","Only 1/20 would be left if plasma were 19/20; here plasma is 11/20, leaving 9/20.")]),

 ("RN","The rational number lying exactly halfway between 0 and 1 is:",
   "1/2",
   C("The midpoint of two numbers is their average; halfway between 0 and 1 is 1/2.")+
   steps("Add the two numbers: 0 + 1 = 1","divide by 2 to find the midpoint","that gives 1/2.")+
   U("The middle mark between 0 and 1 on any ruler or scale sits at 1/2."),
   [("0","0 is one end of the gap, not the middle; the midpoint of 0 and 1 is 1/2."),
    ("1","1 is the other end of the gap, not the midpoint, which is 1/2."),
    ("2","2 lies beyond 1, outside the gap; the halfway point of 0 and 1 is 1/2.")]),

 ("RN","Written in its lowest terms, the rational number -6/10 is:",
   "-3/5",
   C("Divide the top and bottom by their common factor, keeping the negative sign.")+
   steps("6 and 10 share the factor 2","divide top and bottom by 2: -6/10 = -3/5","3 and 5 share no factor, so -3/5 is lowest form.")+
   U("Simplifying signed fractions like this keeps later calculations short and clear."),
   [("-6/10","-6/10 is right in value but not in lowest form; it simplifies to -3/5."),
    ("3/5","Dropping the negative sign changes the value; -6/10 equals -3/5, still negative."),
    ("-3/10","Only the top was halved here; both top and bottom divide by 2 to give -3/5.")]),

 ("RN","The mixed number 2 1/2 written as an improper fraction is:",
   "5/2",
   C("Multiply the whole number by the denominator, add the numerator, and keep the same denominator.")+
   steps("2 x 2 = 4 (whole times denominator)","add the numerator 1: 4 + 1 = 5","keep the denominator 2, giving 5/2.")+
   U("Recipes sometimes write 2 1/2 cups as 5/2 cups for easy multiplying."),
   [("2/2","2/2 equals 1, far less than 2 1/2; the correct improper fraction is 5/2."),
    ("3/2","3/2 is only 1 1/2, not 2 1/2; converting 2 1/2 gives 5/2."),
    ("4/2","4/2 equals 2, missing the extra half; 2 1/2 becomes 5/2.")]),

 ("RN","The product of any rational number and its reciprocal is always:",
   "1",
   C("A reciprocal is built to multiply with the original to give exactly 1.")+
   steps("Take a rational number like 3/5","its reciprocal is 5/3","3/5 x 5/3 = 15/15 = 1.")+
   U("This fact is what makes dividing by a fraction the same as multiplying by its reciprocal."),
   [("0","Multiplying by 0 gives 0, but a number times its reciprocal gives 1, not 0."),
    ("the number itself","Multiplying by 1 leaves a number unchanged; multiplying by its reciprocal gives 1."),
    ("its additive inverse","The additive inverse adds to give 0; a number times its reciprocal gives 1.")]),

 ("RN","The decimal 0.75 written as a rational number in lowest terms is:",
   "3/4",
   C("0.75 means 75 hundredths, which simplifies to a neat fraction.")+
   steps("0.75 = 75/100","both divide by 25: 75/100 = 3/4","3 and 4 share no factor, so 3/4 is lowest form.")+
   U("A price of Rs 0.75 of a rupee is the same as 3/4 of a rupee."),
   [("75/100","75/100 is right in value but not in lowest form; it simplifies to 3/4."),
    ("7/5","0.75 is less than 1, but 7/5 is more than 1; the correct value is 3/4."),
    ("3/5","3/5 is 0.6, not 0.75; the decimal 0.75 equals 3/4.")]),

 ("RN","The temperature falls from 2 degrees C to -3 degrees C. The change in temperature is:",
   "a drop of 5 degrees C",
   C("The change is the new reading minus the old, and falling from 2 to -3 is a 5-degree drop.")+
   steps("Change = final - initial = (-3) - 2","that equals -5","so the temperature dropped by 5 degrees C.")+
   U("A weather report saying the temperature fell 5 degrees overnight describes exactly this."),
   [("a drop of 1 degree C","From 2 down to -3 is five steps, not one; the drop is 5 degrees C."),
    ("a rise of 5 degrees C","The temperature went down, not up; it is a 5-degree drop, not a rise."),
    ("no change","2 and -3 are different readings, so there is a change — a 5-degree drop.")]),

 ("RN","The numbers -7/8 and 7/8 are equal in size but opposite in:",
   "sign",
   C("Both have the same size 7/8, but one is negative and one is positive — they differ only in sign.")+
   steps("Ignore the signs: both are 7/8 in size","one carries a minus, the other a plus","so they are equal in size, opposite in sign.")+
   U("Going 7/8 km east or 7/8 km west covers the same distance in opposite directions."),
   [("size","Their size is the same 7/8; it is the sign, not the size, that is opposite."),
    ("denominator","Both share the denominator 8; what differs between them is the sign."),
    ("numerator","Both share the numerator 7 in size; only their sign is opposite.")]),

 ("RN","To compare the rational numbers 2/3 and 3/4 fairly, the useful first step is to make their:",
   "denominators equal",
   C("Once two fractions share a common denominator, you can compare them just by looking at the tops.")+
   steps("2/3 and 3/4 have different bottoms","rewrite with a common denominator 12: 8/12 and 9/12","now compare tops: 9/12 is bigger, so 3/4 is greater.")+
   U("Comparing 2/3 of a pizza with 3/4 of an equal pizza needs this common-denominator trick."),
   [("numerators equal","Equal tops with different bottoms still cannot be compared directly; equalise the denominators."),
    ("signs opposite","Changing a sign changes the value; to compare you make the denominators equal."),
    ("both into whole numbers","These are proper fractions, not whole numbers; you give them a common denominator.")]),

 ("RN","Written in standard (lowest) form, the rational number 15/25 is:",
   "3/5",
   C("Divide the top and bottom by their largest common factor to reach the simplest equal fraction.")+
   steps("15 and 25 share the factor 5","divide top and bottom by 5: 15/25 = 3/5","3 and 5 share no factor, so 3/5 is lowest form.")+
   U("Writing scores or shares in lowest form, like 3/5, makes them quick to read."),
   [("15/25","15/25 is right in value but not in lowest form; it simplifies to 3/5."),
    ("5/3","5/3 is the flipped (reciprocal-like) fraction and is more than 1; 15/25 equals 3/5."),
    ("3/25","Only the top was divided here; both top and bottom divide by 5 to give 3/5.")]),

 ("RN","The number 0 is a rational number because it can be written in the form p/q as:",
   "0/1",
   C("Zero is rational: it equals 0 divided by any non-zero integer, for example 0/1.")+
   steps("A rational number is p/q with q not zero","0/1 has integer top 0 and non-zero bottom 1","so 0 = 0/1 is a rational number.")+
   U("Writing 0 as 0/1 lets you add and compare it with other fractions on the number line."),
   [("1/0","A fraction can never have 0 on the bottom; 1/0 is undefined, so it is not how we write 0."),
    ("0/0","0/0 is undefined because the denominator is 0; zero is written as 0/1 instead."),
    ("1/1","1/1 equals 1, not 0; zero as a rational number is written 0/1.")]),
]

# ---------- assemble: interleave so no two consecutive share a chapter ----------
assert all(len(b) == 25 for b in (WC, TR, DH, RN)), [len(WC), len(TR), len(DH), len(RN)]
items = []
for i in range(25):
    items += [WC[i], TR[i], DH[i], RN[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=40017,
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
    split = "/".join(str(counts[c]) for c in ("WC", "TR", "DH", "RN"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Weather, Climate & Adaptations",
                     "Transportation in Animals & Plants",
                     "Data Handling",
                     "Rational Numbers"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
