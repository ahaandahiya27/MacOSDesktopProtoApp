# -*- coding: utf-8 -*-
# Boss Challenge Paper 20 — Acids, Bases & Salts · Weather, Climate
#                          & Adaptations · Simple Equations · Symmetry
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans into FUSION — a neutralisation context
# (acid + base in fixed ratios) wrapped around a Simple-Equations skill, an
# acid-rain / weather story, and symmetry read off real weather/biology
# objects (snowflakes, butterflies, starfish). Class-7 scope, simple
# wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_20_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_20_<SHORT>_QuestionPaper.pdf
#   Paper_20_<SHORT>_Questions.md
#   Paper_20_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U, balance

PNUM  = "20"
SHORT = "AcidsBases_Weather_SimpleEquations_Symmetry"
TITLE = "Acids, Bases & Salts · Weather, Climate & Adaptations · Simple Equations · Symmetry"
LABELS = {
    "AB": "Acids, Bases & Salts",
    "WE": "Weather, Climate & Adaptations",
    "SE": "Simple Equations",
    "SY": "Symmetry",
}

# ---------- ACIDS, BASES & SALTS (25) — Science ----------
AB = [
 ("AB","A substance that tastes sour and turns blue litmus paper red is called an:",
   "acid",
   C("Acids are sour-tasting substances that turn blue litmus red — that colour change is their fingerprint.")+
   steps("Sour taste hints at an acid","Blue litmus dipped in it turns red","Both clues together point to an acid.")+
   U("The sour bite of a lemon or raw mango in your kitchen is your tongue meeting a natural acid."),
   [("base","Bases taste bitter and turn RED litmus blue — the opposite of what is described here."),
    ("salt","A salt is what forms when an acid and a base react; on its own it is usually neutral, not sour."),
    ("neutral substance","A neutral substance like pure water changes neither litmus colour, so it cannot be this.")]),

 ("AB","A substance that feels soapy, tastes bitter and turns red litmus blue is known as a:",
   "base",
   C("Bases feel slippery, taste bitter and turn red litmus blue — that is how we recognise them.")+
   steps("Soapy feel and bitter taste hint at a base","Red litmus dipped in it turns blue","These clues together point to a base.")+
   U("Soap and baking soda feel slippery on wet fingers because they are everyday bases."),
   [("acid","Acids are sour and turn BLUE litmus red — the reverse of the soapy, bitter clues given."),
    ("salt","A salt usually has no special taste and does not turn litmus blue; it is the product of a reaction."),
    ("indicator","An indicator only shows a colour change; it is not itself the bitter, soapy substance described.")]),

 ("AB","When an acid is mixed with exactly the right amount of a base, the reaction is named:",
   "neutralisation",
   C("In neutralisation an acid and a base cancel each other, giving a salt and water.")+
   steps("Acid + base react together","Their acidic and basic natures cancel out","The products are a salt and water — this is neutralisation.")+
   U("An antacid tablet neutralises extra acid in your stomach, easing the burning of indigestion."),
   [("evaporation","Evaporation is just a liquid turning to vapour; no acid and base cancel each other there."),
    ("condensation","Condensation is vapour turning back to liquid — a physical change, not an acid–base reaction."),
    ("oxidation","Oxidation involves reaction with oxygen, like rusting; it is not the cancelling of an acid by a base.")]),

 ("AB","The two products always formed when an acid reacts completely with a base are:",
   "a salt and water",
   C("Neutralisation follows the pattern acid + base → salt + water, every time.")+
   steps("Write the general reaction: acid + base","Their reactive parts swap and cancel","Out come a salt and water.")+
   U("Mixing hydrochloric acid with caustic soda in a lab gives common salt and water — the same pattern in your blood when antacids work."),
   [("two acids","An acid is used up in the reaction, not made; you cannot end with two acids."),
    ("only a gas","While some neutralisations release a gas, the always-formed pair is a salt and water, not gas alone."),
    ("a base and oxygen","The base is consumed, and oxygen is not a product of a simple acid–base reaction.")]),

 ("AB","Turmeric, a natural yellow dye, turns bright red when it touches a:",
   "base",
   C("Turmeric is a natural indicator: it stays yellow in acid but turns red in a base.")+
   steps("Turmeric is yellow normally","In an acid it stays yellow","In a base it turns red.")+
   U("A red stain on a turmeric-yellow cloth from a soap splash is the soap's basic nature showing up."),
   [("acid","In an acid turmeric keeps its normal yellow colour; only a base turns it red."),
    ("salt","A neutral salt solution leaves turmeric yellow; it does not produce the red colour."),
    ("neutral water","Pure water is neutral and does not change turmeric's yellow shade.")]),

 ("AB","A gardener finds the soil is too acidic for crops. To correct it, the soil is treated with:",
   "a base such as lime (quicklime)",
   C("Acidic soil is fixed by adding a base, which neutralises the excess acid.")+
   steps("Acidic soil has too much acid","A base cancels acid by neutralisation","So farmers add lime, a base, to balance the soil.")+
   U("Farmers spread lime over sour fields so crops that dislike acid can grow well."),
   [("more acid such as vinegar","Adding acid to already-acidic soil makes it worse, not balanced."),
    ("plain water","Water dilutes but does not neutralise the acid; the soil stays acidic."),
    ("common salt","Salt does not neutralise acid; only a base can cancel the soil's acidity.")]),

 ("AB","An ant's sting injects an acid into the skin. The best soothing rub is a mild:",
   "base, such as baking soda paste",
   C("The sting hurts because of acid, so a mild base neutralises it and eases the pain.")+
   steps("Ant sting leaves acid in the skin","A base neutralises that acid","Baking soda, a mild base, soothes the sting.")+
   U("Rubbing moist baking soda on an ant or bee sting calms the burning quickly."),
   [("acid, such as vinegar","Adding more acid to an acidic sting would make the burning worse."),
    ("plain table salt","Salt does not neutralise the acid of the sting, so it gives little relief."),
    ("sugar solution","Sugar is neutral and does nothing to cancel the acid causing the pain.")]),

 ("AB","Lemon juice, orange juice and other citrus fruits owe their sour taste to:",
   "citric acid",
   C("Citrus fruits contain citric acid, which gives them their sharp, sour flavour.")+
   steps("Sour taste signals an acid","In citrus fruits that acid is citric acid","So lemons and oranges taste sour because of citric acid.")+
   U("The pucker you feel biting a lemon is citric acid working on your tongue."),
   [("lactic acid","Lactic acid is found in curd and sour milk, not in citrus fruits."),
    ("acetic acid","Acetic acid is the acid of vinegar, not the acid of lemons and oranges."),
    ("sodium hydroxide","Sodium hydroxide is a strong base, not a sour fruit acid.")]),

 ("AB","The acid present in vinegar, which we use in cooking and pickles, is:",
   "acetic acid",
   C("Vinegar is a dilute solution of acetic acid, which gives it its sharp sour smell and taste.")+
   steps("Vinegar tastes and smells sour","Its acid is acetic acid","So acetic acid is the acid in vinegar.")+
   U("A splash of vinegar on chips is really a splash of dilute acetic acid."),
   [("citric acid","Citric acid is found in lemons and oranges, not in vinegar."),
    ("tartaric acid","Tartaric acid comes from tamarind and grapes, not from vinegar."),
    ("hydrochloric acid","Hydrochloric acid is a strong lab/stomach acid, far too harsh to be vinegar.")]),

 ("AB","A person suffering from acidity (too much acid in the stomach) is given an antacid, which acts as a:",
   "mild base",
   C("Antacids are mild bases that neutralise the excess acid in the stomach.")+
   steps("Acidity means too much stomach acid","A mild base neutralises that acid","So antacids like milk of magnesia are mild bases.")+
   U("Milk of magnesia eases a burning stomach by cancelling extra acid."),
   [("strong acid","Adding a strong acid would worsen the acidity, not relieve it."),
    ("neutral salt","A neutral salt cannot cancel acid, so it would not relieve acidity."),
    ("sour fruit juice","Sour juice is itself acidic and would add to the problem, not solve it.")]),

 ("AB","The everyday substance whose chemical name is sodium chloride and which forms when hydrochloric acid neutralises sodium hydroxide is:",
   "common table salt",
   C("Hydrochloric acid plus sodium hydroxide gives sodium chloride — ordinary table salt — and water.")+
   steps("Acid (HCl) + base (NaOH) react","They neutralise into a salt and water","That salt is sodium chloride, common table salt.")+
   U("The salt that seasons your food is exactly the product of this acid–base reaction."),
   [("baking soda","Baking soda is sodium bicarbonate, not the product of HCl reacting with NaOH."),
    ("washing soda","Washing soda is sodium carbonate, a different compound from table salt."),
    ("lime","Lime is a base used to treat soil, not the salt formed in this reaction.")]),

 ("AB","Litmus, the most common laboratory indicator, is a natural dye obtained from:",
   "lichens",
   C("Litmus is extracted from lichens, small plants that grow on rocks and tree bark.")+
   steps("Litmus is a natural indicator","It is taken from a living source","That source is lichens.")+
   U("The red and blue litmus papers in your school lab both start as dye from lichens."),
   [("rose petals","China rose petals do give an indicator, but ordinary litmus comes from lichens."),
    ("turmeric roots","Turmeric is its own indicator; litmus is a separate dye taken from lichens."),
    ("lemon skins","Lemon skins contain acid, not litmus dye, which comes from lichens.")]),

 ("AB","A solution leaves both red and blue litmus papers completely unchanged. The solution must be:",
   "neutral",
   C("If neither litmus colour changes, the solution is neither acidic nor basic — it is neutral.")+
   steps("Acids turn blue litmus red","Bases turn red litmus blue","No change at all means the solution is neutral.")+
   U("Pure distilled water leaves both papers unchanged because it is neutral."),
   [("a strong acid","A strong acid would turn blue litmus red, so litmus would not stay unchanged."),
    ("a strong base","A strong base would turn red litmus blue, so this cannot be it."),
    ("a weak acid","Even a weak acid nudges blue litmus toward red; truly no change means neutral.")]),

 ("AB","China rose indicator turns a solution dark green. The solution is therefore:",
   "basic",
   C("China rose indicator turns green in a base (and pinkish in an acid).")+
   steps("China rose is a natural indicator","It shows green in bases","So a dark-green result means the solution is basic.")+
   U("Testing soapy water with china rose gives a green colour, revealing the soap as a base."),
   [("acidic","In acids china rose turns pink/magenta, not green, so this is wrong."),
    ("neutral","A neutral solution leaves china rose its natural pink shade, not green."),
    ("a salt of a strong acid","Such a salt is roughly neutral and would not turn the indicator green.")]),

 ("AB","Tamarind and grapes get their sourness from:",
   "tartaric acid",
   C("Tamarind and grapes contain tartaric acid, which makes them taste sour.")+
   steps("Sour taste means an acid","In tamarind and grapes that acid is tartaric acid","So tartaric acid is the answer.")+
   U("The tangy zing of tamarind chutney comes from tartaric acid."),
   [("lactic acid","Lactic acid is found in curd, not in tamarind or grapes."),
    ("citric acid","Citric acid belongs to citrus fruits like lemons, not tamarind."),
    ("acetic acid","Acetic acid is the acid of vinegar, not of tamarind and grapes.")]),

 ("AB","Curd and sour milk taste tangy because they contain:",
   "lactic acid",
   C("When milk turns to curd, lactic acid forms and gives the sour, tangy taste.")+
   steps("Milk ferments into curd","This produces lactic acid","Lactic acid makes curd taste sour.")+
   U("The pleasant tang of fresh curd or yoghurt is lactic acid at work."),
   [("citric acid","Citric acid is in citrus fruits, not in curd."),
    ("tartaric acid","Tartaric acid comes from tamarind and grapes, not from curd."),
    ("sulphuric acid","Sulphuric acid is a strong lab acid, far too harsh to be in food.")]),

 ("AB","Toothpastes are usually slightly basic so that they can:",
   "neutralise the acid made by mouth bacteria",
   C("Bacteria in the mouth produce acid that attacks teeth; a basic toothpaste neutralises it.")+
   steps("Mouth bacteria make acid after meals","Acid slowly damages tooth enamel","A basic toothpaste neutralises that acid, protecting teeth.")+
   U("Brushing with a mildly basic paste cancels the acid that would otherwise cause cavities."),
   [("make the mouth more acidic","More acid would harm teeth, which is the opposite of the goal."),
    ("turn the teeth blue","Toothpaste is not an indicator and does not colour teeth blue."),
    ("dissolve the enamel faster","Toothpaste protects enamel; it is not meant to dissolve it.")]),

 ("AB","Phenolphthalein, an indicator, is colourless in acid but turns pink in:",
   "a base",
   C("Phenolphthalein stays colourless in acidic or neutral solutions and turns pink in a base.")+
   steps("Phenolphthalein is colourless in acid","It changes only when a base is present","In a base it turns pink.")+
   U("Chemists watch for the pink flash of phenolphthalein to know a base has been added."),
   [("an acid","In an acid phenolphthalein stays colourless, so it cannot signal an acid by turning pink."),
    ("pure water","Neutral water leaves phenolphthalein colourless, not pink."),
    ("a salt solution","A neutral salt solution keeps phenolphthalein colourless, not pink.")]),

 ("AB","Factory waste water is often acidic. Before it is released into a river it should be:",
   "neutralised with a base",
   C("Acidic waste would harm river life, so it is neutralised with a base before release.")+
   steps("Untreated waste is acidic","Acid would kill fish and plants in the river","Adding a base neutralises it, making it safe.")+
   U("Treatment plants add lime to acidic effluent so the river stays alive downstream."),
   [("made more acidic","Adding acid would make the waste even more harmful to the river."),
    ("released without any treatment","Releasing raw acidic waste poisons the river and is not allowed."),
    ("heated until it boils","Boiling does not remove the acid; only neutralising with a base makes it safe.")]),

 ("AB","Milk of magnesia, used to treat acidity, is an example of a:",
   "base",
   C("Milk of magnesia is a mild base (magnesium hydroxide) that neutralises stomach acid.")+
   steps("Milk of magnesia relieves acidity","It works by cancelling acid","So it must itself be a base.")+
   U("A spoon of milk of magnesia eases heartburn by neutralising excess stomach acid."),
   [("acid","An acid would add to the acidity it is meant to relieve, so it cannot be one."),
    ("neutral salt","A neutral salt cannot neutralise acid; the medicine works as a base."),
    ("indicator","Milk of magnesia treats acidity; it is a base, not a colour-change indicator.")]),

 ("AB","Soap solution is tested with red litmus paper. You would expect the paper to:",
   "turn blue, showing soap is basic",
   C("Soap is a base, so it turns red litmus blue.")+
   steps("Soap feels slippery, a sign of a base","Bases turn red litmus blue","So the red paper turns blue.")+
   U("Dip red litmus into soapy water and watch it go blue — proof that soap is basic."),
   [("stay red, showing soap is acidic","Soap is basic, not acidic, so red litmus would not stay red."),
    ("turn colourless","Litmus does not go colourless; it shifts between red and blue."),
    ("turn green","Litmus turns blue in a base, not green; green is a china-rose result.")]),

 ("AB","Sting of a wasp is alkaline (basic). The right home remedy is to apply a mild:",
   "acid, such as vinegar",
   C("A wasp sting is basic, so a mild acid neutralises it and eases the pain.")+
   steps("Wasp sting leaves a base in the skin","A mild acid neutralises a base","Vinegar, a mild acid, soothes the sting.")+
   U("Dabbing vinegar on a wasp sting cancels its basic venom, unlike an ant sting which needs a base."),
   [("base, such as baking soda","A base on a basic sting does nothing to neutralise it; you need an acid."),
    ("plain water","Water dilutes but does not neutralise the basic venom of the sting."),
    ("sugar paste","Sugar is neutral and cannot neutralise the base in the sting.")]),

 ("AB","When sulphur and nitrogen gases from factories dissolve in rain, they make the rain acidic. This polluted rain is called:",
   "acid rain",
   C("Polluting gases dissolve in rain droplets to form acids, producing acid rain.")+
   steps("Factory gases mix with water vapour","They form acids in the rain droplets","The result is acidic rain — acid rain.")+
   U("Acid rain slowly eats away at marble buildings like the Taj Mahal and harms forests and lakes."),
   [("hail","Hail is simply frozen rain (ice balls); it has nothing to do with dissolved acids."),
    ("dew","Dew is water that condenses on cool surfaces overnight, not acidic polluted rain."),
    ("a salt shower","Rain made acidic by gases is acid rain, not a 'salt shower'.")]),

 ("AB","Pure distilled water is tested with both litmus and phenolphthalein. The result will be:",
   "no colour change at all, because it is neutral",
   C("Distilled water is neutral, so it changes neither litmus colour and leaves phenolphthalein colourless.")+
   steps("Distilled water is neither acid nor base","Litmus stays its colour","Phenolphthalein stays colourless — all signs of neutrality.")+
   U("Lab-grade distilled water is the standard 'neutral' against which acids and bases are compared."),
   [("blue litmus turns red","That would happen in an acid; pure water is neutral and causes no change."),
    ("phenolphthalein turns pink","Pink would mean a base; neutral water leaves it colourless."),
    ("turmeric turns red","Red turmeric signals a base; neutral water does not change turmeric.")]),

 ("AB","In a neutralisation reaction the heat that is usually given out tells us the reaction is:",
   "exothermic (it releases heat)",
   C("Neutralisation releases energy as heat, so it is an exothermic reaction.")+
   steps("Acid and base react and combine","Energy is set free as the products form","Heat is released, so the reaction is exothermic.")+
   U("A flask of acid and base warms up as they neutralise — you can feel the heat through the glass."),
   [("endothermic (it absorbs heat)","An endothermic reaction would cool down; neutralisation warms up instead."),
    ("a change of state only","Releasing heat by forming a salt is a chemical change, not just a change of state."),
    ("a purely physical mixing","A real reaction forming salt and water with heat is chemical, not mere mixing.")]),
]

