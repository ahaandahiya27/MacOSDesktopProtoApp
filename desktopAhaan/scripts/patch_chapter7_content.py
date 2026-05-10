#!/usr/bin/env python3
"""Idempotent patch for Chapter 7 (Weather, Climate and Adaptations of Animals
to Climate) — expands useCases, adds new concepts, adds T03, wires
bidirectional cross-chapter links, bumps version."""

import json, os, sys, copy

PACK_PATH = os.path.join(os.path.dirname(__file__), "..",
    "Subjects", "Packs", "science_class7.json")

TARGET_VERSION = "0.27.0-ch07-full"

ALLOWED_DOMAINS = {
    "home", "kitchen", "weather", "human body", "animals", "sport",
    "technology", "industry", "travel", "science", "building",
    "agriculture", "transport", "clothing"
}

# ─── additional useCases for existing concepts ──────────────────────────

EXTRA_USE_CASES = {
    "ch07_t01_c01": [
        {"title": "Packing clothes for a holiday", "description": "You check the weather forecast for the next few days, but you pack based on the climate of the destination — tropical places need light cotton, cold regions need woolens.", "domain": "clothing"},
        {"title": "Choosing crops for a region", "description": "Farmers choose crops based on climate, not daily weather. Rice grows in hot, humid climates; wheat in cooler, drier ones.", "domain": "agriculture"},
        {"title": "Building design in hot vs cold climates", "description": "Houses in hot climates have thick walls and small windows to stay cool; cold-climate houses have insulated walls and large south-facing windows.", "domain": "building"},
        {"title": "Weather apps vs climate atlases", "description": "A weather app tells you if it will rain tomorrow. A climate atlas tells you that Mumbai gets heavy rain every July — one is short-term, the other long-term.", "domain": "technology"},
        {"title": "Sports scheduling and climate", "description": "Cricket Test matches in England are scheduled in summer because the climate is dry and warm. Daily weather can still cause rain delays.", "domain": "sport"},
        {"title": "Desert climate and solar panels", "description": "Solar farms are built in desert climates because the long-term pattern shows over 300 sunny days per year, even if one day is cloudy.", "domain": "technology"},
        {"title": "Airlines and seasonal routes", "description": "Airlines add extra flights to hill stations in summer because the hot-plain climate drives tourists to cooler regions every year.", "domain": "travel"},
    ],
    "ch07_t01_c02": [
        {"title": "Why Shimla is cooler than Delhi", "description": "Altitude shapes climate. Shimla sits at 2200 m where air is thinner and cooler, while Delhi on the plains bakes in summer heat.", "domain": "travel"},
        {"title": "Coastal cities have mild winters", "description": "The sea absorbs and releases heat slowly, so Mumbai (coastal) has milder winters than Nagpur (inland) at the same latitude.", "domain": "weather"},
        {"title": "Rain shadow of the Western Ghats", "description": "The western side of the Ghats gets heavy rain; the eastern side is dry. Mountains force moist air up, squeezing out rain before it crosses.", "domain": "weather"},
        {"title": "Latitude and the length of day", "description": "Near the equator, days and nights are almost equal year-round. Near the poles, summers have nearly 24 hours of sunlight, shaping a very different climate.", "domain": "science"},
        {"title": "Ocean currents warm the UK", "description": "The Gulf Stream carries warm water from the tropics to Britain, giving it a milder climate than Labrador in Canada at the same latitude.", "domain": "travel"},
        {"title": "Forest cover reduces local temperature", "description": "Dense forests release moisture and provide shade, keeping the local climate 2-3 degrees C cooler than nearby deforested areas.", "domain": "agriculture"},
        {"title": "Urbanisation creates heat islands", "description": "Concrete and asphalt in cities absorb heat, making city centres 3-5 degrees C warmer than surrounding countryside — an urban heat island.", "domain": "building"},
    ],
    "ch07_t01_c03": [
        {"title": "Rain gauge in the school garden", "description": "A simple rain gauge — a graduated cylinder left outdoors — measures how many millimetres of rain fell overnight.", "domain": "science"},
        {"title": "Maximum-minimum thermometer", "description": "This thermometer records the highest and lowest temperature each day, helping weather stations track daily temperature range.", "domain": "technology"},
        {"title": "Wind vane on a rooftop", "description": "A wind vane points into the wind, showing direction. Farmers use it to predict whether moist sea air or dry land air is approaching.", "domain": "agriculture"},
        {"title": "Anemometer at an airport", "description": "Pilots need wind speed data before landing. Anemometers at airports spin in the wind; the faster the spin, the higher the wind speed.", "domain": "transport"},
        {"title": "Humidity and hair frizz", "description": "A hygrometer measures humidity. On high-humidity days the reading is above 80 percent and hair absorbs moisture and frizzes.", "domain": "home"},
        {"title": "Weather balloon for upper atmosphere", "description": "Weather balloons carry instruments called radiosondes up to 30 km, sending back temperature, pressure, and humidity data.", "domain": "science"},
        {"title": "Satellite images for cyclone tracking", "description": "Weather satellites photograph cloud patterns from space, letting meteorologists track cyclones and warn coastal communities.", "domain": "technology"},
    ],
}

# ─── new concepts to add ─────────────────────────────────────────────

