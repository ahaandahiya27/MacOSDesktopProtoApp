# -*- coding: utf-8 -*-
# Boss Challenge Paper 34 — Weather, Climate & Adaptations · Physical & Chemical Changes
#                            · Arithmetic Expressions · Rational Numbers
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans into FUSION. A weather thermometer reads a temperature; finding the
# day's RANGE is a subtraction (Arithmetic Expression), and a reading below zero is a Rational/negative
# number on a line. A mass that stays the same across a physical change is read off with brackets.
# The child meets a Science situation and reaches for a Maths skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_34_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_34_<SHORT>_QuestionPaper.pdf
#   Paper_34_<SHORT>_Questions.md
#   Paper_34_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "34"
SHORT = "Weather_PhysChem_ArithmeticExpr_RationalNumbers"
TITLE = ("Weather, Climate & Adaptations · Physical & Chemical Changes · "
         "Arithmetic Expressions · Rational Numbers")
LABELS = {
    "WC": "Weather, Climate & Adaptations",
    "PC": "Physical & Chemical Changes",
    "AE": "Arithmetic Expressions",
    "RN": "Rational Numbers",
}

# ---------- WEATHER, CLIMATE & ADAPTATIONS (25) — Science ----------
WC = [
 ("WC","The day-to-day state of the atmosphere at a place — its heat, rain and wind — is called the:",
   "weather",
   C("How hot, wet or windy a place is on a given day is its weather.")+
   steps("Look at a place on one particular day","note its temperature, rain and wind that day","this day-to-day condition is the weather."),
   [("climate","Climate is the average over many years, not the condition on a single day."),
    ("season","A season is a long part of the year; weather is the condition on a single day."),
    ("habitat","A habitat is where a living thing lives, not the day's atmospheric condition.")]),

 ("WC","The average pattern of the weather of a place taken over many years is called its:",
   "climate",
   C("The weather of a place averaged over a long stretch of years is its climate.")+
   steps("Collect the weather of a place for many years","find the usual, average pattern","this long-term average is the climate."),
   [("weather","Weather is just one day's condition; climate is the average over many years."),
    ("temperature","Temperature is a single measurement; climate is the whole long-term pattern."),
    ("forecast","A forecast predicts coming weather; climate is the long-term average already seen.")]),

 ("WC","The element of weather that a thermometer is used to measure is the:",
   "temperature",
   C("A thermometer reads how hot or cold the air is — that is the temperature.")+
   steps("Pick up a thermometer","it shows how hot or cold the air is","that hotness reading is the temperature."),
   [("rainfall","Rainfall is measured by a rain gauge, not a thermometer."),
    ("wind speed","Wind speed is measured by an anemometer, not a thermometer."),
    ("humidity","Humidity is measured with other instruments; a thermometer reads temperature.")]),

 ("WC","The chief source of energy that drives all the changes in the weather is the:",
   "Sun",
   C("Heat from the Sun warms land, sea and air unevenly, driving every change in the weather.")+
   steps("Something must supply energy for weather to change","the Sun pours heat onto the Earth","this solar heat drives all weather changes."),
   [("Moon","The Moon affects tides, but the Sun's heat is what drives the weather."),
    ("wind","Wind is itself caused by the Sun's uneven heating; it is not the source of energy."),
    ("ocean","Oceans store heat, but the original energy for weather comes from the Sun.")]),

 ("WC","The amount of water vapour, or moisture, present in the air is known as the:",
   "humidity",
   C("How much water vapour the air holds is called the humidity.")+
   steps("Air can hold invisible water vapour","measure how much moisture it holds","that moisture content is the humidity."),
   [("rainfall","Rainfall is water that has already fallen; humidity is vapour still in the air."),
    ("temperature","Temperature is how hot the air is, not how much vapour it holds."),
    ("pressure","Pressure is the push of the air; humidity is the moisture in it.")]),

 ("WC","The rain gauge is the instrument used to measure the amount of:",
   "rainfall",
   C("A rain gauge collects falling rain in a measured tube to record the rainfall.")+
   steps("Set out an open measuring tube","rain collects in it during a shower","reading the depth gives the rainfall."),
   [("sunshine","Sunshine hours are measured by other instruments, not a rain gauge."),
    ("wind direction","Wind direction is shown by a wind vane, not a rain gauge."),
    ("air temperature","Air temperature is read by a thermometer; a rain gauge measures rainfall.")]),

 ("WC","The polar bear is kept warm in its freezing home mainly by its thick fur and an inner layer of:",
   "fat (blubber)",
   C("Beneath its fur, a polar bear has a thick layer of fat called blubber that traps heat in.")+
   steps("Fur alone is not enough in the polar cold","under the skin lies a thick fat layer","this blubber keeps the bear's body heat in."),
   [("feathers","Bears do not have feathers; the polar bear is warmed by fur and fat."),
    ("scales","Scales belong to reptiles and fish, not to a warm-blooded polar bear."),
    ("sweat glands","Sweat would cool the bear; it stays warm through fur and a fat layer.")]),

 ("WC","A polar bear's white fur is useful in the snowy polar region because it helps the bear to:",
   "stay hidden (camouflage) against the snow",
   C("White fur blends with the white snow, hiding the bear from its prey — this is camouflage.")+
   steps("The polar land is covered in white snow","white fur matches that white background","so the bear is hidden — camouflaged — as it hunts."),
   [("look bigger to other bears","White fur is about blending in, not about looking bigger."),
    ("attract more sunlight for warmth","The fur's main snow-time use is hiding the bear, not gathering light."),
    ("frighten away the Sun","Fur cannot affect the Sun; white fur camouflages the bear in snow.")]),

 ("WC","To survive the bitter cold, penguins are often seen to:",
   "huddle closely together in large groups",
   C("Penguins crowd into tight groups so that, packed together, they share warmth and lose less heat.")+
   steps("A single penguin loses heat fast in the cold","many penguins pack tightly together","huddled as a group they keep one another warm."),
   [("spread far apart from one another","Spreading out would lose heat; penguins huddle CLOSE to stay warm."),
    ("dig deep burrows under the ice","Penguins huddle on the surface; they do not dig burrows under ice."),
    ("sleep through the whole winter","Penguins do not hibernate; they huddle together against the cold.")]),

 ("WC","The climate of the polar regions, such as the Arctic, can best be described as:",
   "very cold and ice-covered for most of the year",
   C("The poles are freezing and blanketed in snow and ice through most of the year.")+
   steps("The poles get only slanting, weak sunlight","so they stay extremely cold","ice and snow cover them most of the year."),
   [("hot and dry like a desert","Deserts are hot; the polar regions are bitterly cold and icy."),
    ("warm and rainy all year","Warm, rainy weather belongs to the tropics, not the frozen poles."),
    ("mild with four equal seasons","The poles are dominated by long cold, not four mild equal seasons.")]),

 ("WC","The climate of a tropical rainforest, such as near the equator, is best described as:",
   "hot and wet (humid) for most of the year",
   C("Tropical rainforests sit near the equator where it stays hot and very rainy nearly all year.")+
   steps("The equator gets strong, direct sunlight","so it is hot, and heavy rains fall often","the rainforest climate is hot and humid all year."),
   [("cold and snowy","Snow belongs to the poles or high mountains, not a tropical rainforest."),
    ("hot and very dry","Hot AND dry describes a desert; the rainforest is hot and WET."),
    ("cool and windy","The rainforest is hot and humid, not cool and windy.")]),

 ("WC","A special feature of a living thing that helps it survive in its surroundings is called an:",
   "adaptation",
   C("A body feature or habit that helps a living thing survive where it lives is an adaptation.")+
   steps("A living thing must cope with its surroundings","a helpful feature lets it survive there","that survival-helping feature is an adaptation."),
   [("invention","An invention is made by people; an adaptation is a natural survival feature."),
    ("imitation","Imitation is copying another; adaptation is a feature that aids survival."),
    ("decoration","A decoration is for show; an adaptation actually helps the animal survive.")]),

 ("WC","Some birds fly thousands of kilometres to warmer places to escape the harsh cold of winter. This is called:",
   "migration",
   C("The long seasonal journey birds make to escape harsh weather is called migration.")+
   steps("Harsh winter cold makes a place hard to live in","the birds fly off to warmer lands","this long seasonal journey is migration."),
   [("hibernation","Hibernation is a deep winter sleep in one place, not a long journey away."),
    ("camouflage","Camouflage is blending in to hide, not flying to a warmer place."),
    ("germination","Germination is a seed sprouting, nothing to do with birds escaping cold.")]),

 ("WC","The highest temperature reached during a day is called the day's:",
   "maximum temperature",
   C("The single hottest reading of the day is the day's maximum temperature.")+
   steps("Track the temperature through the day","note the very highest reading","that top reading is the maximum temperature."),
   [("minimum temperature","The minimum is the LOWEST reading, usually before dawn, not the highest."),
    ("average temperature","The average is the middle value; the highest reading is the maximum."),
    ("normal temperature","'Normal' is a long-term usual value; the day's highest reading is its maximum.")]),

 ("WC","The lowest temperature reached during a day, usually in the early morning, is the day's:",
   "minimum temperature",
   C("The single coldest reading of the day, often just before sunrise, is the minimum temperature.")+
   steps("Track the temperature through the day and night","note the very lowest reading, near dawn","that bottom reading is the minimum temperature."),
   [("maximum temperature","The maximum is the HIGHEST reading of the afternoon, not the lowest."),
    ("average temperature","The average is the middle value, not the day's lowest reading."),
    ("boiling temperature","Boiling point is fixed for a liquid; this is the day's lowest air reading.")]),

 ("WC","The polar bear's broad, large paws are useful because they help it to:",
   "walk on snow and swim without sinking",
   C("Wide paws spread the bear's weight so it does not sink in soft snow, and act like paddles for swimming.")+
   steps("Soft snow and cold water are hard to cross","broad paws spread weight and push water","so the bear walks on snow and swims well."),
   [("dig deep tunnels for shelter","The broad paws are for walking on snow and swimming, not tunnelling."),
    ("climb tall forest trees","Polar bears live on ice, not in tall forests; the paws suit snow and water."),
    ("fly short distances","Bears cannot fly; their wide paws help them walk on snow and swim.")]),

 ("WC","A penguin's smooth, streamlined body shape is an adaptation that mainly helps it to:",
   "move easily and fast through water",
   C("A streamlined body slips through water with little resistance, helping the penguin swim fast.")+
   steps("Water resists a bulky shape","a smooth, tapered body cuts through it","so the streamlined penguin swims swiftly."),
   [("stay warm on land","Warmth comes from fat and feathers; the streamlined shape is for swimming."),
    ("dig in the ice","A streamlined body is for swimming, not for digging into ice."),
    ("fly high above the sea","Penguins cannot fly; the streamlined shape helps them swim, not fly.")]),

 ("WC","Compared with the weather, the climate of a place is something that:",
   "stays much the same over many years",
   C("Weather can change hour to hour, but climate is the steady long-term average over years.")+
   steps("Weather may swing from sunny to rainy in a day","climate is the average across many years","so climate stays much the same over a long time."),
   [("changes from hour to hour","Hour-to-hour swings are weather; climate is the long-term steady average."),
    ("changes every single minute","Minute-by-minute change is weather, not the long-term climate."),
    ("never existed before today","Climate is built from many past years of weather, not just today.")]),

 ("WC","On a humid day our sweat dries slowly and we feel sticky because the air already holds:",
   "a lot of water vapour",
   C("When the air is full of moisture, sweat cannot evaporate quickly, so we feel hot and sticky.")+
   steps("Sweat cools us by evaporating into the air","but humid air is already full of vapour","so sweat evaporates slowly and we feel sticky."),
   [("very little moisture","Dry air dries sweat fast; the sticky feeling comes from MUCH moisture in the air."),
    ("no oxygen at all","Humid air still has oxygen; the sticky feeling is from its high moisture."),
    ("too much dust","Dust does not slow sweating; high humidity does, by filling the air with vapour.")]),

 ("WC","Large herds of elephants, big cats and many colourful birds are found together mainly in the:",
   "tropical rainforest",
   C("The warm, wet rainforest offers plenty of food and shelter, so a huge variety of animals live there.")+
   steps("Animals gather where food and warmth are plentiful","the hot, wet rainforest is rich in both","so it teems with elephants, big cats and birds."),
   [("frozen polar region","Few species survive the freezing poles; the rich variety is in the rainforest."),
    ("dry sandy desert","Deserts support far fewer animals; the rainforest brims with life."),
    ("high snowy mountain top","Bare snowy peaks hold little life; the rainforest is packed with species.")]),

 ("WC","A maximum–minimum thermometer is specially useful because in one reading it shows the:",
   "highest and lowest temperatures of the day",
   C("This thermometer records both the day's top and bottom temperatures so both can be read at once.")+
   steps("Temperature rises and falls through the day","this thermometer remembers the extremes","so it shows the day's highest AND lowest in one look."),
   [("rainfall and wind speed","A thermometer reads temperature only, not rainfall or wind."),
    ("humidity of the air","Humidity needs a different instrument; this thermometer reads temperatures."),
    ("air pressure changes","Air pressure is read by a barometer, not by this thermometer.")]),

 ("WC","A thermometer in the morning reads 24 °C and by afternoon it reads 36 °C. The day's temperature RANGE is:",
   "12 °C",
   C("The range is the highest minus the lowest: 36 °C − 24 °C = 12 °C — a weather reading solved by subtraction.")+
   steps("Range = highest reading − lowest reading","put in 36 °C − 24 °C","36 − 24 = 12, so the range is 12 °C."),
   [("60 °C","60 adds the two readings; range is the highest MINUS the lowest, giving 12 °C."),
    ("36 °C","36 °C is the afternoon high alone; the range is 36 − 24 = 12 °C."),
    ("24 °C","24 °C is the morning low alone; the range is 36 − 24 = 12 °C.")]),

 ("WC","Deep in a tropical rainforest the ground stays dim because the tall treetops form a thick:",
   "canopy that blocks most sunlight",
   C("The crowns of the tall trees lock together into a canopy that stops most light reaching the floor.")+
   steps("Rainforest trees grow very tall and close","their leafy crowns overlap into a roof","this canopy blocks most light, so the floor is dim."),
   [("layer of ice over the soil","Rainforests are hot; there is no ice — the dimness is from the leafy canopy."),
    ("cloud of sand in the air","Sand clouds belong to deserts; the rainforest floor is shaded by a leaf canopy."),
    ("sheet of snow on the branches","Snow does not fall in the hot rainforest; the canopy of leaves blocks the light.")]),

 ("WC","An elephant's large flapping ears are an adaptation that mainly help it to:",
   "lose extra body heat and stay cool",
   C("Big thin ears have many blood vessels; flapping them lets the elephant give off heat and cool down.")+
   steps("A large body builds up much heat","big thin ears carry lots of warm blood","flapping them sheds heat, cooling the elephant."),
   [("hear sounds from underground","The large ears mainly help cool the elephant, not hear underground."),
    ("store water for the dry season","Water is stored in the body, not the ears; the ears help shed heat."),
    ("frighten away the rain","Ears cannot affect the rain; their main job is cooling the elephant.")]),

 ("WC","The simple instrument that swings round on a roof to show which way the wind is blowing is a:",
   "wind vane",
   C("A wind vane turns freely and points to the direction from which the wind comes.")+
   steps("The wind pushes against a light, turning arrow","the arrow swings until it points into the wind","reading where it points gives the wind's direction — a wind vane."),
   [("rain gauge","A rain gauge measures how much rain falls, not the wind's direction."),
    ("thermometer","A thermometer reads temperature, not which way the wind blows."),
    ("barometer","A barometer measures air pressure, not the wind's direction.")]),
]

