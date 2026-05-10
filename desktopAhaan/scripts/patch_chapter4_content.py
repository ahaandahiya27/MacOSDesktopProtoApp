#!/usr/bin/env python3
"""Idempotent patch for Chapter 4 (Heat) — expands useCases, adds new concepts,
adds T03, wires bidirectional cross-chapter links, bumps version."""

import json, os, sys, copy

PACK_PATH = os.path.join(os.path.dirname(__file__), "..",
    "Subjects", "Packs", "science_class7.json")

TARGET_VERSION = "0.24.0-ch04-full"

# ─── canonical domain set ───────────────────────────────────────────────
ALLOWED_DOMAINS = {
    "home", "kitchen", "weather", "human body", "animals", "sport",
    "technology", "industry", "travel", "science", "building",
    "agriculture", "transport", "clothing"
}

# ─── additional useCases for existing concepts ──────────────────────────

EXTRA_USE_CASES = {
    "ch04_t01_c01": [
        {"title": "Warm sweater on a cold day", "description": "A sweater does not make heat. It traps body heat — your body is the source, the sweater is the insulator. Temperature tells you how warm, heat tells how much energy is stored.", "domain": "clothing"},
        {"title": "Why the desert is cold at night", "description": "Sand has low heat capacity — it heats quickly under the sun (high temperature) but holds little total heat, so it cools fast after sunset.", "domain": "weather"},
        {"title": "Feverish child vs warm bath", "description": "A child with 39 C fever has a higher temperature than a warm 36 C bath, yet the bath holds far more total heat energy because of the water mass.", "domain": "human body"},
        {"title": "Blacksmith's anvil", "description": "A heavy iron anvil stores enormous heat at the same temperature as a small nail because it has much more mass.", "domain": "industry"},
        {"title": "Penguins huddling", "description": "Penguins share body heat by huddling. Each penguin's temperature is the same, but the group's combined heat warms the air pocket between them.", "domain": "animals"},
        {"title": "Thermos of hot coffee on a hike", "description": "The thermos keeps the coffee temperature high by preventing heat from escaping — same temperature, preserved heat.", "domain": "travel"},
        {"title": "Cooking rice: big pot vs small pot", "description": "A big pot at 100 C holds more heat than a small pot at 100 C — the rice cooks the same in both but the big pot stays hot longer after the flame goes off.", "domain": "kitchen"},
    ],
    "ch04_t01_c02": [
        {"title": "Weather station thermometer", "description": "Outdoor thermometers in Stevenson screens measure air temperature using the expansion of a liquid in a calibrated glass tube.", "domain": "weather"},
        {"title": "Fish tank thermometer", "description": "Aquarium sticker thermometers use liquid crystals that change colour with temperature — a different expansion principle than mercury.", "domain": "home"},
        {"title": "Body temperature check at airports", "description": "Infrared thermometers at airports measure radiation emitted by your forehead — no contact needed.", "domain": "technology"},
        {"title": "Oven thermometer for baking", "description": "A metal coil inside an oven thermometer expands or contracts, moving the dial to show temperature — same expansion principle as a liquid thermometer.", "domain": "kitchen"},
        {"title": "Galileo thermometer on the shelf", "description": "Galileo's thermoscope used air expansion in a tube with water. Modern decorative versions use glass balls of different densities that sink or float.", "domain": "science"},
        {"title": "Dairy farmer checking milk temperature", "description": "Milk must be cooled below 4 C quickly after milking. Farmers use probe thermometers to check — the metal tip conducts heat fast for a quick reading.", "domain": "agriculture"},
        {"title": "Marathon runner's heat monitor", "description": "Some athletes swallow a tiny pill thermometer that radios core body temperature during a race — tracking heat stress in real time.", "domain": "sport"},
    ],
    "ch04_t01_c03": [
        {"title": "Absolute zero in the lab", "description": "At 0 Kelvin (-273.15 C) atoms nearly stop moving. Scientists have cooled atoms to within a billionth of a degree of absolute zero using laser cooling.", "domain": "science"},
        {"title": "Baking with Fahrenheit recipes", "description": "American cake recipes say 350 F — that is about 175 C. Knowing the conversion (F = 9/5 C + 32) prevents burnt desserts.", "domain": "kitchen"},
        {"title": "Arctic survival training", "description": "At -40, Celsius and Fahrenheit give the same number. Soldiers learn this fact in extreme-cold training so they can convert on the fly.", "domain": "travel"},
        {"title": "Room temperature in Kelvin", "description": "Comfortable room temperature (25 C) is 298 K. Scientists reporting experiments always use Kelvin because it starts at absolute zero — no negatives.", "domain": "science"},
        {"title": "Freezing pipes in winter", "description": "Water freezes at 0 C / 273 K / 32 F. Knowing conversions helps homeowners set heating to prevent burst pipes.", "domain": "home"},
        {"title": "Space shuttle tile design", "description": "Re-entry heats tiles to over 1,650 C (about 3,000 F / 1,920 K). Engineers switch between scales depending on the audience.", "domain": "technology"},
        {"title": "Cattle body temperature monitoring", "description": "Normal cattle body temperature is about 38.5 C (101.3 F). Vets in the US use Fahrenheit; Indian vets use Celsius.", "domain": "animals"},
    ],
    "ch04_t02_c01": [
        {"title": "Heated car seat", "description": "Electric wires inside the seat heat the fabric by conduction. Heat flows from the wire through the padding into your back.", "domain": "technology"},
        {"title": "Walking barefoot on hot sand", "description": "Sand grains conduct heat into the soles of your feet — painful evidence that solids transfer heat by conduction.", "domain": "travel"},
        {"title": "Branding livestock", "description": "A hot iron brand conducts heat into the animal's hide in seconds. The metal's high conductivity makes the transfer almost instant.", "domain": "agriculture"},
        {"title": "Ice-cream cone melting in your hand", "description": "Your warm hand conducts heat through the wafer cone to the ice-cream. The wafer is a poor conductor, slowing the melt.", "domain": "kitchen"},
        {"title": "Testing diamond vs glass with a thermal probe", "description": "Diamond conducts heat 5 times better than copper. Jewellers use thermal probes: a real diamond sucks heat away from the probe tip instantly.", "domain": "industry"},
        {"title": "Igloo walls", "description": "Compacted snow is a poor conductor — it traps air pockets. Inside an igloo the temperature can be 15 C warmer than outside.", "domain": "building"},
        {"title": "Handling a cricket bat in winter", "description": "A wooden bat feels warmer than a metal one at the same temperature because wood conducts less heat away from your hand.", "domain": "sport"},
    ],
    "ch04_t02_c02": [
        {"title": "Hot-air balloon", "description": "Heated air inside the balloon is less dense, so it rises. The balloon exploits convection to fly.", "domain": "travel"},
        {"title": "Radiator under a window", "description": "Hot air from the radiator rises, cold air from the window sinks, creating a convection loop that heats the room evenly.", "domain": "home"},
        {"title": "Thunderstorm formation", "description": "Sun heats the ground, warm moist air rises by convection, cools at altitude, and condenses into cumulonimbus clouds and rain.", "domain": "weather"},
        {"title": "Tandoori oven", "description": "In a tandoor, hot air rises and circulates around the naan stuck to the inner wall, cooking it evenly by convection.", "domain": "kitchen"},
        {"title": "Chimney draft", "description": "Hot smoke rises up the chimney by convection, pulling fresh air in through the fireplace opening — a natural ventilation loop.", "domain": "building"},
        {"title": "Ocean currents (Gulf Stream)", "description": "Warm tropical water flows north by convection on a planetary scale. The Gulf Stream keeps northern Europe warmer than expected.", "domain": "science"},
        {"title": "Cooling tower at a power plant", "description": "Hot water sprayed inside the tower heats the air, which rises by convection and exits the top, cooling the water.", "domain": "industry"},
    ],
    "ch04_t02_c03": [
        {"title": "Campfire warmth", "description": "Sit near a campfire and you feel warm on the side facing the fire — that is radiation. The far side stays cool because radiation travels in straight lines.", "domain": "travel"},
        {"title": "Dark-coloured car in summer", "description": "A black car absorbs more solar radiation than a white one. Its interior can reach 70 C on a sunny day.", "domain": "technology"},
        {"title": "Infrared security camera", "description": "Humans radiate infrared heat. Night-vision cameras detect this radiation to see people in total darkness.", "domain": "technology"},
        {"title": "Solar cooker", "description": "A parabolic mirror focuses the Sun's radiation onto a cooking pot. No fuel needed — pure radiative heating.", "domain": "kitchen"},
        {"title": "Sunburn on a cloudy day", "description": "UV radiation from the Sun passes through thin clouds. You can get sunburned even when you do not feel direct heat.", "domain": "human body"},
        {"title": "Reptiles basking on rocks", "description": "Lizards absorb solar radiation to raise their body temperature. They are ectotherms — they depend on radiative heating from the sun.", "domain": "animals"},
        {"title": "Earth radiating heat at night", "description": "After sunset, the Earth's surface radiates infrared energy into space. Clear nights are colder because clouds no longer reflect that radiation back.", "domain": "weather"},
    ],
}