NEW_T01_CONCEPTS = [
    {
        "id": "ch07_t01_c04",
        "title": "The Water Cycle and Weather Patterns",
        "explanations": {
            "oneLine": "The water cycle — evaporation, condensation, and precipitation — drives all weather patterns on Earth.",
            "kidFriendly": "The sun heats water in oceans and rivers, turning it into invisible water vapour that rises. High up, the vapour cools and forms clouds. When the droplets get heavy enough, they fall as rain or snow. This cycle repeats endlessly and creates the weather we experience every day!",
            "textbook": "The hydrological cycle involves evaporation from water bodies, transpiration from plants, condensation into clouds, and precipitation as rain, snow, or hail. Differential heating of the Earth's surface creates pressure gradients that drive winds, which transport moisture and shape regional weather patterns.",
            "expert": "The water cycle transfers approximately 505,000 km cubed of water annually through the atmosphere. Latent heat released during condensation is a primary driver of atmospheric convection and storm development. Hadley, Ferrel, and polar cells redistribute this energy latitudinally, establishing prevailing wind belts and precipitation zones."
        },
        "useCases": [
            {"title": "Puddles disappearing on a sunny day", "description": "Sunlight heats the puddle water, turning it into water vapour (evaporation). The puddle shrinks and eventually vanishes.", "domain": "home"},
            {"title": "Fog on a cold winter morning", "description": "At night the ground cools the air near it below its dew point. Water vapour condenses into tiny droplets, forming fog.", "domain": "weather"},
            {"title": "Clouds forming over mountains", "description": "Moist air is forced upward by a mountain. As it rises it cools, water vapour condenses, and a cloud cap forms over the peak.", "domain": "travel"},
            {"title": "Dew on grass at dawn", "description": "Overnight, grass radiates heat and cools. Water vapour from the air condenses on the cold blades as dew drops.", "domain": "home"},
            {"title": "Monsoon rains in India", "description": "In summer, intense heating over the Indian landmass pulls in moisture-laden winds from the ocean, causing heavy monsoon rainfall.", "domain": "weather"},
            {"title": "Snowfall in the Himalayas", "description": "When moist air rises to very high altitudes where temperatures are below 0 degrees C, water vapour freezes into ice crystals and falls as snow.", "domain": "weather"},
            {"title": "Transpiration from forests", "description": "Trees release water vapour through tiny leaf pores (stomata). A single large tree can transpire hundreds of litres daily, adding moisture to the air.", "domain": "agriculture"},
            {"title": "Clothes drying on a clothesline", "description": "Wind and sun speed up evaporation from wet clothes. The water turns to vapour and joins the water cycle.", "domain": "home"},
            {"title": "Hailstorms damaging crops", "description": "Strong updrafts carry raindrops high into freezing air. Ice layers build up, and heavy hailstones fall, flattening standing crops.", "domain": "agriculture"},
            {"title": "Water harvesting from fog nets", "description": "In dry coastal deserts, large mesh nets catch tiny fog droplets. The collected water trickles into tanks — harvesting the water cycle directly.", "domain": "technology"},
        ],
        "relatedConceptIds": ["ch07_t01_c01", "ch07_t01_c02", "ch07_t01_c05"]
    },
    {
        "id": "ch07_t01_c05",
        "title": "Seasons — Why They Happen",
        "explanations": {
            "oneLine": "Seasons occur because the Earth's axis is tilted at 23.5 degrees, so different parts receive more or less sunlight as Earth orbits the sun.",
            "kidFriendly": "Earth spins on a tilted axis, like a top leaning to one side. As Earth goes around the sun, sometimes the northern half leans toward the sun (summer!) and sometimes away (winter!). That tilt is why we have hot and cold seasons.",
            "textbook": "The Earth's rotational axis is tilted at 23.5 degrees to the plane of its orbit. During the northern summer solstice, the Northern Hemisphere tilts toward the sun, receiving more direct sunlight and longer days. Six months later, it tilts away, producing winter. The equator experiences minimal seasonal variation.",
            "expert": "Axial obliquity of 23.44 degrees drives seasonal insolation variation. Perihelion currently occurs in January, slightly moderating Northern Hemisphere winters. Milankovitch cycles — precession (26,000 yr), obliquity (41,000 yr), and eccentricity (100,000 yr) — modulate long-term seasonal intensity and have paced Pleistocene glacial-interglacial cycles."
        },
        "useCases": [
            {"title": "Summer holidays and long days", "description": "In June, the Northern Hemisphere tilts toward the sun, giving India up to 14 hours of daylight — perfect for outdoor holidays.", "domain": "travel"},
            {"title": "Winter woolens come out in December", "description": "In December, India tilts away from the sun. Days are shorter and sunlight hits at a lower angle, so temperatures drop and we wear warm clothes.", "domain": "clothing"},
            {"title": "Rabi and kharif crop seasons", "description": "Indian farmers plant kharif crops (rice, maize) in the rainy summer season and rabi crops (wheat, mustard) in the cool winter season.", "domain": "agriculture"},
            {"title": "Opposite seasons in Australia", "description": "When it is summer in India (June), it is winter in Australia because the Southern Hemisphere is tilted away from the sun.", "domain": "travel"},
            {"title": "Midnight sun in the Arctic", "description": "In June, the North Pole tilts so far toward the sun that places above the Arctic Circle experience 24 hours of daylight.", "domain": "science"},
            {"title": "Cherry blossoms mark Japanese spring", "description": "As spring days lengthen and warm, cherry trees bloom. The blossom front moves north through Japan, tracked like a weather event.", "domain": "travel"},
            {"title": "Heating bills rise in winter", "description": "Shorter days and lower sun angles mean less solar heating. Homes need furnaces or heaters, and energy consumption spikes.", "domain": "home"},
            {"title": "Cricket season follows the sun", "description": "In England, cricket is played April-September (summer). In Australia, the season runs October-March — both follow their warm season.", "domain": "sport"},
            {"title": "Seasonal flu peaks in winter", "description": "Cold, dry winter air helps flu viruses survive longer outside the body, and people crowd indoors, spreading infection.", "domain": "human body"},
            {"title": "Equinox and equal day-night", "description": "On March 21 and September 23, the tilt is sideways to the sun. Day and night are nearly equal everywhere — the equinox.", "domain": "science"},
        ],
        "relatedConceptIds": ["ch07_t01_c01", "ch07_t01_c02", "ch07_t01_c04"]
    },
    {
        "id": "ch07_t01_c06",
        "title": "Climate Zones of India",
        "explanations": {
            "oneLine": "India has diverse climate zones — from the scorching Thar Desert to the freezing Himalayas to the tropical Kerala coast.",
            "kidFriendly": "India is like a climate supermarket! The Thar Desert is burning hot and dry, Kerala is hot and rainy, the Himalayas are icy cold, and the Northeast gets the most rain on Earth. All these different climates exist in one country because of mountains, seas, and latitude.",
            "textbook": "India's climate zones include: tropical wet (Western Ghats, Northeast), tropical dry (Deccan Plateau), arid (Thar Desert), humid subtropical (Indo-Gangetic Plain), and alpine (Himalayas). The monsoon system, Himalayan barrier, and peninsular shape create this remarkable diversity within 8-37 degrees N latitude.",
            "expert": "Koppen classification places India in Am (tropical monsoon), Aw (tropical savanna), BWh (hot desert), Cwa (humid subtropical), and ET/EF (tundra/ice cap) zones. The Himalayan orographic barrier prevents cold Central Asian air from penetrating south, while the monsoon trough position governs rainfall distribution across the subcontinent."
        },
        "useCases": [
            {"title": "Thar Desert and camel transport", "description": "The Thar receives less than 250 mm rain annually. Camels are ideal transport here because they tolerate extreme heat and need little water.", "domain": "transport"},
            {"title": "Kerala's backwater tourism", "description": "Kerala's tropical wet climate supports lush greenery, coconut palms, and a network of backwaters that attract tourists year-round.", "domain": "travel"},
            {"title": "Tea plantations in Assam", "description": "Assam's warm, humid, high-rainfall climate is ideal for tea. The region produces over half of India's tea.", "domain": "agriculture"},
            {"title": "Apple orchards in Kashmir", "description": "Kashmir's cool, temperate climate with cold winters provides the chilling hours apple trees need to fruit well.", "domain": "agriculture"},
            {"title": "Cherrapunji — wettest place on Earth", "description": "Cherrapunji in Meghalaya receives over 11,000 mm of rain a year. Moist Bay of Bengal winds are forced up the Khasi Hills, dumping rain.", "domain": "weather"},
            {"title": "Mud houses in Rajasthan", "description": "In the arid Thar region, thick mud walls keep interiors cool during 45 degree C summers and warm during cold desert nights.", "domain": "building"},
            {"title": "Ladakh — cold desert at 3500 m", "description": "Ladakh lies in the rain shadow of the Himalayas. It is dry like a desert but freezing cold, with temperatures dropping to minus 30 degrees C.", "domain": "travel"},
            {"title": "Sundarbans and mangrove climate", "description": "The Sundarbans' hot, humid, tidal climate supports the world's largest mangrove forest, home to the Bengal tiger.", "domain": "animals"},
            {"title": "Monsoon-dependent farming in the Gangetic plain", "description": "The Indo-Gangetic Plain relies on monsoon rains for rice and wheat. A weak monsoon means drought and food shortages.", "domain": "agriculture"},
            {"title": "Woolen industry in Ludhiana", "description": "Ludhiana is India's woolen knitwear capital, thriving because the humid subtropical climate creates strong winter demand for woolens.", "domain": "industry"},
        ],
        "relatedConceptIds": ["ch07_t01_c01", "ch07_t01_c02", "ch07_t01_c05"]
    },
    {
        "id": "ch07_t01_c07",
        "title": "Extreme Weather Events — Cyclones, Droughts, Floods",
        "explanations": {
            "oneLine": "Cyclones, droughts, and floods are extreme weather events that cause widespread damage to life and property.",
            "kidFriendly": "Sometimes weather goes extreme! Cyclones are giant spinning storms with fierce winds and heavy rain. Droughts mean no rain for weeks and crops dry up. Floods happen when too much rain falls too fast. All three can be very dangerous, which is why weather warnings are so important.",
            "textbook": "Tropical cyclones form over warm oceans (above 26.5 degrees C) as low-pressure systems with sustained winds exceeding 119 km/h. Droughts result from prolonged below-normal precipitation, often linked to El Nino. Floods occur when rainfall exceeds drainage capacity, exacerbated by deforestation and urbanisation.",
            "expert": "Cyclone intensity scales with sea surface temperature via the Carnot cycle analogy (potential intensity theory). Drought indices (PDSI, SPI) quantify precipitation deficits relative to climatological norms. Flood return periods are shifting under anthropogenic climate change, with extreme precipitation events increasing in frequency consistent with the Clausius-Clapeyron relation (~7% increase per degree C warming)."
        },
        "useCases": [
            {"title": "Cyclone warning systems save lives", "description": "Indian Meteorological Department tracks cyclones using satellites and issues warnings 72 hours in advance, enabling coastal evacuations.", "domain": "technology"},
            {"title": "Odisha super cyclone of 1999", "description": "Wind speeds exceeded 260 km/h, killing thousands. Since then, India built a strong cyclone shelter and warning network.", "domain": "weather"},
            {"title": "Drought and farmer distress", "description": "When monsoon rains fail, crops wither. Farmers lose income and cattle go without fodder — drought is India's most common natural disaster.", "domain": "agriculture"},
            {"title": "Mumbai floods from heavy rain", "description": "In July 2005, Mumbai received 944 mm of rain in 24 hours. Blocked drains and low-lying areas led to catastrophic flooding.", "domain": "weather"},
            {"title": "Flood-resistant houses on stilts", "description": "In Assam and Bihar, homes are built on raised platforms or stilts so that floodwater flows underneath without submerging the living area.", "domain": "building"},
            {"title": "Drought-resistant millet crops", "description": "Millets like bajra and jowar need very little water and survive droughts that destroy rice and wheat crops.", "domain": "agriculture"},
            {"title": "Cyclone shelters along the coast", "description": "Multi-purpose cyclone shelters in Odisha and Andhra Pradesh house thousands during storms and serve as community halls otherwise.", "domain": "building"},
            {"title": "Flood insurance for homes", "description": "In flood-prone areas, insurance companies assess risk using historical flood maps and charge higher premiums.", "domain": "home"},
            {"title": "El Nino and Indian drought", "description": "During El Nino years, warm Pacific waters weaken the Indian monsoon, often causing below-average rainfall and drought conditions.", "domain": "weather"},
            {"title": "Emergency kits for extreme weather", "description": "Families in cyclone-prone areas keep emergency kits with water, torch, first-aid, and important documents ready during the season.", "domain": "home"},
        ],
        "relatedConceptIds": ["ch07_t01_c01", "ch07_t01_c04", "ch07_t01_c06"]
    },
]

