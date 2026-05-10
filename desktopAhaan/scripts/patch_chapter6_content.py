#!/usr/bin/env python3
"""Idempotent patch for Chapter 6 (Physical and Chemical Changes) — expands useCases,
adds new concepts, adds T03, wires bidirectional cross-chapter links, bumps version."""

import json, os, sys, copy

PACK_PATH = os.path.join(os.path.dirname(__file__), "..",
    "Subjects", "Packs", "science_class7.json")

TARGET_VERSION = "0.26.0-ch06-full"

ALLOWED_DOMAINS = {
    "home", "kitchen", "weather", "human body", "animals", "sport",
    "technology", "industry", "travel", "science", "building",
    "agriculture", "transport", "clothing"
}

# ─── additional useCases for existing concepts ──────────────────────────

EXTRA_USE_CASES = {
    "ch06_t01_c01": [
        {"title": "Melting butter in a pan", "description": "Butter changes from solid to liquid when heated — same substance, just a different state. Cool it down and it solidifies again.", "domain": "kitchen"},
        {"title": "Crumpling a sheet of paper", "description": "The paper ball is still paper — same molecules, different shape. Flatten it and it is almost the same as before.", "domain": "home"},
        {"title": "Dissolving sugar in tea", "description": "Sugar seems to disappear but it is still there (taste it!). Evaporate the water and the sugar crystals return.", "domain": "kitchen"},
        {"title": "Stretching a rubber band", "description": "The rubber changes shape but its molecules stay the same. Release it and it returns to its original form.", "domain": "home"},
        {"title": "Freezing water into ice cubes", "description": "Water molecules slow down and lock into a crystal pattern. Melt the ice and you get exactly the same water back.", "domain": "kitchen"},
        {"title": "Breaking a chalk stick", "description": "Two pieces of chalk are still chalk — CaCO3. Only the size changed, not the substance.", "domain": "science"},
        {"title": "Grinding wheat into flour", "description": "The grain becomes powder but the starch and protein molecules are unchanged — a purely physical change.", "domain": "agriculture"},
    ],
    "ch06_t01_c02": [
        {"title": "Burning a matchstick", "description": "The wood reacts with oxygen to form CO2, water vapour, and ash — entirely new substances with different properties.", "domain": "home"},
        {"title": "Curdling milk with lemon", "description": "Citric acid causes milk proteins to clump (denature). The curd formed is a new substance that cannot become milk again.", "domain": "kitchen"},
        {"title": "Iron nail in copper sulphate solution", "description": "Iron displaces copper: Fe + CuSO4 → FeSO4 + Cu. The nail gets coated with reddish copper — a new substance.", "domain": "science"},
        {"title": "Burning firecrackers", "description": "Gunpowder undergoes rapid chemical change, producing light, heat, sound, and smoke — all new substances.", "domain": "home"},
        {"title": "Digesting food in the stomach", "description": "Enzymes break complex food molecules into simpler ones (amino acids, glucose). These are chemically different from the original food.", "domain": "human body"},
        {"title": "Ripening of a banana", "description": "Enzymes convert starch to sugar and chlorophyll to carotenoids — new molecules give the banana its sweet taste and yellow colour.", "domain": "kitchen"},
        {"title": "Photosynthesis in a leaf", "description": "CO2 + H2O → C6H12O6 + O2 in sunlight. Entirely new substances (glucose, oxygen) form from simple inputs.", "domain": "science"},
    ],
    "ch06_t01_c03": [
        {"title": "Rusting garden gate", "description": "Iron in the gate reacts with oxygen and water to form hydrated iron(III) oxide — the flaky brown rust.", "domain": "home"},
        {"title": "Rusting ship hull", "description": "Seawater accelerates rusting. Ships are painted and fitted with sacrificial zinc anodes to protect the hull.", "domain": "transport"},
        {"title": "Rust on bicycle chain", "description": "A bicycle chain rusts quickly if not oiled. The oil film prevents water and oxygen from reaching the iron.", "domain": "sport"},
        {"title": "Rusting railway tracks", "description": "Tracks rust where water collects. Railway engineers use weather-resistant steel alloys to slow the process.", "domain": "transport"},
        {"title": "Rust experiment: three test tubes", "description": "Nail in air+water = rust. Nail in boiled water (no air) = no rust. Nail in dry air (CaCl2) = no rust. Both needed!", "domain": "science"},
        {"title": "Rusting of bridges", "description": "Bridge cables and beams are painted regularly. A single coat of paint blocks oxygen and moisture.", "domain": "building"},
        {"title": "Ancient iron pillar of Delhi", "description": "The 1600-year-old Iron Pillar barely rusts because it contains phosphorus, which forms a protective layer.", "domain": "science"},
    ],
    "ch06_t02_c01": [
        {"title": "Making rock candy at home", "description": "Dissolve sugar in hot water, hang a string, and wait. As water evaporates, sugar crystals grow on the string — crystallisation!", "domain": "kitchen"},
        {"title": "Salt harvesting from seawater", "description": "Seawater in shallow pans evaporates in the sun. Salt crystals left behind are collected — this is natural crystallisation.", "domain": "industry"},
        {"title": "Purifying copper sulphate", "description": "Dissolve impure CuSO4 in hot water, filter, cool slowly. Pure blue crystals form, leaving impurities in solution.", "domain": "science"},
        {"title": "Snowflake formation", "description": "Water vapour in clouds crystallises into hexagonal ice crystals. Each snowflake's pattern depends on temperature and humidity.", "domain": "weather"},
        {"title": "Alum crystals in water purification", "description": "Alum crystals are added to muddy water. They cause dirt particles to clump and settle — a traditional purification method.", "domain": "home"},
        {"title": "Diamond — carbon crystallised under pressure", "description": "Diamonds form when carbon atoms arrange in a crystal lattice deep underground under extreme heat and pressure.", "domain": "science"},
        {"title": "Crystallisation in chocolate tempering", "description": "Chocolate-makers control crystal formation during tempering. The right crystals give chocolate its snap and glossy finish.", "domain": "industry"},
    ],
}