WC_UC = [
 "Telling weather from a single day is how you decide whether to carry an umbrella this morning.",
 "Knowing climate is a long average is how geographers describe a region without checking each day.",
 "Reading a thermometer for temperature is the first measurement in every weather report.",
 "Knowing the Sun drives weather explains why days warm up and winds rise after sunrise.",
 "Understanding humidity is why a muggy day feels hotter than a dry day at the same temperature.",
 "Using a rain gauge is how a farmer records exactly how much rain a field received.",
 "Knowing blubber warms a polar bear explains how it survives where water would freeze you solid.",
 "Understanding white-fur camouflage is how you grasp why Arctic animals are so often white.",
 "Knowing penguins huddle explains the slow shuffle of an emperor-penguin colony in a blizzard.",
 "Picturing the polar climate is how you understand why so few animals can live at the poles.",
 "Picturing the rainforest climate explains why it shelters more kinds of life than anywhere else.",
 "Spotting an adaptation is how a naturalist explains why an animal fits its home so neatly.",
 "Understanding migration is why the same birds vanish each autumn and return every spring.",
 "Reading the day's maximum is how a weather bulletin tells you the hottest part of the day.",
 "Reading the day's minimum is how you know how cold it dipped just before you woke.",
 "Knowing wide paws spread weight is how you understand a polar bear crossing thin snow safely.",
 "Understanding a streamlined body is how you see why a penguin out-swims most fish-eaters.",
 "Knowing climate stays steady is why builders plan houses for a region's long-term weather.",
 "Knowing humid air slows sweating is the reason a sticky day feels so uncomfortable.",
 "Knowing the rainforest is crowded with life is why it is the focus of so much conservation.",
 "Reading a max–min thermometer is how a gardener checks both extremes a plant faced overnight.",
 "Working a temperature range by subtraction is how forecasters report how much it warmed up.",
 "Understanding the canopy explains why the rainforest floor is shady even at midday.",
 "Knowing big ears shed heat is how you understand an elephant flapping them on a hot day.",
 "Reading a wind vane is how a sailor or pilot judges the wind before setting off.",
]