# ---------- WEATHER, CLIMATE & ADAPTATIONS (25) — Science ----------
WE = [
 ("WE","The day-to-day condition of the atmosphere — its temperature, humidity, rainfall and wind — at a place is called its:",
   "weather",
   C("Weather is the atmosphere's condition at a place from hour to hour and day to day.")+
   steps("It changes quickly, even within a day","It covers temperature, humidity, rain and wind","This short-term condition is the weather.")+
   U("The morning forecast telling you to carry an umbrella is describing today's weather."),
   [("climate","Climate is the AVERAGE weather over many years, not the day-to-day condition."),
    ("season","A season is one part of the year; weather can change many times within a single season."),
    ("humidity","Humidity is just one element of weather, not the whole atmospheric condition.")]),

 ("WE","The average weather pattern of a place taken over a long period of about twenty-five years is its:",
   "climate",
   C("Climate is the long-term average of weather measured over many years at a place.")+
   steps("Take the weather day after day","Average it over many years (about 25)","That long-term average is the climate.")+
   U("Saying 'Rajasthan has a hot, dry climate' sums up decades of its weather, not just one day."),
   [("weather","Weather is the short-term, day-to-day condition; climate is its long-term average."),
    ("temperature","Temperature is a single element; climate is the overall long-term pattern."),
    ("forecast","A forecast predicts coming weather for a few days, not the long-term climate.")]),

 ("WE","All the changes we call weather are ultimately driven by energy coming from the:",
   "Sun",
   C("The Sun heats the land, sea and air unevenly, and this drives all weather changes.")+
   steps("The Sun warms the Earth's surface","Uneven heating stirs the air and water","This energy powers winds, clouds and rain — all weather.")+
   U("Sea breezes, monsoon clouds and storms all trace back to the Sun's heating of the Earth."),
   [("Moon","The Moon mainly affects tides through gravity; it does not power the weather."),
    ("stars","Distant stars give far too little energy to drive Earth's weather."),
    ("Earth's core","The core's heat barely reaches the surface; it is the Sun that drives weather.")]),

 ("WE","The amount of water vapour present in the air is measured as the air's:",
   "humidity",
   C("Humidity tells us how much water vapour the air is holding.")+
   steps("Air can hold invisible water vapour","More vapour means higher humidity","So humidity measures the water vapour in the air.")+
   U("On a humid monsoon day sweat does not dry quickly because the air is already full of vapour."),
   [("rainfall","Rainfall is water that has already fallen, not the vapour still held in the air."),
    ("temperature","Temperature measures hotness, not the amount of water vapour."),
    ("wind speed","Wind speed measures how fast air moves, not how much vapour it carries.")]),

 ("WE","The instrument used to measure how much rain has fallen at a place is the:",
   "rain gauge",
   C("A rain gauge collects falling rain and measures its depth, usually in millimetres.")+
   steps("Rain falls into an open funnel","It collects in a measuring tube below","The reading gives the rainfall — that is a rain gauge.")+
   U("Weather stations report daily rainfall in mm using a rain gauge."),
   [("thermometer","A thermometer measures temperature, not the amount of rain."),
    ("barometer","A barometer measures air pressure, not rainfall."),
    ("anemometer","An anemometer measures wind speed, not how much rain has fallen.")]),

 ("WE","Animals and plants of a region develop special features that help them survive their climate. These features are called:",
   "adaptations",
   C("Adaptations are features that suit a living thing to the climate it lives in.")+
   steps("A climate sets challenges (cold, heat, dryness)","Living things develop helpful features over generations","These survival features are called adaptations.")+
   U("A polar bear's thick fur and a camel's water-saving body are both adaptations to their climates."),
   [("migrations","Migration is moving to another place; an adaptation is a body feature that helps survival."),
    ("habits only","Adaptations include body features, not just behaviour, so 'habits only' is too narrow."),
    ("diseases","Diseases harm an animal; adaptations are helpful features, the opposite of diseases.")]),

 ("WE","Two regions of the Earth with the most extreme climates, studied in your textbook, are the:",
   "polar regions and the tropical rainforests",
   C("The polar regions (very cold) and the tropical rainforests (hot and wet) have the most extreme climates studied.")+
   steps("Polar regions are bitterly cold all year","Tropical rainforests are hot and very rainy","These two are the extreme climates compared in the chapter.")+
   U("Polar bears in the Arctic and red-eyed frogs in rainforests show how life adapts to these extremes."),
   [("deserts and oceans","Deserts are extreme too, but the chapter contrasts polar regions with tropical rainforests."),
    ("hills and plains","Hills and plains have milder climates, not the textbook's two extremes."),
    ("rivers and lakes","Rivers and lakes are water bodies, not the climatic regions compared in the chapter.")]),

 ("WE","The polar bear's thick layer of fat (blubber) and dense white fur are adaptations that mainly help it to:",
   "stay warm in the freezing polar climate",
   C("Blubber and thick fur trap heat, keeping the polar bear warm in the bitter cold.")+
   steps("Polar regions are extremely cold","Fat and dense fur are excellent insulators","They trap body heat, keeping the bear warm.")+
   U("These same insulating ideas inspire the down jackets people wear in winter."),
   [("keep cool in the heat","The polar climate is freezing, not hot; the fur and fat are for keeping warm."),
    ("swim faster than fish","Blubber adds warmth, not racing speed; it is an insulation feature."),
    ("change colour with seasons","White fur is for warmth and camouflage in snow, not seasonal colour change here.")]),

 ("WE","A polar bear's white fur also helps it by providing:",
   "camouflage against the snow",
   C("White fur blends with snow, hiding the bear from prey and helping it hunt.")+
   steps("The polar world is white with snow and ice","White fur matches that background","So the bear is camouflaged and hunts unseen.")+
   U("A seal cannot easily spot a white bear creeping over white ice — that is camouflage at work."),
   [("warning bright colours","Bright warning colours advertise danger; white fur instead hides the bear."),
    ("attracting a mate","The white colour is for blending in, not for attracting a mate."),
    ("soaking up sunlight","White reflects rather than soaks up light; the fur's job here is camouflage.")]),

 ("WE","In the hot, wet tropical rainforest, the bright beak and loud calls of a toucan are adaptations that help it to:",
   "find food and recognise its own kind in the dense forest",
   C("In a crowded rainforest, special beaks and calls help animals feed and stay in touch with their species.")+
   steps("Rainforests are dense and full of life","A large beak reaches fruit; loud calls carry through the trees","These help the toucan feed and find its own kind.")+
   U("Many rainforest birds use loud calls because dense leaves make it hard to see one another."),
   [("survive the freezing cold","Rainforests are hot and wet, not cold, so cold-survival is not the point."),
    ("store water for years","Storing water for years is a desert adaptation, not a rainforest one."),
    ("fly above the clouds","A bright beak and loud call help feeding and signalling, not flying above clouds.")]),

 ("WE","Many birds, such as the Siberian crane, fly thousands of kilometres to warmer places when their home turns cold. This seasonal journey is called:",
   "migration",
   C("Migration is the regular seasonal journey animals make to escape harsh weather and find food.")+
   steps("Home region becomes too cold in winter","Food grows scarce there","Birds travel to warmer regions — this is migration.")+
   U("Siberian cranes flying to India for the winter is a famous example of migration."),
   [("hibernation","Hibernation is a deep winter sleep in one place, not a long journey to another."),
    ("adaptation of body shape","Adaptation is a body feature; migration is a behaviour — a seasonal journey."),
    ("camouflage","Camouflage is blending in; it is not the act of travelling to a warmer place.")]),

 ("WE","A camel can survive the desert because it can go for days without water and has broad feet. The desert climate it is adapted to is:",
   "hot and dry",
   C("Deserts are hot with very little rainfall, and the camel's body is built to cope with that.")+
   steps("Deserts get very little rain","Days are scorching hot","The camel's water-saving body suits this hot, dry climate.")+
   U("The camel's nickname 'ship of the desert' reflects how well it crosses hot, dry sands."),
   [("cold and snowy","A snowy climate is the opposite of the camel's hot, dry desert home."),
    ("warm and rainy","Deserts are dry, not rainy; a rainy climate would not suit camel adaptations."),
    ("cool and foggy","Deserts are hot and dry, not cool and foggy.")]),

 ("WE","Compared with weather, the climate of a place changes:",
   "very slowly, over many years",
   C("Weather can change within hours, but climate changes only very slowly across many years.")+
   steps("Weather flips quickly — sun to rain in a day","Climate is the long-term average","Such an average shifts only slowly over many years.")+
   U("People say the climate is warming over decades, while the weather changes from morning to evening."),
   [("from hour to hour","Hour-to-hour change describes weather, not the slow-changing climate."),
    ("every single day","Daily change is weather; climate is steady over long periods."),
    ("only during a storm","A storm is a weather event; climate is the long-term average, changing slowly.")]),

 ("WE","On a clear day, the air temperature at a place is usually highest:",
   "in the early afternoon",
   C("The Sun heats the ground through the morning, so the air is hottest a little after noon.")+
   steps("The Sun rises and warms the ground all morning","Heat keeps building past midday","So the air is hottest in the early afternoon, not at sunrise.")+
   U("This is why afternoon games feel hotter than morning ones on a sunny day."),
   [("at sunrise","At sunrise the ground has been cooling all night, so it is among the coolest times."),
    ("at midnight","Midnight is usually one of the coldest times, long after the Sun has set."),
    ("just before dawn","Just before dawn is typically the coldest moment of the day, not the hottest.")]),

 ("WE","A maximum–minimum thermometer at a weather station is used to record the:",
   "highest and lowest temperatures of the day",
   C("This thermometer remembers the day's highest and lowest temperatures.")+
   steps("Temperature rises and falls through the day","The instrument marks the peak and the dip","So it records the day's maximum and minimum temperatures.")+
   U("Newspapers print a city's 'max 38°, min 26°' from readings on this thermometer."),
   [("amount of rainfall","Rainfall is measured by a rain gauge, not a thermometer."),
    ("speed of the wind","Wind speed is measured by an anemometer, not a thermometer."),
    ("humidity of the air","Humidity needs a separate instrument; this thermometer records temperatures.")]),

 ("WE","The tropical region lies in a broad belt around the Earth's:",
   "equator",
   C("The tropics form the warm belt around the equator, where the Sun's rays are most direct.")+
   steps("The equator circles the middle of the Earth","The Sun strikes it most directly all year","So the warm tropical region surrounds the equator.")+
   U("Countries near the equator, like those in the Amazon, have hot tropical climates."),
   [("North Pole","The North Pole is the cold polar region, the opposite of the warm tropics."),
    ("highest mountains","Mountain tops are cold; the tropics are a warm belt around the equator."),
    ("ocean floor","The tropics are a region on the Earth's surface, not the ocean floor.")]),

 ("WE","A weather report says 'humidity is very high today'. This means you should expect:",
   "sweat to dry slowly and the air to feel sticky",
   C("High humidity means the air is already full of water vapour, so sweat evaporates slowly.")+
   steps("High humidity = lots of vapour in the air","Sweat cannot evaporate easily into damp air","So you feel sticky and uncomfortable.")+
   U("A muggy monsoon afternoon feels stickier than a dry summer one because of high humidity."),
   [("the air to feel very dry","High humidity means damp, not dry, air."),
    ("no clouds to form at all","Plenty of vapour actually helps clouds form, so 'no clouds' is wrong."),
    ("sweat to dry instantly","Sweat dries slowly in humid air, not instantly.")]),

 ("WE","Places on the sea coast have a more moderate climate than places far inland mainly because:",
   "the nearby sea warms and cools slowly, easing temperature swings",
   C("Water heats and cools slowly, so the sea keeps coastal temperatures gentler than inland.")+
   steps("The sea changes temperature slowly","It warms the coast in winter and cools it in summer","So coastal climates are milder, with smaller swings.")+
   U("Mumbai by the sea has gentler temperatures than Delhi far inland, even in the same season."),
   [("the sea blocks all sunlight","The sea does not block sunlight; it moderates temperature through slow heating."),
    ("coasts are always at the equator","Coasts exist at all latitudes; it is the sea's slow heating that moderates them."),
    ("there is no wind near the sea","Coasts often have sea breezes; it is the water's slow heating that softens the climate.")]),

 ("WE","An elephant's very large ears are an adaptation that mainly help it to:",
   "lose extra body heat and stay cool",
   C("The large, thin ears have many blood vessels; flapping them releases heat and cools the elephant.")+
   steps("Elephants live in warm places","Large ears have a big surface and many blood vessels","Flapping them lets heat escape, cooling the animal.")+
   U("On a hot day an elephant fans its ears like a built-in cooling fan."),
   [("hear sounds from underground","The ears' main climate role is cooling, not detecting underground sounds."),
    ("keep warm in the cold","Big ears release heat to cool down; they are not for keeping warm."),
    ("scare away predators","The ears chiefly help with cooling, not with frightening predators.")]),

 ("WE","Weather forecasts that warn of coming rain or storms are especially useful to:",
   "farmers and fishermen planning their work",
   C("Knowing the coming weather helps farmers protect crops and fishermen decide when to sail.")+
   steps("Farming and fishing depend on the weather","A forecast warns of rain or storms in advance","So farmers and fishermen plan their work safely.")+
   U("A storm warning keeps fishing boats in harbour and saves lives at sea."),
   [("astronomers studying stars","Astronomers study space; a ground-weather forecast is most useful to farmers and fishermen."),
    ("only television presenters","Presenters report forecasts, but it is farmers and fishermen who act on them."),
    ("nobody, since weather cannot be predicted","Weather can be forecast usefully for days ahead, helping many people.")]),

 ("WE","Penguins in the freezing Antarctic often huddle tightly together in large groups. This behaviour helps them to:",
   "share body heat and keep warm",
   C("Huddling reduces the cold surface each penguin exposes, letting them share warmth.")+
   steps("Antarctica is bitterly cold","Standing alone loses heat fast","Huddling shares body heat, keeping the group warm.")+
   U("Penguins take turns moving to the warm centre of the huddle so all stay warm."),
   [("catch more fish on land","Huddling is about warmth on the ice, not catching fish, which they do in the sea."),
    ("fly away from danger","Penguins cannot fly; huddling is for warmth, not escape."),
    ("cool themselves down","In freezing Antarctica they need to keep warm, not cool down.")]),

 ("WE","Which of these is an element of weather that a weather report regularly includes?",
   "temperature, rainfall, humidity and wind",
   C("Weather is described using temperature, humidity, rainfall, wind speed and direction.")+
   steps("Weather is the condition of the atmosphere","We measure it with several elements","These include temperature, rainfall, humidity and wind.")+
   U("A daily forecast lists the day's temperature, chance of rain, humidity and wind together."),
   [("the price of vegetables","Vegetable prices are economics, not an element of weather."),
    ("the population of a city","Population is a count of people, not a weather element."),
    ("the height of buildings","Building height is about architecture, not the weather.")]),

 ("WE","The acid-rain that damages the marble of monuments like the Taj Mahal is mainly an example of weather being affected by:",
   "air pollution from gases",
   C("Polluting gases dissolve in rain to form acids, so pollution turns ordinary rain into harmful acid rain.")+
   steps("Factories and vehicles release gases","These gases dissolve in rain droplets, forming acids","The acidic rain then eats away at marble — pollution shaping the weather's effect.")+
   U("Reducing factory and vehicle emissions is how cities try to protect monuments from acid rain."),
   [("the Moon's gravity","The Moon's gravity affects tides, not the acidity of rain."),
    ("the colour of the soil","Soil colour does not turn rain acidic; polluting gases do."),
    ("the number of birds","Bird numbers have nothing to do with rain becoming acidic.")]),

 ("WE","Red-eyed frogs, monkeys and big-billed birds living together in great variety are a sign of which climate?",
   "the hot, wet tropical rainforest",
   C("The warm, rainy tropical rainforest supports the greatest variety of plants and animals on Earth.")+
   steps("Plenty of warmth and rain all year","This supports lush plants and abundant food","So a huge variety of animals thrives — the rainforest.")+
   U("The Amazon and the forests of north-east India teem with such tropical life."),
   [("the cold polar region","Polar regions are icy with few species, not crowded with varied life."),
    ("the hot, dry desert","Deserts have sparse life because of the lack of water, unlike rainforests."),
    ("a snowy mountain top","High snowy peaks are cold and bare, not rich with tropical variety.")]),

 ("WE","A place is described as having a 'hot and humid' climate. The two factors being described are its:",
   "temperature and the amount of water vapour in the air",
   C("'Hot' describes temperature; 'humid' describes the water vapour (humidity) in the air.")+
   steps("'Hot' refers to a high temperature","'Humid' refers to lots of water vapour","Together they describe a hot, moist climate.")+
   U("Coastal Chennai is often called hot and humid because it is both warm and full of sea moisture."),
   [("rainfall and wind direction","Hot describes temperature and humid describes vapour, not rain and wind direction."),
    ("air pressure and altitude","'Hot and humid' is about temperature and moisture, not pressure and height."),
    ("soil type and crop yield","These are about farming, not the temperature and humidity being described.")]),
]