# ─── new concepts ───────────────────────────────────────────────────────

NEW_CONCEPTS_T01 = [
    {
        "id": "ch04_t01_c04",
        "title": "Why Hot Things Cool Down (Newton's Law of Cooling, simplified)",
        "explanations": {
            "oneLine": "A hot object cools faster when it is much hotter than its surroundings, and slows down as it approaches room temperature.",
            "kidFriendly": "Think of a cup of hot chocolate left on the table. At first it cools really quickly — you can almost watch the steam disappear. But then it slows down and seems to stay lukewarm forever. That is because the bigger the temperature gap between the drink and the room, the faster heat escapes. As the gap shrinks, cooling slows. Isaac Newton noticed this pattern in 1701 and wrote it as a neat rule.",
            "textbook": "Newton's Law of Cooling states that the rate of loss of heat from a body is directly proportional to the difference in temperature between the body and its surroundings, provided the difference is small. Mathematically, dT/dt = -k(T - T_env), where T is the body temperature, T_env is the ambient temperature, and k is a constant. The law holds well for forced convection and moderate temperature differences but breaks down at very high temperatures where radiation dominates.",
            "expert": "Newton's empirical cooling law is a first-order linear ODE whose solution is an exponential decay: T(t) = T_env + (T_0 - T_env) e^{-kt}. The constant k depends on the surface area, emissivity, and the convective heat-transfer coefficient h. At high temperatures (e.g., molten steel), Stefan-Boltzmann radiative losses (proportional to T^4) dominate, and Newton's law underestimates the cooling rate. Modern CFD simulations couple convective and radiative terms for accurate predictions."
        },
        "reasoning": "The rate of heat loss depends on the temperature gradient. A large gap drives heat outward fast; as the gap narrows, the driving force weakens. It is like water flowing downhill — steep slopes mean fast flow.",
        "useCases": [
            {"title": "Hot chai cooling on the counter", "description": "Chai at 90 C cools rapidly at first (losing ~10 C in 5 minutes) then slows near room temperature.", "domain": "kitchen"},
            {"title": "Car engine cooling after a drive", "description": "An engine at 100 C cools quickly when parked in cool air; the last few degrees take much longer.", "domain": "technology"},
            {"title": "Forensic time of death estimation", "description": "Police use Newton's law to estimate when a body began cooling, helping determine time of death.", "domain": "science"},
            {"title": "Pizza delivery insulation", "description": "Insulated bags slow the k-constant, keeping pizza hotter for longer by reducing the cooling rate.", "domain": "industry"},
            {"title": "Cooling a baby's milk bottle", "description": "Running cold water over a hot bottle cools it faster because the temperature difference is large.", "domain": "home"},
            {"title": "Athletes in ice baths", "description": "An ice bath at 10 C cools a 38 C body faster than a 20 C pool — bigger temperature gap.", "domain": "sport"},
            {"title": "Hot-air balloon descent", "description": "When the burner is off, the air inside the balloon cools following Newton's law, causing slow descent.", "domain": "travel"},
            {"title": "Cooling freshly baked bricks", "description": "Kilns cool bricks slowly to prevent cracking; engineers calculate the cooling curve using Newton's law.", "domain": "building"},
            {"title": "Snake eggs incubating", "description": "If the nest temperature drops, eggs cool according to Newton's law. The hen python wraps around them to slow the rate.", "domain": "animals"},
            {"title": "Delhi summer night cooling", "description": "After a 45 C day, concrete buildings stay warm late into the night — slow cooling because the gap to 30 C air is only 15 degrees.", "domain": "weather"}
        ],
        "beyondTheBook": "NASA uses advanced cooling models based on Newton's law to predict how quickly spacecraft components cool in the shadow of the Earth during orbit. The International Space Station swings between -157 C in shadow and +121 C in sunlight every 90 minutes — getting the cooling math wrong could crack a solar panel.",
        "relatedConceptIds": ["ch04_t01_c01", "ch04_t01_c05", "ch04_t02_c03", "ch01_t01_c02"],
        "relatedQuestionIds": ["ch04_t01_q01"],
        "pageRefs": [34, 35],
        "needsHumanReview": False
    },
    {
        "id": "ch04_t01_c05",
        "title": "Temperature vs Heat — the Surprise Difference",
        "explanations": {
            "oneLine": "Temperature measures how hot something is; heat measures the total thermal energy it holds — two very different ideas.",
            "kidFriendly": "Imagine two cups of water, both at exactly 80 C. Cup A is tiny (50 ml), Cup B is huge (500 ml). They feel equally hot to a thermometer. But pour each into a cold bathtub — Cup B warms the bath much more because it carries 10 times more heat energy. Temperature is the 'quality' of hotness; heat is the 'quantity'. Same temperature, very different heat!",
            "textbook": "Temperature is a measure of the average kinetic energy of the molecules in a substance. Heat (thermal energy) is the total kinetic energy of all the molecules. Two objects at the same temperature can hold vastly different amounts of heat if their masses differ. Heat is measured in joules (J); temperature in degrees Celsius (C) or Kelvin (K). Q = m c delta-T links them: heat depends on mass (m), specific heat capacity (c), and temperature change.",
            "expert": "Thermodynamically, temperature is the partial derivative of internal energy with respect to entropy at constant volume: T = (dU/dS)_V. Heat is not a state function but a path-dependent transfer of energy across a system boundary due to a temperature gradient. The distinction is fundamental: temperature is an intensive property (independent of system size), while heat transferred is extensive (depends on mass and specific heat). Calorimetry exploits Q = mc delta-T to determine unknown specific heats."
        },
        "reasoning": "Temperature describes how fast molecules jiggle on average; heat sums up the jiggle of every molecule. A large body at the same temperature has more molecules jiggling, so more total energy.",
        "useCases": [
            {"title": "Spark from a fire vs molten iron", "description": "A spark at 1500 C barely stings because it has tiny mass (little heat). Molten iron at the same temperature can cause severe burns.", "domain": "industry"},
            {"title": "Ocean vs puddle on a sunny day", "description": "A shallow puddle can reach 40 C quickly but holds little heat. The ocean at 25 C stores immense heat that drives weather systems.", "domain": "weather"},
            {"title": "Small vs large pot of boiling water", "description": "Both at 100 C, but the large pot takes longer to boil dry because it holds more heat.", "domain": "kitchen"},
            {"title": "Baby's bath vs adult's bath", "description": "Same temperature water, but the adult bath requires more energy to heat because of greater volume (more heat).", "domain": "home"},
            {"title": "Hummingbird vs elephant body temperature", "description": "Both around 37 C, but an elephant stores vastly more body heat due to its mass.", "domain": "animals"},
            {"title": "Sauna vs boiling water", "description": "A sauna at 90 C is survivable because air has low density (little heat). Touching 90 C water would burn instantly.", "domain": "human body"},
            {"title": "Laptop battery vs car battery", "description": "Both might run at 45 C, but the car battery stores far more thermal energy if it overheats.", "domain": "technology"},
            {"title": "Marathon runner vs sprinter", "description": "Both bodies reach 39 C during exercise, but the marathon runner generates more total heat over time.", "domain": "sport"},
            {"title": "Small campfire vs forest fire", "description": "Both have flames at similar temperatures (~600 C), but the forest fire releases millions of times more heat.", "domain": "travel"},
            {"title": "Solar water heater: small vs large tank", "description": "A 100-litre and a 500-litre tank at the same temperature — the larger one provides hot water for 5 times as many showers.", "domain": "building"}
        ],
        "beyondTheBook": "The cosmic microwave background radiation puts the average temperature of outer space at 2.725 K — bitterly cold. Yet the total heat content of the observable universe is staggering because space is so vast. Temperature is tiny; heat is cosmic.",
        "relatedConceptIds": ["ch04_t01_c01", "ch04_t01_c07", "ch02_t03_c01"],
        "relatedQuestionIds": ["ch04_t01_q02"],
        "pageRefs": [36, 37],
        "needsHumanReview": False
    },
    {
        "id": "ch04_t01_c06",
        "title": "Why Mercury Was Used in Thermometers (and the digital takeover)",
        "explanations": {
            "oneLine": "Mercury expands uniformly with temperature, stays liquid over a wide range, and is visible in a tube — ideal for old-school thermometers.",
            "kidFriendly": "Mercury is a metal that is liquid at room temperature — the only metal that does that! When it gets hotter, it expands smoothly — no sudden jumps — so the silver line in the tube creeps up evenly. It does not stick to glass, so readings are clean. But mercury is poisonous, so most countries have banned mercury thermometers. Now we use digital ones with tiny electronic sensors called thermistors that change resistance with temperature.",
            "textbook": "Mercury was the preferred thermometric liquid because it has (1) a high boiling point (357 C) allowing a wide measurement range, (2) uniform (linear) expansion over most of that range, (3) high thermal conductivity for quick response, (4) it does not wet glass, giving a clear meniscus. However, mercury is toxic, and the Minamata Convention (2013) phases out mercury thermometers globally. Digital thermometers use thermistors or platinum resistance sensors, converting temperature-dependent resistance into a digital readout.",
            "expert": "Mercury's coefficient of cubical expansion (~1.82 x 10^-4 per K) is relatively constant between -39 C and 357 C, enabling direct linear calibration. Its high thermal diffusivity (~4.5 x 10^-6 m2/s) ensures rapid equilibrium. Digital alternatives — NTC thermistors (sensitivity ~-4%/K) and Pt100 RTDs (linear, traceable to ITS-90) — offer superior accuracy (0.01 C for RTDs), are non-toxic, and support data logging. Infrared pyrometers extend the range beyond 3000 C for industrial applications."
        },
        "reasoning": "A good thermometric substance must expand predictably, stay liquid over a useful range, and be easy to read. Mercury ticked all boxes for centuries, but its toxicity forced a shift to electronics.",
        "useCases": [
            {"title": "Hospital thermometer evolution", "description": "Hospitals replaced mercury with digital ear thermometers — faster, safer, and disposable probe covers prevent cross-infection.", "domain": "human body"},
            {"title": "Weather station maximum-minimum thermometer", "description": "The classic Six's thermometer used mercury and alcohol together. Modern stations use electronic sensors with wireless data logging.", "domain": "weather"},
            {"title": "Mercury spill cleanup drill", "description": "Schools practise mercury spill drills because even small amounts emit toxic vapour. This is why mercury thermometers are banned in many schools.", "domain": "science"},
            {"title": "Candy-making thermometer", "description": "Sugar must reach precise temperatures (e.g. 150 C for hard crack). Glass mercury thermometers were once standard; now digital probes dominate.", "domain": "kitchen"},
            {"title": "Industrial furnace pyrometer", "description": "At 1500 C mercury boils away. Infrared pyrometers measure radiation instead — no contact needed.", "domain": "industry"},
            {"title": "Fish pond temperature sensor", "description": "Aquaculture ponds use submersible digital probes that radio readings to a phone app — mercury would be too slow and hazardous.", "domain": "agriculture"},
            {"title": "Vintage Galileo thermoscope", "description": "Before mercury, Galileo used air expansion in a water-filled tube. Inaccurate but beautiful — still sold as a desk ornament.", "domain": "home"},
            {"title": "Sports medicine instant read", "description": "Team doctors use forehead infrared guns to check players for heat stroke in seconds during a match.", "domain": "sport"},
            {"title": "Airplane outside air temperature", "description": "Aircraft use platinum RTD probes mounted on the fuselage — mercury would freeze at high altitude.", "domain": "travel"},
            {"title": "Smartphone ambient sensors", "description": "Some phones include tiny MEMS temperature sensors. No mercury, no glass — just a chip smaller than a grain of rice.", "domain": "technology"}
        ],
        "beyondTheBook": "The world's most accurate thermometer, the Consultative Committee for Thermometry's noise thermometer, measures temperature by listening to the random electrical noise in a resistor. It can detect changes of 0.0001 C and is used to define the kelvin itself.",
        "relatedConceptIds": ["ch04_t01_c02", "ch04_t01_c03", "ch04_t02_c01"],
        "relatedQuestionIds": ["ch04_t01_q02"],
        "pageRefs": [38, 39],
        "needsHumanReview": False
    },
    {
        "id": "ch04_t01_c07",
        "title": "Specific Heat Capacity — Why Water is Special",
        "explanations": {
            "oneLine": "Specific heat capacity is the amount of heat needed to raise 1 kg of a substance by 1 C — and water needs a lot more than most materials.",
            "kidFriendly": "Imagine heating a kilogram of water and a kilogram of iron on the same stove. The iron gets scorching hot in a minute, but the water barely warms up. Water is a heat sponge — it absorbs a huge amount of energy before its temperature rises. That is why coastal cities have milder weather (the sea absorbs daytime heat and releases it at night) and why your body (70% water) stays near 37 C even on a hot day.",
            "textbook": "Specific heat capacity (c) is defined as the amount of heat energy required to raise the temperature of 1 kg of a substance by 1 C (or 1 K). For water, c = 4,186 J/(kg C) — one of the highest of any common substance. For iron, c = 449 J/(kg C). The heat equation Q = m c delta-T shows that for the same mass and temperature change, water absorbs about 9 times more energy than iron. This property makes water an excellent coolant and thermal buffer.",
            "expert": "Water's anomalously high specific heat arises from its extensive hydrogen-bond network. Breaking and re-forming H-bonds absorbs energy without raising kinetic energy (and thus temperature). At 1 atm, c_p for liquid water is ~4,186 J/(kg K) at 15 C; it varies slightly with temperature (minimum ~4,178 J/(kg K) near 35 C). Oceanographers exploit this: the top 2.5 m of ocean stores as much heat as the entire atmosphere above it. Calorimetry — Q = mc delta-T — is the standard method for measuring c of unknown materials."
        },
        "reasoning": "Different substances respond differently to the same heat input because their molecular structures absorb energy in different ways. Water's hydrogen bonds act like tiny springs that soak up energy, keeping temperature rise slow.",
        "useCases": [
            {"title": "Coastal cities vs inland cities", "description": "Mumbai stays 25-35 C year-round because the Arabian Sea has high specific heat, buffering temperature swings. Delhi ranges from 5 C to 48 C — no ocean buffer.", "domain": "weather"},
            {"title": "Car radiator coolant", "description": "Car engines are cooled with water (mixed with antifreeze) because water absorbs more heat per litre than any common liquid.", "domain": "technology"},
            {"title": "Hot water bottle at bedtime", "description": "A rubber bottle filled with hot water stays warm for hours because water releases its stored heat slowly.", "domain": "home"},
            {"title": "Cooking with cast iron vs aluminium", "description": "Cast iron (c = 449) heats slowly but holds heat longer. Aluminium (c = 897) heats and cools faster — choose based on the dish.", "domain": "kitchen"},
            {"title": "Desert day-night temperature swing", "description": "Sand (c = 830) gains and loses heat quickly — scorching days, freezing nights. Water would moderate the swing.", "domain": "science"},
            {"title": "Elephant ears as radiators", "description": "Elephants pump blood (mostly water, high c) into their thin ears. Large surface area releases heat slowly, cooling the body.", "domain": "animals"},
            {"title": "Olympic swimming pool heating", "description": "An Olympic pool holds 2.5 million litres. Heating it by 1 C requires ~10.5 billion joules — water's specific heat at scale.", "domain": "sport"},
            {"title": "Rice paddies moderating local climate", "description": "Flooded rice paddies act like shallow lakes, absorbing daytime heat and releasing it at night — stabilising local temperature.", "domain": "agriculture"},
            {"title": "Land-sea breeze mechanism", "description": "Land (low c) heats faster than sea (high c) by day, creating the sea breeze. At night the reverse drives the land breeze.", "domain": "travel"},
            {"title": "Nuclear reactor cooling", "description": "Nuclear plants use water as the primary coolant because its high specific heat absorbs enormous reactor heat safely.", "domain": "industry"}
        ],
        "beyondTheBook": "The top 2.5 metres of the world's oceans hold as much thermal energy as the entire atmosphere. This makes ocean temperature the single biggest factor in long-term climate. A 1 C rise in global ocean temperature represents an almost incomprehensible amount of absorbed energy — roughly 14 zettajoules.",
        "relatedConceptIds": ["ch04_t01_c01", "ch04_t01_c05", "ch04_t02_c06", "ch01_t01_c02"],
        "relatedQuestionIds": ["ch04_t01_q01"],
        "pageRefs": [40, 41],
        "needsHumanReview": False
    },
]