# ─── new concepts ──────────────────────────────────────────────────────

NEW_T01_CONCEPTS = [
    {
        "id": "ch06_t01_c04",
        "title": "Signs of a chemical reaction",
        "explanations": {
            "oneLine": "Chemical changes show at least one sign: colour change, gas production, temperature change, precipitate, or new smell.",
            "kidFriendly": "How do you know a chemical change happened? Look for clues! Did the colour change? Did bubbles appear? Did it get hot or cold? Did a solid form in the liquid? Did it start smelling different? Any of these = chemical change!",
            "textbook": "Observable indicators of chemical change include: (1) change in colour, (2) evolution of gas (bubbles), (3) change in temperature (exothermic or endothermic), (4) formation of a precipitate, and (5) change in odour. The presence of one or more signs suggests a new substance has formed.",
            "expert": "These macroscopic signs reflect molecular-level rearrangements. Colour changes arise from altered electronic transitions (new chromophores). Gas evolution indicates volatile product formation. Temperature changes reflect enthalpy differences (ΔH) between reactants and products."
        },
        "useCases": [
            {"title": "Silver tarnishing black", "description": "Silver reacts with sulphur in the air to form black silver sulphide — a clear colour change signalling chemical reaction.", "domain": "home"},
            {"title": "Baking soda and vinegar fizz", "description": "Mixing them produces CO2 bubbles (gas evolution) and the solution feels cold (endothermic) — two signs at once.", "domain": "kitchen"},
            {"title": "Burning camphor", "description": "White camphor burns to produce light, heat, and a strong smell — multiple signs of chemical change.", "domain": "home"},
            {"title": "Adding acid to limestone", "description": "HCl + CaCO3 → CaCl2 + H2O + CO2. Vigorous bubbling (gas) confirms a chemical reaction.", "domain": "science"},
            {"title": "Mixing lead nitrate and potassium iodide", "description": "Two clear solutions produce a bright yellow precipitate (PbI2) — a dramatic sign of chemical change.", "domain": "science"},
            {"title": "Milk turning sour", "description": "Bacteria convert lactose to lactic acid. The sour smell and changed taste are signs of chemical change.", "domain": "kitchen"},
            {"title": "Rusting nail colour change", "description": "Shiny grey iron turns flaky reddish-brown — the colour change tells you a new substance (iron oxide) has formed.", "domain": "home"},
            {"title": "Exothermic cement setting", "description": "When cement mix sets, it gets warm. The heat release signals chemical reactions between cement and water.", "domain": "building"},
            {"title": "Rotten egg smell of hydrogen sulphide", "description": "When organic matter decomposes, H2S gas forms. The terrible smell is a chemical-change indicator.", "domain": "science"},
            {"title": "Fireworks colour and bang", "description": "Different metal salts produce different colours (Sr = red, Ba = green, Cu = blue). Colour, sound, and heat = chemical change.", "domain": "home"}
        ],
        "relatedConceptIds": ["ch06_t01_c02", "ch06_t01_c01", "ch06_t01_c03"]
    },
    {
        "id": "ch06_t01_c05",
        "title": "Burning, cooking, and digestion as chemical changes",
        "explanations": {
            "oneLine": "Burning, cooking, and digestion are all chemical changes because they produce entirely new substances.",
            "kidFriendly": "When wood burns it becomes ash and smoke — you cannot unburn it. When you cook an egg, the clear white turns solid — you cannot uncook it. When you digest food, enzymes break it into tiny molecules your body can use. All irreversible, all chemical!",
            "textbook": "Combustion (burning) is an exothermic reaction with O2. Cooking denatures proteins and gelatinises starches through heat-driven chemical reactions. Digestion uses enzymes (biological catalysts) to hydrolyse complex molecules into absorbable monomers.",
            "expert": "Combustion follows radical chain mechanisms: initiation, propagation, termination. Maillard reactions in cooking produce hundreds of flavour compounds from amino acid-sugar interactions above 140°C. Digestive enzymes (pepsin pH 1.5-2, trypsin pH 8) operate at specific pH optima."
        },
        "useCases": [
            {"title": "Burning wood in a campfire", "description": "Wood + O2 → CO2 + H2O + ash + heat. The wood is gone forever — new substances formed.", "domain": "home"},
            {"title": "Cooking a boiled egg", "description": "Heat denatures albumin proteins — the clear liquid turns white and solid. Cannot be reversed.", "domain": "kitchen"},
            {"title": "Toast browning in a toaster", "description": "The Maillard reaction between sugars and amino acids creates hundreds of new flavour and colour molecules.", "domain": "kitchen"},
            {"title": "Digesting a chapati", "description": "Amylase in saliva breaks starch into maltose; further enzymes convert it to glucose — entirely different molecules.", "domain": "human body"},
            {"title": "Burning petrol in a car engine", "description": "C8H18 + O2 → CO2 + H2O + energy. The chemical energy in petrol becomes motion energy.", "domain": "transport"},
            {"title": "Forest fire consuming trees", "description": "Uncontrolled combustion converts organic matter to ash, CO2, and water vapour — massive chemical change.", "domain": "weather"},
            {"title": "Grilling vegetables on a barbecue", "description": "High heat caramelises sugars (chemical) and chars cellulose (combustion) — both are chemical changes.", "domain": "kitchen"},
            {"title": "Candle burning", "description": "Wax melts (physical) then vaporises and burns (chemical): C25H52 + O2 → CO2 + H2O + light.", "domain": "home"},
            {"title": "Stomach acid digesting food", "description": "HCl and pepsin in the stomach break proteins into peptides — chemical bonds are broken and new molecules form.", "domain": "human body"},
            {"title": "Burning coal in a power plant", "description": "Coal (mostly carbon) + O2 → CO2. The chemical energy becomes heat, then electricity.", "domain": "industry"}
        ],
        "relatedConceptIds": ["ch06_t01_c02", "ch06_t01_c04", "ch06_t01_c06"]
    },
    {
        "id": "ch06_t01_c06",
        "title": "Reversible vs irreversible changes",
        "explanations": {
            "oneLine": "Reversible changes can go back to the original state (melting ice); irreversible changes cannot (burning paper).",
            "kidFriendly": "Some changes are like a zip — you can undo them. Freeze water, melt it, freeze again — back and forth! But other changes are like breaking an egg — you can never unbreak it. Those are irreversible.",
            "textbook": "Reversible changes: the substance can return to its original form (e.g. melting, dissolving, evaporation). Irreversible changes: new substances form and the original cannot be recovered by simple physical means (e.g. burning, cooking, rusting).",
            "expert": "Thermodynamic reversibility is an idealisation; real processes have entropy increases. However, many physical changes approximate reversibility (solid ⇌ liquid ⇌ gas). Chemical changes that are 'irreversible' in common parlance may be thermodynamically reversible under different conditions (e.g. electrolysis reverses water's formation)."
        },
        "useCases": [
            {"title": "Melting and freezing chocolate", "description": "Melt chocolate, let it cool — it solidifies again. Physical change, fully reversible (though crystal structure may differ).", "domain": "kitchen"},
            {"title": "Dissolving salt and evaporating", "description": "Dissolve salt in water, boil off the water — salt crystals return. Reversible.", "domain": "kitchen"},
            {"title": "Burning a log to ash", "description": "Once burnt, wood becomes ash, CO2, and water vapour. You cannot reassemble a log from these. Irreversible.", "domain": "home"},
            {"title": "Inflating and deflating a balloon", "description": "Air goes in, balloon expands; let air out, it shrinks. Reversible physical change.", "domain": "home"},
            {"title": "Cooking a pancake", "description": "Batter becomes a firm pancake through protein denaturation. You cannot turn a pancake back into batter. Irreversible.", "domain": "kitchen"},
            {"title": "Folding and unfolding a shirt", "description": "Creases appear and disappear — the fabric molecules are unchanged. Reversible physical change.", "domain": "clothing"},
            {"title": "Rusting an iron nail", "description": "Fe → Fe2O3. The rust cannot spontaneously become iron again (would need smelting). Irreversible chemical change.", "domain": "home"},
            {"title": "Evaporating and condensing water", "description": "Water evaporates from a puddle, forms clouds, condenses as rain. The water cycle is reversible.", "domain": "weather"},
            {"title": "Setting of cement", "description": "Cement powder + water → hard concrete through chemical reactions. Cannot be reversed to powder. Irreversible.", "domain": "building"},
            {"title": "Stretching and releasing a spring", "description": "A spring returns to its original shape (within elastic limit). Reversible physical change.", "domain": "science"}
        ],
        "relatedConceptIds": ["ch06_t01_c01", "ch06_t01_c02", "ch06_t01_c05"]
    },
    {
        "id": "ch06_t01_c07",
        "title": "Galvanisation and preventing rust",
        "explanations": {
            "oneLine": "Galvanisation coats iron with zinc to prevent rusting; other methods include painting, oiling, alloying, and electroplating.",
            "kidFriendly": "Iron rusts when air and water touch it. So we cover it up! Dipping iron in molten zinc (galvanisation) gives it a tough shield. Painting, oiling, and mixing iron with other metals (stainless steel) also keep rust away.",
            "textbook": "Galvanisation involves dipping iron or steel in molten zinc (melting point 420°C). Zinc acts as a sacrificial anode: even if scratched, zinc corrodes preferentially, protecting the iron. Other methods: painting (barrier), oiling (barrier), alloying (chromium in stainless steel forms Cr2O3 passive layer).",
            "expert": "In galvanic protection, zinc (E° = -0.76 V) is more electropositive than iron (E° = -0.44 V), so it oxidises preferentially in the electrochemical series. Hot-dip galvanising produces intermetallic Fe-Zn layers. Stainless steel's passive Cr2O3 film self-heals in oxidising environments."
        },
        "useCases": [
            {"title": "Galvanised iron roofing sheets", "description": "Corrugated iron roofs last decades because the zinc coating prevents rust even in rain.", "domain": "building"},
            {"title": "Zinc-coated water pipes", "description": "Water supply pipes are galvanised to prevent rust contaminating drinking water.", "domain": "home"},
            {"title": "Oiling a bicycle chain", "description": "A thin oil layer on the chain blocks water and air, preventing rust. Must be reapplied regularly.", "domain": "sport"},
            {"title": "Painting a garden fence", "description": "Paint forms a physical barrier between iron and the atmosphere. Chipped paint exposes iron to rust.", "domain": "home"},
            {"title": "Stainless steel kitchen sink", "description": "Chromium in stainless steel forms an invisible Cr2O3 layer that self-heals when scratched.", "domain": "kitchen"},
            {"title": "Chrome-plated car bumpers", "description": "Electroplating with chromium gives a shiny, rust-resistant finish to steel car parts.", "domain": "transport"},
            {"title": "Anti-rust spray on tools", "description": "WD-40 and similar sprays leave an oily film that displaces moisture and protects metal tools.", "domain": "home"},
            {"title": "Sacrificial zinc on ship hulls", "description": "Zinc blocks are bolted to steel hulls. The zinc corrodes instead of the hull — sacrificial protection.", "domain": "transport"},
            {"title": "Powder coating on appliances", "description": "A dry powder is electrostatically sprayed and baked onto steel. The tough coating prevents rust for years.", "domain": "industry"},
            {"title": "Alloying to make weathering steel", "description": "Corten steel contains copper and phosphorus. Its rust layer is stable and actually protects the metal beneath.", "domain": "building"}
        ],
        "relatedConceptIds": ["ch06_t01_c03", "ch06_t01_c02", "ch06_t01_c06"]
    },
    {
        "id": "ch06_t01_c08",
        "title": "Physical vs chemical — tricky cases",
        "explanations": {
            "oneLine": "Some changes are hard to classify: dissolving, tearing, and mixing can be tricky — the key test is whether a new substance forms.",
            "kidFriendly": "Is dissolving sugar physical or chemical? Tricky! Sugar molecules stay the same — they just spread out in water. So it is physical. But dissolving an antacid in water IS chemical because new products (salt + water + CO2) form. The golden rule: did a NEW substance appear?",
            "textbook": "Borderline cases: dissolving salt in water (physical — ionic dissociation without new substance), dissolving metals in acid (chemical — new salts form), cutting/tearing (physical — same substance), dry ice sublimation (physical — CO2 state change). The definitive test is whether the change produces a substance with different chemical properties.",
            "expert": "The physical/chemical distinction, while pedagogically useful, is not always sharp. Dissolution of ionic compounds involves breaking the lattice (endothermic) and hydration of ions (exothermic). Allotropic transitions (diamond ↔ graphite) involve bond rearrangement yet are sometimes classified as physical. Context and the formation of new chemical species remain the primary criteria."
        },
        "useCases": [
            {"title": "Dissolving salt in water", "description": "NaCl dissociates into Na+ and Cl- ions. No new substance — evaporate and salt returns. Physical change.", "domain": "kitchen"},
            {"title": "Dissolving zinc in acid", "description": "Zn + 2HCl → ZnCl2 + H2. New substances (zinc chloride, hydrogen gas) form. Chemical change.", "domain": "science"},
            {"title": "Dry ice sublimation", "description": "Solid CO2 turns directly to gas. Same molecule — just a state change. Physical.", "domain": "science"},
            {"title": "Mixing sand and salt", "description": "Both substances keep their identity. You can separate them by dissolving salt in water. Physical.", "domain": "science"},
            {"title": "Making an alloy (brass)", "description": "Mixing copper and zinc melts creates brass. Some argue physical (no new compound); others note metallic bonding changes. Borderline!", "domain": "industry"},
            {"title": "Tearing aluminium foil", "description": "The foil is still aluminium — same atoms, same properties. Only size changed. Physical.", "domain": "home"},
            {"title": "Heating sugar till it caramelises", "description": "Gentle heating melts sugar (physical). Continued heating breaks molecules into new compounds (chemical) — caramelisation.", "domain": "kitchen"},
            {"title": "Whipping cream", "description": "Air is trapped in fat globules — no new substance. But over-whipping breaks fat membranes (chemical). It depends on degree!", "domain": "kitchen"},
            {"title": "Magnetising an iron bar", "description": "Domains align but atoms stay the same. Demagnetise and it is back to normal. Physical.", "domain": "science"},
            {"title": "Souring of wine to vinegar", "description": "Bacteria convert ethanol to acetic acid — a new molecule with different taste and properties. Chemical.", "domain": "kitchen"}
        ],
        "relatedConceptIds": ["ch06_t01_c01", "ch06_t01_c02", "ch06_t01_c04"]
    },
]