# ---------- PHYSICAL & CHEMICAL CHANGES (25) — Science ----------
PC = [
 ("PC","When something changes but not a single new substance is formed, the change is called a:",
   "physical change",
   C("If nothing new is made and only the form, size or state alters, it is a physical change.")+
   steps("Check whether a brand-new substance appears","here only shape, size or state changes","with nothing new formed, it is a physical change."),
   [("chemical change","A chemical change DOES make a new substance; here none is formed."),
    ("nuclear change","A nuclear change alters the atom's core; this is just a change of form."),
    ("permanent change","Not every physical change is permanent; the key point is no new substance forms.")]),

 ("PC","A change in which a brand-new substance with new properties is formed is called a:",
   "chemical change",
   C("When a new substance with different properties appears, the change is a chemical change.")+
   steps("Check whether something new is made","here a substance with new properties appears","forming a new substance means a chemical change."),
   [("physical change","A physical change makes NO new substance; here a new one appears."),
    ("reversible change","Many chemical changes are hard to reverse; the key point is a new substance forms."),
    ("temporary change","A new substance forming marks a chemical change, whether or not it lasts.")]),

 ("PC","The melting of a block of ice into water is an example of a:",
   "physical change",
   C("Ice melting only changes water from solid to liquid; it is still water, so it is physical.")+
   steps("Ice and water are both just water","only the state changes, solid to liquid","no new substance forms, so it is physical."),
   [("chemical change","No new substance is made — it is still water — so this is physical, not chemical."),
    ("irreversible change","Melting can be reversed by freezing, and no new substance forms — it is physical."),
    ("burning change","Nothing burns when ice melts; it is simply a change of state, a physical change.")]),

 ("PC","The burning of a piece of paper or wood is an example of a:",
   "chemical change",
   C("Burning turns paper into ash, smoke and gases — new substances — so it is a chemical change.")+
   steps("Set the paper alight","it turns into ash, smoke and gas","these new substances mean a chemical change."),
   [("physical change","Burning makes new substances (ash, gases), so it is chemical, not physical."),
    ("reversible change","You cannot turn the ash and smoke back into paper; burning is chemical."),
    ("change of state only","Burning is not a mere melting or boiling; new substances form, so it is chemical.")]),

 ("PC","For an iron object to rust, both of these must be present together:",
   "air (oxygen) and water (moisture)",
   C("Iron rusts only when it meets both oxygen from the air and moisture; remove either and rusting stops.")+
   steps("Iron alone in dry sealed air does not rust","add both damp and air to the iron","together they let it rust — both are needed."),
   [("only dry air, with no water","Dry air alone will not rust iron; moisture must also be present."),
    ("only oil, with no air","Oil actually keeps air and water OUT and prevents rust."),
    ("strong sunlight and shade","Light has little to do with rusting; air and moisture are what is needed.")]),

 ("PC","The reddish-brown flaky substance that forms on damp iron is called:",
   "rust",
   C("Damp iron reacts with oxygen to form a reddish-brown coating called rust.")+
   steps("Leave iron in damp air","it slowly reacts with oxygen","a reddish-brown layer — rust — forms."),
   [("ash","Ash is the powder left after burning, not the coating on damp iron."),
    ("curd","Curd comes from souring milk, nothing to do with iron and air."),
    ("chalk","Chalk is a white rock; rust is the reddish-brown coating on damp iron.")]),

 ("PC","Coating an iron object with a layer of zinc to stop it rusting is called:",
   "galvanisation",
   C("Covering iron with a protective zinc layer to keep rust away is called galvanisation.")+
   steps("Bare iron rusts in damp air","cover it with a layer of zinc","this zinc-coating method is galvanisation."),
   [("crystallisation","Crystallisation grows pure crystals; coating iron with zinc is galvanisation."),
    ("evaporation","Evaporation turns liquid to vapour; it has nothing to do with a zinc coat."),
    ("condensation","Condensation turns vapour to liquid; the zinc-coating method is galvanisation.")]),

 ("PC","Painting or oiling an iron gate helps prevent rust because the layer:",
   "keeps air and moisture away from the iron",
   C("A coat of paint or oil seals the iron off from the air and water it needs to rust.")+
   steps("Iron needs air and moisture to rust","paint or oil forms a sealing layer","that layer blocks air and water, so rust cannot form."),
   [("makes the iron heavier","Extra weight does not stop rust; the coat works by blocking air and moisture."),
    ("turns the iron into zinc","Paint cannot change iron into zinc; it simply seals out air and water."),
    ("cools the iron down","Cooling does not stop rust; the coat blocks the air and moisture that cause it.")]),

 ("PC","The process used to obtain large, pure crystals of a substance from its solution is called:",
   "crystallisation",
   C("Letting a solution slowly form pure, well-shaped crystals is called crystallisation.")+
   steps("Dissolve the substance and let the solution stand","as it slowly evaporates, crystals grow","this crystal-forming process is crystallisation."),
   [("galvanisation","Galvanisation coats iron with zinc; it does not grow crystals."),
    ("filtration","Filtration separates solids from a liquid; it does not grow pure crystals."),
    ("rusting","Rusting is iron decaying in damp air, not a way to grow crystals.")]),

 ("PC","Dissolving a spoon of sugar in a glass of water is an example of a:",
   "physical change",
   C("The sugar only spreads through the water and can be recovered by evaporating it, so it is physical.")+
   steps("Stir sugar into water until it vanishes","it is still sugar, just spread out","you can get it back, so the change is physical."),
   [("chemical change","No new substance forms — it is still sugar — so it is physical, not chemical."),
    ("irreversible change","Evaporating the water brings the sugar back, so the change is reversible and physical."),
    ("burning change","Nothing burns; the sugar simply dissolves, which is a physical change.")]),

 ("PC","The cooking of raw food, such as baking a cake from batter, is an example of a:",
   "chemical change",
   C("Cooking turns the raw ingredients into new substances that cannot be changed back, so it is chemical.")+
   steps("Heat the raw batter","it turns into a cake with new taste and texture","these new substances mean a chemical change."),
   [("physical change","Cooking makes new substances you cannot undo, so it is chemical, not physical."),
    ("reversible change","You cannot turn a baked cake back into raw batter; the change is chemical."),
    ("change of state only","Cooking is more than melting or boiling; new substances form, so it is chemical.")]),

 ("PC","The souring of milk to form curd (dahi) is an example of a:",
   "chemical change",
   C("Milk turning into curd makes a new substance with a new taste that cannot be turned back — a chemical change.")+
   steps("Leave warm milk with a little curd","it sets into curd with a sour taste","this new, unchangeable substance means a chemical change."),
   [("physical change","Curd is a new substance you cannot turn back into milk, so it is chemical."),
    ("reversible change","You cannot change curd back into fresh milk; the change is chemical."),
    ("change of state only","This is not mere freezing or melting; a new substance forms, so it is chemical.")]),

 ("PC","When a strip of magnesium ribbon is burnt in air, it gives a white powder. This shows a:",
   "chemical change",
   C("Burning magnesium makes a brand-new white powder, magnesium oxide, so it is a chemical change.")+
   steps("Light the magnesium ribbon","it burns with a bright flame to a white powder","this new substance, magnesium oxide, means a chemical change."),
   [("physical change","A new white powder forms, so it is a chemical, not a physical, change."),
    ("change of state only","The ribbon does not merely melt; it forms a new substance — a chemical change."),
    ("reversible change","You cannot turn the white ash back into magnesium ribbon; the change is chemical.")]),

 ("PC","The white powder formed when magnesium burns is dissolved in water. The solution turns out to be:",
   "basic (turns red litmus blue)",
   C("Magnesium oxide dissolves to give magnesium hydroxide, a basic solution that turns red litmus blue.")+
   steps("Dissolve the white magnesium-oxide powder in water","it forms magnesium hydroxide","this is basic, so it turns red litmus blue."),
   [("acidic (turns blue litmus red)","The magnesium-oxide solution is basic, not acidic, so it turns RED litmus blue."),
    ("neutral like pure water","It is not neutral; the magnesium-oxide solution is basic and turns red litmus blue."),
    ("salty like sea water","Saltiness is not the point; the solution is basic and turns red litmus blue.")]),

 ("PC","Tearing a sheet of paper into small pieces is an example of a:",
   "physical change",
   C("Torn paper is still paper — only its size and shape change — so the change is physical.")+
   steps("Tear the paper into bits","each bit is still paper","only the size changed, so it is a physical change."),
   [("chemical change","No new substance forms; the bits are still paper, so it is physical."),
    ("irreversible chemical change","Tearing makes nothing new; it is a simple physical change."),
    ("burning change","Nothing burns when paper is torn; it is just a physical change of size.")]),

 ("PC","Most physical changes are easy to REVERSE, as shown by the way that:",
   "water can be frozen to ice and the ice melted back to water",
   C("Freezing and melting swap water between ice and liquid with no new substance, so the change reverses easily.")+
   steps("Freeze water and it becomes ice","melt the ice and it becomes water again","this easy back-and-forth shows a reversible physical change."),
   [("burnt wood can be turned back into fresh wood","Burning is a chemical change and cannot be reversed like this."),
    ("curd can be turned back into fresh milk","Souring is a chemical change; curd cannot become milk again."),
    ("rust can be turned back into shiny iron just by drying","Rusting is a chemical change and is not reversed by drying.")]),

 ("PC","When carbon dioxide gas is passed through clear lime water, the lime water turns:",
   "milky (cloudy white)",
   C("Carbon dioxide reacts with lime water to make a white solid, turning the clear liquid milky.")+
   steps("Bubble carbon dioxide through clear lime water","a white solid forms in it","so the lime water turns milky — a chemical change."),
   [("bright red","Lime water turns MILKY white with carbon dioxide, not red."),
    ("deep blue","Carbon dioxide turns lime water milky white, not blue."),
    ("completely colourless and clear","It does the opposite — clear lime water turns cloudy, milky white.")]),

 ("PC","A useful clue that a CHEMICAL change has taken place is when, during the change, there is:",
   "the giving off of a gas, heat, light or a new colour",
   C("Bubbles of gas, heat or light, or a fresh colour are signs that a new substance has formed.")+
   steps("Watch the change closely","look for gas, heat, light or a new colour","such signs point to a new substance — a chemical change."),
   [("only a change in the shape of the object","A mere shape change with no new substance is a physical change."),
    ("only the object getting wet","Getting wet alone is physical; chemical change shows gas, heat or new colour."),
    ("only the object being moved to a new place","Moving an object changes nothing chemically; it stays the same substance.")]),

 ("PC","Inside green leaves, plants combine carbon dioxide and water in sunlight to make food. This process is a:",
   "chemical change",
   C("Photosynthesis builds new substances — food (glucose) and oxygen — so it is a chemical change.")+
   steps("Leaves take in carbon dioxide and water","in sunlight they build glucose and oxygen","these new substances mean a chemical change."),
   [("physical change","New substances (food and oxygen) are made, so it is chemical, not physical."),
    ("change of state only","Photosynthesis is not a mere melting or boiling; new substances form."),
    ("reversible change like melting","Photosynthesis builds new substances and is not reversed like melting ice.")]),

 ("PC","Rusting is considered harmful mainly because, over time, it:",
   "weakens iron objects and slowly eats them away",
   C("Rust flakes off and eats into the iron, making bridges, gates and tools weak and unsafe.")+
   steps("Damp air slowly rusts iron","the rust flakes and eats into the metal","so the iron object weakens and may break."),
   [("makes iron shinier and stronger","Rust does the opposite — it dulls and WEAKENS the iron."),
    ("turns iron into pure gold","Rusting cannot make gold; it slowly destroys the iron."),
    ("cools the iron so it lasts longer","Rust harms iron; it does not cool or preserve it.")]),

 ("PC","Stainless steel cutlery does not rust easily because it is a special mixture of metals, that is, an:",
   "alloy made to resist rusting",
   C("Stainless steel is an alloy blended so that it resists the rusting that plain iron suffers.")+
   steps("Plain iron rusts in damp air","stainless steel mixes iron with other metals","this rust-resisting alloy does not rust easily."),
   [("alloy that rusts faster than iron","Stainless steel resists rust; it does not rust faster than plain iron."),
    ("pure single metal like plain iron","Stainless steel is a MIXTURE of metals, not a single pure metal."),
    ("type of plastic, not a metal","Stainless steel is a metal alloy, not a plastic.")]),

 ("PC","The boiling of water in a kettle, turning it into steam, is an example of a:",
   "physical change",
   C("Boiling only changes water from liquid to gas; it is still water, so the change is physical.")+
   steps("Heat the water until it boils","it turns to steam, but it is still water","no new substance forms, so it is physical."),
   [("chemical change","No new substance is made — steam is still water — so it is physical."),
    ("irreversible change","Cooling the steam turns it back to water, so the change is reversible and physical."),
    ("burning change","The water does not burn; it merely changes state, a physical change.")]),

 ("PC","Iron nails were kept in three test-tubes: dry air only, boiled water with no air, and ordinary damp air. The nails that rust are those in:",
   "ordinary damp air, where both air and moisture are present",
   C("Only the nails with both air and moisture rust; remove either, and rusting does not happen.")+
   steps("Rusting needs both air and moisture","dry-air and air-free tubes lack one of these","only the damp-air tube has both, so only its nails rust."),
   [("the dry air only, with no moisture","Dry air lacks moisture, so those nails do not rust."),
    ("the boiled water with no air","Boiled water has no dissolved air, so those nails do not rust."),
    ("all three test-tubes equally","Two tubes each lack one needed thing, so only the damp-air nails rust.")]),

 ("PC","A burnt matchstick cannot be made to look new and unburnt again. This tells us that burning is:",
   "an irreversible (chemical) change",
   C("Burning makes new substances that cannot be turned back, so it is an irreversible chemical change.")+
   steps("Strike and burn the matchstick","it becomes ash and charred wood","these cannot become a fresh match, so burning is irreversible."),
   [("a reversible physical change","Burning cannot be reversed and makes new substances; it is not physical or reversible."),
    ("the same as melting wax","Melting wax can be reset by cooling; burning makes new substances and cannot be undone."),
    ("a change with no new substance","Burning DOES make new substances, which is why it cannot be reversed.")]),

 ("PC","As a candle burns, the wax near the flame melts and then the wax vapour burns. This shows that a candle burning involves:",
   "both a physical change (melting) and a chemical change (burning)",
   C("Melting wax is physical (still wax), but the wax burning to give new gases and light is chemical — both happen together.")+
   steps("The wax near the flame melts — still wax, so physical","the wax vapour then burns to new gases and light — chemical","so a burning candle shows both kinds of change."),
   [("only a physical change, nothing more","Melting is physical, but the flame also burns wax — a chemical change — so both occur."),
    ("only a chemical change, nothing more","Burning is chemical, but the wax also melts — a physical change — so both occur."),
    ("no change of any kind at all","A burning candle clearly changes; it shows both a physical and a chemical change.")]),
]