NEW_T02_CONCEPTS = [
    {
        "id": "ch07_t02_c01",
        "title": "Polar Adaptations — Surviving Extreme Cold",
        "explanations": {
            "oneLine": "Animals in polar regions survive extreme cold through thick fur, blubber, compact bodies, and behavioural strategies like huddling.",
            "kidFriendly": "Imagine living where it is minus 40 degrees C! Polar bears have thick white fur and a layer of fat (blubber) to stay warm. Penguins huddle together in groups to share body heat. These clever tricks help animals survive in the coldest places on Earth.",
            "textbook": "Polar adaptations include morphological features such as thick insulating fur or feathers, subcutaneous fat (blubber up to 10 cm in seals), compact body shape (reduced surface-area-to-volume ratio per Bergmann's rule), and counter-current heat exchange in extremities. Behavioural adaptations include huddling (emperor penguins) and seasonal migration.",
            "expert": "Allen's rule predicts reduced appendage size in cold climates to minimise heat loss. Counter-current vascular arrangements (rete mirabile) in cetacean flukes and penguin flippers maintain core temperature while allowing extremities to approach ambient temperature. Antifreeze glycoproteins in Antarctic notothenioid fish depress the freezing point of blood below minus 2 degrees C."
        },
        "useCases": [
            {"title": "Polar bear's white fur and black skin", "description": "Each hair is transparent and hollow, scattering light to appear white for camouflage. Underneath, black skin absorbs the sun's warmth.", "domain": "animals"},
            {"title": "Emperor penguin huddle", "description": "In Antarctic blizzards, thousands of penguins pack together. Birds on the outside slowly rotate inward, so everyone gets a turn in the warm centre.", "domain": "animals"},
            {"title": "Seal blubber as insulation", "description": "Seals have a blubber layer up to 10 cm thick. This fat insulates against icy water and stores energy for periods without food.", "domain": "animals"},
            {"title": "Arctic fox fur changes colour", "description": "The Arctic fox grows white fur in winter for snow camouflage and brown fur in summer to blend with rocks and tundra.", "domain": "animals"},
            {"title": "Snowy owl's feathered feet", "description": "The snowy owl has thick feathers covering its feet and toes, acting like warm boots that prevent heat loss on frozen ground.", "domain": "animals"},
            {"title": "Inspiration for thermal clothing", "description": "Winter jackets mimic polar animal adaptations: down feathers trap air for insulation, just like a penguin's plumage.", "domain": "clothing"},
            {"title": "Walrus tusks and ice holes", "description": "Walruses use their tusks to haul themselves onto ice floes and to maintain breathing holes in the ice — essential for survival.", "domain": "animals"},
            {"title": "Reindeer hooves change with seasons", "description": "In summer, reindeer hooves are spongy for grip on soft tundra. In winter, they shrink and harden, exposing sharp rims that grip ice.", "domain": "animals"},
            {"title": "Igloos trap body heat", "description": "Inuit people build igloos from snow blocks. Snow is a good insulator, and body heat inside can raise the temperature to 15 degrees C above outside.", "domain": "building"},
            {"title": "Antarctic krill — base of the food chain", "description": "Tiny krill survive in frigid water with antifreeze compounds. They feed whales, seals, and penguins — the entire polar ecosystem depends on them.", "domain": "animals"},
        ],
        "relatedConceptIds": ["ch07_t01_c01", "ch07_t02_c03", "ch07_t02_c05"]
    },
    {
        "id": "ch07_t02_c02",
        "title": "Tropical Adaptations — Life in Hot, Wet Forests",
        "explanations": {
            "oneLine": "Tropical rainforest animals adapt to heat and humidity with bright colours for signalling, long limbs for climbing, and nocturnal habits to avoid daytime heat.",
            "kidFriendly": "Tropical forests are warm, wet, and packed with life! Monkeys have long arms to swing through trees, toucans have huge beaks to reach fruit, and many animals are brightly coloured to warn predators or attract mates. Lots of creatures come out at night when it is cooler.",
            "textbook": "Tropical adaptations include prehensile tails and elongated limbs for arboreal locomotion, vivid aposematic colouration (poison dart frogs), broad leaves in canopy-dwellers for thermoregulation, and nocturnal or crepuscular activity patterns to avoid midday heat. High biodiversity drives intense competition, promoting specialisation.",
            "expert": "Tropical species exhibit narrow thermal tolerance (stenothermy) compared to temperate species, making them disproportionately vulnerable to warming. Janzen's hypothesis posits that low seasonality in the tropics leads to narrow physiological tolerances. Vertical stratification of the canopy creates distinct microclimates, each with specialised fauna operating within narrow thermal and humidity envelopes."
        },
        "useCases": [
            {"title": "Monkey's prehensile tail as a fifth hand", "description": "Spider monkeys wrap their strong tails around branches, freeing both hands to pick fruit high in the rainforest canopy.", "domain": "animals"},
            {"title": "Toucan's large beak radiates heat", "description": "A toucan's beak has many blood vessels. By increasing blood flow to the beak, it releases body heat like a radiator, keeping cool.", "domain": "animals"},
            {"title": "Poison dart frog's bright colours", "description": "Brilliant reds and blues warn predators: 'I am toxic!' This aposematic colouration keeps frogs safe without needing to fight.", "domain": "animals"},
            {"title": "Sloth's slow metabolism saves energy", "description": "Sloths move so slowly that algae grows on their fur, providing camouflage. Their low metabolism means they need very little food.", "domain": "animals"},
            {"title": "Tree frog's sticky toe pads", "description": "Tropical tree frogs have microscopic wet adhesion pads on their toes, letting them cling to smooth, rain-soaked leaves.", "domain": "animals"},
            {"title": "Chameleon's colour change for temperature", "description": "Chameleons darken their skin to absorb heat on cool mornings and lighten it to reflect heat during hot afternoons.", "domain": "animals"},
            {"title": "Nocturnal hunting by jungle cats", "description": "Leopards and jungle cats hunt at night when prey is active and the forest is cooler, using excellent night vision.", "domain": "animals"},
            {"title": "Epiphytic orchids grow on trees", "description": "Orchids perch on tree branches to reach sunlight in the dense canopy. Their aerial roots absorb moisture from humid tropical air.", "domain": "science"},
            {"title": "Tropical hardwoods in furniture", "description": "Teak and mahogany thrive in tropical climates. Their dense wood resists moisture and insects, making them prized for furniture.", "domain": "home"},
            {"title": "Cocoa farming in tropical climates", "description": "Cocoa trees need constant warmth (above 20 degrees C), high humidity, and rainfall over 1500 mm — found only in tropical zones.", "domain": "agriculture"},
        ],
        "relatedConceptIds": ["ch07_t01_c01", "ch07_t01_c06", "ch07_t02_c04"]
    },
    {
        "id": "ch07_t02_c03",
        "title": "Migration — The Long-Distance Solution",
        "explanations": {
            "oneLine": "Many animals migrate thousands of kilometres to find better weather, food, or breeding grounds when seasons change.",
            "kidFriendly": "When winter comes and food runs out, some animals go on an incredible journey! Arctic terns fly from the Arctic to Antarctica and back — the longest migration of any animal. Birds, whales, and even butterflies travel thousands of kilometres to find warm weather and food.",
            "textbook": "Migration is the seasonal movement of animals from one region to another in response to changes in climate, food availability, or breeding requirements. Navigation mechanisms include the Earth's magnetic field, star patterns, sun position, and visual landmarks. Migration is energetically costly but improves survival and reproductive success.",
            "expert": "Migratory species use a combination of magnetoreception (cryptochrome-based in birds), celestial cues, olfactory maps (salmon), and inherited genetic programmes (zugunruhe) to navigate. Optimal migration theory balances energy expenditure against fitness gains. Climate change is causing phenological mismatches between migration timing and peak resource availability."
        },
        "useCases": [
            {"title": "Siberian cranes at Bharatpur", "description": "Every winter, Siberian cranes fly over 5000 km to Keoladeo National Park in Rajasthan, escaping the harsh Siberian cold.", "domain": "animals"},
            {"title": "Arctic tern — pole to pole", "description": "The Arctic tern migrates from Arctic to Antarctic and back each year — about 70,000 km — chasing endless summer.", "domain": "animals"},
            {"title": "Monarch butterfly migration", "description": "Millions of monarch butterflies fly 4000 km from Canada to Mexico each autumn. No single butterfly makes the return trip; their grandchildren do.", "domain": "animals"},
            {"title": "Wildebeest crossing the Serengeti", "description": "Over a million wildebeest migrate in a loop across the Serengeti, following the rains to fresh grazing — the greatest land migration.", "domain": "animals"},
            {"title": "Salmon swimming upstream", "description": "Pacific salmon hatch in freshwater rivers, migrate to the ocean to grow, then return to the exact same river to breed and die.", "domain": "animals"},
            {"title": "Whale migration for breeding", "description": "Humpback whales feed in cold polar waters in summer, then migrate to warm tropical seas in winter to give birth.", "domain": "animals"},
            {"title": "Bird-watching tourism in India", "description": "Migratory birds like flamingos and pelicans attract thousands of tourists to wetlands such as Chilika Lake, boosting local economies.", "domain": "travel"},
            {"title": "GPS tracking of migratory birds", "description": "Scientists attach tiny GPS tags to birds to map exact migration routes, stopover sites, and flight altitudes.", "domain": "technology"},
            {"title": "Flyways and aircraft safety", "description": "Major bird migration routes (flyways) cross busy airports. Bird-strike risk increases during migration season, requiring radar monitoring.", "domain": "transport"},
            {"title": "Climate change shifting migration routes", "description": "Warmer winters mean some birds now overwinter closer to their breeding grounds, shortening traditional migration routes.", "domain": "weather"},
        ],
        "relatedConceptIds": ["ch07_t01_c05", "ch07_t02_c01", "ch07_t02_c05"]
    },
    {
        "id": "ch07_t02_c04",
        "title": "Desert Adaptations — Camels, Foxes, and Scorpions",
        "explanations": {
            "oneLine": "Desert animals survive scorching days and scarce water with features like water-storing humps, large ears for cooling, and nocturnal lifestyles.",
            "kidFriendly": "Deserts are super hot during the day and cold at night, with almost no water. Camels store fat in their humps for energy and can go weeks without drinking. Fennec foxes have huge ears that work like radiators to release heat. Most desert animals hide underground during the day and come out at night when it is cool.",
            "textbook": "Desert adaptations include physiological water conservation (concentrated urine in kangaroo rats, metabolic water production), morphological features (large ears in fennec foxes for heat dissipation via vasodilation, long legs to raise bodies above hot sand), and behavioural strategies (burrowing, nocturnality, aestivation). The camel's hump stores fat, not water, but metabolising fat produces metabolic water.",
            "expert": "Desert mammals exhibit renal adaptations including elongated loops of Henle for maximal water reabsorption, producing urine concentrated up to 9000 mOsm/kg in some rodents. Countercurrent nasal heat exchange recovers moisture from exhaled air. Ectotherms like scorpions reduce metabolic water loss via book lungs with spiracles that open only during gas exchange."
        },
        "useCases": [
            {"title": "Camel's hump stores fat, not water", "description": "The hump is a mound of fat that provides energy. When metabolised, fat also releases water — about 1 g of water per gram of fat.", "domain": "animals"},
            {"title": "Fennec fox's giant ears", "description": "The fennec fox's oversized ears are full of blood vessels. Blood flowing through them releases heat to the air, keeping the fox cool.", "domain": "animals"},
            {"title": "Scorpion glows under UV light", "description": "Scorpions are nocturnal, hiding under rocks by day. Their exoskeleton contains a substance that fluoresces under ultraviolet light.", "domain": "animals"},
            {"title": "Kangaroo rat never drinks water", "description": "The kangaroo rat gets all its water from dry seeds it eats. Its kidneys produce extremely concentrated urine to conserve every drop.", "domain": "animals"},
            {"title": "Desert lizard's sand dance", "description": "The shovel-snouted lizard lifts alternate feet off scorching sand in a 'thermal dance' to avoid burning its toes.", "domain": "animals"},
            {"title": "Cactus wren nests in spiny cacti", "description": "By building nests among sharp cactus spines, the wren protects its eggs from predators like snakes in the open desert.", "domain": "animals"},
            {"title": "Solar panels inspired by desert beetles", "description": "The Namib beetle collects fog on its bumpy back. Engineers mimicked its surface to design water-collecting coatings for solar panels.", "domain": "technology"},
            {"title": "Camel caravans for desert trade", "description": "For centuries, camels carried goods across the Sahara and Thar deserts. Their ability to go days without water made long trade routes possible.", "domain": "transport"},
            {"title": "Loose flowing robes in desert cultures", "description": "People in desert regions wear loose, light-coloured clothing that reflects sunlight and allows air circulation, mimicking animal cooling strategies.", "domain": "clothing"},
            {"title": "Desert agriculture with drip irrigation", "description": "Israel's drip irrigation wastes almost no water, allowing farming in the Negev Desert — humans adapting like desert animals to conserve water.", "domain": "agriculture"},
        ],
        "relatedConceptIds": ["ch07_t01_c06", "ch07_t02_c02", "ch07_t02_c05"]
    },
    {
        "id": "ch07_t02_c05",
        "title": "Hibernation and Aestivation — Sleeping Through Extremes",
        "explanations": {
            "oneLine": "Some animals survive harsh seasons by entering a deep sleep — hibernation in winter cold, aestivation in summer heat.",
            "kidFriendly": "What if you could sleep through the worst weather? Bears hibernate all winter, slowing their heartbeat and living off stored fat. Some frogs do the opposite — they sleep through hot, dry summers (called aestivation) buried in cool mud. Sleeping through bad times saves energy when there is no food.",
            "textbook": "Hibernation is a state of torpor characterised by drastically reduced metabolic rate, heart rate, breathing, and body temperature, enabling survival through winter food scarcity. Aestivation is a similar dormancy during hot, dry periods. Both involve pre-dormancy fat accumulation and hormonal regulation of metabolic suppression.",
            "expert": "Hibernation involves regulated hypothermia to near-ambient temperatures (as low as minus 2.9 degrees C in Arctic ground squirrels using supercooling). Metabolic rate may drop to 2-5 percent of basal levels. Brown adipose tissue generates non-shivering thermogenesis during periodic arousals. Aestivating lungfish secrete a mucus cocoon and switch to urea-based nitrogen excretion to survive months of desiccation."
        },
        "useCases": [
            {"title": "Bear hibernation through winter", "description": "Brown bears eat heavily in autumn, then hibernate for 5-7 months. Their heart rate drops from 40 to 8 beats per minute.", "domain": "animals"},
            {"title": "Frog buries itself in mud for aestivation", "description": "Indian bullfrogs burrow into moist mud during the hot dry summer, emerging only when monsoon rains arrive.", "domain": "animals"},
            {"title": "Lungfish survives dried-up ponds", "description": "When African rivers dry up, lungfish burrow into the mud and secrete a mucus cocoon, sleeping for months until water returns.", "domain": "animals"},
            {"title": "Hedgehog hibernation in European gardens", "description": "Hedgehogs build leaf nests and hibernate through cold European winters, their body temperature dropping to near 5 degrees C.", "domain": "animals"},
            {"title": "Ground squirrel and medical research", "description": "Scientists study how ground squirrels hibernate without muscle wasting. This could help develop treatments for astronauts' muscle loss in space.", "domain": "science"},
            {"title": "Ladybird beetles cluster for winter", "description": "Thousands of ladybirds gather in sheltered spots and enter a dormant state, conserving energy until spring warmth returns.", "domain": "animals"},
            {"title": "Snail seals its shell in dry weather", "description": "Land snails secrete a hardened mucus plug (epiphragm) over their shell opening during dry spells, preventing water loss.", "domain": "animals"},
            {"title": "Hibernation and food storage in kitchens", "description": "Just as bears fatten up before winter, humans historically preserved and stored food (pickling, drying) to survive scarce winter months.", "domain": "kitchen"},
            {"title": "Torpor in hummingbirds overnight", "description": "Hummingbirds enter nightly torpor, dropping body temperature by 20 degrees C to save energy when they cannot feed in the dark.", "domain": "animals"},
            {"title": "Crocodile aestivation in drought", "description": "In Australia, freshwater crocodiles dig burrows in riverbanks and aestivate during the dry season, waiting for rains to refill the rivers.", "domain": "animals"},
        ],
        "relatedConceptIds": ["ch07_t02_c01", "ch07_t02_c04", "ch07_t02_c03"]
    },
]