NEW_T02_CONCEPTS = [
    {
        "id": "ch06_t02_c02",
        "title": "Growing crystals at home — a fun experiment",
        "explanations": {
            "oneLine": "You can grow beautiful crystals at home using sugar, salt, or alum dissolved in hot water and left to cool slowly.",
            "kidFriendly": "Want to grow your own crystals? Dissolve as much sugar or alum as you can in hot water. Hang a string in the solution and wait a few days. Crystals will grow on the string like magic! The slower they grow, the bigger and prettier they get.",
            "textbook": "A supersaturated solution is created by dissolving solute in hot water beyond its room-temperature solubility. As the solution cools, excess solute deposits on a seed crystal or nucleation site. Slow cooling produces larger, well-formed crystals; rapid cooling produces many small crystals.",
            "expert": "Crystal growth involves nucleation (formation of stable clusters exceeding critical radius) and growth (layer-by-layer addition at step edges). The growth rate depends on supersaturation, temperature, and impurity adsorption. Burton-Cabrera-Frank theory describes spiral growth around screw dislocations."
        },
        "useCases": [
            {"title": "Rock candy on a stick", "description": "A string dipped in supersaturated sugar solution grows large sugar crystals over 5-7 days — edible science!", "domain": "kitchen"},
            {"title": "Alum crystal growing competition", "description": "Schools hold alum crystal contests. Students compete to grow the largest, clearest crystal by controlling cooling rate.", "domain": "science"},
            {"title": "Epsom salt crystal garden", "description": "Dissolve Epsom salt in hot water, pour over sponge pieces, and watch needle-like crystals sprout overnight.", "domain": "home"},
            {"title": "Copper sulphate blue diamonds", "description": "CuSO4 crystals are deep blue and triclinic. Growing them from saturated solution is a classic lab exercise.", "domain": "science"},
            {"title": "Borax snowflake ornaments", "description": "Pipe-cleaner shapes dipped in borax solution grow sparkling crystals overnight — popular holiday craft.", "domain": "home"},
            {"title": "Salt crystal garden with charcoal", "description": "Charcoal bricks soaked in salt, bluing, and ammonia grow colourful crystal towers over days.", "domain": "home"},
            {"title": "Seed crystal technique", "description": "Tie a small perfect crystal to a thread and hang it in saturated solution. It grows layer by layer into a large crystal.", "domain": "science"},
            {"title": "Geode-making with eggshells", "description": "Coat eggshell halves with alum powder, soak in dyed alum solution. Crystals grow inside, mimicking natural geodes.", "domain": "home"},
            {"title": "Temperature control for crystal size", "description": "A fridge produces many tiny crystals (fast cooling). A cupboard produces fewer large ones (slow cooling).", "domain": "science"},
            {"title": "Sugar crystals in jam making", "description": "If jam cools too slowly or has excess sugar, crystals form in the jar — crystallisation in action.", "domain": "kitchen"}
        ],
        "relatedConceptIds": ["ch06_t02_c01", "ch06_t01_c01", "ch06_t02_c03"]
    },
    {
        "id": "ch06_t02_c03",
        "title": "Crystals in nature and industry",
        "explanations": {
            "oneLine": "From diamonds deep underground to silicon chips in computers, crystals are everywhere in nature and modern technology.",
            "kidFriendly": "Crystals are not just pretty — they run the world! The diamond on a ring, the quartz in a watch, the silicon in your computer chip, and even the salt on your food are all crystals. Nature and factories both make crystals, just at different speeds.",
            "textbook": "Natural crystals form over geological timescales (quartz, diamond, calcite) or rapidly (snowflakes, salt flats). Industrial crystallisation produces pure chemicals, pharmaceuticals, and semiconductor wafers. Silicon single crystals grown by the Czochralski process are the basis of microelectronics.",
            "expert": "Czochralski growth pulls a single crystal from a melt at controlled rates. Zone refining achieves 99.9999% purity. Epitaxial growth deposits crystalline layers atom by atom for semiconductor devices. Protein crystallography (X-ray diffraction) reveals 3D structures critical for drug design."
        },
        "useCases": [
            {"title": "Quartz crystals in watches", "description": "A tiny quartz crystal vibrates exactly 32,768 times per second when electrified, keeping your watch accurate.", "domain": "technology"},
            {"title": "Silicon wafers for computer chips", "description": "Pure silicon crystals are sliced into wafers and etched with billions of transistors — the heart of every device.", "domain": "technology"},
            {"title": "Diamond drill bits", "description": "Diamond (crystalline carbon) is the hardest natural material. Industrial diamonds tip drill bits for cutting rock.", "domain": "industry"},
            {"title": "Salt flats in Gujarat (Rann of Kutch)", "description": "Seawater evaporates in desert heat, leaving vast salt crystal deposits harvested by local communities.", "domain": "agriculture"},
            {"title": "Snowflakes — natural ice crystals", "description": "Each snowflake is a hexagonal ice crystal. Their shape depends on temperature and humidity during formation.", "domain": "weather"},
            {"title": "Calcite crystals in limestone caves", "description": "Stalactites and stalagmites are calcite crystals deposited from dripping mineral-rich water over thousands of years.", "domain": "science"},
            {"title": "Pharmaceutical crystallisation", "description": "Drug molecules are crystallised to ensure consistent purity, particle size, and dissolution rate in tablets.", "domain": "industry"},
            {"title": "Gemstones — emeralds, rubies, sapphires", "description": "These gems are crystals of common minerals with trace impurities giving colour (Cr in ruby, Fe/Ti in sapphire).", "domain": "science"},
            {"title": "LCD screens use liquid crystals", "description": "Liquid crystal molecules align under electric fields to block or pass light, creating the images on your screen.", "domain": "technology"},
            {"title": "Sugar refining by crystallisation", "description": "Raw cane juice is boiled and cooled repeatedly. Each crystallisation cycle produces purer white sugar.", "domain": "industry"}
        ],
        "relatedConceptIds": ["ch06_t02_c01", "ch06_t02_c02", "ch06_t01_c01"]
    },
]