PC_UC = [
 "Spotting a physical change is how you know dissolved sugar can still be recovered from water.",
 "Spotting a chemical change is how you know a burnt or cooked thing cannot be turned back.",
 "Knowing melting is physical is why an ice cube and its puddle are still the very same water.",
 "Knowing burning is chemical is why a fire's ash can never be re-made into firewood.",
 "Knowing rust needs air and water is why tools kept dry and oiled stay shiny for years.",
 "Recognising rust is how you spot which iron parts of a gate or cycle are being eaten away.",
 "Knowing galvanisation is why zinc-coated roofing sheets last for years in the rain.",
 "Knowing paint blocks air and water is why a freshly painted railing resists rust so well.",
 "Knowing crystallisation is how sea-salt and pure sugar crystals are grown on a large scale.",
 "Knowing dissolving is physical is why stirred salt water can give the salt back on drying.",
 "Knowing cooking is chemical is why a baked cake can never be turned back into raw batter.",
 "Knowing curd-setting is chemical is why dahi, once set, can never become plain milk again.",
 "Watching magnesium burn is a classic class experiment that shows a clear chemical change.",
 "Testing the white ash with litmus is how you learn that a metal oxide can be a base.",
 "Knowing tearing is physical is why scraps of paper are still just paper to recycle.",
 "Knowing freezing reverses melting is why an ice tray works again and again with the same water.",
 "The lime-water test is how a lab proves that a gas given off is carbon dioxide.",
 "Watching for gas, heat or colour is how a chemist decides a real reaction has happened.",
 "Knowing photosynthesis is chemical is how you grasp that plants build new food from air and water.",
 "Knowing rust weakens iron is why old bridges and gates must be checked and repainted.",
 "Knowing stainless steel is a rust-resisting alloy is why kitchen knives stay bright for years.",
 "Knowing boiling is physical is why steam from a kettle can cool back into ordinary water.",
 "The three-test-tube experiment is how a class proves rust needs BOTH air and moisture.",
 "Knowing burning cannot be undone is why a used matchstick is simply thrown away.",
 "Watching a candle is how you see a physical and a chemical change happening side by side.",
]