NEW_CONCEPTS_T02 = [
    {
        "id": "ch04_t02_c04",
        "title": "Thermos Flask — How One Bottle Beats All Three Heat Modes",
        "explanations": {
            "oneLine": "A thermos flask blocks conduction, convection, and radiation with a vacuum layer, sealed air space, and reflective coating.",
            "kidFriendly": "A thermos is like a fortress against heat escape. The vacuum between two glass walls stops conduction and convection (heat cannot travel through nothing). The shiny silver coating inside reflects radiation back — like a mirror bouncing heat rays. The tight lid stops hot air escaping. Result: your soup stays hot for hours. The same design keeps cold drinks cold too — it works both ways!",
            "textbook": "A vacuum flask (Dewar flask) minimises heat transfer by all three modes. The vacuum between double walls eliminates conduction and convection (both require a medium). The silvered inner surfaces have low emissivity, reflecting infrared radiation back into the liquid. A cork or plastic stopper reduces heat loss from the top. James Dewar invented the flask in 1892. The brand name Thermos was trademarked in 1904.",
            "expert": "The effective thermal conductance of a Dewar flask is dominated by residual gas conduction (at ~10^-3 Pa the mean free path exceeds the wall gap), radiative exchange between silvered surfaces (emissivity ~0.02), and solid conduction through the neck seal. Modern vacuum flasks achieve U-values below 0.5 W/(m2 K). Multilayer insulation (MLI) with aluminised Mylar further reduces radiative loss in cryogenic dewars used for liquid nitrogen (77 K) and liquid helium (4.2 K) storage."
        },
        "reasoning": "Each heat transfer mode has a weakness: conduction needs matter, convection needs fluid, radiation can be reflected. A thermos exploits all three weaknesses simultaneously.",
        "useCases": [
            {"title": "School lunch box thermos", "description": "Hot dal stays warm till lunch because the vacuum blocks conduction and convection; the silver lining reflects radiation.", "domain": "home"},
            {"title": "Cryogenic storage of vaccines", "description": "mRNA vaccines need -70 C. Dewar flasks filled with dry ice keep them cold for days during transport.", "domain": "science"},
            {"title": "Thermos on a construction site", "description": "Workers carry thermos flasks of hot tea to remote sites with no electricity — the flask is a passive heater.", "domain": "building"},
            {"title": "Spacecraft thermal control", "description": "Satellites use multi-layer insulation (MLI) — the space-age cousin of the thermos — to survive extreme temperature swings.", "domain": "technology"},
            {"title": "Camel herder's water flask", "description": "In the Rajasthan desert, a thermos keeps water cool all day — blocking the 45 C heat from getting in.", "domain": "travel"},
            {"title": "Ice-cream transport", "description": "Ice-cream delivery trucks use vacuum-insulated panels — the same principle as a thermos, scaled up.", "domain": "industry"},
            {"title": "Mountaineer's hot drink", "description": "At 5,000 m altitude, air temperature is -20 C. A good thermos keeps coffee drinkable for 8+ hours.", "domain": "sport"},
            {"title": "Rice cooker keep-warm mode", "description": "Some rice cookers use vacuum-insulated inner pots to keep rice warm without continuous electricity.", "domain": "kitchen"},
            {"title": "Newborn baby transport incubator", "description": "Portable incubators for premature babies use vacuum insulation to maintain 37 C during ambulance transfers.", "domain": "human body"},
            {"title": "Penguin huddle analogy", "description": "Penguins trap still air between their feathers (like a thermos vacuum) — nature's version of blocking conduction and convection.", "domain": "animals"}
        ],
        "beyondTheBook": "James Dewar never patented his flask. Two German glassblowers did, founding the Thermos company in 1904. Dewar sued and lost — one of the most famous missed patents in science history.",
        "relatedConceptIds": ["ch04_t02_c01", "ch04_t02_c02", "ch04_t02_c03", "ch03_t01_c01"],
        "relatedQuestionIds": ["ch04_t02_q01"],
        "pageRefs": [42, 43],
        "needsHumanReview": False
    },
    {
        "id": "ch04_t02_c05",
        "title": "Cooking Vessels — Why Copper Bottoms, Wooden Handles",
        "explanations": {
            "oneLine": "Cooking pans use good conductors (copper, aluminium) for the base to spread heat fast, and bad conductors (wood, plastic) for handles to protect your hand.",
            "kidFriendly": "Next time you are in the kitchen, look at a pan. The bottom is metal — usually aluminium or stainless steel with a copper disc. Metal conducts heat brilliantly, so the flame's energy spreads evenly across the base and into the food. But the handle? Wood or plastic — terrible conductors! That is the point: you want heat in the food, not in your fingers. Smart design uses good and bad conductors in the same object.",
            "textbook": "Cooking vessels exploit differences in thermal conductivity. Copper (k = 401 W/m K) and aluminium (k = 237 W/m K) are used for bases because they distribute heat uniformly, preventing hot spots. Stainless steel (k = 16 W/m K) is often used for the body because it resists corrosion, with a copper or aluminium core for conductivity. Handles are made of wood (k = 0.12 W/m K), Bakelite (k = 0.23 W/m K), or silicone — all thermal insulators — to prevent burns.",
            "expert": "Thermal design of cookware optimises the Biot number (Bi = hL/k). For uniform cooking, Bi should be small (high k, thin walls), ensuring the temperature gradient within the metal is negligible. Tri-ply construction (steel-aluminium-steel) achieves this while maintaining corrosion resistance. Induction-compatible bases add a ferromagnetic layer. Handle materials must have low k and withstand repeated thermal cycling without degradation — phenolic resins and silicone elastomers are standard."
        },
        "reasoning": "The goal is to move heat efficiently to food while keeping the cook safe. Nature provides materials at both extremes of conductivity, and clever design puts each where it is most useful.",
        "useCases": [
            {"title": "Copper-bottom kadhai", "description": "Indian kadhai with copper base heats evenly for deep frying. Without copper, the centre would be much hotter than the edges.", "domain": "kitchen"},
            {"title": "Wooden spoon for stirring", "description": "A wooden spoon does not conduct heat from hot soup to your hand, and does not scratch non-stick coatings.", "domain": "home"},
            {"title": "Cast-iron tawa for rotis", "description": "Cast iron heats slowly but holds heat uniformly — perfect for puffing rotis evenly.", "domain": "kitchen"},
            {"title": "Silicone oven mitts", "description": "Silicone is an insulator that withstands 250 C — replacing bulky cotton mitts in modern kitchens.", "domain": "technology"},
            {"title": "Blacksmith's tongs", "description": "Long iron tongs keep the blacksmith's hand far from the forge. Length plus air gap reduce conduction to the hand.", "domain": "industry"},
            {"title": "Thermal break in window frames", "description": "Modern window frames use a plastic strip between inner and outer aluminium — same principle as a wooden handle on a metal pan.", "domain": "building"},
            {"title": "Wool-lined saucepan cosy", "description": "A fabric cosy around a saucepan slows cooling — insulation on the body, conductor on the base.", "domain": "clothing"},
            {"title": "Stainless steel water bottle", "description": "Steel is a poor conductor for a metal, so a steel bottle keeps water temperature more stable than aluminium.", "domain": "sport"},
            {"title": "Clay tandoor vs metal oven", "description": "Clay is a poor conductor — it heats slowly but retains heat for hours, ideal for slow-cooking naan.", "domain": "agriculture"},
            {"title": "Spacecraft heat shields", "description": "Ablative tiles on re-entry vehicles are poor conductors — they absorb heat on the outside while the inside stays cool.", "domain": "science"}
        ],
        "beyondTheBook": "Diamond is the best thermal conductor known (k = 2,200 W/m K, five times better than copper), yet it is an electrical insulator. Researchers are developing diamond heat spreaders for high-power computer chips — the ultimate conductor where it matters most.",
        "relatedConceptIds": ["ch04_t02_c01", "ch04_t02_c04", "ch03_t01_c06"],
        "relatedQuestionIds": ["ch04_t02_q02"],
        "pageRefs": [44, 45],
        "needsHumanReview": False
    },
    {
        "id": "ch04_t02_c06",
        "title": "Sea Breeze and Land Breeze — Convection at Coastal Scale",
        "explanations": {
            "oneLine": "During the day, land heats faster than sea, so warm air rises over land and cool sea air rushes in (sea breeze); at night the reverse happens (land breeze).",
            "kidFriendly": "Stand on a beach on a hot afternoon and you will feel a cool wind blowing from the sea. Here is why: the sun heats the land much faster than the water (because land has a lower specific heat capacity). Hot air over the land rises like an invisible balloon. Cooler air from the sea rushes in to fill the gap — that is the sea breeze. At night, the land cools faster. Now the sea is warmer, air rises over it, and a gentle breeze blows from land to sea — the land breeze. Same principle, opposite direction!",
            "textbook": "Sea and land breezes are local convection currents caused by differential heating. During the day, land (low specific heat) heats faster than water (high specific heat). Air over land becomes warm and rises (low pressure), while cooler, denser air over the sea flows toward land (sea breeze). At night, land cools faster than the sea, reversing the pressure gradient and creating a land breeze. These breezes moderate coastal temperatures and influence local weather patterns.",
            "expert": "The sea-breeze circulation is a mesoscale thermally-driven flow driven by the horizontal pressure gradient resulting from differential surface heating. The sea-breeze front can penetrate 50-100 km inland, reaching depths of 1-2 km. The return flow aloft (anti-sea-breeze) completes the Hadley-like cell. Coriolis deflection is noticeable for breezes lasting several hours, causing the sea-breeze front to rotate clockwise in the Northern Hemisphere. Numerical weather prediction models resolve sea breezes at ~1 km grid spacing."
        },
        "reasoning": "Uneven heating creates pressure differences, and pressure differences drive wind. The sea and land heat at different rates because water has much higher specific heat capacity than soil or rock.",
        "useCases": [
            {"title": "Mumbai evening sea breeze", "description": "Mumbai residents feel a cool sea breeze every afternoon — convection drawing ocean air inland across the city.", "domain": "weather"},
            {"title": "Fishermen setting out at night", "description": "Traditional fishermen in Kerala launch boats on the land breeze (blowing offshore) at night and return on the sea breeze by day.", "domain": "travel"},
            {"title": "Coastal wind farms", "description": "Sea breezes are predictable. Wind turbines near the coast harness this reliable convection-driven wind.", "domain": "technology"},
            {"title": "Beach kite flying", "description": "Kite flyers prefer afternoons at the beach — the sea breeze is strongest when land-sea temperature contrast peaks.", "domain": "sport"},
            {"title": "Drying fish on the coast", "description": "Coastal communities dry fish using the steady sea breeze — natural convective airflow speeds evaporation.", "domain": "industry"},
            {"title": "Coastal fog formation", "description": "When warm, moist sea air flows over cooler land at night, fog forms — a visible sign of the breeze at work.", "domain": "science"},
            {"title": "Planting windbreaks near the coast", "description": "Farmers plant tree rows to slow the salt-laden sea breeze that can damage crops inland.", "domain": "agriculture"},
            {"title": "Seaside house ventilation", "description": "Architects orient windows to catch the sea breeze for natural cooling — reducing air-conditioning costs.", "domain": "building"},
            {"title": "Dog cooling on the beach", "description": "Dogs lie facing the sea breeze — cool air over their wet tongue and nose aids evaporative cooling.", "domain": "animals"},
            {"title": "Evening barbecue smoke direction", "description": "At a coastal barbecue, smoke drifts inland during the day (sea breeze) and out to sea at night (land breeze).", "domain": "home"}
        ],
        "beyondTheBook": "On Mars, the thin CO2 atmosphere creates slope winds similar to sea breezes. NASA's Perseverance rover has measured these Martian 'thermal breezes' — convection is not just an Earth phenomenon.",
        "relatedConceptIds": ["ch04_t02_c02", "ch04_t01_c07", "ch04_t01_c01"],
        "relatedQuestionIds": ["ch04_t02_q03"],
        "pageRefs": [46, 47],
        "needsHumanReview": False
    },
]