NEW_T03 = {
    "id": "ch07_t03",
    "title": "Climate change and animal survival",
    "concepts": [
        {
            "id": "ch07_t03_c01",
            "title": "Climate Change and Wildlife — Shifting Habitats",
            "explanations": {
                "oneLine": "As global temperatures rise, many animals are forced to move to cooler regions or higher altitudes, disrupting ecosystems.",
                "kidFriendly": "The Earth is slowly getting warmer because of extra greenhouse gases. This means animals that like cold weather have to move higher up mountains or closer to the poles. Some animals cannot move fast enough and get stuck in places that are now too hot for them.",
                "textbook": "Anthropogenic climate change is causing range shifts in many species — poleward at approximately 17 km per decade and upslope at 11 m per decade on average. Species with limited dispersal ability or specialised habitat requirements face population decline or extinction. Phenological mismatches occur when predator-prey or plant-pollinator timing shifts unevenly.",
                "expert": "Meta-analyses (Parmesan & Yohe 2003, Chen et al. 2011) document consistent range shifts across taxonomic groups. Climate velocity — the speed at which isotherms move across landscapes — exceeds dispersal rates for many species, particularly in flat terrain. Assisted migration and wildlife corridors are debated conservation strategies to facilitate range shifts."
            },
            "useCases": [
                {"title": "Pikas retreating uphill", "description": "American pikas, small mountain mammals, are moving to higher elevations as lower slopes become too warm. Some peaks are already too low.", "domain": "animals"},
                {"title": "Polar bears and shrinking sea ice", "description": "Polar bears hunt seals on sea ice. As Arctic ice melts earlier each spring, bears have less time to hunt and face starvation.", "domain": "animals"},
                {"title": "Butterflies moving north in Europe", "description": "Many European butterfly species have shifted their ranges northward by 35-240 km in just two decades as temperatures rise.", "domain": "animals"},
                {"title": "Cherry blossom timing in Japan", "description": "Kyoto's cherry blossoms now bloom 10 days earlier than 50 years ago. Animals that depend on flower timing must adjust or suffer.", "domain": "science"},
                {"title": "Penguin colonies shrinking in Antarctica", "description": "Adelie penguin populations have declined by 65 percent on the Antarctic Peninsula as warming reduces the sea ice they need for breeding.", "domain": "animals"},
                {"title": "Tree line creeping upward", "description": "In the Himalayas, the tree line is moving to higher altitudes. This squeezes alpine meadow habitat where snow leopards and marmots live.", "domain": "agriculture"},
                {"title": "Mosquitoes spreading to new areas", "description": "Warmer temperatures allow disease-carrying mosquitoes to survive at higher altitudes and latitudes, bringing malaria to new regions.", "domain": "human body"},
                {"title": "Coral reef fish losing homes", "description": "As reefs die from warming, the thousands of fish species that depend on coral for food and shelter must relocate or perish.", "domain": "animals"},
                {"title": "Wildlife corridors between parks", "description": "Conservationists create forested corridors between national parks so animals can migrate to newly suitable habitat as climates shift.", "domain": "travel"},
                {"title": "Farmers adjusting crops as zones shift", "description": "As climate zones move, crops that once thrived in a region may fail. Farmers must switch to heat-tolerant varieties.", "domain": "agriculture"},
            ],
            "relatedConceptIds": ["ch07_t01_c01", "ch07_t01_c07", "ch07_t03_c02"]
        },
        {
            "id": "ch07_t03_c02",
            "title": "Coral Bleaching — When Oceans Get Too Warm",
            "explanations": {
                "oneLine": "When sea temperatures rise even 1-2 degrees C above normal, corals expel the colourful algae living inside them, turning white and often dying.",
                "kidFriendly": "Corals look like colourful underwater rocks, but they are actually tiny animals! Inside each coral live tiny colourful algae that give them food and colour. When the water gets too warm, the coral gets stressed and kicks out the algae, turning ghostly white. Without the algae, the coral starves.",
                "textbook": "Coral bleaching occurs when thermal stress causes corals to expel their symbiotic zooxanthellae (dinoflagellate algae of genus Symbiodinium). These algae provide up to 90 percent of the coral's energy through photosynthesis. Sustained bleaching leads to coral death, reef collapse, and loss of biodiversity that depends on the reef structure.",
                "expert": "Bleaching thresholds are typically 1 degree C above the maximum monthly mean SST sustained for 4 or more weeks (Degree Heating Weeks metric). Reactive oxygen species produced by heat-stressed zooxanthellae trigger the expulsion response. Reef recovery requires 10-15 years without repeated stress, but the increasing frequency of marine heatwaves (2016, 2017, 2020, 2024 events on the GBR) prevents full recovery between episodes."
            },
            "useCases": [
                {"title": "Great Barrier Reef mass bleaching", "description": "In 2016 and 2017, back-to-back marine heatwaves bleached two-thirds of the Great Barrier Reef, the worst event ever recorded.", "domain": "animals"},
                {"title": "Clownfish lose their anemone homes", "description": "Bleached reefs lose anemones. Clownfish, which depend on anemones for protection, become homeless and vulnerable to predators.", "domain": "animals"},
                {"title": "Loss of reef tourism income", "description": "Coral reefs attract snorkelers and divers worldwide. Bleaching reduces reef beauty and biodiversity, cutting tourism revenue.", "domain": "travel"},
                {"title": "Reef fish nurseries vanish", "description": "Many commercially important fish species use healthy coral reefs as nurseries. Bleaching destroys these breeding grounds.", "domain": "industry"},
                {"title": "Coral reefs protect coastlines", "description": "Healthy reefs break wave energy, protecting shores from erosion and storm surges. Dead reefs crumble, leaving coasts exposed.", "domain": "building"},
                {"title": "Artificial reefs as a solution", "description": "Scientists sink concrete structures to provide new surfaces for coral larvae to attach. Some are electrified to boost coral growth.", "domain": "technology"},
                {"title": "Heat-resistant coral breeding", "description": "Researchers crossbreed corals from warmer waters with local species to produce more heat-tolerant offspring for reef restoration.", "domain": "science"},
                {"title": "Lakshadweep coral bleaching in India", "description": "India's Lakshadweep islands experienced severe coral bleaching during the 2016 El Nino event, threatening local fisheries.", "domain": "weather"},
                {"title": "Mangroves buffer reefs from warm runoff", "description": "Coastal mangroves filter warm, sediment-laden runoff before it reaches reefs, reducing thermal and chemical stress on corals.", "domain": "science"},
                {"title": "Citizen science reef monitoring", "description": "Volunteer divers photograph reefs and upload data to global databases, helping scientists track bleaching events in real time.", "domain": "technology"},
            ],
            "relatedConceptIds": ["ch07_t03_c01", "ch07_t03_c03", "ch07_t01_c01"]
        },
        {
            "id": "ch07_t03_c03",
            "title": "Conservation — Helping Animals Survive a Changing World",
            "explanations": {
                "oneLine": "Conservation efforts — protected areas, breeding programmes, habitat restoration — help animals cope with climate change and human activity.",
                "kidFriendly": "Animals need our help! We can protect forests so animals have homes, create national parks where hunting is banned, breed endangered animals in zoos and release them into the wild, and plant trees to cool the planet. Every little action helps animals survive in a changing world.",
                "textbook": "Conservation strategies include in-situ measures (national parks, wildlife sanctuaries, biosphere reserves) and ex-situ measures (captive breeding, seed banks, zoos). Wildlife corridors connect fragmented habitats. International agreements like CITES regulate trade in endangered species. Community-based conservation involves local people in protecting biodiversity.",
                "expert": "The IUCN Red List framework classifies species by extinction risk using criteria based on population size, rate of decline, and range fragmentation. The 30x30 target (protecting 30 percent of land and sea by 2030) aims to safeguard biodiversity hotspots. Landscape-level conservation planning uses species distribution models under climate projections to identify future refugia and connectivity corridors."
            },
            "useCases": [
                {"title": "Project Tiger in India", "description": "Launched in 1973, Project Tiger established reserves across India. Tiger numbers have recovered from 1800 to over 3000 thanks to habitat protection.", "domain": "animals"},
                {"title": "Breeding programme for snow leopards", "description": "Zoos worldwide participate in coordinated breeding programmes for snow leopards, maintaining genetic diversity for future wild releases.", "domain": "animals"},
                {"title": "Mangrove restoration along coastlines", "description": "Planting mangroves protects coasts from cyclones, sequesters carbon, and creates nurseries for fish, crabs, and birds.", "domain": "agriculture"},
                {"title": "Wildlife corridors in the Western Ghats", "description": "Forested corridors between fragmented reserves allow elephants, tigers, and other wildlife to move safely between habitats.", "domain": "animals"},
                {"title": "Reducing plastic waste to save sea turtles", "description": "Sea turtles mistake plastic bags for jellyfish. Beach cleanups and plastic bans directly reduce turtle deaths.", "domain": "animals"},
                {"title": "Community forest guards in Rajasthan", "description": "Local Bishnoi communities have protected wildlife for centuries. They guard blackbuck and trees as part of their cultural tradition.", "domain": "animals"},
                {"title": "CITES bans ivory trade", "description": "The global ban on ivory trade under CITES has helped reduce elephant poaching, though enforcement remains a challenge.", "domain": "industry"},
                {"title": "Vulture conservation and Diclofenac ban", "description": "India banned the veterinary drug Diclofenac after it caused a 99 percent decline in vulture populations. Numbers are slowly recovering.", "domain": "science"},
                {"title": "Green roofs cool cities for urban wildlife", "description": "Planting vegetation on rooftops reduces urban heat, provides habitat for insects and birds, and combats the heat island effect.", "domain": "building"},
                {"title": "Carbon footprint reduction at home", "description": "Using public transport, saving electricity, and eating less meat all reduce greenhouse gas emissions, slowing climate change for wildlife.", "domain": "home"},
            ],
            "relatedConceptIds": ["ch07_t03_c01", "ch07_t03_c02", "ch07_t02_c03"]
        }
    ],
    "questions": [
        {
            "id": "ch07_t03_q01",
            "type": "mcq",
            "prompt": "What happens to many animal species as global temperatures rise?",
            "options": ["They grow larger", "They shift their range toward poles or higher altitudes", "They become nocturnal", "They develop thicker fur"],
            "answer": "They shift their range toward poles or higher altitudes",
            "explanation": "As temperatures increase, many species move poleward or to higher elevations to stay within their preferred temperature range."
        },
        {
            "id": "ch07_t03_q02",
            "type": "mcq",
            "prompt": "Coral bleaching is caused by:",
            "options": ["Pollution from plastic", "A rise in sea temperature of just 1-2 degrees C", "Overfishing near reefs", "Freshwater mixing with seawater"],
            "answer": "A rise in sea temperature of just 1-2 degrees C",
            "explanation": "When sea temperature rises even slightly above normal, corals expel their symbiotic algae (zooxanthellae), turning white and losing their energy source."
        },
        {
            "id": "ch07_t03_q03",
            "type": "mcq",
            "prompt": "Which is an example of an in-situ conservation method?",
            "options": ["Keeping animals in a zoo", "Storing seeds in a seed bank", "Establishing a national park", "Breeding animals in captivity"],
            "answer": "Establishing a national park",
            "explanation": "In-situ conservation means protecting species in their natural habitat. National parks and wildlife sanctuaries are prime examples."
        }
    ]
}