# ---------- ARITHMETIC EXPRESSIONS (25) — Maths ----------
AE = [
 ("AE","In the arithmetic expression 7 + 4 + 9, the numbers 7, 4 and 9 are each called a:",
   "term",
   C("The numbers joined by + and − signs in an expression are its terms.")+
   steps("Look at the parts split by the + and − signs","each separate part is one piece of the expression","each such piece is called a term."),
   [("factor","Factors are numbers MULTIPLIED together; terms are parts joined by + or −."),
    ("product","A product is the result of multiplying; the parts here are terms."),
    ("sum","The sum is the final total; the parts being added are the terms.")]),

 ("AE","Following the correct order, the value of the expression 2 + 3 × 4 is:",
   "14",
   C("Multiplication is done before addition: 3 × 4 = 12, then 2 + 12 = 14.")+
   steps("Do the multiplication first: 3 × 4 = 12","now add the 2: 2 + 12","2 + 12 = 14, so the value is 14."),
   [("20","20 adds first (2 + 3 = 5) then ×4; but multiplication comes first, giving 14."),
    ("24","24 multiplies everything; only 3 × 4 is multiplied first, then add 2, giving 14."),
    ("9","9 ignores the ×4 as a multiply; doing 3 × 4 first then +2 gives 14.")]),

 ("AE","With the bracket worked out first, the value of the expression (2 + 3) × 4 is:",
   "20",
   C("The bracket is worked first: 2 + 3 = 5, then 5 × 4 = 20.")+
   steps("Work inside the bracket first: 2 + 3 = 5","now multiply by 4: 5 × 4","5 × 4 = 20, so the value is 20."),
   [("14","14 multiplies before the bracket; brackets come FIRST, giving 5 × 4 = 20."),
    ("24","24 is 2 + (3 × 4) wrongly; the bracket here is (2 + 3), giving 5 × 4 = 20."),
    ("9","9 forgets the × 4 altogether; 5 × 4 = 20.")]),

 ("AE","In any expression that mixes brackets and other operations, the part you must work out first is:",
   "whatever is inside the brackets",
   C("Brackets always come first: you finish the work inside them before anything else.")+
   steps("Scan the expression for brackets","clear the work inside the brackets first","then carry on with the rest of the expression."),
   [("the addition, always before brackets","Brackets come BEFORE addition, not after it."),
    ("the left-most number, whatever it is","Position does not decide order; brackets are worked first."),
    ("the largest number in the expression","Size does not decide order; the brackets are worked first.")]),

 ("AE","Following the correct order, the value of the expression 10 − 2 × 3 is:",
   "4",
   C("Multiply before subtracting: 2 × 3 = 6, then 10 − 6 = 4.")+
   steps("Do the multiplication first: 2 × 3 = 6","now subtract from 10: 10 − 6","10 − 6 = 4, so the value is 4."),
   [("24","24 subtracts first (10 − 2 = 8) then ×3; multiplication comes first, giving 4."),
    ("30","30 multiplies everything; only 2 × 3 is multiplied first, giving 10 − 6 = 4."),
    ("11","11 has no basis; 2 × 3 = 6 then 10 − 6 = 4.")]),

 ("AE","Following the correct order, the value of the expression 5 × 2 + 3 is:",
   "13",
   C("Multiply before adding: 5 × 2 = 10, then 10 + 3 = 13.")+
   steps("Do the multiplication first: 5 × 2 = 10","now add the 3: 10 + 3","10 + 3 = 13, so the value is 13."),
   [("25","25 adds first (2 + 3 = 5) then ×5; multiplication comes first, giving 13."),
    ("30","30 multiplies everything; only 5 × 2 is done first, then +3, giving 13."),
    ("10","10 forgets to add the 3; 5 × 2 + 3 = 13.")]),

 ("AE","Adding zero to a number, as in the expression 8 + 0, always gives:",
   "the same number, 8",
   C("Zero is the additive identity: adding 0 changes nothing, so 8 + 0 = 8.")+
   steps("Start with 8","add nothing — that is, add 0","the value is unchanged: 8 + 0 = 8."),
   [("0","Adding 0 does not wipe the number out; 8 + 0 = 8, not 0."),
    ("80","Adding 0 is not the same as writing a 0 beside it; 8 + 0 = 8, not 80."),
    ("16","Adding 0 does not double the number; 8 + 0 = 8, not 16.")]),

 ("AE","Following the correct order, the value of the expression 6 + (4 − 1) is:",
   "9",
   C("Work the bracket first: 4 − 1 = 3, then 6 + 3 = 9.")+
   steps("Clear the bracket first: 4 − 1 = 3","now add the 6: 6 + 3","6 + 3 = 9, so the value is 9."),
   [("3","3 forgets to add the 6; after 4 − 1 = 3 you still add 6, giving 9."),
    ("11","11 adds inside the bracket (4 + 1) instead of subtracting; 6 + 3 = 9."),
    ("1","1 mixes up the numbers; 6 + (4 − 1) = 6 + 3 = 9.")]),

 ("AE","With the bracket worked out first, the value of the expression 6 − (4 − 1) is:",
   "3",
   C("Work the bracket first: 4 − 1 = 3, then 6 − 3 = 3.")+
   steps("Clear the bracket first: 4 − 1 = 3","now subtract from 6: 6 − 3","6 − 3 = 3, so the value is 3."),
   [("9","9 adds instead of subtracting; 6 − (4 − 1) = 6 − 3 = 3."),
    ("1","1 drops the bracket wrongly as 6 − 4 − 1; the bracket gives 6 − 3 = 3."),
    ("11","11 adds everything; the correct working is 6 − 3 = 3.")]),

 ("AE","Using the distributive rule, the value of the expression 4 × (10 + 2) is:",
   "48",
   C("4 × (10 + 2) = 4 × 10 + 4 × 2 = 40 + 8 = 48, the same as 4 × 12.")+
   steps("Add inside the bracket: 10 + 2 = 12","multiply: 4 × 12","4 × 12 = 48, so the value is 48."),
   [("42","42 multiplies only the 10 and forgets the 2; 4 × 12 = 48."),
    ("16","16 adds 4 + 10 + 2; the expression is 4 × 12 = 48."),
    ("24","24 multiplies 4 × (10 − 2) wrongly; with + inside it is 4 × 12 = 48.")]),

 ("AE","Removing the bracket, the expression 20 − (5 + 3) has the value:",
   "12",
   C("20 − (5 + 3) = 20 − 8 = 12; the minus sign applies to the whole bracket.")+
   steps("Add inside the bracket: 5 + 3 = 8","subtract from 20: 20 − 8","20 − 8 = 12, so the value is 12."),
   [("18","18 subtracts only the 5 and forgets the 3; 20 − 8 = 12."),
    ("22","22 subtracts 5 then ADDS 3; the whole bracket is subtracted, giving 12."),
    ("28","28 adds the bracket instead of subtracting; 20 − 8 = 12.")]),

 ("AE","Comparing the two expressions 3 + 4 and 3 × 4, the one with the GREATER value is:",
   "3 × 4, which equals 12",
   C("3 + 4 = 7 but 3 × 4 = 12, so the product 3 × 4 is greater.")+
   steps("Work out 3 + 4 = 7","work out 3 × 4 = 12","12 is bigger than 7, so 3 × 4 is greater."),
   [("3 + 4, which equals 12","3 + 4 is 7, not 12; the greater one is 3 × 4 = 12."),
    ("they are exactly equal","7 and 12 are not equal; 3 × 4 = 12 is the greater."),
    ("3 + 4, which equals 7 and is bigger","7 is smaller than 12, so 3 × 4 is the bigger value.")]),

 ("AE","Following the correct order, the value of the expression 12 ÷ 3 + 1 is:",
   "5",
   C("Divide before adding: 12 ÷ 3 = 4, then 4 + 1 = 5.")+
   steps("Do the division first: 12 ÷ 3 = 4","now add the 1: 4 + 1","4 + 1 = 5, so the value is 5."),
   [("3","3 adds first (3 + 1 = 4) then divides; division comes first, giving 5."),
    ("4","4 forgets to add the 1; 12 ÷ 3 + 1 = 5."),
    ("13","13 adds 12 and 1 first; division comes first, giving 4 + 1 = 5.")]),

 ("AE","Following the correct order, the value of the expression 2 × (5 + 5) is:",
   "20",
   C("Work the bracket first: 5 + 5 = 10, then 2 × 10 = 20.")+
   steps("Clear the bracket: 5 + 5 = 10","multiply by 2: 2 × 10","2 × 10 = 20, so the value is 20."),
   [("15","15 multiplies only the first 5; 2 × 10 = 20."),
    ("12","12 adds 2 + 5 + 5; the expression is 2 × 10 = 20."),
    ("17","17 mixes adding and multiplying; 2 × (5 + 5) = 20.")]),

 ("AE","Following the correct order, the value of the expression 100 − 10 × 5 is:",
   "50",
   C("Multiply before subtracting: 10 × 5 = 50, then 100 − 50 = 50.")+
   steps("Do the multiplication first: 10 × 5 = 50","subtract from 100: 100 − 50","100 − 50 = 50, so the value is 50."),
   [("450","450 subtracts first (100 − 10 = 90) then ×5; multiply first, giving 50."),
    ("550","550 has no basis; 10 × 5 = 50 then 100 − 50 = 50."),
    ("85","85 mixes the numbers; the correct value is 100 − 50 = 50.")]),

 ("AE","Following the correct order, the value of the expression 3 × 3 + 3 is:",
   "12",
   C("Multiply before adding: 3 × 3 = 9, then 9 + 3 = 12.")+
   steps("Do the multiplication first: 3 × 3 = 9","add the last 3: 9 + 3","9 + 3 = 12, so the value is 12."),
   [("18","18 adds first (3 + 3 = 6) then ×3; multiplication comes first, giving 12."),
    ("27","27 multiplies all three 3s; only 3 × 3 is done first, then +3, giving 12."),
    ("9","9 forgets to add the last 3; 3 × 3 + 3 = 12.")]),

 ("AE","Following the correct order, the value of the expression 2 + 2 × 2 + 2 is:",
   "8",
   C("Multiply before adding: 2 × 2 = 4, then 2 + 4 + 2 = 8.")+
   steps("Do the multiplication first: 2 × 2 = 4","now add the rest: 2 + 4 + 2","2 + 4 + 2 = 8, so the value is 8."),
   [("16","16 adds the first two 2s, ×2, then +2 wrongly; the multiply comes first, giving 8."),
    ("12","12 multiplies too much; only the middle 2 × 2 is multiplied, giving 8."),
    ("10","10 mishandles the order; the correct value is 2 + 4 + 2 = 8.")]),

 ("AE","The phrase 'seven more than twice six' is written as the expression 2 × 6 + 7, whose value is:",
   "19",
   C("Twice six is 2 × 6 = 12, and seven more makes 12 + 7 = 19.")+
   steps("Twice six is 2 × 6 = 12","seven more means + 7: 12 + 7","12 + 7 = 19, so the value is 19."),
   [("26","26 doubles (6 + 7) wrongly; it is 2 × 6 first, then + 7, giving 19."),
    ("84","84 multiplies 12 by 7; 'more than' means ADD 7, giving 19."),
    ("13","13 only adds 6 and 7; 'twice six' is 12, so 12 + 7 = 19.")]),

 ("AE","Following the correct order, the value of the expression (8 − 3) × 2 is:",
   "10",
   C("Work the bracket first: 8 − 3 = 5, then 5 × 2 = 10.")+
   steps("Clear the bracket: 8 − 3 = 5","multiply by 2: 5 × 2","5 × 2 = 10, so the value is 10."),
   [("2","2 multiplies before the bracket (3 × 2) then subtracts; brackets come first, giving 10."),
    ("13","13 adds instead of multiplying; (8 − 3) × 2 = 10."),
    ("16","16 multiplies 8 × 2 and ignores the −3; the bracket gives 5 × 2 = 10.")]),

 ("AE","Following the correct order, the value of the expression 9 + 9 ÷ 9 is:",
   "10",
   C("Divide before adding: 9 ÷ 9 = 1, then 9 + 1 = 10.")+
   steps("Do the division first: 9 ÷ 9 = 1","now add the first 9: 9 + 1","9 + 1 = 10, so the value is 10."),
   [("2","2 adds first (9 + 9 = 18) then ÷9; division comes first, giving 10."),
    ("18","18 forgets the ÷ 9 step; 9 ÷ 9 = 1, then 9 + 1 = 10."),
    ("3","3 has no basis; 9 + (9 ÷ 9) = 9 + 1 = 10.")]),

 ("AE","A plant is given (3 + 2) hours of sunlight each day for 4 days. The expression 4 × (3 + 2) gives a total of:",
   "20 hours",
   C("Add inside the bracket first: 3 + 2 = 5 hours a day, then 4 × 5 = 20 hours — a science count solved with brackets.")+
   steps("Each day's sunlight is 3 + 2 = 5 hours","over 4 days: 4 × 5","4 × 5 = 20, so the total is 20 hours."),
   [("14 hours","14 is 4 × 3 + 2, multiplying only the 3; the bracket gives 4 × 5 = 20."),
    ("9 hours","9 adds 4 + 3 + 2; the expression is 4 × 5 = 20 hours."),
    ("24 hours","24 multiplies wrongly; 4 × (3 + 2) = 4 × 5 = 20 hours.")]),

 ("AE","Following the correct order, the value of the expression 3 × 4 − 2 is:",
   "10",
   C("Multiply before subtracting: 3 × 4 = 12, then 12 − 2 = 10.")+
   steps("Do the multiplication first: 3 × 4 = 12","subtract the 2: 12 − 2","12 − 2 = 10, so the value is 10."),
   [("6","6 subtracts first (4 − 2 = 2) then ×3; multiplication comes first, giving 10."),
    ("12","12 forgets to subtract the 2; 3 × 4 − 2 = 10."),
    ("18","18 multiplies (4 − 2) by... no; 3 × 4 = 12 then − 2 = 10.")]),

 ("AE","Two expressions have the SAME value, so we may join them with an equals sign. This is true for:",
   "2 + 3 and 1 + 4, since both equal 5",
   C("2 + 3 = 5 and 1 + 4 = 5, so the two expressions are equal and joined by =.")+
   steps("Work out 2 + 3 = 5","work out 1 + 4 = 5","both equal 5, so 2 + 3 = 1 + 4."),
   [("2 + 3 and 1 + 5, which are equal","1 + 5 = 6, not 5, so these are not equal."),
    ("4 + 4 and 2 + 3, which are equal","4 + 4 = 8 but 2 + 3 = 5, so they are not equal."),
    ("3 + 3 and 2 + 2, which are equal","3 + 3 = 6 but 2 + 2 = 4, so they are not equal.")]),

 ("AE","To make the two expressions 6 + __ and 10 equal, the number that goes in the blank is:",
   "4",
   C("6 + 4 = 10, so the blank must be 4 to make the two expressions equal.")+
   steps("We need 6 + __ to equal 10","ask what adds to 6 to make 10","10 − 6 = 4, so the blank is 4."),
   [("16","16 gives 6 + 16 = 22, not 10; the blank is 10 − 6 = 4."),
    ("6","6 gives 6 + 6 = 12, not 10; the blank is 4."),
    ("10","10 gives 6 + 10 = 16, not 10; the blank is 4.")]),

 ("AE","Following the correct order, the value of the expression 18 ÷ (3 + 3) is:",
   "3",
   C("Work the bracket first: 3 + 3 = 6, then 18 ÷ 6 = 3.")+
   steps("Clear the bracket first: 3 + 3 = 6","now divide: 18 ÷ 6","18 ÷ 6 = 3, so the value is 3."),
   [("9","9 divides 18 by the first 3 only; the bracket gives 18 ÷ 6 = 3."),
    ("12","12 does 18 ÷ 3 then + 3; the bracket comes first, giving 18 ÷ 6 = 3."),
    ("6","6 is the value inside the bracket, not the answer; 18 ÷ 6 = 3.")]),
]

