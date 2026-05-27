#!/usr/bin/env python3
"""
enrich_quick_checks.py — one-shot pedagogical enrichment of the 68 scene
quick-check MCQs that the 2026-05-27 migration moved into
science_class7.json's `chapters[].quickCheckQuestions` arrays.

Background:
The migration carried each quick-check's id, prompt, options, and answer,
but left `commonMistakes` and `solutionSteps` empty. Downstream that means
QuestionDetailView's commonMistakesCard renders blank and the hint ladder
(Question.derivedHints → solutionSteps.prefix(2)) has nothing to show when
the kid lands on a missed quick-check from Daily Practice or the D4
"Stuck here?" strip. This script authors 1 solutionStep + 2 commonMistakes
per quick-check so every corrective surface has content to render.

Mirrors migrate_boss_quiz_to_pack.py: per-Q authoring table is hard-coded
below, dry-run is the default, --write applies in place, --force overwrites
already-populated fields.

Run from the repo root:

    # Dry-run — prints the JSON patch (keyed by Q id) to stdout.
    python3 scripts/enrich_quick_checks.py

    # Apply — rewrites science_class7.json in place.
    python3 scripts/enrich_quick_checks.py --write

    # Force-overwrite already-enriched fields.
    python3 scripts/enrich_quick_checks.py --write --force

Idempotency: a second `--write --force` run produces byte-identical output.
CI can assert this via `git diff --quiet` after a re-run.

Length floors (rejected before any write):
  - each commonMistake  >= 30 chars
  - each solutionStep    >= 50 chars

This script is a HISTORICAL ARTEFACT. After the enrichment commit lands it
stays in the repo for the record but is never re-run on a schedule.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
PACK_PATH = REPO_ROOT / "desktopAhaan" / "Subjects" / "Packs" / "science_class7.json"

CM_MIN = 30   # commonMistake minimum length
SS_MIN = 50   # solutionStep minimum length


# ─── Per-Q authoring table ─────────────────────────────────────────────────
# Keyed by quick-check id. Each value: one solutionStep (the WHY of the
# correct answer) and exactly two commonMistakes (one per wrong option,
# quoting the option text verbatim). Kept in chapter order for review.

ENRICHMENT: dict[str, dict] = {
    # ── Ch.3 Fibre to Fabric ──
    "scenecheck_ch03_q00": {
        "solutionStep": "The wash-tub stands for washing in water, and the number inside is the highest temperature the water should reach. Staying at or below that number protects the cloth, because water that is too hot can shrink the fibres or fade the colours.",
        "commonMistakes": [
            "Picking 'Dry clean only' — that has its own symbol, a plain circle, with no water tub. The tub always means it is safe to wash in water, not that you must avoid it.",
            "Picking 'Cannot wash' — a 'do not wash' label shows the tub crossed out. A tub with a number is actually telling you it is fine to wash, just within a temperature limit.",
        ],
    },
    "scenecheck_ch03_q01": {
        "solutionStep": "The triangle on a label is the bleach symbol, and a cross through any care symbol means 'do not do this'. So a crossed-out triangle is telling you that bleach would harm this fabric and must be kept away from it.",
        "commonMistakes": [
            "Picking 'Ironing' — ironing has its own picture, a small iron shape, not a triangle. The triangle only ever stands for bleaching.",
            "Picking 'Tumble dry' — tumble drying is shown by a circle inside a square, which looks nothing like a triangle. Do not let the crossed-out look make you guess; the shape tells you what is banned.",
        ],
    },
    "scenecheck_ch03_q02": {
        "solutionStep": "A square stands for drying and the circle inside it stands for the spinning drum of a tumble dryer. Put together, the circle-in-a-square means the cloth can safely go in a tumble dryer.",
        "commonMistakes": [
            "Picking 'Hand wash' — washing symbols use the wash-tub shape, not a square. A square always points to drying instructions instead.",
            "Picking 'Dry clean' — dry cleaning is just a plain circle on its own, with no square around it. The square box is what changes the meaning to machine tumble drying.",
        ],
    },
    "scenecheck_ch03_q03": {
        "solutionStep": "The iron picture means the fabric can be ironed, and the dots inside set how hot the iron may get — one dot is cool, two is medium, three is hot. More dots simply mean the fibres can handle more heat.",
        "commonMistakes": [
            "Picking 'How many shirts to do' — a care label only describes the one item it is sewn into, never a quantity. The dots are about heat, not counting clothes.",
            "Picking 'How wet it should be' — wetness is shown by drying and washing symbols, not by the iron symbol. Anything inside the iron shape is about its temperature.",
        ],
    },

    # ── Ch.4 Heat ──
    "scenecheck_ch04_q00": {
        "solutionStep": "Conduction and convection both need particles, like solid material or moving air, to carry heat along. A vacuum has almost no particles, so there is nothing to pass the heat through, which shuts down both of those paths at once.",
        "commonMistakes": [
            "Picking 'Radiation only' — radiation travels as rays and needs no particles, so a vacuum cannot stop it. That is exactly why a separate shiny layer is added to deal with radiation.",
            "Picking 'Nothing — it's just decorative' — the empty gap is the most important part of the flask. Removing the particles is what blocks two whole heat paths, so it is doing serious work.",
        ],
    },
    "scenecheck_ch04_q01": {
        "solutionStep": "Heat can also leave as radiation, which is rays that travel even through empty space. A shiny silvered surface bounces those rays back toward the drink instead of letting them pass out, keeping the warmth inside.",
        "commonMistakes": [
            "Picking 'For style' — the silver is hidden inside the flask where nobody sees it, so looks are not the point. Its job is to reflect heat rays back in.",
            "Picking 'To make it heavier' — a thin shiny coating adds almost no weight at all. The mirror-like surface is chosen for how it reflects radiation, not for mass.",
        ],
    },
    "scenecheck_ch04_q02": {
        "solutionStep": "Air is made of particles that can carry heat by conduction and by swirling currents called convection. Filling the gap with air would hand heat those particle paths again, so warmth would leak out far quicker than it does across an empty vacuum.",
        "commonMistakes": [
            "Picking 'Yes, just as well' — air may feel empty, but it is full of particles that pass heat along. That is the very thing the vacuum was made to remove.",
            "Picking 'Only in winter' — the way heat moves does not change with the season. Air would let heat escape faster all year round, not just in cold months.",
        ],
    },
    "scenecheck_ch04_q03": {
        "solutionStep": "The top of the flask is open, and a solid lid touching the hot drink would carry heat straight out by conduction. Cork is a poor conductor, so a cork stopper slows that direct heat escape through the opening more than anything else.",
        "commonMistakes": [
            "Picking 'Cooking the tea' — a stopper cannot cook anything; it only seals the top. Its real job is to block heat from conducting out through the lid.",
            "Picking 'Adding flavour' — cork is there to trap heat, not to season the drink. The question is about stopping a heat path, not about taste.",
        ],
    },

    # ── Ch.5 Acids, Bases and Salts ──
    "scenecheck_ch05_q00": {
        "solutionStep": "When fuels are burned, sulphur dioxide and nitrogen dioxide rise into the air, and these two gases dissolve in raindrops to form sulphuric and nitric acids. That acid mixed into the rain is what we call acid rain.",
        "commonMistakes": [
            "Picking 'O₂ and N₂' — oxygen and nitrogen make up most of the clean air we breathe and do not turn rain acidic. They are harmless and not the gases that cause the problem.",
            "Picking 'CO₂ and CH₄' — these add to global warming, but they are not the main acids in acid rain. The strong acids come from the sulphur and nitrogen oxides instead.",
        ],
    },
    "scenecheck_ch05_q01": {
        "solutionStep": "Even ordinary rain is slightly acidic, near pH 5.6, because a little carbon dioxide from the air dissolves in it. Acid rain forms when stronger pollutant gases push the pH lower than that, dropping below 5.",
        "commonMistakes": [
            "Picking '~7 → stays 7' — pH 7 is exactly neutral, but normal rain is already a touch acidic, not neutral. So this both starts and ends in the wrong place.",
            "Picking '~9 → drops to 6' — pH above 7 means basic, and rain is never basic to begin with. Rain sits on the acidic side and only gets more acidic in acid rain.",
        ],
    },
    "scenecheck_ch05_q02": {
        "solutionStep": "Coal often contains sulphur, and power plants burn huge amounts of it to make electricity. As that sulphur burns it turns into sulphur dioxide, which is why coal-fired power plants release the most of this gas.",
        "commonMistakes": [
            "Picking 'Cars' — vehicles mainly give off nitrogen oxides and carbon gases, with far less sulphur dioxide. They add to pollution but are not the top source of SO₂.",
            "Picking 'Cooking with LPG' — LPG burns quite cleanly and contains very little sulphur. It releases hardly any sulphur dioxide compared with burning coal.",
        ],
    },
    "scenecheck_ch05_q03": {
        "solutionStep": "Limestone is made of a base called calcium carbonate, and acids react with bases and break them down. So the acid in acid rain slowly reacts with the stone, eating away the surface of statues and buildings.",
        "commonMistakes": [
            "Picking 'limestone is acid' — if limestone were an acid it would not react with acid rain at all, since two acids do not neutralise each other. It is the base nature of limestone that lets the acid attack it.",
            "Picking 'limestone reflects sunlight' — sunlight does not chip away at stone monuments. The damage is a chemical reaction with acid, not anything to do with light.",
        ],
    },

    # ── Ch.7 Weather, Climate and Adaptations ──
    "scenecheck_ch07_q00": {
        "solutionStep": "A sun symbol stands for the sky being clear with the sun shining and few or no clouds in the way. That is why forecasters use it to mean a bright, sunny day.",
        "commonMistakes": [
            "Picking 'Cloudy' — a cloudy forecast uses a cloud shape, because clouds would be blocking the sun. A plain sun means the opposite, a clear sky.",
            "Picking 'Foggy' — fog is shown with hazy lines, not a shining sun. The sun symbol tells you the air is clear, not misty.",
        ],
    },
    "scenecheck_ch07_q01": {
        "solutionStep": "The cloud with drops falling from it shows water coming down from the sky, which is rain. Forecasters use those little falling lines to tell you to expect wet weather.",
        "commonMistakes": [
            "Picking 'Snow' — snow forecasts usually show snowflakes or dots, not streaks of falling water. The drop shapes here mean liquid rain, not frozen snow.",
            "Picking 'Drizzle only' — drizzle is just very light rain, while this symbol covers rain in general, including heavier falls. Reading it as 'only' drizzle is too narrow.",
        ],
    },
    "scenecheck_ch07_q02": {
        "solutionStep": "This symbol shows a cloud with both rain and a lightning bolt, and a storm with thunder and lightning is called a thunderstorm. The lightning bolt is the clue that it is more than ordinary rain.",
        "commonMistakes": [
            "Picking 'Heat wave' — a heat wave is about very hot, dry days and would not be drawn with a storm cloud and lightning. The lightning bolt points to a thunderstorm instead.",
            "Picking 'Wind' — windy weather is usually shown with blowing lines or arrows, not a lightning bolt. The bolt is what marks this out as a thunderstorm.",
        ],
    },
    "scenecheck_ch07_q03": {
        "solutionStep": "The wavy horizontal lines stand for thick, hazy air near the ground, which is fog or mist. Those layered lines show that tiny water droplets are floating in the air and making it hard to see far.",
        "commonMistakes": [
            "Picking 'Smoke' — weather forecasts report natural conditions like mist, not smoke from fires. These wavy lines mean foggy, damp air rather than smoke.",
            "Picking 'Pollen' — pollen counts are not shown by this haze symbol, and pollen is not a weather state like fog. The wavy lines are about misty, low visibility air.",
        ],
    },

    # ── Ch.8 Winds, Storms and Cyclones ──
    "scenecheck_ch08_q00": {
        "solutionStep": "Move to the designated shelter the moment a warning is issued. The shelter list is shared before the storm so you can act on the alert itself, not on what you see outside — by the time danger is visible, it is already too late to travel safely.",
        "commonMistakes": [
            "Picking 'Take photos of clouds' — it looks educational, but it keeps you outdoors just as the wind is building. Once a warning is out, every minute outside is a minute of risk.",
            "Picking 'Wait and watch' — cyclone tracks shift fast, so if you wait until you can see it, you are already inside the danger zone. Act on the warning first.",
        ],
    },
    "scenecheck_ch08_q01": {
        "solutionStep": "Keep at least three days of food and water because a strong cyclone can knock out roads, power, and water supply for that long. Shops stay shut and help may not reach you quickly, so your stock has to last until services come back.",
        "commonMistakes": [
            "Picking '12 hours' — a storm and its flooding often last much longer than half a day, so this would run out while you are still cut off from help.",
            "Picking '1 day' — relief teams and repair crews usually need more than a single day to reach a flooded area, so one day's supply leaves you short.",
        ],
    },
    "scenecheck_ch08_q02": {
        "solutionStep": "The innermost room is safest because thick walls on all sides block flying debris, and staying away from glass keeps you safe if windows shatter in the high wind. The fewer outside walls and windows around you, the less danger from things being thrown by the storm.",
        "commonMistakes": [
            "Picking 'Near windows' — glass can break and fly inward under cyclone winds, so standing close to it puts you right where sharp pieces would land.",
            "Picking 'On the roof' — the roof has nothing to shield you and the strongest winds hit there first, making it one of the most dangerous spots.",
        ],
    },
    "scenecheck_ch08_q03": {
        "solutionStep": "The calm 'eye' is only the centre of the storm, so once it passes the other side arrives and the wind blows hard again from the opposite direction. The danger is not over until the whole cyclone has moved away, so you must stay sheltered.",
        "commonMistakes": [
            "Picking 'It's over' — the calm you feel is just the middle of the storm passing over, not the end, and the back half is still coming.",
            "Picking 'Sunshine' — the quiet eye can trick you into thinking the weather has cleared, but the second wall of the cyclone follows right behind it.",
        ],
    },

    # ── Ch.9 Soil ──
    "scenecheck_ch09_q00": {
        "solutionStep": "Rice grows best in clay-heavy soil because clay holds water tightly, and rice fields need to stay flooded while the plants grow. The trapped water gives the roots the standing moisture that rice depends on.",
        "commonMistakes": [
            "Picking 'Sandy' — sandy soil lets water drain straight through, so the field would dry out and rice cannot get the standing water it needs.",
            "Picking 'Desert' — desert soil has almost no water at all, and rice simply cannot survive without plenty of moisture around its roots.",
        ],
    },
    "scenecheck_ch09_q01": {
        "solutionStep": "Tiny decomposer microbes like bacteria and fungi feed on dead leaves and break them down into humus, the dark crumbly part of soil. This is a living process, which is why warmth and moisture only help the microbes do the actual work.",
        "commonMistakes": [
            "Picking 'Sunlight' — sunlight gives energy to growing plants, but it does not break dead matter down into humus the way living microbes do.",
            "Picking 'Rain only' — rain keeps the soil moist and helps the microbes, but water by itself cannot digest dead leaves into humus.",
        ],
    },
    "scenecheck_ch09_q02": {
        "solutionStep": "On a bare slope there are no plant roots to hold the soil, so heavy rain washes the fertile top layer downhill. This topsoil holds most of the nutrients, so losing it leaves the land much poorer for growing things.",
        "commonMistakes": [
            "Picking 'Improves soil' — fast-running rainwater strips soil away instead of building it up, so the land is left worse, not better.",
            "Picking 'Adds nutrients' — the moving water actually carries the nutrient-rich topsoil away, so the slope ends up with fewer nutrients.",
        ],
    },
    "scenecheck_ch09_q03": {
        "solutionStep": "Loam is a balanced mix of sand, silt, and clay, so it drains extra water without drying out and also holds enough nutrients for plants. This middle ground is exactly what most crops need to grow well.",
        "commonMistakes": [
            "Picking 'it's pretty' — how soil looks has nothing to do with how well crops grow; what matters is its water and nutrient balance.",
            "Picking 'it's expensive' — price does not make soil good for plants, and loam is valued for its balance, not its cost.",
        ],
    },

    # ── Ch.10 Respiration in Organisms ──
    "scenecheck_ch10_q00": {
        "solutionStep": "We breathe in oxygen (O₂) because our cells need it to release energy from food, and we breathe out carbon dioxide (CO₂) as the waste gas that energy-making produces. So the gas we take in and the gas we give off are different.",
        "commonMistakes": [
            "Picking 'CO₂ in, O₂ out' — this is the exact reverse; CO₂ is the waste we get rid of, not the gas we need to take in.",
            "Picking 'Both N₂' — nitrogen makes up most of the air but our bodies do not use it for breathing, so it is not the gas we exchange.",
        ],
    },
    "scenecheck_ch10_q01": {
        "solutionStep": "Respiration happens in the mitochondria because these tiny parts of the cell are where food and oxygen react to release energy. They are often called the cell's powerhouses for exactly this reason.",
        "commonMistakes": [
            "Picking 'Nucleus' — the nucleus controls the cell and holds its instructions, but it is not where energy is released from food.",
            "Picking 'Cell wall' — the cell wall is only a stiff outer support found in plant cells and does no energy-releasing work.",
        ],
    },
    "scenecheck_ch10_q02": {
        "solutionStep": "Fish gills are built to pull dissolved oxygen out of water, not out of air, so in air the delicate gills collapse and stick together and can no longer take in oxygen. Without oxygen the fish cannot make energy and dies.",
        "commonMistakes": [
            "Picking 'Too warm' — a fish out of water dies from lack of oxygen, not simply because the air feels warm.",
            "Picking 'Too bright' — brightness does not stop a fish from breathing; the real problem is that gills cannot get oxygen from air.",
        ],
    },
    "scenecheck_ch10_q03": {
        "solutionStep": "An adult lung has roughly 300 million tiny air sacs called alveoli, and having so many gives the lungs a huge surface for oxygen to pass into the blood. The large number is what lets us absorb enough oxygen with each breath.",
        "commonMistakes": [
            "Picking '~3,000' — this is far too few to give the lungs the enormous surface they need for fast oxygen exchange.",
            "Picking '~30 billion' — this overshoots by a lot; the real count is around 300 million, not tens of billions.",
        ],
    },

    # ── Ch.11 Transportation in Animals and Plants ──
    "scenecheck_ch11_q00": {
        "solutionStep": "Arteries carry oxygen-rich blood away from the heart because they have thick, strong walls that handle the high pressure of each heartbeat pushing blood outward. Veins, by contrast, bring blood back toward the heart.",
        "commonMistakes": [
            "Picking 'Veins' — veins do the opposite job, carrying blood back to the heart rather than away from it.",
            "Picking 'Lymph' — lymph is a separate pale fluid that drains tissues; it is not the vessel that carries blood out of the heart.",
        ],
    },
    "scenecheck_ch11_q01": {
        "solutionStep": "Sugar made in the leaves travels to the roots through the phloem, the tube system that carries food around the plant. Xylem moves water the other way, upward from the roots, so the two pipes have different jobs.",
        "commonMistakes": [
            "Picking 'Xylem' — xylem carries water and minerals up from the roots, not the sugar coming down from the leaves.",
            "Picking 'Stomata' — stomata are tiny pores on leaves for gas exchange, not tubes that move food through the plant.",
        ],
    },
    "scenecheck_ch11_q02": {
        "solutionStep": "Type O is the universal donor because its red cells carry none of the A or B markers that another person's body might attack. With no markers to react against, O blood can be safely given to people of other groups.",
        "commonMistakes": [
            "Picking 'A' — type A blood carries the A marker, which the immune system of a non-A person would attack, so it cannot go to everyone.",
            "Picking 'AB' — AB blood carries both markers and can receive from all groups, but for the same reason it cannot be the universal giver.",
        ],
    },
    "scenecheck_ch11_q03": {
        "solutionStep": "The kidneys filter about 180 litres of blood a day because the same blood passes through them over and over, getting cleaned each time. Most of that fluid is taken back into the body, and only a small amount leaves as urine.",
        "commonMistakes": [
            "Picking '~5 L' — that is close to the total blood in your body, but the kidneys clean that blood again and again, so the daily amount filtered is far higher.",
            "Picking '~1500 L' — this is much too high; the kidneys process around 180 litres in a day, not over a thousand.",
        ],
    },

    # ── Ch.12 Reproduction in Plants ──
    "scenecheck_ch12_q00": {
        "solutionStep": "Pollen lands on the stigma, the sticky top of the flower's female part. Its stickiness is no accident — it is built to catch and hold pollen grains so they can grow a tube down to the eggs and start a new seed.",
        "commonMistakes": [
            "Picking 'Petal' — petals are the bright, showy leaves that attract bees and butterflies, but their job is advertising, not catching pollen. The pollen needs the sticky stigma to do its work.",
            "Picking 'Sepal' — sepals are the small green leaf-like covers that protect the bud before it opens. They guard the flower; they do not receive pollen.",
        ],
    },
    "scenecheck_ch12_q01": {
        "solutionStep": "Coconuts disperse mainly by water because the thick fibrous husk traps air and makes the coconut float. It can ride ocean currents for long distances and still sprout when it washes up on a new shore.",
        "commonMistakes": [
            "Picking 'Wind' — a coconut is far too heavy for the wind to lift or carry, unlike tiny dandelion seeds. Wind moves light seeds, not heavy fruit.",
            "Picking 'Insects' — insects carry pollen between flowers, but they could never move something as big and heavy as a coconut. They help with pollination, not with spreading large fruit.",
        ],
    },
    "scenecheck_ch12_q02": {
        "solutionStep": "The eyes on a potato are buds that can sprout into whole new plants. A potato is actually a swollen underground stem, and like other stems it carries buds — give it warmth and moisture and each eye can grow into a new shoot.",
        "commonMistakes": [
            "Picking 'Holes for breathing' — they may look like little dents, but a potato does not breathe through them. They are resting buds waiting for the right conditions to grow.",
            "Picking 'Where roots come out' — it is easy to assume anything underground makes roots, but the eyes produce shoots, not roots. They grow upward into new plants.",
        ],
    },
    "scenecheck_ch12_q03": {
        "solutionStep": "Asexual reproduction needs only one parent, so the new plant is a clone — an exact copy of that single parent. Because no second parent mixes in different features, there is no blending of two sets of traits.",
        "commonMistakes": [
            "Picking 'Two parents needed' — that describes sexual reproduction, where pollen from one part joins the egg from another. Asexual reproduction skips that and uses just one parent.",
            "Picking 'Always two-step process' — the number of steps is not what defines it. What matters is that a single parent produces an identical copy.",
        ],
    },

    # ── Ch.13 Motion and Time ──
    "scenecheck_ch13_q00": {
        "solutionStep": "City roads are usually capped near 50 km/h because they are crowded with people, cyclists, and crossings, so slower speeds give drivers time to stop safely. It is fast enough to get around but slow enough to react to surprises.",
        "commonMistakes": [
            "Picking '10 km/h' — that is barely faster than a brisk walk and would make city travel painfully slow. Roads are designed to keep traffic flowing, not crawling.",
            "Picking '200 km/h' — that is race-car speed, far too dangerous among pedestrians and junctions. No city road allows anything close to it.",
        ],
    },
    "scenecheck_ch13_q01": {
        "solutionStep": "National highways allow up to about 100 km/h because they are wide, straight, and have far fewer crossings or pedestrians than city roads. The open, controlled design makes higher speeds safer than they would be in town.",
        "commonMistakes": [
            "Picking '20 km/h' — that is slower than a city limit and would make a long highway journey take forever. Highways are built for steady, faster travel.",
            "Picking '500 km/h' — that is faster than most aeroplanes and far beyond what any car or road could safely handle. No highway permits anything near it.",
        ],
    },
    "scenecheck_ch13_q02": {
        "solutionStep": "School zones are kept low, around 25 km/h, because children may step onto the road suddenly and a slower car can stop in a much shorter distance. The lower the speed, the more time a driver has to protect a child.",
        "commonMistakes": [
            "Picking '100 km/h' — that is highway speed and would be dangerous where children gather. Near schools, drivers must go far slower.",
            "Picking '150 km/h' — that is extremely fast even for an open highway, let alone a place full of young students. It would make stopping in time impossible.",
        ],
    },
    "scenecheck_ch13_q03": {
        "solutionStep": "The Vande Bharat express runs at a top speed of around 180 km/h, which is much faster than road traffic but still a real, achievable speed for a modern Indian train. Its smooth tracks and powerful design make this possible.",
        "commonMistakes": [
            "Picking '50 km/h' — that is roughly a city car's pace and would make a fast express train no quicker than ordinary traffic. The whole point of the train is to be much faster.",
            "Picking '1000 km/h' — that is faster than a passenger jet, which no train on rails can reach. It is wildly beyond what train tracks allow.",
        ],
    },
    "scenecheck_ch13_q04": {
        "solutionStep": "Speed equals distance divided by time, so 60 km divided by 2 hours gives 30 km/h. The car covers 60 km spread over two hours, which works out to 30 km in each hour.",
        "commonMistakes": [
            "Picking '60 km/h' — that is the total distance, not the speed. You still have to divide by the 2 hours it took to get the speed.",
            "Picking '120 km/h' — this comes from multiplying 60 by 2 instead of dividing. Speed is distance shared over time, so you divide, not multiply.",
        ],
    },
    "scenecheck_ch13_q05": {
        "solutionStep": "An odometer measures the total distance a vehicle has driven, adding up every kilometre over its lifetime. It keeps a running count, unlike instruments that only show your current pace.",
        "commonMistakes": [
            "Picking 'Speedometer' — it shows how fast you are going right now, not how far you have travelled in total. Speed and distance are different things.",
            "Picking 'Pedometer' — that counts the steps a person walks, not the distance a vehicle drives. It is worn on the body, not fitted in a car.",
        ],
    },
    "scenecheck_ch13_q06": {
        "solutionStep": "A pendulum's period depends most on the length of its string — a longer string swings more slowly, a shorter one more quickly. Surprisingly, the heaviness of the bob barely changes the timing at all.",
        "commonMistakes": [
            "Picking 'Mass of bob' — it feels like a heavier weight should swing differently, but a pendulum's swing time stays nearly the same whatever the bob's mass. Length is what really matters.",
            "Picking 'Colour of string' — colour is just appearance and has no effect on how the pendulum moves. Only physical length changes the swing time.",
        ],
    },
    "scenecheck_ch13_q07": {
        "solutionStep": "One minute is made up of 60 seconds, the standard way we divide time on every clock. This is why a clock's second hand makes one full circle of 60 marks for each minute that passes.",
        "commonMistakes": [
            "Picking '10' — that may seem like a tidy round number, but time is not counted in tens like our usual numbers. A minute holds 60 seconds, not 10.",
            "Picking '100' — it is tempting because we often group things in hundreds, but clocks use 60, not 100. A minute is 60 seconds.",
        ],
    },

    # ── Ch.14 Electric Current and its Effect ──
    "scenecheck_ch14_q00": {
        "solutionStep": "In a series circuit the current flows through every bulb along one single path, so if one bulb fuses it breaks that path and all the others go off too. There is no other route for the current to take.",
        "commonMistakes": [
            "Picking 'Others stay on' — that happens in a parallel circuit, where each bulb has its own path. In a series circuit there is only one path, so a break stops them all.",
            "Picking 'Only adjacent goes off' — the gap does not just affect the neighbouring bulb; it cuts the whole single loop. Every bulb on that one path loses its current.",
        ],
    },
    "scenecheck_ch14_q01": {
        "solutionStep": "A fuse breaks the circuit when the current grows too high, acting like a safety guard. Its thin wire melts and snaps the connection before the dangerous current can overheat the wires and start a fire.",
        "commonMistakes": [
            "Picking 'Decorate the box' — a fuse is a safety device, not decoration; its plain look hides an important protective job. It exists to prevent fires, not to look nice.",
            "Picking 'Increase voltage' — a fuse never adds power to a circuit; it only cuts the circuit off when the current becomes unsafe. It protects, it does not boost.",
        ],
    },
    "scenecheck_ch14_q02": {
        "solutionStep": "An electromagnet's poles swap when you reverse the battery, because the current then flows the opposite way around the coil. The direction of the current decides which end becomes north and which becomes south.",
        "commonMistakes": [
            "Picking 'Add more turns' — extra turns make the magnet stronger, but they do not flip which end is north or south. Strength and polarity are two separate things.",
            "Picking 'Cool the wire' — changing the temperature does not reverse the poles. Only changing the direction of the current can swap them.",
        ],
    },
    "scenecheck_ch14_q03": {
        "solutionStep": "Indian homes are supplied with 230 V AC at 50 Hz, which is the standard mains electricity across the country. AC means the current changes direction 50 times each second, which is how the power grid delivers energy to houses.",
        "commonMistakes": [
            "Picking '12 V DC' — that is the low, steady voltage of a car battery or torch, far too weak to run household appliances. Home wiring needs the much higher 230 V mains supply.",
            "Picking '1000 V DC' — that is dangerously high and is used in heavy industry or power lines, not inside homes. Household supply is 230 V, not 1000 V.",
        ],
    },

    # ── Ch.15 Light ──
    "scenecheck_ch15_q00": {
        "solutionStep": "A plane mirror flips the image left-to-right, called lateral inversion. Your right hand looks like the left hand of the person in the mirror because the light bounces straight back, swapping the sides while keeping top and bottom the same.",
        "commonMistakes": [
            "Picking 'Upside down' — that is what some curved mirrors or lenses do, but a flat mirror keeps top and bottom in place. Only the left and right sides get swapped.",
            "Picking 'Same as original' — it feels true because the image looks so familiar, but try reading text in a mirror: the letters reverse. That proves the sides are swapped.",
        ],
    },
    "scenecheck_ch15_q01": {
        "solutionStep": "White sunlight is actually a mix of seven colours blended together. A prism bends each colour by a slightly different amount, so they spread out and fan into a rainbow band — this spreading is called dispersion.",
        "commonMistakes": [
            "Picking 'White stays white' — it would only stay white if all colours bent the same amount, but each colour bends differently, so the prism pulls them apart.",
            "Picking 'Only red' — red is just one of the seven hidden colours in white light. The prism reveals all of them, not just one.",
        ],
    },
    "scenecheck_ch15_q02": {
        "solutionStep": "A concave lens is thinner in the middle and curves inward, so it spreads light rays apart instead of bringing them together. This makes things look smaller, which is exactly why it is used in glasses for short-sighted people (the minus or negative ones).",
        "commonMistakes": [
            "Picking 'Magnifies' — that is the job of a convex lens, which bulges outward and bends light inward to enlarge things. A concave lens does the opposite.",
            "Picking 'Burns paper' — burning needs light focused to a tiny hot point, which a convex lens does. A concave lens spreads light out, so it cannot concentrate enough heat.",
        ],
    },
    "scenecheck_ch15_q03": {
        "solutionStep": "Sunlight has all colours, but the tiny gas particles in the air scatter blue light much more than the other colours. That scattered blue light reaches our eyes from every direction in the sky, so the whole sky looks blue.",
        "commonMistakes": [
            "Picking 'Air is blue' — air is actually colourless. If air were truly blue, sunsets could not turn red, but they do because scattering changes with the angle of the light.",
            "Picking 'Earth reflects sea' — the sky is blue even over deserts and mountains far from any sea. The colour comes from scattered sunlight, not a reflection of water.",
        ],
    },

    # ── Ch.16 Water: A Precious Resource ──
    "scenecheck_ch16_q00": {
        "solutionStep": "Almost all of Earth's water is salty seawater or locked in ice, and only a tiny sliver is fresh water we can actually drink and use — less than 1 percent. That is why saving water matters so much: there is far less usable water than it seems.",
        "commonMistakes": [
            "Picking '50%' — that sounds like a fair half-and-half split, but most water is salty oceans, leaving only a tiny fraction as usable fresh water.",
            "Picking '97%' — that number is real, but it is the share that is salty ocean water, not the fresh water we can use. It is easy to mix up the two.",
        ],
    },
    "scenecheck_ch16_q01": {
        "solutionStep": "Drip irrigation delivers water drop by drop right at the roots through small pipes, so very little is lost to evaporation or runoff. Because the water goes straight to where the plant needs it, almost none is wasted.",
        "commonMistakes": [
            "Picking 'Flood' — flooding the whole field uses huge amounts of water, and much of it soaks away or evaporates before plants can use it. It is the most wasteful method.",
            "Picking 'Sprinkler' — sprinklers are better than flooding, but spraying water into the air lets a lot evaporate before it lands. Drip wastes even less.",
        ],
    },
    "scenecheck_ch16_q02": {
        "solutionStep": "Rainwater harvesting means catching rain when it falls and saving it in tanks or letting it soak into the ground for later use. Instead of letting rain run away and be lost, you store it so it is there when you need it.",
        "commonMistakes": [
            "Picking 'Buying water' — buying is just paying someone else for water, not gathering it yourself. Harvesting is about collecting the free rain that falls on your own roof or land.",
            "Picking 'Stealing rivers' — taking water that belongs to others is not harvesting and is unfair. Rainwater harvesting only uses the rain that falls naturally where you are.",
        ],
    },
    "scenecheck_ch16_q03": {
        "solutionStep": "Boiling water for at least five minutes makes it hot enough to kill the germs that cause illness. The high heat destroys the bacteria and other tiny organisms hiding in the water, making it safe to drink.",
        "commonMistakes": [
            "Picking 'Adding sugar' — sugar only changes the taste and does nothing to the germs. In fact, some germs would happily feed on the sugar.",
            "Picking 'Storing in plastic' — a plastic container just holds the water; it does not remove or kill anything already living in it. The germs stay until heat destroys them.",
        ],
    },

    # ── Ch.17 Forest: Our Lifeline ──
    "scenecheck_ch17_q00": {
        "solutionStep": "Forest soil, roots, and fallen leaves soak up rain like a sponge and then let it seep out slowly over many days. This steady release keeps streams flowing in dry times and stops sudden floods after heavy rain.",
        "commonMistakes": [
            "Picking 'Look soft' — looking soft is not the same as acting like a sponge. It is the soaking up and slow release of water that makes the comparison true, not the appearance.",
            "Picking 'Have moss' — moss is just one small plant in the forest. The sponge effect comes from the whole forest floor and roots holding and releasing water, not from moss alone.",
        ],
    },
    "scenecheck_ch17_q01": {
        "solutionStep": "Decomposers like fungi and bacteria break down dead leaves and animals into humus, a dark crumbly material rich in nutrients. This feeds the soil so new plants can grow, completing nature's recycling loop.",
        "commonMistakes": [
            "Picking 'Stone' — stone is hard rock that forms over very long times from minerals, not from rotting matter. Decomposers create soft, living soil instead.",
            "Picking 'Plastic' — plastic is made by people in factories and is exactly the kind of thing decomposers cannot break down. They work on natural dead matter.",
        ],
    },
    "scenecheck_ch17_q02": {
        "solutionStep": "The banyan is India's national tree because it spreads wide with many hanging roots that grow into new trunks, so one tree can shelter huge numbers of birds, animals, and people. It stands for long life and the connection of all living things.",
        "commonMistakes": [
            "Picking 'Mango' — the mango is India's national fruit, which is easy to mix up, but it is not the national tree.",
            "Picking 'Neem' — neem is a very useful and valued tree in India, but the official national tree is the banyan.",
        ],
    },
    "scenecheck_ch17_q03": {
        "solutionStep": "In the Chipko movement, villagers hugged trees so loggers could not cut them down without harming people. Their brave, peaceful action protected forests and showed how ordinary people can stand up for nature.",
        "commonMistakes": [
            "Picking 'Saving rivers' — protecting rivers is important, but Chipko was specifically about stopping trees from being felled, not about rivers.",
            "Picking 'Building dams' — Chipko was actually against destroying forests, and dam-building often clears them. The movement worked to save trees, not build.",
        ],
    },

    # ── Ch.18 Wastewater Story ──
    "scenecheck_ch18_q00": {
        "solutionStep": "Wastewater is not just water; it carries waste that is dissolved (mixed in invisibly, like salts and soap) and suspended (floating bits like food scraps and dirt). Cleaning it means removing both kinds before the water can be reused or returned to nature.",
        "commonMistakes": [
            "Picking 'Just water' — if it were just water it would not need treating, but wastewater is loaded with dissolved and floating waste that must be removed.",
            "Picking 'Only soap' — soap is one part of it, but wastewater also holds food bits, dirt, germs, and many dissolved substances, not soap alone.",
        ],
    },
    "scenecheck_ch18_q01": {
        "solutionStep": "In anaerobic digestion, special microbes break down the sludge without any oxygen, and as they feed they release biogas, which is mostly methane. This gas can be captured and burned as fuel, turning waste into useful energy.",
        "commonMistakes": [
            "Picking 'Pure water' — pure water needs further cleaning steps; the digestion of sludge produces gas, not clean drinking water.",
            "Picking 'Salt' — salt is not made by microbes breaking down sludge. The useful product of this process is flammable biogas.",
        ],
    },
    "scenecheck_ch18_q02": {
        "solutionStep": "Greywater is the gently used water from sinks, showers, and washing clothes, which holds some soap and dirt but no toilet waste. Because it is much less polluted, it can often be reused for things like watering plants.",
        "commonMistakes": [
            "Picking 'Toilets only' — water from toilets is called blackwater and is heavily contaminated. Greywater comes from washing, not toilets.",
            "Picking 'Mixed with rain' — rainwater is separate and usually clean. Greywater is defined by where it comes from indoors, not by being mixed with rain.",
        ],
    },
    "scenecheck_ch18_q03": {
        "solutionStep": "The ancient Indus Valley people built covered drains and brick-lined sewers along their streets to carry away dirty water. This shows they understood good sanitation thousands of years ago, long before many other places did.",
        "commonMistakes": [
            "Picking 'No sanitation' — this is the opposite of the truth; the Indus Valley is famous precisely because it had advanced drains and sewers.",
            "Picking 'Cars' — cars were invented only in modern times, thousands of years after the Indus Valley civilisation existed.",
        ],
    },

    # ── Ch.19 Earth, Moon and the Sun ──
    "scenecheck_ch19_q00": {
        "solutionStep": "The Solar System has eight planets orbiting the Sun, from Mercury out to Neptune. Pluto used to be counted as the ninth, but scientists reclassified it as a dwarf planet, leaving eight.",
        "commonMistakes": [
            "Picking '7' — this misses one planet. Counting carefully from Mercury to Neptune gives eight.",
            "Picking '9' — this includes Pluto, which was once called the ninth planet but is now classed as a dwarf planet, so the count is eight.",
        ],
    },
    "scenecheck_ch19_q01": {
        "solutionStep": "Earth spins on an axis that is tilted at about 23.5 degrees, so as it orbits the Sun, different parts lean toward or away from the Sun at different times of year. The part tilted toward the Sun gets more direct heat and has summer, while the part tilted away has winter.",
        "commonMistakes": [
            "Picking 'Distance from Sun' — many think we are hotter when closer to the Sun, but the distance barely changes the seasons. It is the tilt, not the distance, that matters.",
            "Picking 'Moon's phases' — the Moon's changing shape is caused by sunlight and its orbit, and it has nothing to do with Earth's seasons.",
        ],
    },
    "scenecheck_ch19_q02": {
        "solutionStep": "The Sun sits at the centre of the Solar System, and its strong gravity holds all the planets in their orbits around it. Everything, including Earth, travels around the Sun.",
        "commonMistakes": [
            "Picking 'Earth' — people long ago believed Earth was the centre, but we now know Earth is just one planet orbiting the Sun.",
            "Picking 'Moon' — the Moon is small and orbits Earth, so it cannot be the centre of the whole Solar System.",
        ],
    },
    "scenecheck_ch19_q03": {
        "solutionStep": "Mangalyaan, also called the Mars Orbiter Mission, was India's first spacecraft sent to Mars, and it succeeded on the very first try. The name itself means 'Mars craft', which is a helpful clue.",
        "commonMistakes": [
            "Picking 'Chandrayaan' — Chandrayaan means 'Moon craft' and was India's mission to the Moon, not Mars.",
            "Picking 'Aditya' — Aditya is India's mission to study the Sun, so it went toward the Sun rather than Mars.",
        ],
    },
}


def validate_table() -> list[str]:
    """Check every authored entry against the length floors. Returns a list
    of human-readable problems (empty == clean)."""
    problems: list[str] = []
    for qid, entry in ENRICHMENT.items():
        ss = entry.get("solutionStep", "")
        cms = entry.get("commonMistakes", [])
        if len(ss) < SS_MIN:
            problems.append(f"{qid}: solutionStep {len(ss)} chars (< {SS_MIN})")
        if len(cms) < 2:
            problems.append(f"{qid}: only {len(cms)} commonMistakes (need 2)")
        for i, cm in enumerate(cms):
            if len(cm) < CM_MIN:
                problems.append(f"{qid}: commonMistakes[{i}] {len(cm)} chars (< {CM_MIN})")
    return problems


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true",
                        help="apply enrichment to science_class7.json in place")
    parser.add_argument("--force", action="store_true",
                        help="overwrite commonMistakes/solutionSteps even if already populated")
    args = parser.parse_args()

    # Validate the authoring table before touching anything.
    problems = validate_table()
    if problems:
        print("Authoring table FAILED length-floor validation:", file=sys.stderr)
        for p in problems:
            print(f"  - {p}", file=sys.stderr)
        return 1

    with PACK_PATH.open("r", encoding="utf-8") as f:
        pack = json.load(f)

    # Cross-check: pack ids vs authoring-table ids.
    pack_ids: set[str] = set()
    for chapter in pack.get("chapters", []):
        for q in (chapter.get("quickCheckQuestions") or []):
            pack_ids.add(q["id"])

    missing_in_table = sorted(pack_ids - set(ENRICHMENT))
    for qid in missing_in_table:
        print(f"WARN  pack quick-check '{qid}' has no authoring-table entry",
              file=sys.stderr)
    extra_in_table = sorted(set(ENRICHMENT) - pack_ids)
    for qid in extra_in_table:
        print(f"WARN  authoring-table id '{qid}' not found in pack (typo?)",
              file=sys.stderr)

    # Build the per-id patch.
    patch: dict[str, dict] = {}
    written = 0
    skipped = 0
    for chapter in pack.get("chapters", []):
        for q in (chapter.get("quickCheckQuestions") or []):
            entry = ENRICHMENT.get(q["id"])
            if entry is None:
                continue
            already = bool(q.get("commonMistakes")) or bool(q.get("solutionSteps"))
            if already and not args.force:
                print(f"SKIP {q['id']}: already enriched. Use --force to overwrite.",
                      file=sys.stderr)
                skipped += 1
                continue
            new_cm = list(entry["commonMistakes"])
            new_ss = [entry["solutionStep"]]
            patch[q["id"]] = {"commonMistakes": new_cm, "solutionSteps": new_ss}
            if args.write:
                q["commonMistakes"] = new_cm
                q["solutionSteps"] = new_ss
                written += 1

    if not args.write:
        json.dump(patch, sys.stdout, indent=2, ensure_ascii=False)
        sys.stdout.write("\n")
        print(f"\nDry-run: {len(patch)} quick-check(s) would be enriched.",
              file=sys.stderr)
        return 0

    with PACK_PATH.open("w", encoding="utf-8") as f:
        json.dump(pack, f, indent=2, ensure_ascii=False)
        f.write("\n")

    print(f"\nEnriched {written} quick-check(s); skipped {skipped}.",
          file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