# ─── cross-chapter links ────────────────────────────────────────────────
CROSS_LINKS = {
    "ch07_t01_c04": ["ch06_t01_c01"],   # water cycle ↔ water (Ch6 topic)
    "ch07_t03_c01": ["ch04_t03_c02"],   # climate change & wildlife ↔ greenhouse effect (Ch4)
    "ch07_t03_c02": ["ch05_t03_c03"],   # coral bleaching ↔ ocean acidification (Ch5)
    "ch07_t02_c01": ["ch06_t02_c03"],   # polar adaptations ↔ states of water / ice (Ch6)
    "ch07_t01_c07": ["ch04_t03_c01"],   # extreme weather ↔ global warming (Ch4)
    "ch07_t03_c03": ["ch05_t02_c03"],   # conservation ↔ acid rain environmental damage (Ch5)
}

def main():
    with open(PACK_PATH, "r") as f:
        data = json.load(f)

    if data.get("version") == TARGET_VERSION:
        print(f"Already at {TARGET_VERSION} — validating only.")
        validate(data)
        return

    ch = next(c for c in data["chapters"] if c["id"] == "ch07")

    # 1. Expand useCases on existing concepts
    for topic in ch["topics"]:
        for concept in topic["concepts"]:
            cid = concept["id"]
            if cid in EXTRA_USE_CASES:
                existing_titles = {u["title"] for u in concept["useCases"]}
                for uc in EXTRA_USE_CASES[cid]:
                    if uc["title"] not in existing_titles:
                        concept["useCases"].append(uc)

    # 2. Add new concepts to T01
    t01 = next(t for t in ch["topics"] if t["id"] == "ch07_t01")
    existing_ids = {c["id"] for c in t01["concepts"]}
    for nc in NEW_T01_CONCEPTS:
        if nc["id"] not in existing_ids:
            t01["concepts"].append(nc)

    # 3. Add new concepts to T02
    t02 = next(t for t in ch["topics"] if t["id"] == "ch07_t02")
    existing_ids = {c["id"] for c in t02["concepts"]}
    for nc in NEW_T02_CONCEPTS:
        if nc["id"] not in existing_ids:
            t02["concepts"].append(nc)

    # 4. Add T03 if missing
    existing_topic_ids = {t["id"] for t in ch["topics"]}
    if "ch07_t03" not in existing_topic_ids:
        ch["topics"].append(NEW_T03)

    # 5. Wire cross-chapter links (bidirectional)
    all_concepts = {}
    for chapter in data["chapters"]:
        for topic in chapter["topics"]:
            for concept in topic["concepts"]:
                all_concepts[concept["id"]] = concept

    for src, targets in CROSS_LINKS.items():
        if src in all_concepts:
            for tgt in targets:
                src_refs = all_concepts[src].setdefault("relatedConceptIds", [])
                if tgt not in src_refs:
                    src_refs.append(tgt)
                if tgt in all_concepts:
                    tgt_refs = all_concepts[tgt].setdefault("relatedConceptIds", [])
                    if src not in tgt_refs:
                        tgt_refs.append(src)

    # 6. Bump version
    data["version"] = TARGET_VERSION

    with open(PACK_PATH, "w") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    print(f"Patched to {TARGET_VERSION}")

    validate(data)