AE_UC = [
 "Naming terms is how you break a long expression into the pieces you add and subtract.",
 "Doing 2 + 3 × 4 the right way is how a shopkeeper totals a fixed charge plus priced items.",
 "Knowing the bracket comes first is why (2 + 3) × 4 is read as five lots of four.",
 "Working brackets first is the rule that keeps everyone's answer to a sum the same.",
 "Doing 10 − 2 × 3 in order is how you subtract a known cost from a starting amount correctly.",
 "Doing 5 × 2 + 3 in order is the everyday sum of a per-item price plus a flat fee.",
 "Knowing 8 + 0 = 8 is the simple idea that adding nothing leaves an amount unchanged.",
 "Doing 6 + (4 − 1) is how you add a leftover after a small take-away inside a bracket.",
 "Doing 6 − (4 − 1) shows how a minus sign reaches across a whole bracket.",
 "Using 4 × (10 + 2) is how the distributive rule speeds up multiplying a sum.",
 "Doing 20 − (5 + 3) is how you subtract a combined cost in one careful step.",
 "Comparing 3 + 4 with 3 × 4 shows at a glance how fast multiplying outgrows adding.",
 "Doing 12 ÷ 3 + 1 in order is how you share a total then add one more part.",
 "Doing 2 × (5 + 5) is the quick way to double a combined amount.",
 "Doing 100 − 10 × 5 in order is how you take many equal costs from a starting sum.",
 "Doing 3 × 3 + 3 in order is a neat check that you multiply before you add.",
 "Doing 2 + 2 × 2 + 2 carefully is how tricky exam sums catch out careless order.",
 "Writing 'seven more than twice six' as 2 × 6 + 7 is how words become a solvable expression.",
 "Doing (8 − 3) × 2 is how you scale up a difference you worked out in a bracket.",
 "Doing 9 + 9 ÷ 9 in order is a famous test of whether you divide before you add.",
 "Using 4 × (3 + 2) is exactly how you'd total a plant's daily sunlight over several days.",
 "Doing 3 × 4 − 2 in order is how you take a small amount off a multiplied total.",
 "Spotting that 2 + 3 equals 1 + 4 is how you check two expressions are truly equal.",
 "Filling 6 + __ = 10 is the puzzle behind finding a missing part of a known total.",
 "Doing 18 ÷ (3 + 3) is how you share a total among a group you first add up in a bracket.",
]