NEW_TOPIC_T03 = {
    "id": "ch04_t03",
    "title": "Heat in Bodies, Climates, and the Future",
    "concepts": [
        {
            "id": "ch04_t03_c01",
            "title": "Heat in the Human Body — Why 37 C, Why You Sweat",
            "explanations": {
                "oneLine": "The human body maintains a core temperature near 37 C using metabolic heat production and cooling mechanisms like sweating and blood-vessel dilation.",
                "kidFriendly": "Your body is a furnace that never turns off. Digesting food, thinking, even sleeping generates heat. Your internal thermostat (the hypothalamus in your brain) keeps you at about 37 C. Too hot? You sweat — water on your skin evaporates and carries heat away, cooling you. Blood vessels near the skin widen to dump heat outward. Too cold? You shiver — muscles vibrate to make extra heat, and blood vessels narrow to keep warmth inside. It is a 24/7 balancing act.",
                "textbook": "Thermoregulation in humans is controlled by the hypothalamus. Metabolic reactions release heat (basal metabolic rate ~80 W at rest). When core temperature rises, vasodilation increases blood flow to the skin, and sweat glands secrete water whose evaporation absorbs latent heat (~2,260 kJ/kg), cooling the body. When core temperature falls, vasoconstriction reduces skin blood flow, and shivering generates heat by rapid involuntary muscle contractions. Normal body temperature ranges from 36.1 C to 37.2 C.",
                "expert": "Human thermoregulation is a negative-feedback control system. The hypothalamic set-point (~37 C) is modulated by circadian rhythm (±0.5 C), menstrual cycle, and pyrogens (fever-inducing cytokines like IL-1). Heat dissipation involves four physical mechanisms: radiation (~40%), convection (~20%), evaporation (~20%), and conduction (~20%) at rest in thermoneutral conditions. At high metabolic rates (e.g., marathon running, ~1,200 W), evaporative cooling dominates, requiring up to 1.5 L/hr of sweat production."
            },
            "reasoning": "Enzymes in the body work best near 37 C. Too hot or too cold, and chemical reactions slow or proteins denature. The body uses physics — evaporation, radiation, convection — to keep the thermostat steady.",
            "useCases": [
                {"title": "Why you shiver in winter", "description": "Rapid muscle twitching (shivering) converts chemical energy to heat, raising body temperature.", "domain": "human body"},
                {"title": "Sweating during a cricket match", "description": "Players lose up to 2 litres of sweat per hour in summer. Each litre carries away about 2,400 kJ of heat.", "domain": "sport"},
                {"title": "Dogs panting instead of sweating", "description": "Dogs have few sweat glands. They cool by panting — evaporating moisture from the tongue and airways.", "domain": "animals"},
                {"title": "Fever as a defence mechanism", "description": "The hypothalamus raises the set-point during infection, making you feel cold and shiver to generate more heat — killing temperature-sensitive bacteria.", "domain": "science"},
                {"title": "Air conditioning in tropical offices", "description": "AC removes excess heat from indoor air so your body does not need to sweat heavily to stay at 37 C.", "domain": "building"},
                {"title": "Matka (earthen pot) water cooling", "description": "Water seeps through the porous clay and evaporates on the surface — the same evaporative cooling your skin uses.", "domain": "home"},
                {"title": "Spicy food and sweating", "description": "Capsaicin in chillies tricks nerve receptors into thinking you are hot, triggering sweat — a false alarm that cools you for real.", "domain": "kitchen"},
                {"title": "Wetsuit insulation for swimmers", "description": "A thin water layer trapped between wetsuit and skin warms to body temperature. The neoprene insulates, reducing heat loss.", "domain": "sport"},
                {"title": "Heat stroke during Hajj pilgrimages", "description": "Extreme heat and crowding in Mecca can overwhelm the body's cooling system, causing heat stroke at 40+ C core temp.", "domain": "travel"},
                {"title": "Wool blanket in a Himalayan winter", "description": "Wool traps still air, reducing conductive and convective heat loss from your warm body.", "domain": "clothing"}
            ],
            "beyondTheBook": "Humans are endotherms — we make our own heat. But some deep-sea fish have evolved regional endothermy: the opah (moonfish) keeps its brain and eyes 5 C warmer than the surrounding water using counter-current heat exchangers in its gills.",
            "relatedConceptIds": ["ch04_t01_c01", "ch04_t02_c02", "ch04_t02_c03", "ch02_t03_c01", "ch01_t01_c02"],
            "relatedQuestionIds": ["ch04_t03_q01"],
            "pageRefs": [48, 49],
            "needsHumanReview": False
        },
        {
            "id": "ch04_t03_c02",
            "title": "Heat and Climate Change — A Planet With a Fever",
            "explanations": {
                "oneLine": "Greenhouse gases trap heat radiated from Earth's surface, raising the planet's average temperature — the greenhouse effect driving climate change.",
                "kidFriendly": "Earth is wrapped in a blanket of gases — carbon dioxide, methane, water vapour. Sunlight passes through this blanket and warms the ground. The ground radiates heat back up, but the gas blanket traps some of it, keeping the planet warm enough for life. The problem: humans are burning fossil fuels, adding extra CO2 and methane, making the blanket thicker. More heat gets trapped, and the planet warms up — like a car with closed windows in the sun. That extra warming is climate change.",
                "textbook": "The greenhouse effect is a natural process: solar radiation (short-wave) passes through the atmosphere and is absorbed by Earth's surface, which re-emits it as infrared (long-wave) radiation. Greenhouse gases (CO2, CH4, N2O, H2O) absorb and re-emit infrared radiation, warming the lower atmosphere. Human activities (burning fossil fuels, deforestation, agriculture) have increased atmospheric CO2 from ~280 ppm (pre-industrial) to over 420 ppm, enhancing the greenhouse effect and raising global average temperature by ~1.2 C since 1850.",
                "expert": "The radiative forcing from doubled CO2 is approximately +3.7 W/m2 (IPCC AR6). Climate sensitivity — the equilibrium warming per CO2 doubling — is estimated at 2.5-4.0 C (likely range). Feedbacks include water-vapour amplification (positive), ice-albedo (positive), cloud (uncertain, likely net positive), and Planck radiation (negative, stabilising). The ocean's thermal inertia (heat capacity of the top 700 m ~ 10^25 J/K) delays full equilibrium warming by decades, creating 'committed warming' from past emissions."
            },
            "reasoning": "The greenhouse effect is just heat radiation physics at planetary scale. Gases that absorb infrared act like a one-way valve — sunlight in, heat trapped. Adding more of these gases strengthens the trap.",
            "useCases": [
                {"title": "Melting Arctic ice", "description": "Rising temperatures melt sea ice, which reduces reflectivity (albedo) so the ocean absorbs more heat — a positive feedback loop.", "domain": "weather"},
                {"title": "Coral bleaching in warm oceans", "description": "Corals expel symbiotic algae when water temperature rises by just 1-2 C, turning white and often dying.", "domain": "animals"},
                {"title": "Solar panels reducing emissions", "description": "Solar panels convert sunlight to electricity without burning fuel, avoiding CO2 release and slowing the greenhouse effect.", "domain": "technology"},
                {"title": "Delhi smog in winter", "description": "Burning crop stubble releases CO2 and particulates. The resulting smog traps heat near the surface, worsening local warming.", "domain": "industry"},
                {"title": "Rainforest as a carbon sink", "description": "Amazon trees absorb CO2 during photosynthesis, removing greenhouse gas from the atmosphere — forests cool the planet.", "domain": "science"},
                {"title": "Electric vehicles in Indian cities", "description": "EVs produce zero tailpipe CO2. Widespread adoption could cut urban transport emissions by 50% or more.", "domain": "transport"},
                {"title": "Rice paddies emitting methane", "description": "Flooded rice fields produce methane (a potent greenhouse gas). Alternate wetting-drying techniques cut emissions by 30-50%.", "domain": "agriculture"},
                {"title": "Green roofs in Mumbai", "description": "Rooftop gardens insulate buildings (less AC) and absorb CO2 — a double win against urban heat and climate change.", "domain": "building"},
                {"title": "Cotton vs polyester carbon footprint", "description": "Polyester is made from petroleum (fossil carbon). Organic cotton sequesters CO2 as it grows — different heat-planet impacts.", "domain": "clothing"},
                {"title": "Glacier retreat in the Himalayas", "description": "Rising temperatures are shrinking Himalayan glaciers, threatening water supply for billions in the Ganga basin.", "domain": "travel"}
            ],
            "beyondTheBook": "Venus is the ultimate greenhouse cautionary tale. Its thick CO2 atmosphere traps so much heat that surface temperature reaches 465 C — hotter than Mercury, which is closer to the Sun. A runaway greenhouse effect turned Venus from a possibly habitable world into a furnace.",
            "relatedConceptIds": ["ch04_t02_c03", "ch04_t01_c07", "ch04_t03_c01", "ch01_t01_c02"],
            "relatedQuestionIds": ["ch04_t03_q03"],
            "pageRefs": [50, 51],
            "needsHumanReview": False
        },
        {
            "id": "ch04_t03_c03",
            "title": "Bonus: The Strange World of Cryogenics (heat at extremes)",
            "explanations": {
                "oneLine": "Cryogenics is the science of producing and using extremely low temperatures, where gases become liquids and matter behaves in bizarre new ways.",
                "kidFriendly": "What happens when you keep removing heat from something? First it cools, then freezes. But if you keep going — way below zero — amazing things happen. Air itself turns into a liquid at -196 C. Helium becomes a liquid at -269 C. At these temperatures, some metals lose all electrical resistance (superconductivity), and liquid helium can climb up the walls of a cup! This is cryogenics — the science of super-cold.",
                "textbook": "Cryogenics deals with temperatures below -150 C (123 K). At these temperatures, common gases liquefy: nitrogen at 77 K, oxygen at 90 K, hydrogen at 20 K, helium at 4.2 K. Superconductivity (zero electrical resistance) occurs in many metals and alloys below a critical temperature. Superfluidity in helium-4 below 2.17 K allows frictionless flow. Applications include MRI scanners (superconducting magnets cooled by liquid helium), rocket fuel (liquid hydrogen + liquid oxygen), and food preservation (flash-freezing with liquid nitrogen).",
                "expert": "Cryogenic engineering exploits quantum phenomena that emerge at low temperatures. BCS theory explains superconductivity via Cooper pairing of electrons mediated by phonons. Superfluid helium-4 is described by a two-fluid model (Tisza-Landau) with zero viscosity below the lambda point (2.17 K). High-temperature superconductors (YBa2Cu3O7, Tc ~ 93 K) operate in liquid-nitrogen range, enabling practical applications. Dilution refrigerators reach ~10 mK; nuclear demagnetisation achieves microkelvin temperatures for fundamental physics research."
            },
            "reasoning": "Removing heat reveals hidden physics. At everyday temperatures, thermal noise masks quantum effects. Cool matter enough, and quantum behaviour — superconductivity, superfluidity, Bose-Einstein condensation — takes over.",
            "useCases": [
                {"title": "MRI scanner magnets", "description": "The superconducting magnets in MRI machines are bathed in liquid helium at 4 K, creating powerful, stable magnetic fields.", "domain": "technology"},
                {"title": "Liquid nitrogen ice cream", "description": "Pouring liquid nitrogen (-196 C) into cream base flash-freezes it in seconds, creating ultra-smooth ice cream.", "domain": "kitchen"},
                {"title": "Rocket fuel: liquid hydrogen + oxygen", "description": "NASA's SLS rocket burns liquid hydrogen (-253 C) with liquid oxygen (-183 C) — cryogenic propellants.", "domain": "science"},
                {"title": "Frozen food preservation", "description": "Flash-freezing food with liquid nitrogen preserves texture better than slow freezing — small ice crystals cause less cell damage.", "domain": "industry"},
                {"title": "Cryotherapy for sports injuries", "description": "Athletes use whole-body cryotherapy chambers (-110 C) to reduce inflammation after intense training.", "domain": "sport"},
                {"title": "Sperm and egg banks", "description": "Reproductive cells are stored in liquid nitrogen (-196 C) for decades. At that temperature, all chemical reactions essentially stop.", "domain": "human body"},
                {"title": "Superconducting maglev trains", "description": "Japanese maglev trains use superconducting magnets cooled to 4 K to levitate and travel at 600 km/h.", "domain": "transport"},
                {"title": "Antarctic research stations", "description": "Vostok Station recorded -89.2 C — so cold that exhaled breath instantly forms ice crystals and falls as fine snow.", "domain": "travel"},
                {"title": "Cryopreserving coral fragments", "description": "Scientists freeze coral larvae in liquid nitrogen to create genetic banks for reef restoration as oceans warm.", "domain": "animals"},
                {"title": "LNG shipping", "description": "Natural gas is cooled to -162 C to liquefy it for tanker transport — 600 times smaller volume than gas.", "domain": "industry"}
            ],
            "beyondTheBook": "In 2024, scientists created a Bose-Einstein condensate — a state of matter where atoms merge into a single quantum wave — aboard the International Space Station. Microgravity allowed the condensate to last over a second, revealing new quantum behaviour impossible to observe on Earth.",
            "relatedConceptIds": ["ch04_t01_c03", "ch04_t01_c04", "ch04_t02_c04", "ch03_t01_c01"],
            "relatedQuestionIds": ["ch04_t03_q02"],
            "pageRefs": [52, 53],
            "needsHumanReview": False
        }
    ],
    "questions": [
        {
            "id": "ch04_t03_q01",
            "type": "mcq",
            "text": "The normal human body temperature is maintained at about:",
            "options": ["25 C", "37 C", "42 C", "100 C"],
            "answer": "37 C",
            "explanation": "The hypothalamus in the brain keeps the core body temperature near 37 C through mechanisms like sweating and shivering.",
            "relatedConceptIds": ["ch04_t03_c01"]
        },
        {
            "id": "ch04_t03_q02",
            "type": "numerical",
            "text": "How much heat energy is needed to raise the temperature of 2 kg of water from 20 C to 70 C? (Specific heat capacity of water = 4,200 J/kg C)",
            "answer": "420000",
            "unit": "J",
            "explanation": "Q = m x c x delta-T = 2 x 4200 x (70-20) = 2 x 4200 x 50 = 420,000 J.",
            "relatedConceptIds": ["ch04_t01_c07", "ch04_t03_c01"]
        },
        {
            "id": "ch04_t03_q03",
            "type": "short-answer",
            "text": "Explain how the burning of fossil fuels contributes to climate change, using the concept of heat radiation.",
            "answer": "Burning fossil fuels releases carbon dioxide (CO2) into the atmosphere. CO2 is a greenhouse gas that absorbs infrared radiation emitted by Earth's surface and re-emits it in all directions, including back toward the ground. This traps additional heat in the atmosphere, raising the average global temperature — the enhanced greenhouse effect that drives climate change.",
            "explanation": "The key link is between radiation (infrared heat from Earth), greenhouse gases (CO2 absorbs and re-emits this radiation), and the resulting temperature rise.",
            "relatedConceptIds": ["ch04_t03_c02", "ch04_t02_c03"]
        }
    ]
}