NEW_T03 = {
    "id": "ch06_t03",
    "title": "Chemical changes in everyday life",
    "concepts": [
        {
            "id": "ch06_t03_c01",
            "title": "Baking soda and vinegar — chemistry in your kitchen",
            "explanations": {
                "oneLine": "Mixing baking soda (NaHCO3) with vinegar (CH3COOH) produces sodium acetate, water, and carbon dioxide gas.",
                "kidFriendly": "The classic volcano experiment! Pour vinegar onto baking soda and — WHOOSH — a fizzy eruption! The fizz is CO2 gas, formed when the acid (vinegar) reacts with the base (baking soda). It is a real chemical reaction happening right in your kitchen.",
                "textbook": "NaHCO3 + CH3COOH → CH3COONa + H2O + CO2↑. This is an acid-base reaction. The CO2 gas causes effervescence. The reaction is exothermic but feels cold because CO2 expansion absorbs heat (endothermic dissolution of gas).",
                "expert": "The reaction proceeds via proton transfer from acetic acid to bicarbonate ion, forming carbonic acid (H2CO3) which rapidly decomposes to CO2 and H2O. The enthalpy of reaction is approximately -94 kJ/mol. Sodium acetate trihydrate formed in concentrated solutions exhibits interesting supersaturation properties (hot ice)."
            },
            "useCases": [
                {"title": "Volcano science project", "description": "Students build a clay volcano, pour vinegar into baking soda inside, and watch CO2 foam erupt — a classic demo.", "domain": "science"},
                {"title": "Cleaning a clogged drain", "description": "Pour baking soda then vinegar down the drain. The fizzing CO2 loosens grease and debris.", "domain": "home"},
                {"title": "Inflating a balloon with CO2", "description": "Put baking soda in a balloon, stretch it over a vinegar bottle. CO2 produced inflates the balloon — no blowing needed!", "domain": "science"},
                {"title": "Baking powder in cakes", "description": "Baking powder contains NaHCO3 + dry acid. When wet, they react to produce CO2, making the cake rise.", "domain": "kitchen"},
                {"title": "Cleaning tarnished coins", "description": "Soaking old coins in vinegar with a pinch of baking soda helps remove oxidation and tarnish.", "domain": "home"},
                {"title": "DIY fire extinguisher", "description": "CO2 from baking soda + vinegar can smother a small candle flame — CO2 is heavier than air and cuts off oxygen.", "domain": "science"},
                {"title": "Fizzy lemonade from scratch", "description": "A pinch of baking soda in lemon juice creates fizzy bubbles — homemade sparkling lemonade!", "domain": "kitchen"},
                {"title": "Hot ice (sodium acetate crystallisation)", "description": "Concentrated sodium acetate solution supercools. Touch it and it crystallises instantly, releasing heat — hot ice!", "domain": "science"},
                {"title": "Removing sticky labels", "description": "A baking soda paste with vinegar breaks down adhesive residue on glass jars.", "domain": "home"},
                {"title": "CO2 gas collection experiment", "description": "Collect CO2 from the reaction in an inverted bottle. Test with a burning splint — it goes out, confirming CO2.", "domain": "science"}
            ],
            "relatedConceptIds": ["ch06_t01_c02", "ch06_t01_c04", "ch05_t02_c01"]
        },
        {
            "id": "ch06_t03_c02",
            "title": "Fireworks and sparklers — spectacular chemical reactions",
            "explanations": {
                "oneLine": "Fireworks contain metal salts that burn with characteristic colours: strontium for red, barium for green, copper for blue.",
                "kidFriendly": "Fireworks are the most spectacular chemical reactions you can see! Different metals burn with different colours: strontium = red, barium = green, copper = blue, sodium = yellow. The 'bang' comes from gases expanding super fast.",
                "textbook": "Fireworks contain an oxidiser (KNO3 or KClO4), a fuel (charcoal, sulphur), a binder, and colour-producing metal salts. When ignited, the exothermic reaction produces hot gases (expansion = bang), and metal atoms emit characteristic wavelengths of light (flame emission).",
                "expert": "Colour production involves electronic excitation of metal atoms/ions. Sr2+ emits at 606 nm (red), Ba2+ at 524 nm (green), Cu2+ at 420 nm (blue). Aluminium or magnesium powder provides white sparks via incandescence. Timing is controlled by shell architecture and fuse burn rates."
            },
            "useCases": [
                {"title": "Diwali fireworks display", "description": "Indian celebrations use chemical reactions in crackers — potassium nitrate provides oxygen, metal salts provide colour.", "domain": "home"},
                {"title": "Sparklers on birthdays", "description": "Iron filings and barium nitrate burn slowly on a wire, producing golden sparks — a controlled chemical reaction.", "domain": "home"},
                {"title": "Red signal flares at sea", "description": "Maritime flares contain strontium nitrate for a bright red flame visible for kilometres — a lifesaving chemical reaction.", "domain": "transport"},
                {"title": "Green fireworks from barium", "description": "Barium chloride burns with a green flame. Firework makers mix it carefully to get the right shade.", "domain": "industry"},
                {"title": "Blue fireworks — the hardest colour", "description": "Copper compounds produce blue, but the colour is fragile at high temperatures. Achieving deep blue is a fireworks challenge.", "domain": "industry"},
                {"title": "Flame test in the lab", "description": "Students dip wire loops in metal salts and hold them in a flame. Each metal gives a characteristic colour.", "domain": "science"},
                {"title": "Olympic torch relay", "description": "The Olympic torch uses a chemical fuel that burns reliably in wind and rain — chemistry ensures it stays lit.", "domain": "sport"},
                {"title": "Magnesium ribbon burning bright white", "description": "Mg burns at 3100°C with intense white light: 2Mg + O2 → 2MgO. Used in early camera flash bulbs.", "domain": "science"},
                {"title": "Smoke bombs in sports events", "description": "Coloured smoke bombs use organic dyes vaporised by an exothermic chemical reaction.", "domain": "sport"},
                {"title": "Thermite welding of railway tracks", "description": "Fe2O3 + 2Al → 2Fe + Al2O3. The reaction produces molten iron at 2500°C, fusing tracks together.", "domain": "transport"}
            ],
            "relatedConceptIds": ["ch06_t01_c02", "ch06_t01_c04", "ch06_t01_c05"]
        },
        {
            "id": "ch06_t03_c03",
            "title": "Photosynthesis and respiration — life's chemical engines",
            "explanations": {
                "oneLine": "Photosynthesis builds glucose from CO2 and water using sunlight; respiration breaks glucose back down to release energy.",
                "kidFriendly": "Plants are amazing chemical factories! They take CO2 from the air and water from the soil, add sunlight, and make glucose (food) + oxygen. Animals do the reverse: they eat glucose, breathe oxygen, and get energy + CO2. It is a beautiful chemical cycle!",
                "textbook": "Photosynthesis: 6CO2 + 6H2O + light energy → C6H12O6 + 6O2 (endothermic, in chloroplasts). Respiration: C6H12O6 + 6O2 → 6CO2 + 6H2O + energy (exothermic, in mitochondria). Together, they form a carbon-oxygen cycle essential for life.",
                "expert": "Photosynthesis involves light-dependent reactions (photolysis of H2O, NADPH/ATP generation in thylakoids) and the Calvin cycle (CO2 fixation via RuBisCO). Aerobic respiration proceeds through glycolysis, Krebs cycle, and oxidative phosphorylation, yielding ~36-38 ATP per glucose molecule."
            },
            "useCases": [
                {"title": "Trees cleaning city air", "description": "Urban trees absorb CO2 and release O2 through photosynthesis — living air purifiers powered by chemical reactions.", "domain": "science"},
                {"title": "Breathing during exercise", "description": "Muscles need more energy, so respiration rate increases — more glucose burned, more CO2 exhaled.", "domain": "sport"},
                {"title": "Composting fallen leaves", "description": "Microbes respire, breaking down leaf glucose into CO2 and water. The heat they release warms the compost pile.", "domain": "agriculture"},
                {"title": "Aquarium plants and fish balance", "description": "Plants photosynthesise (produce O2), fish respire (produce CO2). A balanced tank has both reactions in harmony.", "domain": "home"},
                {"title": "Greenhouse farming with CO2 enrichment", "description": "Farmers pump extra CO2 into greenhouses to boost photosynthesis and increase crop yields.", "domain": "agriculture"},
                {"title": "Yeast fermentation in bread", "description": "Yeast respires anaerobically: glucose → CO2 + ethanol. The CO2 bubbles make bread dough rise.", "domain": "kitchen"},
                {"title": "Biofuels from plant sugars", "description": "Corn or sugarcane glucose is fermented to ethanol — a biofuel. Photosynthesis captured the sun's energy first.", "domain": "technology"},
                {"title": "Oxygen masks on aeroplanes", "description": "Chemical oxygen generators produce O2 for passengers. The reverse (respiration) is why we need the O2.", "domain": "transport"},
                {"title": "Coral reef photosynthesis", "description": "Zooxanthellae algae inside corals photosynthesise, providing up to 90% of the coral's energy — a chemical partnership.", "domain": "animals"},
                {"title": "Food calories = chemical energy", "description": "A food Calorie measures the energy released when glucose is respired. It is purely a measure of chemical change.", "domain": "human body"}
            ],
            "relatedConceptIds": ["ch06_t01_c02", "ch06_t01_c05", "ch01_t01_c02"]
        }
    ],
    "questions": [
        {
            "id": "ch06_t03_q01",
            "type": "mcq",
            "prompt": "What gas is produced when baking soda reacts with vinegar?",
            "options": ["Oxygen", "Carbon dioxide", "Hydrogen", "Nitrogen"],
            "answer": "Carbon dioxide",
            "explanation": "NaHCO3 + CH3COOH → CH3COONa + H2O + CO2. The fizzing is CO2 gas escaping."
        },
        {
            "id": "ch06_t03_q02",
            "type": "mcq",
            "prompt": "Strontium salts in fireworks produce which colour?",
            "options": ["Blue", "Green", "Red", "Yellow"],
            "answer": "Red",
            "explanation": "Strontium compounds emit red light when heated. Barium = green, copper = blue, sodium = yellow."
        },
        {
            "id": "ch06_t03_q03",
            "type": "mcq",
            "prompt": "Photosynthesis and respiration are:",
            "options": ["Both physical changes", "Both chemical changes", "Photosynthesis is physical, respiration is chemical", "Neither is a change"],
            "answer": "Both chemical changes",
            "explanation": "Both involve forming new substances: photosynthesis makes glucose from CO2+H2O; respiration breaks glucose to CO2+H2O."
        }
    ]
}