# ---------- SIMPLE EQUATIONS (25) — Maths ----------
SE = [
 ("SE","A statement that two expressions are equal, joined by an equals sign, is called an:",
   "equation",
   C("An equation says the left side equals the right side, joined by '='.")+
   steps("Write two expressions","Place an equals sign between them","If they are stated equal, you have an equation.")+
   U("A shopkeeper's bill 'cost = price × number' is really an equation."),
   [("expression","An expression like 2x+3 has no equals sign, so it is not an equation."),
    ("inequality","An inequality uses signs like < or >, not the '=' that defines an equation."),
    ("variable","A variable is just a letter like x; the whole equality statement is the equation.")]),

 ("SE","To solve x + 5 = 12, you transpose the 5 and get:",
   "x = 7",
   C("Move +5 to the other side as −5: x = 12 − 5 = 7.")+
   steps("x + 5 = 12","Transpose +5 → subtract 5 from 12","x = 12 − 5 = 7.")+
   U("Working out 'how much more do I need' when you already have part of the money uses this step."),
   [("x = 17","That comes from adding 12 + 5; transposing +5 means you SUBTRACT, giving 7."),
    ("x = 60","That is 12 × 5; the operation is subtraction, not multiplication, so x = 7."),
    ("x = 5","x = 5 ignores the 12; correctly, x = 12 − 5 = 7.")]),

 ("SE","The solution of the equation 3x = 15 is:",
   "x = 5",
   C("Divide both sides by 3: x = 15 ÷ 3 = 5.")+
   steps("3x = 15","Divide both sides by 3","x = 15 ÷ 3 = 5.")+
   U("Splitting a 15-rupee cost equally among 3 friends is the same division."),
   [("x = 45","That is 15 × 3; to undo a multiplication you DIVIDE, giving x = 5."),
    ("x = 12","That is 15 − 3; the 3 multiplies x, so you divide, getting x = 5."),
    ("x = 18","That is 15 + 3; you must divide by 3 instead, so x = 5.")]),

 ("SE","If x ÷ 4 = 3, then the value of x is:",
   "x = 12",
   C("Multiply both sides by 4: x = 3 × 4 = 12.")+
   steps("x ÷ 4 = 3","Undo the division by multiplying by 4","x = 3 × 4 = 12.")+
   U("If 4 equal glasses hold 3 units each, the jug held 12 — the same reasoning."),
   [("x = 7","That is 3 + 4; to undo a division you MULTIPLY, so x = 12."),
    ("x = 0.75","That is 3 ÷ 4; here you multiply instead, giving x = 12."),
    ("x = 1","x = 1 does not satisfy 1 ÷ 4 = 3; the correct value is 12.")]),

 ("SE","Solving 2x + 3 = 11 gives:",
   "x = 4",
   C("First take 3 to the right, then divide by 2: 2x = 8, so x = 4.")+
   steps("2x + 3 = 11","Transpose +3: 2x = 11 − 3 = 8","Divide by 2: x = 8 ÷ 2 = 4.")+
   U("Working back from a total bill that includes a fixed charge plus equal items uses these two steps."),
   [("x = 7","That stops at 2x = 14 by adding; you must subtract 3 first, giving x = 4."),
    ("x = 4.5","That comes from 9 ÷ 2 (subtracting only 2); subtract 3 first to get x = 4."),
    ("x = 16","That is 8 × 2; after 2x = 8 you DIVIDE by 2, giving x = 4.")]),

 ("SE","'Five less than a number is 9.' Written as an equation this is x − 5 = 9, and the number is:",
   "x = 14",
   C("'Five less than a number' is x − 5; set it equal to 9 and transpose: x = 9 + 5 = 14.")+
   steps("Five less than x → x − 5","x − 5 = 9","Transpose −5: x = 9 + 5 = 14.")+
   U("Turning a word puzzle like this into an equation is how detectives turn clues into answers."),
   [("x = 4","That is 9 − 5; to undo −5 you ADD 5, giving x = 14."),
    ("x = 45","That is 9 × 5; the operation is addition, so x = 14."),
    ("x = 9","x = 9 ignores the 'five less'; correctly x = 9 + 5 = 14.")]),

 ("SE","An equation works like a balance: whatever you do to one side, you must:",
   "do exactly the same to the other side",
   balance("LHS","RHS")+
   C("An equation is a balanced see-saw; to keep it balanced you treat both sides alike.")+
   steps("Both sides start equal","Add, subtract, multiply or divide one side","Do the same to the other so the balance is kept.")+
   U("A pan balance stays level only if you add or remove the same weight from both pans."),
   [("change only the left side","Changing one side alone tips the balance; both sides must be treated the same."),
    ("ignore the right side","Ignoring a side breaks the equality; the same operation must hit both sides."),
    ("multiply the left and divide the right","Different operations on the two sides destroy the balance, so this is wrong.")]),

 ("SE","The equation 5x − 2 = 13 has the solution:",
   "x = 3",
   C("Add 2 to both sides, then divide by 5: 5x = 15, x = 3.")+
   steps("5x − 2 = 13","Transpose −2: 5x = 13 + 2 = 15","Divide by 5: x = 15 ÷ 5 = 3.")+
   U("Reversing 'multiply then subtract' to find the starting number is exactly this."),
   [("x = 2.2","That comes from 11 ÷ 5 (subtracting 2); you must ADD 2 first, giving x = 3."),
    ("x = 11","That stops at 5x = 11; correctly 5x = 15, so x = 3."),
    ("x = 75","That is 15 × 5; after 5x = 15 you DIVIDE by 5, getting x = 3.")]),

 ("SE","To check that x = 6 solves x + 4 = 10, you should:",
   "put 6 in place of x and see if both sides are equal",
   C("Checking a solution means substituting it back and confirming the two sides match.")+
   steps("Replace x by 6 in the equation","Left side: 6 + 4 = 10","Right side is 10, so both match — the solution checks out.")+
   U("Re-adding your shopping items to confirm a total is the same idea: substitute and verify."),
   [("rub out the equation and start again","You verify by substituting, not by erasing the equation."),
    ("change the 10 to a 6","Altering the equation defeats the purpose; you substitute x = 6 instead."),
    ("add 6 and 10 together","Checking means substituting x = 6, not adding 6 to the right side.")]),

 ("SE","Solving the equation 2(x + 3) = 14 gives:",
   "x = 4",
   C("Divide both sides by 2 to get x + 3 = 7, then transpose: x = 4.")+
   steps("2(x + 3) = 14","Divide by 2: x + 3 = 7","Transpose +3: x = 7 − 3 = 4.")+
   U("Finding the size of each share when equal groups, each enlarged by a fixed amount, total a number uses this."),
   [("x = 7","That stops at x + 3 = 7; you must still subtract 3, giving x = 4."),
    ("x = 11","That comes from 14 − 3 without dividing first; divide by 2, so x = 4."),
    ("x = 8","That is 14 ÷ 2 + 1; correctly x + 3 = 7 gives x = 4.")]),

 ("SE","The value of x in x/2 + 1 = 5 is:",
   "x = 8",
   C("Take 1 to the right (x/2 = 4), then multiply by 2: x = 8.")+
   steps("x/2 + 1 = 5","Transpose +1: x/2 = 5 − 1 = 4","Multiply by 2: x = 4 × 2 = 8.")+
   U("Doubling back from 'half of it plus one' to the whole amount uses these steps."),
   [("x = 4","That stops at x/2 = 4; you must still multiply by 2, giving x = 8."),
    ("x = 12","That comes from (5+1)×2; you SUBTRACT 1 first, so x = 8."),
    ("x = 10","That is 5 × 2 with the +1 ignored; correctly x = 8.")]),

 ("SE","If 9 = x + 4, then the value of x is:",
   "x = 5",
   C("Transpose +4 to the left: x = 9 − 4 = 5. The equals sign works both ways.")+
   steps("9 = x + 4","Transpose +4: x = 9 − 4","x = 5.")+
   U("Reading an equation 'backwards' is fine because both sides of '=' are equal."),
   [("x = 13","That is 9 + 4; to undo +4 you SUBTRACT, giving x = 5."),
    ("x = 36","That is 9 × 4; the operation is subtraction, so x = 5."),
    ("x = 9","x = 9 ignores the +4; correctly x = 9 − 4 = 5.")]),

 ("SE","'I think of a number, multiply it by 4, and get 28.' The number is found from 4x = 28, giving:",
   "x = 7",
   C("Divide both sides by 4: x = 28 ÷ 4 = 7.")+
   steps("Let the number be x","Multiplying by 4 gives 4x = 28","Divide by 4: x = 28 ÷ 4 = 7.")+
   U("Turning a 'think of a number' trick into 4x = 28 is how you reveal the secret number."),
   [("x = 32","That is 28 + 4; to undo a multiplication you DIVIDE, so x = 7."),
    ("x = 112","That is 28 × 4; you must divide by 4 instead, giving x = 7."),
    ("x = 24","That is 28 − 4; the 4 multiplies x, so divide to get x = 7.")]),

 ("SE","The perimeter of a square is 4 times its side. If the perimeter is 36 cm, the side x is found from 4x = 36, so:",
   "x = 9 cm",
   C("Perimeter of a square is 4 × side, so 4x = 36 gives x = 9 cm.")+
   steps("Perimeter = 4 × side → 4x = 36","Divide both sides by 4","x = 36 ÷ 4 = 9 cm.")+
   U("Knowing the fence length around a square plot, you find one side by dividing by 4."),
   [("x = 32 cm","That is 36 − 4; you divide by 4 instead, giving 9 cm."),
    ("x = 144 cm","That is 36 × 4; the side is 36 ÷ 4 = 9 cm."),
    ("x = 18 cm","That is half of 36 (as if a rectangle); a square's side is 36 ÷ 4 = 9 cm.")]),

 ("SE","'The sum of a number and twice the number is 21.' This becomes x + 2x = 21, so the number is:",
   "x = 7",
   C("Combine like terms: x + 2x = 3x = 21, so x = 7.")+
   steps("x + 2x = 3x","3x = 21","Divide by 3: x = 21 ÷ 3 = 7.")+
   U("Adding a base amount and double-the-amount, then splitting back, is a common money puzzle."),
   [("x = 21","x = 21 ignores combining; 3x = 21 gives x = 7."),
    ("x = 10.5","That is 21 ÷ 2; you have 3x, not 2x, so x = 7."),
    ("x = 63","That is 21 × 3; you DIVIDE by 3, getting x = 7.")]),

 ("SE","Three consecutive whole numbers add up to 18. Taking them as x, x+1, x+2, the smallest number x is:",
   "x = 5",
   C("Add them: x + (x+1) + (x+2) = 3x + 3 = 18, so 3x = 15 and x = 5.")+
   steps("Sum = x + (x+1) + (x+2) = 3x + 3","3x + 3 = 18 → 3x = 15","x = 15 ÷ 3 = 5, so the numbers are 5, 6, 7.")+
   U("Sharing 18 sweets as three numbers in a row (5, 6, 7) uses this set-up."),
   [("x = 6","6 is the MIDDLE number; the smallest is 5 (5 + 6 + 7 = 18)."),
    ("x = 9","x = 9 would make the sum far above 18; correctly x = 5."),
    ("x = 4","4 + 5 + 6 = 15, not 18; the correct smallest number is 5.")]),

 ("SE","Solving 6x = 0 gives:",
   "x = 0",
   C("Dividing both sides by 6: x = 0 ÷ 6 = 0. Anything times zero is zero.")+
   steps("6x = 0","Divide both sides by 6","x = 0 ÷ 6 = 0.")+
   U("If 6 equal baskets hold nothing in total, each holds zero — the same logic."),
   [("x = 6","x = 6 would give 6 × 6 = 36, not 0; the answer is x = 0."),
    ("x = 1","x = 1 gives 6, not 0; only x = 0 makes 6x = 0."),
    ("x = −6","x = −6 gives −36, not 0; the solution is x = 0.")]),

 ("SE","A fusion question. In a neutralisation, 1 spoon of base neutralises 2 spoons of acid. If 2x spoons of acid are exactly neutralised by 5 spoons of base, then forming 2x = 10 gives:",
   "x = 5",
   C("Each spoon of base neutralises 2 spoons of acid, so 5 spoons neutralise 10 spoons of acid; thus 2x = 10 and x = 5.")+
   steps("5 spoons of base neutralise 5 × 2 = 10 spoons of acid","So 2x = 10","Divide by 2: x = 5.")+
   U("Chemists use exactly this kind of ratio equation to mix acid and base in the right amounts."),
   [("x = 10","x = 10 stops at 2x = 10 without dividing; correctly x = 5."),
    ("x = 20","That is 10 × 2; you DIVIDE by 2, getting x = 5."),
    ("x = 2.5","That is 5 ÷ 2; here 2x = 10 gives x = 5, not 2.5.")]),

 ("SE","A fusion question. A weather station notes that today's maximum temperature is 7 °C higher than the minimum. If the maximum is 31 °C, the minimum t comes from t + 7 = 31, so:",
   "t = 24 °C",
   C("The minimum plus 7 equals the maximum, so t + 7 = 31 and t = 31 − 7 = 24 °C.")+
   steps("Minimum + 7 = maximum → t + 7 = 31","Transpose +7: t = 31 − 7","t = 24 °C.")+
   U("Newspapers list a city's max and min; the gap between them is found by exactly this subtraction."),
   [("t = 38 °C","That is 31 + 7; to undo +7 you SUBTRACT, giving 24 °C."),
    ("t = 7 °C","t = 7 ignores the maximum of 31; correctly t = 31 − 7 = 24 °C."),
    ("t = 31 °C","31 °C is the maximum, not the minimum; the minimum is 24 °C.")]),

 ("SE","To clear the fraction in (2x)/3 = 4, you first:",
   "multiply both sides by 3",
   C("Multiplying both sides by 3 removes the denominator, giving 2x = 12.")+
   steps("(2x)/3 = 4","Multiply both sides by 3: 2x = 12","Then divide by 2: x = 6.")+
   U("Clearing a denominator first keeps the working tidy, like scaling up a recipe before measuring."),
   [("subtract 3 from both sides","Subtracting does not remove a denominator; you multiply by 3 instead."),
    ("divide both sides by 3","Dividing by 3 keeps the fraction; multiplying by 3 clears it."),
    ("add 3 to both sides","Adding 3 does not cancel the divide-by-3; multiplying by 3 does.")]),

 ("SE","A father is 4 times as old as his son. If the son is x years old and the father is 36, then 4x = 36 gives the son's age as:",
   "x = 9 years",
   C("The father's age is 4 × son's age, so 4x = 36 and x = 9 years.")+
   steps("Father = 4 × son → 4x = 36","Divide by 4","x = 36 ÷ 4 = 9 years.")+
   U("Age puzzles in quizzes are solved by turning the words into a simple equation like this."),
   [("x = 32 years","That is 36 − 4; to undo a multiplication you DIVIDE, giving 9."),
    ("x = 40 years","That is 36 + 4; the son is younger, x = 36 ÷ 4 = 9 years."),
    ("x = 144 years","That is 36 × 4; you divide by 4, so x = 9 years.")]),

 ("SE","The equation 7x − 3x = 20 simplifies first to 4x = 20, so:",
   "x = 5",
   C("Combine like terms: 7x − 3x = 4x, so 4x = 20 and x = 5.")+
   steps("7x − 3x = 4x","4x = 20","Divide by 4: x = 5.")+
   U("Combining like terms before solving is like grouping similar coins before counting."),
   [("x = 2","That is 20 ÷ 10 (treating it as 10x); 7x − 3x = 4x, so x = 5."),
    ("x = 80","That is 20 × 4; after 4x = 20 you DIVIDE, getting x = 5."),
    ("x = 20","x = 20 ignores the 4; correctly 4x = 20 gives x = 5.")]),

 ("SE","Which of the following is a correct equation (not just an expression)?",
   "3x − 1 = 8",
   C("An equation must contain an equals sign joining two equal expressions.")+
   steps("Look for the '=' sign","'3x − 1 = 8' has it, equating two sides","So it is a genuine equation, unlike the others.")+
   U("A balance scale needs two pans; an equation needs two sides joined by '='."),
   [("3x − 1","This has no equals sign, so it is only an expression, not an equation."),
    ("5 + 2x","Without an '=' this is just an expression, not an equation."),
    ("7x","A single term like 7x has no equals sign and so is not an equation.")]),

 ("SE","After solving an equation you find x = 3. Substituting back into 2x + 1 should give:",
   "7, confirming the solution",
   C("Substitute x = 3: 2 × 3 + 1 = 7. If this matches the right side, the solution is confirmed.")+
   steps("Put x = 3 into 2x + 1","2 × 3 + 1 = 6 + 1 = 7","A matching value of 7 confirms x = 3 is correct.")+
   U("Re-checking an answer by plugging it back is a habit that catches mistakes in exams."),
   [("5","2 × 3 + 1 = 7, not 5; the value 5 would come from 2 × 2 + 1."),
    ("9","9 would need x = 4 (2×4+1); with x = 3 the value is 7."),
    ("3","3 just repeats x; substituting into 2x + 1 gives 7.")]),

 ("SE","Five identical pens cost 60 rupees altogether. Writing 5x = 60, the cost of one pen x is:",
   "x = 12 rupees",
   C("The total cost is 5 × (price of one pen), so 5x = 60 and x = 12 rupees.")+
   steps("5 pens cost 60 → 5x = 60","Divide both sides by 5","x = 60 ÷ 5 = 12 rupees.")+
   U("Working out a single item's price from the cost of a bundle is exactly this division."),
   [("x = 65 rupees","That is 60 + 5; to undo a multiplication you DIVIDE, giving 12."),
    ("x = 300 rupees","That is 60 × 5; one pen costs 60 ÷ 5 = 12 rupees, not 300."),
    ("x = 55 rupees","That is 60 − 5; the 5 multiplies x, so divide to get 12 rupees.")]),
]