def validate(data):
    ch = next(c for c in data["chapters"] if c["id"] == "ch07")
    errors = []

    all_ids = set()
    for chapter in data["chapters"]:
        for topic in chapter["topics"]:
            for concept in topic["concepts"]:
                all_ids.add(concept["id"])

    total_concepts = 0
    total_use_cases = 0
    for topic in ch["topics"]:
        for concept in topic["concepts"]:
            total_concepts += 1
            uc_count = len(concept.get("useCases", []))
            total_use_cases += uc_count

            # Check 4 explanation depths
            expl = concept.get("explanations", {})
            for key in ["oneLine", "kidFriendly", "textbook", "expert"]:
                if key not in expl:
                    errors.append(f"{concept['id']} missing explanation depth: {key}")

            # Check >= 10 useCases
            if uc_count < 10:
                errors.append(f"{concept['id']} has only {uc_count} useCases (need >= 10)")

            # Check no "medicine" domain
            for uc in concept.get("useCases", []):
                if uc.get("domain") == "medicine":
                    errors.append(f"{concept['id']} useCase '{uc['title']}' uses forbidden domain 'medicine'")

            # Check cross-refs resolve
            for ref in concept.get("relatedConceptIds", []):
                if ref not in all_ids:
                    errors.append(f"{concept['id']} references non-existent concept: {ref}")

    total_questions = sum(len(t.get("questions", [])) for t in ch["topics"])

    if errors:
        print(f"VALIDATION ERRORS ({len(errors)}):")
        for e in errors:
            print(f"  - {e}")
        sys.exit(1)
    else:
        print(f"Validation passed: {total_concepts} concepts, {total_use_cases} useCases, {total_questions} questions, {len(ch['topics'])} topics")

if __name__ == "__main__":
    main()