CROSS_LINKS = {
    "ch06_t01_c03": ["ch04_t02_c01"],  # rusting ↔ conduction
    "ch06_t03_c03": ["ch01_t01_c02"],  # photosynthesis ↔ ch1 photosynthesis
    "ch06_t03_c01": ["ch05_t02_c01"],  # baking soda+vinegar ↔ neutralisation
}

def main():
    with open(PACK_PATH, "r") as f:
        data = json.load(f)

    if data.get("version") == TARGET_VERSION:
        print(f"Already at {TARGET_VERSION} — validating only.")
        validate(data)
        return

    ch = next(c for c in data["chapters"] if c["id"] == "ch06")

    # 1. Expand useCases on existing concepts
    for topic in ch["topics"]:
        for concept in topic["concepts"]:
            cid = concept["id"]
            if cid in EXTRA_USE_CASES:
                existing_titles = {u["title"] for u in concept["useCases"]}
                for uc in EXTRA_USE_CASES[cid]:
                    if uc["title"] not in existing_titles:
                        concept["useCases"].append(uc)

    # 2. Add new T01 concepts
    t01 = next(t for t in ch["topics"] if t["id"] == "ch06_t01")
    existing_ids = {c["id"] for c in t01["concepts"]}
    for nc in NEW_T01_CONCEPTS:
        if nc["id"] not in existing_ids:
            t01["concepts"].append(nc)

    # 3. Add new T02 concepts
    t02 = next(t for t in ch["topics"] if t["id"] == "ch06_t02")
    existing_ids = {c["id"] for c in t02["concepts"]}
    for nc in NEW_T02_CONCEPTS:
        if nc["id"] not in existing_ids:
            t02["concepts"].append(nc)

    # 4. Add T03 if missing
    existing_topic_ids = {t["id"] for t in ch["topics"]}
    if "ch06_t03" not in existing_topic_ids:
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
    ch = next(c for c in data["chapters"] if c["id"] == "ch06")
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

            expl = concept.get("explanations", {})
            for key in ["oneLine", "kidFriendly", "textbook", "expert"]:
                if key not in expl:
                    errors.append(f"{concept['id']} missing explanation depth: {key}")

            if uc_count < 10:
                errors.append(f"{concept['id']} has only {uc_count} useCases (need >= 10)")

            for uc in concept.get("useCases", []):
                if uc.get("domain") == "medicine":
                    errors.append(f"{concept['id']} useCase '{uc['title']}' uses forbidden domain 'medicine'")

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