# ─── bidirectional cross-chapter links ──────────────────────────────────

CROSS_LINKS = {
    # Ch4 concept -> list of Ch1/2/3 concepts it references
    "ch04_t01_c04": ["ch01_t01_c02"],
    "ch04_t01_c05": ["ch02_t03_c01"],
    "ch04_t01_c07": ["ch01_t01_c02"],
    "ch04_t02_c04": ["ch03_t01_c01"],
    "ch04_t02_c05": ["ch03_t01_c06"],
    "ch04_t02_c06": [],  # no cross-chapter
    "ch04_t03_c01": ["ch02_t03_c01", "ch01_t01_c02"],
    "ch04_t03_c02": ["ch01_t01_c02"],
    "ch04_t03_c03": ["ch03_t01_c01"],
}


def find_concept(data, cid):
    """Find a concept dict by id across all chapters/topics."""
    for ch in data.get("chapters", []):
        for t in ch.get("topics", []):
            for c in t.get("concepts", []):
                if c["id"] == cid:
                    return c
    return None


def find_topic(data, tid):
    """Find a topic dict by id."""
    for ch in data.get("chapters", []):
        for t in ch.get("topics", []):
            if t["id"] == tid:
                return t
    return None


def patch(data):
    """Apply all patches. Idempotent — safe to run multiple times."""

    ch04 = None
    for ch in data.get("chapters", []):
        if ch["id"] == "ch04":
            ch04 = ch
            break
    if ch04 is None:
        print("ERROR: ch04 not found in pack.")
        sys.exit(1)

    # 1. Expand existing useCases to 10 each
    for cid, extras in EXTRA_USE_CASES.items():
        concept = find_concept(data, cid)
        if concept is None:
            print(f"WARNING: {cid} not found, skipping useCase expansion.")
            continue
        existing_titles = {uc["title"] for uc in concept.get("useCases", [])}
        for uc in extras:
            if uc["title"] not in existing_titles:
                concept.setdefault("useCases", []).append(uc)

    # 2. Add new concepts to T01
    t01 = find_topic(data, "ch04_t01")
    if t01:
        existing_ids = {c["id"] for c in t01.get("concepts", [])}
        for nc in NEW_CONCEPTS_T01:
            if nc["id"] not in existing_ids:
                t01["concepts"].append(nc)

    # 3. Add new concepts to T02
    t02 = find_topic(data, "ch04_t02")
    if t02:
        existing_ids = {c["id"] for c in t02.get("concepts", [])}
        for nc in NEW_CONCEPTS_T02:
            if nc["id"] not in existing_ids:
                t02["concepts"].append(nc)

    # 4. Add T03 if not present
    existing_topic_ids = {t["id"] for t in ch04.get("topics", [])}
    if "ch04_t03" not in existing_topic_ids:
        ch04["topics"].append(NEW_TOPIC_T03)

    # 5. Bidirectional cross-chapter links
    for ch4_cid, linked_cids in CROSS_LINKS.items():
        for other_cid in linked_cids:
            other = find_concept(data, other_cid)
            if other and ch4_cid not in other.get("relatedConceptIds", []):
                other.setdefault("relatedConceptIds", []).append(ch4_cid)

    # 6. Bump version
    data["version"] = TARGET_VERSION

    return data


