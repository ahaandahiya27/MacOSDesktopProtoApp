#!/usr/bin/env python3
"""Idempotent patch for Chapter 5 (Acids, Bases and Salts) — expands useCases,
adds new concepts, adds T03, wires bidirectional cross-chapter links, bumps version."""

import json, os, sys, copy

PACK_PATH = os.path.join(os.path.dirname(__file__), "..",
    "Subjects", "Packs", "science_class7.json")

TARGET_VERSION = "0.25.0-ch05-full"

ALLOWED_DOMAINS = {
    "home", "kitchen", "weather", "human body", "animals", "sport",
    "technology", "industry", "travel", "science", "building",
    "agriculture", "transport", "clothing"
}

# ─── additional useCases for existing concepts ──────────────────────────

EXTRA_USE_CASES = {
    "ch05_t01_c01": [
        {"title": "Lemon juice on a cut stings", "description": "Lemon juice contains citric acid. When it touches a wound, the acid irritates exposed nerve endings, causing a sharp sting.", "domain": "human body"},
        {"title": "Sour taste of tamarind chutney", "description": "Tamarind contains tartaric acid, giving chutney its sour punch. The sour taste is the tongue's way of detecting acids.", "domain": "kitchen"},
        {"title": "Vinegar for cleaning windows", "description": "Acetic acid in vinegar dissolves mineral deposits on glass, making it a cheap, natural cleaner.", "domain": "home"},
        {"title": "Acid in car batteries", "description": "Car batteries use dilute sulphuric acid as an electrolyte, allowing chemical reactions that produce electric current.", "domain": "technology"},
        {"title": "Citric acid as a food preservative", "description": "Citric acid lowers pH, preventing bacterial growth. It is added to jams, soft drinks, and canned fruit.", "domain": "industry"},
        {"title": "Ants spray formic acid", "description": "When an ant bites, it injects formic acid under your skin. The acid causes the itchy, burning sensation.", "domain": "animals"},
        {"title": "Acid rain damaging marble statues", "description": "Sulphuric and nitric acids in rain react with calcium carbonate in marble, slowly dissolving historic monuments.", "domain": "building"},
    ],
    "ch05_t01_c02": [
        {"title": "Soap feels slippery", "description": "Soap is a base. Bases feel slippery because they react with the oils on your skin, forming a soapy layer.", "domain": "home"},
        {"title": "Baking soda for heartburn", "description": "Sodium bicarbonate (baking soda) is a mild base that neutralises excess stomach acid, relieving heartburn.", "domain": "human body"},
        {"title": "Lime water in construction", "description": "Calcium hydroxide (lime water) is a base used in whitewashing walls. It reacts with CO2 in air to form a hard white coating.", "domain": "building"},
        {"title": "Ammonia in floor cleaners", "description": "Ammonia is a base that dissolves grease and grime. That is why floor cleaners have a strong, pungent smell.", "domain": "home"},
        {"title": "Milk of magnesia for acidity", "description": "Magnesium hydroxide (milk of magnesia) is a mild base doctors prescribe to neutralise excess stomach acid.", "domain": "human body"},
        {"title": "KOH in soft soap making", "description": "Potassium hydroxide (a strong base) reacts with fats to produce liquid soap — the process is called saponification.", "domain": "industry"},
        {"title": "Ash water for washing in villages", "description": "Wood ash dissolved in water forms a mild base (potassium carbonate). Rural communities have used it for washing clothes for centuries.", "domain": "home"},
    ],
    "ch05_t01_c03": [
        {"title": "Litmus paper in a school lab", "description": "Blue litmus turns red in acid; red litmus turns blue in base. It is the simplest indicator test taught in every school.", "domain": "science"},
        {"title": "Turmeric stain turns red with soap", "description": "Turmeric is a natural indicator. A yellow turmeric stain on a white shirt turns red-brown when washed with soap (a base).", "domain": "home"},
        {"title": "Phenolphthalein in titrations", "description": "Phenolphthalein is colourless in acid and turns pink in base. Chemists use it to find the exact point of neutralisation.", "domain": "science"},
        {"title": "pH paper for swimming pools", "description": "Pool operators dip pH paper in water. The colour change shows if the water is too acidic or too basic for safe swimming.", "domain": "sport"},
        {"title": "Red cabbage juice indicator", "description": "Red cabbage juice turns red in acid, purple in neutral, green in mild base, and yellow in strong base — a rainbow of colours!", "domain": "kitchen"},
        {"title": "Universal indicator in water testing", "description": "Water treatment plants use universal indicator to check that drinking water is close to pH 7 (neutral) before distribution.", "domain": "technology"},
        {"title": "Hibiscus tea changes colour", "description": "Hibiscus petals contain natural indicators. Adding lemon (acid) turns the tea brighter red; adding baking soda (base) turns it blue-green.", "domain": "kitchen"},
    ],
    "ch05_t02_c01": [
        {"title": "Antacid tablet fizzes in water", "description": "Antacid tablets contain a base that neutralises stomach acid. The fizz is CO2 released during the neutralisation reaction.", "domain": "human body"},
        {"title": "Bee sting remedy", "description": "A bee injects acidic venom. Applying baking soda paste (a base) neutralises the acid and reduces pain.", "domain": "animals"},
        {"title": "Wasp sting remedy", "description": "A wasp injects alkaline venom. Applying vinegar (an acid) neutralises the base. Opposite remedy to a bee sting!", "domain": "animals"},
        {"title": "Farmers adding lime to acidic soil", "description": "Calcium hydroxide (lime) is a base. Adding it to acidic soil neutralises the acid, making the soil better for crops.", "domain": "agriculture"},
        {"title": "Factory waste treatment", "description": "Acidic factory waste is neutralised with lime (a base) before release. This prevents acid from entering rivers.", "domain": "industry"},
        {"title": "Indigestion after spicy food", "description": "Spicy food can increase stomach acid. A glass of cold milk (slightly basic) helps neutralise the excess acid.", "domain": "kitchen"},
        {"title": "Toothpaste neutralises mouth acid", "description": "Bacteria in the mouth produce acids that cause cavities. Toothpaste is mildly basic, neutralising these acids.", "domain": "human body"},
    ],
    "ch05_t02_c02": [
        {"title": "Table salt on food", "description": "Sodium chloride (NaCl) is the most common salt, formed from hydrochloric acid + sodium hydroxide. We sprinkle it on food daily.", "domain": "kitchen"},
        {"title": "Baking soda in cakes", "description": "Sodium bicarbonate (NaHCO3) is a salt that releases CO2 when heated, making cakes rise and become fluffy.", "domain": "kitchen"},
        {"title": "Plaster of Paris for casts", "description": "Calcium sulphate (a salt) mixed with water sets hard. Doctors use it to make plaster casts for broken bones.", "domain": "human body"},
        {"title": "Road de-icing with rock salt", "description": "Spreading salt (NaCl) on icy roads lowers the freezing point of water, preventing dangerous ice formation.", "domain": "transport"},
        {"title": "Salt in food preservation", "description": "Salt draws water out of bacteria by osmosis, killing them. This is why pickles, salted fish, and cured meat last months.", "domain": "kitchen"},
        {"title": "Epsom salt bath", "description": "Magnesium sulphate (Epsom salt) dissolved in warm water is used to soothe sore muscles after exercise.", "domain": "sport"},
        {"title": "Copper sulphate in farming", "description": "Copper sulphate (a blue salt) is sprayed on crops as a fungicide, protecting them from fungal diseases.", "domain": "agriculture"},
    ],
}