# ---------- RATIONAL NUMBERS (25) — Maths ----------
RN = [
 ("RN","Any number you can express as p/q, with p and q whole numbers and the bottom q not zero, is a:",
   "rational number",
   C("Any number expressible as a fraction p/q with a non-zero whole-number bottom is a rational number.")+
   steps("Write the number as a fraction p over q","make sure the bottom q is not zero","if it fits this form, it is a rational number."),
   [("natural number","Natural numbers are only 1, 2, 3, …; rational numbers also include fractions and negatives."),
    ("prime number","A prime is a special whole number; the p/q form describes a rational number."),
    ("irrational number","An irrational number CANNOT be written as p/q; the p/q form is a rational number.")]),

 ("RN","The number 0 is a rational number because it can be written as:",
   "0/1 (zero over one)",
   C("Zero fits the p/q form as 0/1, with a non-zero bottom, so it is rational.")+
   steps("Try to write 0 as a fraction p/q","0 = 0/1, and the bottom 1 is not zero","so 0 is a rational number."),
   [("1/0 (one over zero)","Dividing by zero is not allowed; 0 is written 0/1, not 1/0."),
    ("a number that cannot be a fraction","Zero CAN be a fraction, 0/1, so it is rational."),
    ("only a negative number","Zero is neither positive nor negative, but it is still rational as 0/1.")]),

 ("RN","Written in its simplest (standard) form, the rational number 4/8 is:",
   "1/2",
   C("Divide top and bottom by their common factor 4: 4 ÷ 4 = 1 and 8 ÷ 4 = 2, giving 1/2.")+
   steps("Find a common factor of 4 and 8 — that is 4","divide both by 4: 4 ÷ 4 and 8 ÷ 4","this gives 1/2, the simplest form."),
   [("4/8 is already simplest","4/8 can still be reduced; both share the factor 4, giving 1/2."),
    ("2/1","2/1 is the number 2, far bigger than 4/8; the simplest form is 1/2."),
    ("8/4","8/4 flips it to 2; reducing 4/8 correctly gives 1/2.")]),

 ("RN","The additive inverse (opposite) of the rational number 3/7 is:",
   "−3/7",
   C("The additive inverse is the number that adds to it to give 0; for 3/7 that is −3/7.")+
   steps("Ask what adds to 3/7 to make 0","that is the same size with the opposite sign","so the additive inverse is −3/7."),
   [("7/3","7/3 is the reciprocal, used in multiplying to 1, not the additive inverse."),
    ("3/7 itself","Adding 3/7 to itself gives 6/7, not 0; the inverse is −3/7."),
    ("0","0 is the result of adding a number to its inverse, not the inverse of 3/7.")]),

 ("RN","Comparing the two negative numbers −1/2 and −3/4, the GREATER one is:",
   "−1/2",
   C("On the number line −1/2 lies to the right of −3/4 (closer to zero), so −1/2 is greater.")+
   steps("Place both on a number line","−1/2 sits closer to 0 than −3/4","the one nearer 0 is greater, so −1/2 is greater."),
   [("−3/4","−3/4 is further from 0 on the negative side, so it is the SMALLER, not the greater."),
    ("they are equal","−1/2 and −3/4 are different points on the line, so they are not equal."),
    ("neither can be compared","Negative rationals can be compared; −1/2 is greater than −3/4.")]),

 ("RN","Every integer, such as 5, is also a rational number because it can be written as:",
   "5/1 (the integer over one)",
   C("Any integer fits p/q by putting 1 underneath: 5 = 5/1, so every integer is rational.")+
   steps("Take any integer, say 5","write it over 1: 5/1","this is the p/q form, so the integer is rational."),
   [("5/0 (the integer over zero)","Dividing by zero is not allowed; 5 is written 5/1, not 5/0."),
    ("a number that is never rational","Integers ARE rational; 5 = 5/1 fits the p/q form."),
    ("0/5 (zero over the integer)","0/5 equals 0, not 5; the integer 5 is written 5/1.")]),

 ("RN","Turned upside down, the reciprocal (multiplicative inverse) of 2/3 comes out as:",
   "3/2",
   C("The reciprocal is found by turning the fraction upside down: 2/3 becomes 3/2.")+
   steps("Take the fraction 2/3","swap its top and bottom","this gives 3/2, the reciprocal."),
   [("−2/3","−2/3 is the additive inverse (opposite sign), not the reciprocal."),
    ("2/3 itself","A fraction times itself is not 1 in general; the reciprocal flips it to 3/2."),
    ("0","Multiplying by 0 gives 0, not 1; the reciprocal of 2/3 is 3/2.")]),

 ("RN","Adding a rational number to its additive inverse, such as 4/9 + (−4/9), always gives:",
   "0",
   C("A number and its opposite cancel out, so their sum is always zero.")+
   steps("Take a number and its opposite, 4/9 and −4/9","add them together","they cancel, giving 0."),
   [("1","A number times its RECIPROCAL gives 1; a number plus its inverse gives 0."),
    ("8/9","8/9 adds two positive 4/9s; here one is negative, so they cancel to 0."),
    ("4/9","The two cancel completely; the sum is 0, not 4/9.")]),

 ("RN","Reduced to its simplest form, the rational number −8/12 is:",
   "−2/3",
   C("Divide top and bottom by the common factor 4: −8 ÷ 4 = −2 and 12 ÷ 4 = 3, giving −2/3.")+
   steps("Find a common factor of 8 and 12 — that is 4","divide both by 4, keeping the minus sign","this gives −2/3, the simplest form."),
   [("−4/6","−4/6 still shares the factor 2; reducing fully gives −2/3."),
    ("−12/8","−12/8 flips the fraction; reducing −8/12 correctly gives −2/3."),
    ("2/3","The minus sign must stay; −8/12 reduces to −2/3, not +2/3.")]),

 ("RN","On a number line, the rational number −2/3 is found:",
   "between 0 and −1, on the left of zero",
   C("Since −2/3 is negative and smaller in size than 1, it sits between 0 and −1 to the left of zero.")+
   steps("It is negative, so it lies left of 0","its size 2/3 is less than 1","so it sits between 0 and −1 on the left."),
   [("between 0 and 1, on the right of zero","−2/3 is negative, so it lies LEFT of 0, not right."),
    ("exactly on the number 1","−2/3 is a small negative number, nowhere near +1."),
    ("between −1 and −2","Its size 2/3 is less than 1, so it lies between 0 and −1, not beyond −1.")]),

 ("RN","A rational number that lies exactly halfway between 0 and 1 is:",
   "1/2",
   C("Halfway from 0 to 1 is one half, the rational number 1/2.")+
   steps("Split the gap from 0 to 1 into two equal parts","the middle mark is one half","so the halfway number is 1/2."),
   [("2 (two)","2 lies beyond 1, not between 0 and 1; the midpoint is 1/2."),
    ("1/4","1/4 is a quarter of the way, not halfway; halfway is 1/2."),
    ("0 itself","0 is the start point, not the midpoint; halfway to 1 is 1/2.")]),

 ("RN","Multiplying a rational number by its reciprocal, such as 5/6 × 6/5, always gives:",
   "1",
   C("A number times its reciprocal cancels to 1, the multiplicative identity.")+
   steps("Take a number and its reciprocal, 5/6 and 6/5","multiply tops and bottoms","everything cancels, giving 1."),
   [("0","Adding a number to its INVERSE gives 0; multiplying by the reciprocal gives 1."),
    ("11/11 written as a fraction","Reciprocals multiply to 1, not to a sum like 11/11; the answer is simply 1."),
    ("25/36","25/36 squares 5/6; the reciprocal flips it, so the product is 1.")]),

 ("RN","Comparing the two rational numbers 3/4 and 2/3, the GREATER one is:",
   "3/4",
   C("Writing both over 12, 3/4 = 9/12 and 2/3 = 8/12; since 9/12 > 8/12, 3/4 is greater.")+
   steps("Use a common bottom of 12","3/4 = 9/12 and 2/3 = 8/12","9/12 is bigger than 8/12, so 3/4 is greater."),
   [("2/3","Over 12, 2/3 = 8/12, which is smaller than 3/4 = 9/12, so 2/3 is the smaller."),
    ("they are equal","9/12 and 8/12 are different, so 3/4 and 2/3 are not equal."),
    ("3/4 only when both are negative","Both are positive here, and 3/4 = 9/12 is the greater.")]),

 ("RN","Written with a denominator of 6, the rational number equal to 1/2 is:",
   "3/6",
   C("Multiply top and bottom of 1/2 by 3: (1×3)/(2×3) = 3/6, an equivalent rational number.")+
   steps("We want the bottom to be 6","multiply 1/2 top and bottom by 3","this gives 3/6, equal to 1/2."),
   [("2/6","2/6 reduces to 1/3, not 1/2; the right equivalent is 3/6."),
    ("6/3","6/3 equals 2, far bigger than 1/2; the equivalent with bottom 6 is 3/6."),
    ("1/6","1/6 is much smaller than 1/2; the equivalent with bottom 6 is 3/6.")]),

 ("RN","The temperature one morning is −2 °C and it rises by 5 °C by noon. Written as a sum of signed numbers, −2 + 5 gives:",
   "3 °C",
   C("Starting at −2 and adding 5 moves 5 steps up the number line to +3 — a weather change read with signed numbers.")+
   steps("Begin at −2 on the number line","a rise of 5 means add 5: −2 + 5","stepping 5 up from −2 lands on +3, so 3 °C."),
   [("−7 °C","−7 would mean falling by 5; a RISE adds 5, giving −2 + 5 = 3 °C."),
    ("7 °C","7 ignores the minus on the 2; −2 + 5 = 3, not 7."),
    ("−3 °C","−3 keeps the wrong sign; counting 5 up from −2 reaches +3 °C.")]),

 ("RN","The number −7 is a rational number, and as a fraction it can be written as:",
   "−7/1",
   C("Any integer is rational; −7 fits the p/q form as −7/1, with a non-zero bottom.")+
   steps("Take the integer −7","write it over 1, keeping its sign: −7/1","the bottom 1 is not zero, so it is rational."),
   [("−1/7","−1/7 is a small fraction, not the integer −7; −7 is written −7/1."),
    ("7/1","7/1 is +7; the minus sign must stay, giving −7/1."),
    ("−7/0","Dividing by zero is not allowed; −7 is written −7/1, not −7/0.")]),

 ("RN","Working it out, the value of the subtraction 1/2 − 1/4 is:",
   "1/4",
   C("Write 1/2 as 2/4, then 2/4 − 1/4 = 1/4.")+
   steps("Give both the same bottom: 1/2 = 2/4","subtract: 2/4 − 1/4","2 − 1 over 4 is 1/4, so the answer is 1/4."),
   [("1/2","1/2 forgets to subtract anything; 2/4 − 1/4 = 1/4, not 1/2."),
    ("0","The two are not equal, so the difference is not 0; it is 1/4."),
    ("2/6","You do not subtract the bottoms; with bottom 4 it is 2/4 − 1/4 = 1/4.")]),

 ("RN","Working it out, the value of the addition (−1/5) + (1/5) is:",
   "0",
   C("−1/5 and 1/5 are opposites, so they cancel to give 0.")+
   steps("The two have the same size but opposite signs","opposites cancel each other","so (−1/5) + (1/5) = 0."),
   [("2/5","2/5 adds two positive fifths; one here is negative, so they cancel to 0."),
    ("−2/5","−2/5 adds two negatives; here one is positive, so they cancel to 0."),
    ("1/5","The two cancel completely, giving 0, not 1/5.")]),

 ("RN","Both −3/5 and 3/5 have the same size but opposite signs, so they are best described as:",
   "additive inverses of each other",
   C("Two numbers equal in size but opposite in sign add to zero, so they are additive inverses.")+
   steps("They are the same size, 3/5","but their signs are opposite","such a pair adds to 0 — they are additive inverses."),
   [("reciprocals of each other","Reciprocals multiply to 1; these are opposite in SIGN, so additive inverses."),
    ("exactly equal numbers","Opposite signs make them different points, not equal numbers."),
    ("both positive numbers","One of them, −3/5, is negative; they are additive inverses.")]),

 ("RN","Working it out, the value of the addition 2/7 + 3/7 is:",
   "5/7",
   C("With the same bottom 7, add the tops: 2 + 3 = 5, giving 5/7.")+
   steps("The bottoms are both 7","add the tops: 2 + 3 = 5","keep the bottom 7, giving 5/7."),
   [("5/14","You do not add the bottoms; with bottom 7 it stays 5/7."),
    ("6/7","6/7 adds wrongly; 2 + 3 = 5, so the answer is 5/7."),
    ("1/7","1/7 subtracts the tops; the sum 2 + 3 over 7 is 5/7.")]),

 ("RN","A rational number is called POSITIVE when its numerator and denominator have:",
   "the same sign (both positive or both negative)",
   C("If the top and bottom share a sign, the fraction is positive; opposite signs make it negative.")+
   steps("Check the signs of the top and the bottom","same signs (++ or −−) give a positive value","opposite signs give a negative value."),
   [("opposite signs to each other","Opposite signs make the fraction NEGATIVE, not positive."),
    ("a numerator of zero","A zero top makes the fraction 0, which is neither positive nor negative."),
    ("a denominator of zero","A zero bottom is not allowed at all; it cannot be a rational number.")]),

 ("RN","The product of the two rational numbers 2/3 × 3/2 is:",
   "1",
   C("These are reciprocals: (2×3)/(3×2) = 6/6 = 1.")+
   steps("Multiply the tops: 2 × 3 = 6","multiply the bottoms: 3 × 2 = 6","6/6 = 1, so the product is 1."),
   [("0","Multiplying never gives 0 unless a factor is 0; here the product is 1."),
    ("5/5 written as a sum","These multiply (not add) to 1; the answer is simply 1."),
    ("4/9","4/9 squares 2/3; multiplying by the reciprocal 3/2 gives 1.")]),

 ("RN","The rational number that is the additive inverse of 0 is:",
   "0 itself",
   C("Zero added to zero is still zero, so the additive inverse of 0 is 0.")+
   steps("Ask what adds to 0 to give 0","0 + 0 = 0","so the additive inverse of 0 is 0 itself."),
   [("1","Adding 1 to 0 gives 1, not 0; the inverse of 0 is 0."),
    ("−1","Adding −1 to 0 gives −1, not 0; the inverse of 0 is 0."),
    ("there is no such number","0 does have an additive inverse — it is 0 itself.")]),

 ("RN","A rational number that lies between the two numbers 1/4 and 3/4 is:",
   "1/2",
   C("Since 1/4 < 1/2 < 3/4, the number 1/2 lies between 1/4 and 3/4.")+
   steps("Write them over 4: 1/4, 2/4, 3/4","2/4 sits between 1/4 and 3/4","2/4 is 1/2, so 1/2 lies between them."),
   [("1 (one)","1 is bigger than 3/4, so it lies beyond, not between 1/4 and 3/4."),
    ("1/8","1/8 is smaller than 1/4, so it lies below, not between them."),
    ("0","0 is below 1/4, so it does not lie between 1/4 and 3/4.")]),

 ("RN","Reduced to its simplest form, the rational number 10/5 equals the whole number:",
   "2",
   C("Divide top and bottom by 5: 10 ÷ 5 = 2 and 5 ÷ 5 = 1, giving 2/1, which is 2.")+
   steps("Find the common factor of 10 and 5 — that is 5","divide both by 5: 10 ÷ 5 and 5 ÷ 5","this gives 2/1, the whole number 2."),
   [("5","5 is the bottom number, not the value; 10/5 = 2."),
    ("1/2","1/2 flips the fraction; 10/5 is 10 ÷ 5 = 2, not a half."),
    ("10","10 is the top number, not the value; 10 ÷ 5 = 2.")]),
]