# ---------- SYMMETRY (25) — Maths ----------
SY = [
 ("SY","A line that divides a figure into two identical halves that are mirror images is called a:",
   "line of symmetry",
   C("A line of symmetry splits a shape so one half exactly mirrors the other.")+
   steps("Fold the figure along the line","Both halves land exactly on top of each other","Such a fold line is a line of symmetry.")+
   U("Folding a paper heart down the middle to check it matches uses a line of symmetry."),
   [("diagonal only","A diagonal is just a corner-to-corner line; it is a line of symmetry only if the halves mirror."),
    ("number line","A number line places numbers in order; it has nothing to do with mirror halves."),
    ("perimeter","Perimeter is the distance around a shape, not a folding line that mirrors halves.")]),

 ("SY","The number of lines of symmetry in a square is:",
   "4",
   C("A square has 4 lines of symmetry: 2 through the midpoints of opposite sides and 2 along the diagonals.")+
   steps("Two lines join midpoints of opposite sides","Two lines run along the diagonals","Together that makes 4 lines of symmetry.")+
   U("A square floor tile looks the same when flipped across any of these 4 lines."),
   [("2","2 is the count for a (non-square) rectangle; a square has 4."),
    ("1","1 line is too few; a square has 4 lines of symmetry."),
    ("0","A square is highly symmetric and has 4 lines, not 0.")]),

 ("SY","A rectangle that is not a square has exactly how many lines of symmetry?",
   "2",
   C("A rectangle has 2 lines of symmetry — through the midpoints of each pair of opposite sides.")+
   steps("One line joins the midpoints of the long sides","One joins the midpoints of the short sides","The diagonals do NOT mirror it, so there are 2 in all.")+
   U("A rectangular door panel matches itself when flipped about its vertical or horizontal centre line."),
   [("4","4 lines belong to a square; a plain rectangle has only 2 because its diagonals do not mirror."),
    ("1","A rectangle has 2 lines of symmetry, not just 1."),
    ("0","A rectangle is symmetric across 2 lines, so 0 is wrong.")]),

 ("SY","An equilateral triangle (all sides equal) has how many lines of symmetry?",
   "3",
   C("An equilateral triangle has 3 lines of symmetry, one from each vertex to the midpoint of the opposite side.")+
   steps("Each line runs from a corner to the middle of the opposite side","There are 3 corners","So there are 3 lines of symmetry.")+
   U("A triangular road-sign with equal sides looks the same when flipped about any of its 3 lines."),
   [("1","1 line belongs to an isosceles (only two equal sides) triangle; an equilateral has 3."),
    ("2","An equilateral triangle has 3 lines of symmetry, not 2."),
    ("0","A scalene triangle has 0 lines, but an equilateral one has 3.")]),

 ("SY","The number of lines of symmetry in a circle is:",
   "infinite (countless)",
   C("Every line through the centre of a circle is a line of symmetry, so there are infinitely many.")+
   steps("Draw any line through the centre","It splits the circle into two matching halves","Since there are countless such lines, the count is infinite.")+
   U("A round plate looks identical no matter which way you flip it across its centre."),
   [("only 2","A circle has far more than 2; any line through its centre works, so the count is infinite."),
    ("4","4 is the square's count; a circle has infinitely many lines of symmetry."),
    ("0","A circle is the most symmetric shape, with infinitely many lines, not 0.")]),

 ("SY","An isosceles triangle (exactly two equal sides) has how many lines of symmetry?",
   "1",
   C("An isosceles triangle has just 1 line of symmetry, running down from the apex between the two equal sides.")+
   steps("The two equal sides meet at the apex","One line drops from the apex to the base's midpoint","That single line mirrors the triangle — just 1.")+
   U("A simple kite-like roof gable, with two equal slopes, has this one vertical line of symmetry."),
   [("3","3 lines belong to an equilateral triangle; an isosceles one has only 1."),
    ("2","An isosceles triangle has just 1 line of symmetry, not 2."),
    ("0","A scalene triangle has 0, but an isosceles one has 1.")]),

 ("SY","Among the capital letters A, H, and S, the one that has NO line of symmetry is:",
   "S",
   C("A and H have lines of symmetry, but S has none; instead S has rotational symmetry.")+
   steps("A has a vertical line of symmetry","H has both vertical and horizontal lines","S cannot be folded onto itself, so it has no line of symmetry.")+
   U("Designers know that letters like S need rotational, not mirror, balance in a logo."),
   [("A","A has a vertical line of symmetry, so it is not the letter without one."),
    ("H","H has two lines of symmetry, so it does have line symmetry."),
    ("both A and H","Both A and H have lines of symmetry; only S has none.")]),

 ("SY","The capital letter H has how many lines of symmetry?",
   "2",
   C("H can be folded both vertically and horizontally onto itself, giving 2 lines of symmetry.")+
   steps("A vertical fold matches the two uprights","A horizontal fold matches top and bottom","So H has 2 lines of symmetry.")+
   U("The letter H on a sign reads the same flipped left-right or top-bottom because of these 2 lines."),
   [("1","H has 2 lines (vertical AND horizontal), not just 1."),
    ("0","H is symmetric in two ways, so it does not have 0 lines."),
    ("4","H has only 2 lines of symmetry; 4 would suit a square, not the letter H.")]),

 ("SY","The number of times a figure looks exactly the same as it is turned once around (through 360°) is called its:",
   "order of rotational symmetry",
   C("The order of rotational symmetry counts how many times a shape matches itself in one full turn.")+
   steps("Turn the figure one full circle (360°)","Count how often it looks unchanged","That count is the order of rotational symmetry.")+
   U("A car wheel's hub with equally spaced spokes has an order equal to the number of spokes."),
   [("line of symmetry","A line of symmetry is about folding, not about turning a figure around."),
    ("perimeter","Perimeter is the distance around a shape, not a count of matching turns."),
    ("angle of rotation","The angle is how far you turn each time; the ORDER is how many matches occur in a full turn.")]),

 ("SY","A square is turned about its centre through a full circle. Its order of rotational symmetry is:",
   "4",
   C("A square looks the same after every 90° turn, so it matches itself 4 times in 360°.")+
   steps("Turn the square 90° — it looks the same","Each 90° turn gives a match: 90°, 180°, 270°, 360°","That is 4 matches, so the order is 4.")+
   U("A square table looks identical after each quarter-turn — order 4."),
   [("2","2 is a rectangle's order; a square matches 4 times, so its order is 4."),
    ("1","Order 1 means no real rotational symmetry; a square has order 4."),
    ("8","A square matches every 90°, giving 4 matches in 360°, not 8.")]),

 ("SY","A rectangle (not a square) turned about its centre has rotational symmetry of order:",
   "2",
   C("A rectangle looks the same after a half-turn (180°) and after a full turn, so its order is 2.")+
   steps("Turn the rectangle 180° — it looks the same","Turn it another 180° to complete 360°","That is 2 matches, so the order is 2.")+
   U("A rectangular photo frame looks identical after a half-turn — order 2."),
   [("4","4 is a square's order; a plain rectangle only matches twice, so order 2."),
    ("1","A rectangle does match after a half-turn, so its order is 2, not 1."),
    ("0","Rotational order is at least 1; a rectangle's is 2, never 0.")]),

 ("SY","For a square, the smallest angle by which it can be turned so that it looks the same is:",
   "90°",
   C("A square's order of rotational symmetry is 4, so the smallest matching turn is 360° ÷ 4 = 90°.")+
   steps("Order of rotational symmetry is 4","Smallest angle = 360° ÷ order","360° ÷ 4 = 90°.")+
   U("Turning a square tile a quarter-turn (90°) leaves the pattern looking unchanged."),
   [("45°","45° would need order 8; a square has order 4, so the angle is 90°."),
    ("180°","180° is the rectangle's smallest matching turn; a square matches sooner, at 90°."),
    ("360°","360° is a full turn for any shape; a square already matches at 90°.")]),

 ("SY","A regular hexagon (six equal sides) has how many lines of symmetry?",
   "6",
   C("A regular polygon with n sides has n lines of symmetry, so a regular hexagon has 6.")+
   steps("For a regular n-sided polygon, lines of symmetry = n","Here n = 6","So a regular hexagon has 6 lines of symmetry.")+
   U("A hexagonal nut or a honeycomb cell has 6 lines of symmetry."),
   [("3","3 lines belong to an equilateral triangle; a regular hexagon has 6."),
    ("4","4 lines belong to a square; a regular hexagon has 6."),
    ("12","A regular hexagon has 6 lines, equal to its number of sides, not 12.")]),

 ("SY","A fusion question. A real snowflake very often shows the same pattern repeating every 60° as it is turned. Its order of rotational symmetry is therefore:",
   "6",
   C("If the snowflake matches itself every 60°, then 360° ÷ 60° = 6, so its order is 6.")+
   steps("It matches after each 60° turn","Count the matches in a full turn: 360° ÷ 60°","That gives 6 — an order of 6, the famous six-fold snowflake symmetry.")+
   U("Photographs of snowflakes almost always show this beautiful six-fold symmetry from how ice crystals grow."),
   [("3","Matching every 60° gives 360 ÷ 60 = 6 matches, not 3."),
    ("4","A six-fold snowflake matches every 60°, giving order 6, not 4."),
    ("60","60 is the angle in degrees, not the order; the order is 360 ÷ 60 = 6.")]),

 ("SY","A fusion question. A butterfly with its wings spread looks the same on its left and right halves. The kind of symmetry a butterfly clearly shows is:",
   "line (mirror) symmetry, with a vertical line down the middle",
   C("A butterfly's two wings mirror each other across a vertical line down its body — line symmetry.")+
   steps("Imagine a vertical line down the butterfly's body","The left wing mirrors the right wing","So it has line (mirror) symmetry.")+
   U("Many living things — leaves, faces, butterflies — show this left–right mirror symmetry."),
   [("no symmetry at all","A butterfly's matching wings clearly show mirror symmetry, so 'none' is wrong."),
    ("rotational symmetry of order 4","Wings mirror left-right; they do not repeat every quarter-turn like order 4."),
    ("infinite lines of symmetry","Only a vertical line mirrors a butterfly; it does not have countless lines like a circle.")]),

 ("SY","A triangle whose three sides are all of different lengths (a scalene triangle) has lines of symmetry numbering:",
   "0",
   C("Because no two sides match, a scalene triangle cannot be folded onto itself, so it has 0 lines of symmetry.")+
   steps("All three sides differ","No fold makes the halves match","So there are 0 lines of symmetry.")+
   U("A randomly shaped triangular off-cut of paper has no line that folds it onto itself."),
   [("1","1 line needs at least two equal sides (isosceles); a scalene triangle has 0."),
    ("3","3 lines belong to an equilateral triangle; a scalene one has 0."),
    ("2","A scalene triangle has no matching sides, so 0 lines, not 2.")]),

 ("SY","A regular pentagon (five equal sides) has lines of symmetry numbering:",
   "5",
   C("A regular polygon with n sides has n lines of symmetry, so a regular pentagon has 5.")+
   steps("Lines of symmetry of a regular n-gon = n","Here n = 5","So a regular pentagon has 5 lines of symmetry.")+
   U("The 5-pointed star and the regular pentagon both carry 5 lines of symmetry."),
   [("4","4 lines belong to a square; a regular pentagon has 5."),
    ("10","A regular pentagon has 5 lines, equal to its sides, not 10."),
    ("0","A regular pentagon is symmetric with 5 lines, so 0 is wrong.")]),

 ("SY","The mirror image of a shape across a line is also called its:",
   "reflection",
   C("Flipping a shape across a line produces its reflection — a mirror image.")+
   steps("Place a mirror along the line","The shape on the other side is the flipped image","That image is called a reflection.")+
   U("Your image in a flat mirror is a reflection, with left and right swapped."),
   [("rotation","A rotation turns a shape about a point; a reflection flips it across a line."),
    ("translation","A translation slides a shape without flipping; that is not a mirror image."),
    ("enlargement","An enlargement changes size; a reflection keeps size but flips the shape.")]),

 ("SY","The capital letter O is usually treated as having:",
   "two lines of symmetry (and high rotational symmetry)",
   C("A printed O (an oval/circle) can be folded vertically and horizontally, giving 2 lines of symmetry.")+
   steps("Fold O top-to-bottom — it matches","Fold O left-to-right — it matches","So a printed O has 2 lines of symmetry.")+
   U("Because O is so symmetric, it reads the same upside-down in many fonts."),
   [("no lines of symmetry","O is highly symmetric; it has at least 2 lines, not 0."),
    ("exactly one line of symmetry","O matches both vertically and horizontally, so it has 2 lines, not 1."),
    ("three lines of symmetry","A printed O has 2 main lines of symmetry, not 3.")]),

 ("SY","A fusion question. A starfish commonly has five arms spaced evenly around its centre. Turning it, the order of its rotational symmetry is:",
   "5",
   C("Five evenly spaced arms mean the starfish matches itself every 72°, giving order 360° ÷ 72° = 5.")+
   steps("Five equal arms are spaced 360° ÷ 5 = 72° apart","It matches itself after each 72° turn","So its order of rotational symmetry is 5.")+
   U("This five-fold symmetry of starfish and many flowers is common in nature."),
   [("2","Five equal arms give order 5, not 2 (which suits a rectangle)."),
    ("4","Four-fold symmetry suits a square; a five-armed starfish has order 5."),
    ("72","72 is the turning angle in degrees, not the order; the order is 360 ÷ 72 = 5.")]),

 ("SY","A general parallelogram (like a leaning rhombus that is not a rectangle) usually has lines of symmetry numbering:",
   "0, but it has rotational symmetry of order 2",
   C("A slanted parallelogram cannot be folded onto itself, so 0 lines, yet a half-turn maps it onto itself (order 2).")+
   steps("Try folding it — no fold makes the halves match: 0 lines","Turn it 180° about its centre — it looks the same","So lines = 0 but rotational order = 2.")+
   U("A leaning parallelogram road sign has no fold line but looks the same after a half-turn."),
   [("2 lines of symmetry","Those 2 lines belong to a rectangle; a slanted parallelogram has 0 fold lines."),
    ("4 lines of symmetry","4 lines belong to a square; a general parallelogram has none."),
    ("0 lines and no rotational symmetry","It does have rotational symmetry of order 2, from the half-turn.")]),

 ("SY","The smallest angle of rotation that brings an equilateral triangle onto itself is:",
   "120°",
   C("An equilateral triangle has rotational order 3, so the smallest matching turn is 360° ÷ 3 = 120°.")+
   steps("Order of rotational symmetry = 3","Smallest angle = 360° ÷ 3","360° ÷ 3 = 120°.")+
   U("A three-bladed fan, evenly spaced, also looks the same after each 120° turn."),
   [("60°","60° would need order 6; an equilateral triangle has order 3, so 120°."),
    ("90°","90° is the square's smallest turn; the triangle's is 120°."),
    ("360°","360° is a full turn; the triangle already matches at 120°.")]),

 ("SY","For any regular polygon, the number of its lines of symmetry is always equal to:",
   "the number of its sides",
   C("A regular polygon with n equal sides has exactly n lines of symmetry.")+
   steps("Equilateral triangle (3 sides) → 3 lines","Square (4 sides) → 4 lines","In general, a regular n-gon has n lines of symmetry.")+
   U("Spotting that a regular shape's lines of symmetry equal its sides is a quick exam shortcut."),
   [("twice the number of sides","A regular n-gon has n lines, not 2n; e.g. a square has 4, not 8."),
    ("always four","Only a square has 4; a regular pentagon has 5 and a hexagon has 6."),
    ("zero","Regular polygons are very symmetric; they have n lines, not 0.")]),

 ("SY","A figure is said to have rotational symmetry only if its order of rotational symmetry is:",
   "more than 1",
   C("Every shape returns to itself after a full 360° turn, so true rotational symmetry needs an order greater than 1.")+
   steps("A full 360° turn always matches any shape (that is order 1, the trivial case)","Real rotational symmetry needs an extra match before 360°","So the order must be more than 1.")+
   U("A plain scalene triangle has order 1 (only the full turn matches), so it has no real rotational symmetry."),
   [("exactly 1","Order 1 is the trivial full-turn match every shape has; real symmetry needs order more than 1."),
    ("equal to 0","Rotational order is never 0; the lowest meaningful value is more than 1."),
    ("a fraction","Order is a whole-number count of matches, never a fraction.")]),

 ("SY","A kite, which has two pairs of equal adjacent sides, has how many lines of symmetry?",
   "1",
   C("A kite has a single line of symmetry, running along the diagonal between its two pairs of equal sides.")+
   steps("The two pairs of equal sides meet along one diagonal","Folding along that diagonal makes the halves match","No other fold works, so a kite has exactly 1 line of symmetry.")+
   U("A real flying kite is built about this one central line so it balances in the wind."),
   [("2","2 lines belong to a rectangle or rhombus; a kite has just 1 along its main diagonal."),
    ("4","4 lines belong to a square; a kite has only 1 line of symmetry."),
    ("0","A kite does have one fold line of symmetry, so 0 is wrong.")]),
]

assert len(AB) == 25 and len(WE) == 25 and len(SE) == 25 and len(SY) == 25

# Interleave so no two consecutive questions share a chapter; Science/Maths alternate.
items = []
for i in range(25):
    items += [AB[i], SE[i], WE[i], SY[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=20533,
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
    split = "/".join(str(counts[c]) for c in ("AB", "SE", "WE", "SY"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Acids, Bases & Salts",
                     "Weather, Climate & Adaptations",
                     "Simple Equations", "Symmetry"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