# ─── new concepts to add ─────────────────────────────────────────────

NEW_T01_CONCEPTS = [
    {
        "id": "ch05_t01_c04",
        "title": "The pH scale — measuring acidity and alkalinity",
        "explanations": {
            "oneLine": "The pH scale runs from 0 (strongest acid) through 7 (neutral) to 14 (strongest base).",
            "kidFriendly": "Think of pH as a ruler for sourness and bitterness. Zero is super-sour acid, 7 is plain water, and 14 is super-bitter base. The lower the number, the more acidic; the higher, the more basic.",
            "textbook": "pH is defined as the negative logarithm of hydrogen-ion concentration: pH = -log[H+]. Pure water at 25 C has pH 7. Values below 7 indicate acidic solutions; above 7 indicate basic (alkaline) solutions.",
            "expert": "pH quantifies the activity of hydronium ions (H3O+) in solution. The scale is logarithmic: each unit change represents a tenfold change in [H+]. Buffer systems in biological organisms maintain narrow pH ranges critical for enzyme function."
        },
        "useCases": [
            {"title": "Testing swimming pool water", "description": "Pool pH must stay between 7.2 and 7.8. Too low irritates eyes; too high reduces chlorine effectiveness.", "domain": "sport"},
            {"title": "Blood pH is tightly controlled", "description": "Human blood maintains pH 7.35-7.45. Even small deviations can be life-threatening, so the body uses buffer systems.", "domain": "human body"},
            {"title": "Soil pH for blueberries", "description": "Blueberries thrive in acidic soil (pH 4.5-5.5). Farmers add sulphur to lower pH for better berry harvests.", "domain": "agriculture"},
            {"title": "Aquarium pH for tropical fish", "description": "Most tropical fish need pH 6.5-7.5. Fish keepers test weekly and add pH adjusters if needed.", "domain": "home"},
            {"title": "Shampoo pH and hair health", "description": "Hair cuticles close at pH 4.5-5.5. Good shampoos are slightly acidic to keep hair smooth and shiny.", "domain": "home"},
            {"title": "pH of rainwater", "description": "Normal rain is slightly acidic (pH ~5.6) due to dissolved CO2. Below pH 5.0 it is classified as acid rain.", "domain": "weather"},
            {"title": "Wine-making and pH control", "description": "Winemakers measure grape must pH (around 3.0-3.5). Too high and the wine tastes flat; too low and it is unpleasantly tart.", "domain": "industry"},
            {"title": "Stomach acid pH", "description": "Stomach acid (HCl) has pH 1.5-3.5, strong enough to dissolve small bones but kept from damaging the stomach by a mucus lining.", "domain": "human body"},
            {"title": "pH of household bleach", "description": "Bleach has pH ~12.5, making it a strong base. It kills germs by breaking down proteins, but must be handled with care.", "domain": "home"},
            {"title": "Concrete durability and pH", "description": "Fresh concrete has pH ~13 due to calcium hydroxide. This high alkalinity protects steel reinforcement from rusting.", "domain": "building"}
        ],
        "relatedConceptIds": ["ch05_t01_c01", "ch05_t01_c02", "ch05_t01_c03"]
    },
    {
        "id": "ch05_t01_c05",
        "title": "Strong vs weak acids and bases",
        "explanations": {
            "oneLine": "Strong acids/bases fully split into ions in water; weak ones only partially split.",
            "kidFriendly": "Imagine a bag of marbles. A strong acid dumps ALL marbles into the water at once. A weak acid only drops a few at a time. More marbles (ions) in the water means a stronger reaction.",
            "textbook": "Strong acids (e.g. HCl, H2SO4) fully dissociate in aqueous solution, producing a high concentration of H+ ions. Weak acids (e.g. CH3COOH, H2CO3) only partially dissociate, establishing an equilibrium.",
            "expert": "Dissociation constants (Ka for acids, Kb for bases) quantify the extent of ionisation. Strong acids have very large Ka values (effectively complete dissociation), while weak acids like acetic acid (Ka ≈ 1.8 × 10^-5) exist largely in molecular form."
        },
        "useCases": [
            {"title": "Battery acid is a strong acid", "description": "Car batteries use dilute sulphuric acid (a strong acid) because it fully ionises, providing maximum conductivity for the electric current.", "domain": "technology"},
            {"title": "Vinegar is a weak acid", "description": "Acetic acid in vinegar only partially ionises in water. That is why vinegar is safe on salads but can still dissolve limescale.", "domain": "kitchen"},
            {"title": "Caustic soda drain cleaner", "description": "NaOH (a strong base) fully dissociates, making it powerful enough to dissolve hair and grease blocking drains.", "domain": "home"},
            {"title": "Baking soda is a weak base", "description": "NaHCO3 only partially ionises. It is mild enough to use in cooking and as a gentle cleaning agent.", "domain": "kitchen"},
            {"title": "Hydrochloric acid in the stomach", "description": "HCl in gastric juice is a strong acid. The stomach lining produces mucus to protect itself from this powerful acid.", "domain": "human body"},
            {"title": "Citric acid in soft drinks", "description": "Citric acid is a weak acid added to colas and sodas for tartness. It is safe to drink because it only partially ionises.", "domain": "industry"},
            {"title": "Ammonia cleaning solution", "description": "Ammonia is a weak base. It is effective enough to cut grease but mild enough for household use when diluted.", "domain": "home"},
            {"title": "Carbonic acid in sparkling water", "description": "CO2 dissolved in water forms carbonic acid (H2CO3), a weak acid that gives sparkling water its mild tang.", "domain": "kitchen"},
            {"title": "Strong base in soap making", "description": "NaOH (strong base) reacts with fats to make soap. The reaction works because NaOH fully dissociates, providing abundant OH- ions.", "domain": "industry"},
            {"title": "Weak acid in food preservation", "description": "Benzoic acid (weak) is added to pickles and sauces. Its gentle acidity inhibits microbial growth without harsh taste.", "domain": "kitchen"}
        ],
        "relatedConceptIds": ["ch05_t01_c01", "ch05_t01_c02", "ch05_t01_c04"]
    },
    {
        "id": "ch05_t01_c06",
        "title": "Natural indicators — turmeric, litmus, and more",
        "explanations": {
            "oneLine": "Many plants contain pigments that change colour in acids and bases, acting as natural indicators.",
            "kidFriendly": "Nature has its own pH test kit! Turmeric turns red in bases, litmus paper (from lichens) turns red in acids and blue in bases, and red cabbage juice gives a whole rainbow of colours depending on the pH.",
            "textbook": "Natural indicators are substances derived from plants or organisms whose colour depends on pH. Litmus is extracted from lichens; turmeric contains curcumin, which changes from yellow to red above pH 8.6. Anthocyanins in red cabbage produce a wide colour range across the pH spectrum.",
            "expert": "Curcumin undergoes keto-enol tautomerism; the enolate form (predominant above pH 8.6) absorbs at a different wavelength, causing the yellow-to-red shift. Anthocyanins' flavylium cation is red at low pH; the quinoidal base form appears blue/green at higher pH."
        },
        "useCases": [
            {"title": "Turmeric stain test at home", "description": "Rub turmeric paste on paper. Dip one strip in lemon juice (stays yellow) and another in soap water (turns red). Instant indicator!", "domain": "home"},
            {"title": "Litmus paper in the chemistry lab", "description": "Students test unknown solutions with red and blue litmus paper to classify them as acid, base, or neutral.", "domain": "science"},
            {"title": "Red cabbage juice rainbow", "description": "Boil red cabbage, collect the purple juice. Add different household liquids to see colours from red (acid) to yellow (strong base).", "domain": "kitchen"},
            {"title": "Beetroot juice as an indicator", "description": "Beetroot juice turns yellow in bases. It is less precise than litmus but works in a pinch for a home experiment.", "domain": "kitchen"},
            {"title": "Hibiscus tea colour changes", "description": "Hibiscus flowers contain anthocyanins. Adding lemon turns the tea bright red; adding baking soda turns it green.", "domain": "kitchen"},
            {"title": "China rose indicator", "description": "Petals of China rose (Hibiscus rosa-sinensis) soaked in water make a pink solution that turns green in bases.", "domain": "science"},
            {"title": "Marigold petals in rural testing", "description": "Marigold petal extract turns colourless in acids and yellow in bases. Village communities use it for simple soil tests.", "domain": "agriculture"},
            {"title": "Lichen-based litmus production", "description": "Litmus is commercially extracted from Roccella lichens found on rocky coasts. The dye is absorbed into paper strips.", "domain": "industry"},
            {"title": "Onion juice indicator", "description": "Onion juice loses its smell in bases. Scientists have used this to detect bases in the absence of paper indicators.", "domain": "science"},
            {"title": "Grape juice indicator", "description": "Purple grape juice turns red in acid and greenish in base due to anthocyanins, making it a fun classroom demo.", "domain": "science"}
        ],
        "relatedConceptIds": ["ch05_t01_c03", "ch05_t01_c04", "ch05_t01_c01"]
    },
    {
        "id": "ch05_t01_c07",
        "title": "Acids and bases in the kitchen",
        "explanations": {
            "oneLine": "Many foods and cleaning products in the kitchen are acids or bases that we use every day.",
            "kidFriendly": "Your kitchen is a chemistry lab! Lemon juice, vinegar, and curd are acids. Baking soda, soap, and oven cleaner are bases. When you cook, you are mixing acids and bases without even knowing it!",
            "textbook": "Common kitchen acids include acetic acid (vinegar, pH ~2.5), citric acid (lemons, pH ~2), and lactic acid (curd, pH ~4.5). Kitchen bases include sodium bicarbonate (baking soda, pH ~8.3), soap (pH ~10), and oven cleaner (NaOH, pH ~13).",
            "expert": "Maillard reactions in cooking are pH-dependent; alkaline conditions accelerate browning. Leavening relies on acid-base reactions: baking powder combines NaHCO3 with a dry acid (cream of tartar) that reacts when moistened, releasing CO2."
        },
        "useCases": [
            {"title": "Vinegar in salad dressing", "description": "Acetic acid gives vinaigrette its tangy flavour and also acts as a mild preservative by lowering pH.", "domain": "kitchen"},
            {"title": "Baking soda makes cakes rise", "description": "When NaHCO3 reacts with an acid (buttermilk, lemon), CO2 gas is produced, creating air bubbles that make the cake fluffy.", "domain": "kitchen"},
            {"title": "Curd sets because of lactic acid", "description": "Bacteria convert lactose in milk to lactic acid. The acid curdles the milk proteins, forming curd.", "domain": "kitchen"},
            {"title": "Tamarind paste in South Indian cooking", "description": "Tartaric acid in tamarind balances spice with sourness and tenderises meat by breaking down proteins.", "domain": "kitchen"},
            {"title": "Cleaning a kettle with vinegar", "description": "Limescale (calcium carbonate) dissolves in acetic acid: CaCO3 + 2CH3COOH → Ca(CH3COO)2 + H2O + CO2.", "domain": "home"},
            {"title": "Soap for washing greasy pans", "description": "Soap (a base) saponifies grease, breaking fat molecules into tiny droplets that water can wash away.", "domain": "home"},
            {"title": "Lemon juice prevents browning of apples", "description": "Citric acid lowers the pH on the apple surface, slowing the enzyme-driven oxidation that turns flesh brown.", "domain": "kitchen"},
            {"title": "Oven cleaner dissolves burnt food", "description": "NaOH in oven cleaner is a strong base that breaks down carbonised food by attacking carbon-hydrogen bonds.", "domain": "home"},
            {"title": "Buttermilk tenderises meat", "description": "Lactic acid in buttermilk partially denatures meat proteins, making the meat softer before cooking.", "domain": "kitchen"},
            {"title": "Washing soda for laundry", "description": "Sodium carbonate (washing soda) is a base that softens hard water and boosts detergent power.", "domain": "home"}
        ],
        "relatedConceptIds": ["ch05_t01_c01", "ch05_t01_c02", "ch05_t02_c01"]
    },
]