def validate(data):
    """Validate Ch4 after patching."""
    errors = []
    ch04 = None
    for ch in data["chapters"]:
        if ch["id"] == "ch04":
            ch04 = ch
            break
    if not ch04:
        errors.append("ch04 not found")
        return errors

    all_concept_ids = set()
    all_question_ids = set()
    for ch in data["chapters"]:
        for t in ch.get("topics", []):
            for c in t.get("concepts", []):
                all_concept_ids.add(c["id"])
            for q in t.get("questions", []):
                all_question_ids.add(q["id"])

    concept_count = 0
    usecase_count = 0
    for t in ch04["topics"]:
        for c in t["concepts"]:
            concept_count += 1
            cid = c["id"]
            # Check depths
            expl = c.get("explanations", {})
            for depth in ["oneLine", "kidFriendly", "textbook", "expert"]:
                if not expl.get(depth):
                    errors.append(f"{cid}: missing depth '{depth}'")
            # Check useCases
            ucs = c.get("useCases", [])
            if len(ucs) < 10:
                errors.append(f"{cid}: only {len(ucs)} useCases (need >=10)")
            for uc in ucs:
                usecase_count += 1
                if not uc.get("title"):
                    errors.append(f"{cid}: useCase missing title")
                if not uc.get("description"):
                    errors.append(f"{cid}: useCase missing description")
                if not uc.get("domain"):
                    errors.append(f"{cid}: useCase missing domain")
                if uc.get("domain") == "medicine":
                    errors.append(f"{cid}: useCase uses forbidden domain 'medicine'")
                if uc.get("domain") and uc["domain"] not in ALLOWED_DOMAINS:
                    errors.append(f"{cid}: useCase domain '{uc['domain']}' not in canonical set")
            # Check cross-refs
            for ref in c.get("relatedConceptIds", []):
                if ref not in all_concept_ids:
                    errors.append(f"{cid}: broken concept ref '{ref}'")
            for ref in c.get("relatedQuestionIds", []):
                if ref not in all_question_ids:
                    errors.append(f"{cid}: broken question ref '{ref}'")
        for q in t.get("questions", []):
            all_question_ids.add(q["id"])

    if data.get("version") != TARGET_VERSION:
        errors.append(f"version is '{data.get('version')}', expected '{TARGET_VERSION}'")

    question_count = sum(len(t.get("questions", [])) for t in ch04["topics"])

    print(f"Ch4 Concepts: {concept_count}")
    print(f"Ch4 UseCases: {usecase_count}")
    print(f"Ch4 Questions: {question_count}")
    print(f"Ch4 Topics: {len(ch04['topics'])}")
    print(f"Pack version: {data.get('version')}")

    return errors