RN_UC = [
 "Knowing the p/q form is how you tell at a glance whether a number counts as rational.",
 "Knowing 0 = 0/1 is why zero quietly belongs among the rational numbers.",
 "Reducing 4/8 to 1/2 is the tidying step that keeps every fraction answer in simplest form.",
 "Finding the additive inverse is how you know what cancels a number back to zero.",
 "Comparing −1/2 with −3/4 is how a thermometer tells which freezing reading is the warmer.",
 "Seeing 5 as 5/1 is how you realise whole numbers are just rationals in disguise.",
 "Knowing the reciprocal flips a fraction is the key step in dividing by a fraction.",
 "Knowing a number plus its inverse is 0 is the idea behind cancelling debts against savings.",
 "Reducing −8/12 to −2/3 keeps negative fractions neat and easy to compare.",
 "Placing −2/3 on a line is how you picture a small loss or a below-zero reading.",
 "Knowing 1/2 is the midpoint of 0 and 1 is how you split a length exactly in half.",
 "Knowing a number times its reciprocal is 1 is the trick that simplifies many fraction sums.",
 "Comparing 3/4 with 2/3 over a common bottom is how you judge which share is bigger.",
 "Writing 1/2 as 3/6 is how you match fractions before adding or comparing them.",
 "Computing −2 + 5 is exactly how you track a temperature rising from below zero at dawn.",
 "Seeing −7 as −7/1 is how a debt or a drop in temperature joins the rational numbers.",
 "Doing 1/2 − 1/4 is the recipe-and-measure sense of taking one share from another.",
 "Doing (−1/5) + (1/5) shows how a gain exactly cancels an equal loss.",
 "Spotting additive inverses is how you pair a number with the one that zeroes it out.",
 "Doing 2/7 + 3/7 is how you add same-sized shares of one whole into a larger share.",
 "Reading the signs is how you tell a positive rational from a negative one at a glance.",
 "Knowing 2/3 × 3/2 = 1 is the reciprocal idea that powers fraction division.",
 "Knowing 0 is its own inverse is a neat special case worth remembering for exams.",
 "Finding 1/2 between 1/4 and 3/4 shows there is always a rational number in any gap.",
 "Reducing 10/5 to 2 shows how a fraction can hide a plain whole number inside it.",
]


def _with_uc(lst, ucs):
    assert len(lst) == len(ucs) == 25, (len(lst), len(ucs))
    out = []
    for it, uc in zip(lst, ucs):
        code, stem, correct, html, distr = it
        out.append((code, stem, correct, html + U(uc), distr))
    return out


WC = _with_uc(WC, WC_UC)
PC = _with_uc(PC, PC_UC)
AE = _with_uc(AE, AE_UC)
RN = _with_uc(RN, RN_UC)

items = []
for i in range(25):
    items += [WC[i], PC[i], AE[i], RN[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=34811,
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
    split = "/".join(str(counts[c]) for c in ("WC", "PC", "AE", "RN"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Weather, Climate & Adaptations",
                     "Physical & Chemical Changes",
                     "Arithmetic Expressions",
                     "Rational Numbers"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