NEW_T02_CONCEPTS = [
    {
        "id": "ch05_t02_c03",
        "title": "Acid rain — when the sky turns sour",
        "explanations": {
            "oneLine": "When factories and vehicles release sulphur dioxide and nitrogen oxides, these gases dissolve in rain to form sulphuric and nitric acids.",
            "kidFriendly": "Imagine rain that is sour like lemon juice! When smoke from factories mixes with clouds, the rain that falls can be acidic enough to damage buildings, kill fish, and hurt trees.",
            "textbook": "Acid rain has pH below 5.0, caused primarily by SO2 and NOx emissions. SO2 + H2O → H2SO3 (sulphurous acid), which oxidises to H2SO4. NOx + H2O → HNO3. Acid rain corrodes limestone, marble, and metals, and acidifies lakes and soil.",
            "expert": "Wet and dry deposition of sulphate and nitrate aerosols affect ecosystems at multiple trophic levels. Buffering capacity of soils (dependent on CaCO3 content) determines vulnerability. Cap-and-trade systems for SO2 emissions have significantly reduced acid rain in developed nations."
        },
        "useCases": [
            {"title": "Taj Mahal turning yellow", "description": "Acid rain reacts with the white marble (CaCO3) of the Taj Mahal, causing it to yellow and crumble. This is called 'marble cancer'.", "domain": "building"},
            {"title": "Dead fish in Scandinavian lakes", "description": "In the 1970s, lakes in Norway and Sweden became so acidic from acid rain that fish populations collapsed.", "domain": "animals"},
            {"title": "Damaged forests in Germany", "description": "The Black Forest suffered severe 'Waldsterben' (forest death) in the 1980s due to acid rain leaching nutrients from soil.", "domain": "agriculture"},
            {"title": "Corroded railway bridges", "description": "Acid rain accelerates rusting of steel structures like railway bridges, increasing maintenance costs.", "domain": "transport"},
            {"title": "Catalytic converters reduce NOx", "description": "Modern cars have catalytic converters that reduce nitrogen oxide emissions, helping to decrease acid rain.", "domain": "technology"},
            {"title": "Scrubbers in coal power plants", "description": "Flue gas desulphurisation (scrubbers) remove SO2 from smokestack emissions, dramatically cutting acid rain.", "domain": "industry"},
            {"title": "Limestone buffer in acidified lakes", "description": "Spreading powdered limestone (CaCO3) in acidified lakes neutralises the acid, helping fish return.", "domain": "science"},
            {"title": "Acid rain on heritage buildings in India", "description": "Many ancient temples and monuments in industrial areas of India show acid rain damage to their stone surfaces.", "domain": "building"},
            {"title": "pH of normal rain vs acid rain", "description": "Normal rain is pH ~5.6 (slightly acidic due to CO2). Acid rain is pH 4.0-5.0 — ten times more acidic.", "domain": "weather"},
            {"title": "Indoor plants and acid rain", "description": "Watering houseplants with collected rainwater in polluted cities can gradually acidify the soil.", "domain": "home"}
        ],
        "relatedConceptIds": ["ch05_t01_c04", "ch05_t01_c01", "ch05_t02_c01"]
    },
    {
        "id": "ch05_t02_c04",
        "title": "Antacids and bee stings — neutralisation in daily life",
        "explanations": {
            "oneLine": "Neutralisation reactions happen all around us: antacids calm stomachs, baking soda soothes stings, and toothpaste fights mouth acids.",
            "kidFriendly": "Got a tummy ache from too much acid? Take an antacid — it is a base that neutralises the extra acid. Bee sting hurting? Dab baking soda (base) to calm the acid. Neutralisation is your everyday superhero!",
            "textbook": "Antacids (e.g. Mg(OH)2, Al(OH)3, NaHCO3) neutralise excess HCl in the stomach: Mg(OH)2 + 2HCl → MgCl2 + 2H2O. Insect stings inject acids (formic acid in ants) or bases (wasp venom), treatable by applying the opposite.",
            "expert": "Commercial antacids are formulated with combinations of bases (Mg(OH)2 for fast action, Al(OH)3 for sustained effect) to avoid rebound hyperacidity. Prostaglandin-mediated mucosal protection is enhanced by maintaining intragastric pH above 4."
        },
        "useCases": [
            {"title": "Antacid tablet after a heavy meal", "description": "Overeating triggers extra stomach acid. An antacid (milk of magnesia) neutralises the acid and stops the burning.", "domain": "human body"},
            {"title": "Baking soda paste on an ant bite", "description": "Ant venom contains formic acid. A paste of baking soda (NaHCO3) applied to the bite neutralises the acid and reduces itching.", "domain": "human body"},
            {"title": "Vinegar on a wasp sting", "description": "Wasp venom is alkaline. Applying vinegar (acetic acid) neutralises the base and eases the pain.", "domain": "human body"},
            {"title": "Toothpaste fighting tooth decay", "description": "Bacteria produce acids that dissolve tooth enamel. Brushing with basic toothpaste neutralises these acids.", "domain": "human body"},
            {"title": "Calamine lotion on insect bites", "description": "Calamine (zinc carbonate) is a mild base that soothes acid-induced skin irritation from insect bites.", "domain": "human body"},
            {"title": "Lime on an acidic sports field", "description": "Sports grounds officers add lime (calcium hydroxide) to neutralise acidic soil, ensuring even grass growth.", "domain": "sport"},
            {"title": "Treating acid spill in a lab", "description": "If acid spills on a lab bench, sprinkling sodium bicarbonate neutralises it safely before wiping clean.", "domain": "science"},
            {"title": "Nettle sting and dock leaf", "description": "Nettle stings inject formic acid. Dock leaves contain a base that soothes the sting when rubbed on.", "domain": "animals"},
            {"title": "Alkaline eye drops", "description": "If acid splashes in the eye, mild alkaline saline is used to irrigate and neutralise the acid quickly.", "domain": "human body"},
            {"title": "Acid indigestion in athletes", "description": "Intense exercise can increase stomach acid. Runners sometimes carry antacid tablets for relief during long races.", "domain": "sport"}
        ],
        "relatedConceptIds": ["ch05_t02_c01", "ch05_t01_c01", "ch05_t01_c02"]
    },
    {
        "id": "ch05_t02_c05",
        "title": "Soil pH and farming — why farmers add lime",
        "explanations": {
            "oneLine": "Different crops need different soil pH; farmers test and adjust soil pH by adding lime (base) or organic matter (acid).",
            "kidFriendly": "Just like you need the right temperature to be comfortable, plants need the right soil pH to grow well. If the soil is too sour (acidic), farmers add lime to sweeten it. If it is too basic, they add compost.",
            "textbook": "Soil pH affects nutrient availability. Most crops thrive in pH 6.0-7.5. Acidic soils (pH < 6) are treated with CaCO3 or Ca(OH)2 (liming). Alkaline soils (pH > 8) benefit from addition of sulphur or organic matter, which produce acids as they decompose.",
            "expert": "Soil pH governs cation exchange capacity, microbial activity, and the solubility of nutrients (e.g. phosphorus is most available at pH 6-7). Aluminium toxicity occurs below pH 5, inhibiting root growth. Liming rate is calculated from buffer pH and soil CEC."
        },
        "useCases": [
            {"title": "Liming acidic paddy fields", "description": "Rice paddies in heavy rainfall areas become acidic. Farmers add powdered limestone before planting to bring pH up.", "domain": "agriculture"},
            {"title": "Tea gardens need acidic soil", "description": "Tea plants love pH 4.5-5.5. Tea estates in Assam and Darjeeling avoid liming to keep soil acidic.", "domain": "agriculture"},
            {"title": "Blueberries in acidic beds", "description": "Blueberry farmers add sulphur to soil to lower pH to 4.5-5.5, because the plants cannot absorb iron at higher pH.", "domain": "agriculture"},
            {"title": "Composting to lower alkaline soil pH", "description": "In arid regions with alkaline soil, adding compost introduces organic acids that gradually lower pH.", "domain": "agriculture"},
            {"title": "pH testing kits for farmers", "description": "Simple soil pH kits use indicator dye: mix soil with water and reagent, compare colour to a chart.", "domain": "agriculture"},
            {"title": "Acid soil and aluminium toxicity", "description": "Below pH 5, aluminium ions become soluble and toxic to roots. Liming locks aluminium back into insoluble forms.", "domain": "science"},
            {"title": "Coastal salt-affected soils", "description": "Seawater intrusion makes soil alkaline. Farmers add gypsum (CaSO4) to displace sodium and lower pH.", "domain": "agriculture"},
            {"title": "Earthworms prefer neutral soil", "description": "Earthworms thrive at pH 6-7. Their burrowing aerates soil — another reason to keep pH balanced.", "domain": "animals"},
            {"title": "Flower colour and soil pH", "description": "Hydrangeas bloom pink in alkaline soil and blue in acidic soil — a natural pH indicator in your garden!", "domain": "home"},
            {"title": "Organic farming and pH management", "description": "Organic farmers avoid chemical amendments, using wood ash (base) and pine needles (acid) to adjust pH naturally.", "domain": "agriculture"}
        ],
        "relatedConceptIds": ["ch05_t01_c04", "ch05_t02_c01", "ch05_t02_c03"]
    },
]