def main():
    with open(PACK_PATH, "r", encoding="utf-8") as f:
        data = json.load(f)

    # Idempotency check
    if data.get("version") == TARGET_VERSION:
        print(f"Already at version {TARGET_VERSION}. No changes needed.")
        # Still validate
        errors = validate(data)
        if errors:
            print("VALIDATION ERRORS:")
            for e in errors:
                print(f"  - {e}")
            sys.exit(1)
        else:
            print("Validation passed.")
        return

    # Count before
    ch04_before = None
    for ch in data["chapters"]:
        if ch["id"] == "ch04":
            ch04_before = ch
            break
    concepts_before = sum(len(t.get("concepts", [])) for t in ch04_before["topics"])
    usecases_before = sum(
        len(c.get("useCases", []))
        for t in ch04_before["topics"]
        for c in t.get("concepts", [])
    )
    questions_before = sum(len(t.get("questions", [])) for t in ch04_before["topics"])

    # Patch
    data = patch(data)

    # Validate
    errors = validate(data)
    if errors:
        print("VALIDATION ERRORS:")
        for e in errors:
            print(f"  - {e}")
        sys.exit(1)

    # Write
    with open(PACK_PATH, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

    print(f"\nPatch applied successfully!")
    print(f"  Concepts: {concepts_before} -> {sum(len(t.get('concepts', [])) for t in ch04_before['topics'])}")
    print(f"  UseCases: {usecases_before} -> {sum(len(c.get('useCases', [])) for t in ch04_before['topics'] for c in t.get('concepts', []))}")
    print(f"  Questions: {questions_before} -> {sum(len(t.get('questions', [])) for t in ch04_before['topics'])}")
    print(f"  Version: 0.23.0-audit-pass -> {TARGET_VERSION}")


if __name__ == "__main__":
    main()