NEW_T03 = {
    "id": "ch05_t03",
    "title": "Acids and bases in industry and nature",
    "concepts": [
        {
            "id": "ch05_t03_c01",
            "title": "Acids in industry — from batteries to fertilisers",
            "explanations": {
                "oneLine": "Sulphuric acid is the world's most-produced chemical, used in batteries, fertilisers, and metal processing.",
                "kidFriendly": "Factories use acids for all sorts of things! Sulphuric acid helps make the fertiliser that feeds crops, the batteries in your car, and even the steel in bridges. It is the most used chemical on the planet.",
                "textbook": "H2SO4 is used in lead-acid batteries, phosphate fertiliser production (superphosphate), petroleum refining, and steel pickling. HCl cleans metal surfaces. HNO3 is used in explosives and fertilisers (ammonium nitrate).",
                "expert": "Global H2SO4 production exceeds 260 million tonnes annually, serving as a proxy for industrial development. The Contact Process (V2O5 catalyst, 450°C) converts SO3 to H2SO4. Fertiliser production (Haber-Bosch → HNO3 → NH4NO3) consumes ~1% of global energy."
            },
            "useCases": [
                {"title": "Car battery acid", "description": "Lead-acid batteries use dilute H2SO4 (about 35%). The acid reacts with lead plates to produce electricity.", "domain": "technology"},
                {"title": "Superphosphate fertiliser", "description": "Treating rock phosphate with H2SO4 produces superphosphate, a fertiliser that provides phosphorus to crops.", "domain": "agriculture"},
                {"title": "Pickling steel beams", "description": "Before painting or galvanising, steel is dipped in HCl to remove rust and oxide layers — called 'pickling'.", "domain": "industry"},
                {"title": "Petroleum refining", "description": "H2SO4 is used to remove impurities from petroleum products, acting as a catalyst in alkylation processes.", "domain": "industry"},
                {"title": "Ammonium nitrate for farming", "description": "HNO3 + NH3 → NH4NO3, one of the most widely used nitrogen fertilisers worldwide.", "domain": "agriculture"},
                {"title": "Etching printed circuit boards", "description": "Ferric chloride (made from HCl) dissolves unwanted copper from circuit boards, leaving the designed tracks.", "domain": "technology"},
                {"title": "Tanning leather", "description": "Acids help remove hair and flesh from hides during the leather tanning process.", "domain": "industry"},
                {"title": "Sugar refining", "description": "Phosphoric acid (H3PO4) clarifies raw sugar by causing impurities to settle out.", "domain": "industry"},
                {"title": "HCl in PVC production", "description": "Hydrochloric acid is a by-product and reactant in making PVC plastic — the stuff of water pipes.", "domain": "industry"},
                {"title": "Acid in gold extraction", "description": "Aqua regia (HCl + HNO3 mix) can dissolve gold. Refineries use it to purify gold to 99.99%.", "domain": "industry"}
            ],
            "relatedConceptIds": ["ch05_t01_c01", "ch05_t01_c05", "ch05_t02_c03"]
        },
        {
            "id": "ch05_t03_c02",
            "title": "The chemistry of tooth decay",
            "explanations": {
                "oneLine": "Bacteria in the mouth produce acids that dissolve tooth enamel, causing cavities; fluoride and brushing help fight back.",
                "kidFriendly": "After you eat sweets, tiny bacteria in your mouth throw an acid party. The acid eats into your tooth enamel and makes holes (cavities). Brushing with toothpaste (a base) washes the acid away and protects your teeth!",
                "textbook": "Oral bacteria (Streptococcus mutans) metabolise sugars to produce lactic acid. When plaque pH drops below 5.5, hydroxyapatite [Ca10(PO4)6(OH)2] in enamel begins to dissolve. Fluoride replaces OH- to form fluorapatite, which is more acid-resistant.",
                "expert": "Demineralisation occurs when the ion activity product of calcium and phosphate in plaque fluid drops below the solubility product of hydroxyapatite (Ksp ≈ 10^-117). Fluorapatite (Ksp ≈ 10^-121) resists dissolution at lower pH. Saliva's bicarbonate buffer (pH 6.2-7.4) provides natural remineralisation."
            },
            "useCases": [
                {"title": "Brushing after sugary snacks", "description": "Brushing removes plaque and neutralises acid. Waiting 30 minutes after eating avoids brushing softened enamel.", "domain": "human body"},
                {"title": "Fluoride toothpaste", "description": "Fluoride strengthens enamel by forming fluorapatite, which resists acid attack better than regular enamel.", "domain": "human body"},
                {"title": "Sugar-free chewing gum", "description": "Chewing gum stimulates saliva flow. Saliva is mildly basic and washes away acid, reducing cavity risk.", "domain": "human body"},
                {"title": "Dental sealants", "description": "A thin resin coating on molars blocks bacteria from settling in grooves, preventing acid production.", "domain": "human body"},
                {"title": "Acid erosion from fizzy drinks", "description": "Cola (pH ~2.5) and energy drinks are very acidic. Regular sipping bathes teeth in acid, eroding enamel.", "domain": "human body"},
                {"title": "Cheese after a meal", "description": "Cheese raises mouth pH quickly because it contains calcium and phosphate, which help remineralise enamel.", "domain": "kitchen"},
                {"title": "Xylitol candies", "description": "Xylitol is a sugar substitute that bacteria cannot ferment into acid, reducing cavity-causing acid production.", "domain": "human body"},
                {"title": "Baby bottle tooth decay", "description": "Prolonged bottle-feeding with milk or juice bathes baby teeth in sugar, leading to severe acid-driven decay.", "domain": "human body"},
                {"title": "Streptococcus mutans — the cavity bacteria", "description": "S. mutans converts sucrose to lactic acid faster than other mouth bacteria, making it the main cavity culprit.", "domain": "science"},
                {"title": "Water fluoridation", "description": "Many countries add tiny amounts of fluoride to drinking water (0.7 ppm) to reduce tooth decay across the population.", "domain": "technology"}
            ],
            "relatedConceptIds": ["ch05_t01_c01", "ch05_t02_c04", "ch05_t01_c04"]
        },
        {
            "id": "ch05_t03_c03",
            "title": "Ocean acidification — acids in the sea",
            "explanations": {
                "oneLine": "The ocean absorbs CO2 from the air, forming carbonic acid that lowers seawater pH and threatens marine life.",
                "kidFriendly": "The ocean is like a giant sponge for CO2. But when too much CO2 dissolves, it makes carbonic acid, turning the sea slightly sour. This makes it hard for corals and shellfish to build their homes from calcium carbonate.",
                "textbook": "CO2 + H2O → H2CO3 → H+ + HCO3-. Since pre-industrial times, ocean pH has dropped from 8.2 to 8.1 — a 26% increase in acidity. Lower pH reduces carbonate ion availability, making it harder for calcifying organisms (corals, molluscs, foraminifera) to build CaCO3 shells.",
                "expert": "Ocean uptake accounts for ~25% of anthropogenic CO2 emissions. The carbonate saturation horizon is shoaling, threatening deep-sea calcifiers. Projected pH decrease of 0.3-0.4 units by 2100 (RCP 8.5) would push aragonite undersaturation into productive surface waters."
            },
            "useCases": [
                {"title": "Coral bleaching and acidification", "description": "Acidic water weakens coral skeletons. Combined with warming, it triggers mass bleaching events that kill reefs.", "domain": "animals"},
                {"title": "Oyster hatchery failures", "description": "In the US Pacific Northwest, oyster larvae failed to grow shells as seawater pH dropped, devastating the industry.", "domain": "industry"},
                {"title": "Pteropods — sea butterflies dissolving", "description": "Tiny sea snails called pteropods have shells that visibly dissolve in acidified water, breaking the food chain.", "domain": "animals"},
                {"title": "Kelp forests as CO2 sinks", "description": "Kelp absorbs CO2 locally, raising pH in surrounding water and providing refuge for shellfish.", "domain": "science"},
                {"title": "Great Barrier Reef under threat", "description": "Australia's Great Barrier Reef shows reduced calcification rates linked to ocean acidification and warming.", "domain": "animals"},
                {"title": "Carbon capture and ocean chemistry", "description": "Proposals to inject CO2 deep underground aim to reduce atmospheric CO2 and slow ocean acidification.", "domain": "technology"},
                {"title": "Clownfish losing their way", "description": "Studies show acidified water impairs clownfish ability to smell predators and find their anemone homes.", "domain": "animals"},
                {"title": "pH monitoring buoys", "description": "Oceanic buoys equipped with pH sensors track acidification trends across the world's oceans in real time.", "domain": "technology"},
                {"title": "Seagrass meadows buffering acidity", "description": "Seagrass photosynthesis absorbs CO2, locally raising pH and protecting nearby shellfish beds.", "domain": "science"},
                {"title": "Historical ocean pH from ice cores", "description": "Air bubbles in Antarctic ice cores reveal pre-industrial CO2 levels, helping scientists calculate past ocean pH.", "domain": "science"}
            ],
            "relatedConceptIds": ["ch05_t02_c03", "ch05_t01_c04", "ch04_t03_c02"]
        }
    ],
    "questions": [
        {
            "id": "ch05_t03_q01",
            "type": "mcq",
            "prompt": "Which acid is produced in the largest quantity worldwide?",
            "options": ["Hydrochloric acid", "Sulphuric acid", "Nitric acid", "Acetic acid"],
            "answer": "Sulphuric acid",
            "explanation": "Sulphuric acid (H2SO4) is the world's most produced chemical, used in fertilisers, batteries, and metal processing."
        },
        {
            "id": "ch05_t03_q02",
            "type": "mcq",
            "prompt": "Tooth decay happens because bacteria produce:",
            "options": ["Bases", "Salts", "Acids", "Water"],
            "answer": "Acids",
            "explanation": "Bacteria like S. mutans convert sugars into lactic acid, which dissolves tooth enamel."
        },
        {
            "id": "ch05_t03_q03",
            "type": "mcq",
            "prompt": "Ocean acidification is caused by the ocean absorbing too much:",
            "options": ["Oxygen", "Carbon dioxide", "Nitrogen", "Methane"],
            "answer": "Carbon dioxide",
            "explanation": "CO2 dissolves in seawater to form carbonic acid, lowering the ocean's pH."
        }
    ]
}

# ─── cross-chapter links ────────────────────────────────────────────────
CROSS_LINKS = {
    "ch05_t02_c03": ["ch04_t03_c02"],  # acid rain ↔ climate change
    "ch05_t03_c03": ["ch04_t03_c02"],  # ocean acidification ↔ climate change
    "ch05_t01_c01": ["ch04_t02_c01"],  # acids ↔ conduction (dissolving)
}

def main():
    with open(PACK_PATH, "r") as f:
        data = json.load(f)

    if data.get("version") == TARGET_VERSION:
        print(f"Already at {TARGET_VERSION} — validating only.")
        validate(data)
        return

    ch = next(c for c in data["chapters"] if c["id"] == "ch05")

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
    t01 = next(t for t in ch["topics"] if t["id"] == "ch05_t01")
    existing_ids = {c["id"] for c in t01["concepts"]}
    for nc in NEW_T01_CONCEPTS:
        if nc["id"] not in existing_ids:
            t01["concepts"].append(nc)

    # 3. Add new concepts to T02
    t02 = next(t for t in ch["topics"] if t["id"] == "ch05_t02")
    existing_ids = {c["id"] for c in t02["concepts"]}
    for nc in NEW_T02_CONCEPTS:
        if nc["id"] not in existing_ids:
            t02["concepts"].append(nc)

    # 4. Add T03 if missing
    existing_topic_ids = {t["id"] for t in ch["topics"]}
    if "ch05_t03" not in existing_topic_ids:
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
    ch = next(c for c in data["chapters"] if c["id"] == "ch05")
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
