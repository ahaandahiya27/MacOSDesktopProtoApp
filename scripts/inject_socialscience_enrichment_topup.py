#!/usr/bin/env python3
"""P1-I — top up Social Science `examConnections` + `whatIfs` from 2 → 3 / chapter.

Every Social Science chapter (ssch01–ssch20) shipped with exactly 2
examConnections and 2 whatIfs — one below the Science floor of 3/ch. This adds a
THIRD of each (`sschNN_xc03` / `sschNN_wi03`) to all 20 chapters (20 + 20 = 40
new items), so all four subjects clear the same 3/ch enrichment bar.

The injector APPENDS idempotently: it keeps the existing two items (xc01/xc02,
wi01/wi02), drops any prior copy of the new id, and re-appends the authored
third — so re-running never duplicates. Each new item:
  * examConnection: 50–130 words, a NEP-faithful "you'll see this again"
    forward pointer (CBSE Class 8–12 / NTSE / Olympiad), targetExam-tagged,
    anchored by ≥1 REAL in-chapter relatedConceptId;
  * whatIf: a one-line counterfactual + a 3–5 sentence guided answer (≥30
    chars), anchored by ≥1 real in-chapter relatedConceptId.

The injector hard-fails if any relatedConceptId does not resolve in-chapter.

Additive only. Re-runnable. Writes the canonical format
`json.dumps(d, ensure_ascii=False, indent=2) + "\n"`.
"""
import json
from pathlib import Path

PACK = Path(__file__).resolve().parent.parent / "desktopAhaan/Subjects/Packs/socialscience_class7.json"


def xc(id, title, body, target, related):
    return {"id": id, "title": title, "body": body, "targetExam": target, "relatedConceptIds": related}


def wi(id, question, answer, related):
    return {"id": id, "question": question, "answer": answer, "relatedConceptIds": related}


# Third examConnection per chapter (sschNN_xc03).
EXAM3 = {
    "ssch01": xc("ssch01_xc03", "India's mineral wealth returns — Class 10 Economic Geography",
        "The Peninsular Plateau you study here as ancient, mineral-rich rock is exactly where Class 10 geography "
        "locates India's coal, iron ore and bauxite belts. There you learn how the old crystalline plateau, worn "
        "flat over billions of years, concentrates the minerals that power India's steel plants and industry, and "
        "why the Chhotanagpur region is called the country's mineral heartland. The plateau-and-Ghats landscape "
        "you map now becomes the resource map behind the nation's economy.",
        "CBSE Class 10 Geography", ["ssch01_t04_c02", "ssch01_t04_c01"]),
    "ssch02": xc("ssch02_xc03", "Measuring the atmosphere grows into Class 9–10 climatology",
        "The instruments you meet here — thermometer, barometer, rain gauge, hygrometer — are the same tools "
        "Class 9 and 10 geography uses to build climate data over decades, not days. There you learn that climate "
        "is the long-run average of exactly these weather readings, and how meteorologists feed them into models "
        "that forecast monsoons and cyclones. The single day's readings you take now become the long records that "
        "reveal a region's climate and its change.",
        "CBSE Class 9–10 Geography", ["ssch02_t04_c03", "ssch02_t05_c02"]),
    "ssch03": xc("ssch03_xc03", "The greenhouse effect returns — Class 10 Science and Geography",
        "Climate change and the greenhouse effect you meet here reappear in Class 10 in far more depth: the "
        "physics of how CO₂ and methane trap heat, the evidence from ice cores and temperature records, and "
        "India's pledges under global climate agreements. You will connect the monsoon's growing unpredictability "
        "to a warming planet and study mitigation versus adaptation as policy. The greenhouse idea introduced "
        "here is one of the most examined topics in senior school.",
        "CBSE Class 10 Science / Geography", ["ssch03_t04_c02", "ssch03_t04_c03"]),
    "ssch04": xc("ssch04_xc03", "Early republics and assemblies — roots studied again in Civics",
        "The sabhā and samiti assemblies and the gaṇa–saṅgha republics you meet here are revisited in Class 9 and "
        "10 political science as the ancient Indian roots of representative government. There you trace how the "
        "idea of collective decision-making — rule by discussion rather than by one ruler — runs from these early "
        "janapadas to the modern Parliament. The contrast between monarchy and republic you first see here is a "
        "recurring theme in civics.",
        "CBSE Class 9–10 Political Science", ["ssch04_t03_c01", "ssch04_t03_c03"]),
    "ssch05": xc("ssch05_xc03", "Kauṭilya's Arthaśāstra returns in Class 11–12 Political Science",
        "Chandragupta Maurya's adviser Kauṭilya and his Arthaśāstra — the saptāṅga (seven-limb) theory of the "
        "state — reappear in Class 11 and 12 political science and public administration as one of the world's "
        "earliest treatises on statecraft, economics and diplomacy. There you compare its ideas on governance, "
        "taxation and spycraft with Greek and modern thinkers. The seven limbs of empire you outline here are a "
        "foundation text for the study of the state.",
        "CBSE Class 11–12 Political Science", ["ssch05_t04_c03", "ssch05_t04_c02"]),
    "ssch06": xc("ssch06_xc03", "The Gandhara and Mathura art schools — Class 11 Fine Arts / History",
        "The Gandhara and Mathura schools of sculpture you meet under the Kushanas return in Class 11 history and "
        "fine-arts study as the moment the Buddha was first carved in human form. There you learn to tell the "
        "Greco-Roman drapery of Gandhara from the indigenous warmth of Mathura, and how Kanishka's empire let "
        "Indian, Greek and Central Asian styles blend. The cultural confluence you read about here is a set "
        "art-history topic.",
        "CBSE Class 11 History / Fine Arts", ["ssch06_t05_c02", "ssch06_t05_c01"]),
    "ssch07": xc("ssch07_xc03", "Aryabhata and Gupta science return in Class 9 Maths and History",
        "The Gupta 'Classical Age' achievements you meet here — Aryabhata's place-value decimals and his claim "
        "that the Earth rotates, the concept of zero, Varahamihira's astronomy — reappear in Class 9 maths and "
        "history as the foundation of the number system the whole world now uses. There you learn how these ideas "
        "travelled through the Arab world to Europe. The 'tireless creativity' of this age is studied as a peak of "
        "Indian science.",
        "CBSE Class 9 Mathematics / History", ["ssch07_t04_c02", "ssch07_t04_c01"]),
    "ssch08": xc("ssch08_xc03", "Sacred geography and national integration — Class 9–10 study",
        "The networks of tīrthas — the Chār Dhām, the jyotirlingas, the river sangams and the Kumbh Mela — you "
        "map here are revisited in Class 9 and 10 as a force that knit a diverse subcontinent into one cultural "
        "unit long before political unity. There you study how pilgrimage routes doubled as trade routes and "
        "spread ideas, languages and goods. The way the land 'becomes sacred' is examined as a thread of Indian "
        "civilisational unity.",
        "CBSE Class 9–10 History", ["ssch08_t03_c01", "ssch08_t03_c02"]),
    "ssch09": xc("ssch09_xc03", "Separation of powers returns in Class 9–10 Political Science",
        "The three organs of government and the separation of powers you meet here are studied in full in Class 9 "
        "and 10 civics: how the legislature makes laws, the executive carries them out, and the judiciary guards "
        "the Constitution, each checking the others so no one branch grows too strong. There you compare "
        "parliamentary and presidential systems in detail. The democratic principles you first sort here become "
        "the core of senior political science.",
        "CBSE Class 9–10 Political Science", ["ssch09_t03_c03", "ssch09_t03_c02"]),
    "ssch10": xc("ssch10_xc03", "The Preamble and Fundamental Rights — Class 8–11 deep study",
        "The Preamble's words — sovereign, socialist, secular, democratic republic; justice, liberty, equality, "
        "fraternity — that you read here are studied clause by clause in Class 8, 9 and 11 political science, "
        "alongside the Fundamental Rights and Duties they introduce. There you learn how the Constituent Assembly "
        "debated each idea and how courts interpret them today. The 'We, the People' opening you meet now is "
        "perhaps the most examined passage in all of Indian civics.",
        "CBSE Class 8–11 Political Science", ["ssch10_t05_c01", "ssch10_t05_c02"]),
    "ssch11": xc("ssch11_xc03", "The functions of money return in Class 9–12 Economics",
        "The four functions of money you meet here — medium of exchange, store of value, measure of value and "
        "standard of deferred payment — are the formal definition Class 9 and 12 economics builds upon. There you "
        "study how a central bank issues currency, what gives money its value, and how digital payments (UPI) are "
        "changing all four functions. The journey from barter's 'double coincidence of wants' to money is the "
        "classic opening of economics.",
        "CBSE Class 9–12 Economics", ["ssch11_t03_c02", "ssch11_t02_c01"]),
    "ssch12": xc("ssch12_xc03", "Demand and supply return as Class 11–12 Microeconomics",
        "The demand-and-supply idea and the search for the 'just right' price you meet here become the central "
        "machinery of Class 11 and 12 microeconomics. There you draw demand and supply curves, find the "
        "equilibrium price where they cross, and study how shortages and surpluses push prices back toward it. "
        "The everyday market-bargaining you observe now is the intuition behind one of the most important "
        "diagrams in all of economics.",
        "CBSE Class 11–12 Economics", ["ssch12_t02_c02", "ssch12_t02_c01"]),
    "ssch13": xc("ssch13_xc03", "The Green Revolution returns in Class 10–12 Geography and Economics",
        "The Green Revolution and its costs that you meet here are studied in depth in Class 10 and 12 as the "
        "transformation that made India self-sufficient in food grains, along with its price — groundwater "
        "depletion, soil exhaustion and regional imbalance. There you weigh it against today's push for "
        "sustainable and organic farming. The cropping seasons and soil types you learn now underpin the whole "
        "geography of Indian agriculture.",
        "CBSE Class 10–12 Geography / Economics", ["ssch13_t05_c02", "ssch13_t05_c03"]),
    "ssch14": xc("ssch14_xc03", "India's foreign relations return in Class 12 Political Science",
        "India's relationships with her neighbours and bodies like SAARC that you map here are studied in full in "
        "Class 12 political science as 'India's foreign policy' and 'contemporary world politics'. There you "
        "examine non-alignment, the disputes and partnerships with China and Pakistan, and India's place in South "
        "Asia and the Indian Ocean. The good-neighbour idea and the ancient trade routes you learn now frame the "
        "country's diplomacy today.",
        "CBSE Class 12 Political Science", ["ssch14_t05_c04", "ssch14_t01_c03"]),
    "ssch15": xc("ssch15_xc03", "Reading history from sources — Xuanzang and the historian's method",
        "The way historians use Xuanzang's travel account and inscriptions to reconstruct Harsha's age, which you "
        "meet here, becomes a formal skill in Class 9–12 history: how to read a primary source critically, weigh "
        "its bias, and cross-check it against archaeology. There you study the difference between a chronicle and "
        "evidence. The detective-work of 'how we know what we know' is itself an examined part of senior history.",
        "CBSE Class 9–12 History", ["ssch15_t01_c03", "ssch15_t01_c02"]),
    "ssch16": xc("ssch16_xc03", "Al-Biruni and Bhaskaracharya — Class 9 Maths and History",
        "The scholar Al-Biruni, who studied and recorded eleventh-century India, and Bhaskaracharya, whose "
        "mathematics endured, reappear in Class 9 maths and history. There you meet Bhaskaracharya's "
        "Līlāvatī and his early grasp of ideas leading toward calculus, and Al-Biruni's Kitāb-ul-Hind as a model "
        "of careful cross-cultural scholarship. The meeting of Indian and Central Asian learning you read about "
        "here is a set topic in the history of science.",
        "CBSE Class 9 Mathematics / History", ["ssch16_t02_c02", "ssch16_t02_c01"]),
    "ssch17": xc("ssch17_xc03", "Vasudhaiva Kuṭumbakam — India's pluralism in Class 9–12 Civics",
        "India's ethos of welcoming refugees and the ideal of vasudhaiva kuṭumbakam ('the world is one family') "
        "you meet here are revisited in Class 9–12 civics as the roots of India's secularism and its constitutional "
        "guarantee of equality to all faiths. There you study how communities like the Parsis, Jews and Tibetans "
        "found refuge and enriched the country. The acceptance-of-many theme is a recurring value-education and "
        "political-science topic.",
        "CBSE Class 9–12 Political Science", ["ssch17_t04_c04", "ssch17_t01_c01"]),
    "ssch18": xc("ssch18_xc03", "The three tiers of government return in Class 8–10 Civics",
        "The three tiers — Union, State and local (panchayat and municipality) government — and the idea of "
        "decentralisation you meet here are studied in detail in Class 8, 9 and 10 civics, including the 73rd and "
        "74th Constitutional amendments that gave local bodies real power. There you learn how a citizen's "
        "everyday needs are met at the level closest to them. The triple role of government you outline now is "
        "core senior-school civics.",
        "CBSE Class 8–10 Political Science", ["ssch18_t04_c03", "ssch18_t04_c01"]),
    "ssch19": xc("ssch19_xc03", "Infrastructure and development return in Class 10–12 Economics",
        "The link between infrastructure and development you meet here — roads, railways, power and communications "
        "as the 'backbone' of growth — becomes a formal Class 10 and 12 economics topic. There you study how "
        "investment in physical and social infrastructure raises productivity and living standards, and how "
        "Kauṭilya's Arthaśāstra already grasped this. The idea that an economy can only grow as fast as its "
        "infrastructure allows is repeatedly examined.",
        "CBSE Class 10–12 Economics", ["ssch19_t01_c02", "ssch19_t04_c03"]),
    "ssch20": xc("ssch20_xc03", "Compound interest and the RBI return in Class 8 Maths and Class 12 Economics",
        "The 'magic of compounding' you meet here is exactly the compound-interest formula you derive in Class 8 "
        "maths, where a sum grows on its own growth year after year. The RBI's role as banker to banks and "
        "controller of money returns in Class 12 economics, where you study how it sets interest rates to manage "
        "inflation. The bank account and interest you learn about now connect a maths formula to the whole "
        "monetary system.",
        "CBSE Class 8 Maths / Class 12 Economics", ["ssch20_t01_c03", "ssch20_t03_c01"]),
}


# Third whatIf per chapter (sschNN_wi03).
WHATIF3 = {
    "ssch01": wi("ssch01_wi03", "What if the Himalayas did not exist?",
        "Cold winds from Central Asia would sweep unchecked into the plains, making north India bitterly cold in "
        "winter. The mountains also force the monsoon winds to rise and shed their rain on India; without them, "
        "much of the country could be dry like the deserts at the same latitude. The great Himalayan rivers — fed "
        "by snow and glaciers — would not exist, so the fertile northern plains would never have formed. India's "
        "whole climate and farming depend on this northern wall.",
        ["ssch01_t01_c03", "ssch01_t02_c03"]),
    "ssch02": wi("ssch02_wi03", "What if there were no troposphere?",
        "Almost all weather happens in the troposphere, the lowest layer of the atmosphere, where the air we "
        "breathe and nearly all water vapour sit. Without it there would be no clouds, no rain, no wind as we know "
        "it — and no breathable air near the ground. The temperature drop with height that drives rising air and "
        "storms would vanish. Life as we know it depends on this thin, weather-making blanket close to the Earth.",
        ["ssch02_t01_c02", "ssch02_t01_c03"]),
    "ssch03": wi("ssch03_wi03", "What if the monsoon failed to arrive one year?",
        "Most Indian farming depends on monsoon rain, so a failed monsoon would mean drought: crops would wither, "
        "reservoirs and wells would run low, and food prices would rise sharply. Rivers fed by rain would shrink, "
        "hurting drinking water and hydro-power. This is why monsoon forecasting matters so much, and why India "
        "builds dams and irrigation to store water against a weak monsoon year. A single missing rainy season can "
        "ripple through the whole economy.",
        ["ssch03_t03_c01", "ssch03_t04_c01"]),
    "ssch04": wi("ssch04_wi03", "What if iron tools had never been invented in ancient India?",
        "Iron axes let people clear the dense forests of the Ganga plains for farming, and iron ploughs turned "
        "heavy soil that wooden tools could not. Without iron, that second wave of city-building — the "
        "mahajanapadas with their surplus grain, armies and trade — might never have happened. Society would have "
        "stayed in scattered villages far longer. Iron metallurgy was the quiet engine behind the rise of cities, "
        "states and coins.",
        ["ssch04_t04_c01", "ssch04_t01_c03"]),
    "ssch05": wi("ssch05_wi03", "What if Ashoka had not turned to dhamma after the Kalinga War?",
        "The bloodshed at Kalinga so shook Ashoka that he gave up conquest for dhamma — a policy of tolerance, "
        "welfare and non-violence broadcast on rock and pillar edicts across the empire. Without that change, the "
        "Mauryas might have kept expanding by war, and we would lose one of history's rare examples of a powerful "
        "ruler choosing peace at the height of his strength. His edicts, which still teach us today, would never "
        "have been carved.",
        ["ssch05_t05_c01", "ssch05_t05_c02"]),
    "ssch06": wi("ssch06_wi03", "What if the Cholas had not built the Grand Anicut?",
        "The Grand Anicut (Kallanai), an ancient dam across the Kaveri, spread the river's water across the delta "
        "and made it one of India's richest rice-growing regions for two thousand years. Without it, much of that "
        "water would have run wasted to the sea, and the Chola heartland could not have fed the population and "
        "armies that powered its sea-trade empire. A single piece of water engineering shaped the prosperity of "
        "the whole southern kingdom.",
        ["ssch06_t03_c03", "ssch06_t03_c02"]),
    "ssch07": wi("ssch07_wi03", "What if Aryabhata had not described the idea of zero and place value?",
        "Without a symbol and place for zero, every calculation would be as clumsy as it was with Roman numerals — "
        "try multiplying XLVII by XIX. The decimal place-value system that Gupta-age mathematicians refined let "
        "any number be written with just ten digits and made arithmetic, algebra and astronomy possible. That "
        "system spread through the Arab world to the whole planet. Modern science and computing rest on this Gupta "
        "achievement.",
        ["ssch07_t04_c02", "ssch07_t04_c01"]),
    "ssch08": wi("ssch08_wi03", "What if pilgrimage routes had never crossed the subcontinent?",
        "The great tīrtha networks made people travel from one end of India to the other, carrying not just "
        "prayers but goods, languages, stories and ideas. Without them, distant regions might have stayed "
        "strangers to one another, and the sense of a single shared culture across a vast land would be far "
        "weaker. Pilgrimage routes often became trade routes too. Much of India's cultural unity was woven by "
        "pilgrims' feet.",
        ["ssch08_t03_c03", "ssch08_t03_c01"]),
    "ssch09": wi("ssch09_wi03", "What if a country had no separation of powers?",
        "If the same person or body made the laws, enforced them and judged disputes, there would be nothing to "
        "stop power being abused — a law could be passed, applied and 'upheld' by one hand with no check. "
        "Separation of powers splits these roles among the legislature, executive and judiciary so each can "
        "restrain the others. Without it, even an elected ruler could slide into dictatorship. The division is "
        "what keeps a democracy honest.",
        ["ssch09_t03_c03", "ssch09_t04_c02"]),
    "ssch10": wi("ssch10_wi03", "What if India had no written Constitution?",
        "Without a single supreme document, there would be no agreed list of citizens' rights, no fixed rules for "
        "how the government is formed, and no neutral standard for courts to judge whether a law is fair. Those in "
        "power could change the rules to suit themselves. The Constitution sets limits on government and "
        "guarantees equality and freedom to everyone alike. It is the rulebook that makes the rule of law, rather "
        "than the rule of the strong, possible.",
        ["ssch10_t01_c02", "ssch10_t04_c02"]),
    "ssch11": wi("ssch11_wi03", "What if money had never been invented and we still bartered everything?",
        "Barter needs a 'double coincidence of wants' — you must find someone who has what you want AND wants what "
        "you have. A teacher wanting rice would have to find a farmer who happened to want lessons. Trade would be "
        "slow and limited, and you could not easily save value for later or price very different goods against "
        "each other. Money solves all of this by being a thing everyone accepts. Without it, a complex economy "
        "could barely function.",
        ["ssch11_t02_c01", "ssch11_t02_c02"]),
    "ssch12": wi("ssch12_wi03", "What if a popular product suddenly became very scarce?",
        "When something many people want becomes scarce, demand outstrips supply and the price tends to rise — "
        "sellers can ask more, and only those willing to pay get it. The high price then signals producers to "
        "make more and may push buyers toward substitutes, slowly easing the shortage. This tug-of-war between "
        "demand and supply is how a market sets prices without anyone being in charge. Scarcity and price are "
        "tightly linked.",
        ["ssch12_t02_c02", "ssch12_t01_c02"]),
    "ssch13": wi("ssch13_wi03", "What if all farmers stopped saving seeds and bought new ones every year?",
        "Saved, traditional seeds carry generations of local adaptation — to a region's pests, soil and climate — "
        "and they cost nothing. If everyone bought new seeds yearly, farmers would depend on companies and spend "
        "more, and many hardy local varieties could be lost forever, shrinking crop diversity. That diversity is "
        "an insurance policy: when a disease wipes out one variety, another may resist it. Losing it makes the "
        "whole food system more fragile.",
        ["ssch13_t04_c02", "ssch13_t05_c03"]),
    "ssch14": wi("ssch14_wi03", "What if India shared no open border with any neighbour?",
        "India's open border with Nepal lets people, goods and culture flow freely both ways, a sign of unusually "
        "close ties. If every border were sealed, such everyday movement and trade would stop, and the deep "
        "cultural and family links across South Asia would weaken. Being a 'good neighbour' depends on these "
        "connections. Borders can divide or bind, and how a country manages them shapes peace in the whole region.",
        ["ssch14_t03_c02", "ssch14_t01_c03"]),
    "ssch15": wi("ssch15_wi03", "What if Xuanzang had never written about his travels in India?",
        "Xuanzang's detailed account is one of our best windows into Harsha's India — its towns, universities like "
        "Nalanda, rulers and daily life. Without such a source, historians would have far less to go on, and much "
        "of what we 'know' about that age would be guesswork from ruins and inscriptions alone. Travellers' "
        "writings are precious primary evidence. A single careful observer can preserve a whole era for the "
        "future.",
        ["ssch15_t01_c03", "ssch15_t02_c02"]),
    "ssch16": wi("ssch16_wi03", "What if Rajendra Chola had not built a strong navy?",
        "Rajendra Chola's navy let the Cholas project power across the seas — raiding and trading as far as "
        "Southeast Asia — making them one of the few Indian empires to become a maritime power. Without that "
        "fleet, Chola influence would have stayed on land, and the rich sea-trade with the lands around the Bay of "
        "Bengal might have passed them by. Control of the seas, not just the land, made the Cholas exceptional.",
        ["ssch16_t03_c03", "ssch16_t03_c02"]),
    "ssch17": wi("ssch17_wi03", "What if India had turned away refugees instead of welcoming them?",
        "Communities like the Parsis, the Jews of Kerala, and Tibetan refugees found safety in India and, in "
        "return, enriched it with crafts, trade, learning and faith. Had India shut its doors, it would be poorer "
        "in culture and would not embody vasudhaiva kuṭumbakam — 'the world is one family'. The willingness to "
        "give refuge has long been part of India's identity. Acceptance made the country more varied and more "
        "humane.",
        ["ssch17_t01_c02", "ssch17_t04_c04"]),
    "ssch18": wi("ssch18_wi03", "What if there were no government at all?",
        "With no government, there would be no one to make and enforce laws, run police and courts, or provide "
        "shared things like roads, schools and clean water. The strong could simply take from the weak — 'might is "
        "right' instead of the rule of law. A government exists to protect rights, provide services and settle "
        "disputes fairly. Even an imperfect government is what keeps daily life orderly and rights protected.",
        ["ssch18_t03_c01", "ssch18_t02_c03"]),
    "ssch19": wi("ssch19_wi03", "What if a region had no roads, power or communication links?",
        "Without infrastructure, farmers could not get crops to market, factories could not run, students could "
        "not reach schools, and businesses could not connect with customers — so the region would stay poor no "
        "matter how hard people worked. This is why infrastructure is called the 'backbone' of development: it "
        "multiplies the value of everything else. Building roads, power and networks is often the first step in "
        "lifting an area out of poverty.",
        ["ssch19_t01_c02", "ssch19_t02_c01"]),
    "ssch20": wi("ssch20_wi03", "What if banks did not exist and people kept all their money at home?",
        "Money kept at home earns no interest, can be lost or stolen, and sits idle. Banks gather many people's "
        "savings and lend them to farmers, businesses and home-buyers, so the same money helps the whole economy "
        "grow — and pays savers interest that compounds over time. Without banks, there would be far less credit "
        "for new enterprises and no safe place for savings. The banking system quietly powers investment and "
        "growth.",
        ["ssch20_t02_c01", "ssch20_t01_c03"]),
}


def main():
    pack = json.loads(PACK.read_text(encoding="utf-8"))
    chapter_concept_ids = {}
    for ch in pack["chapters"]:
        ids = set()
        for tp in ch["topics"]:
            for c in tp["concepts"]:
                ids.add(c["id"])
        chapter_concept_ids[ch["id"]] = ids

    n_xc = 0
    n_wi = 0
    for ch in pack["chapters"]:
        cid = ch["id"]
        new_xc = EXAM3.get(cid)
        new_wi = WHATIF3.get(cid)
        if not new_xc or not new_wi:
            raise SystemExit(f"{cid}: missing authored third examConnection/whatIf")

        wc = len(new_xc["body"].split())
        if wc < 50 or wc > 130:
            raise SystemExit(f"{new_xc['id']} body {wc} words (want 50–130)")
        if len(new_wi["answer"].strip()) < 30:
            raise SystemExit(f"{new_wi['id']} answer too short")
        if len(new_wi["question"].strip()) < 5:
            raise SystemExit(f"{new_wi['id']} question too short")
        for rc in new_xc["relatedConceptIds"] + new_wi["relatedConceptIds"]:
            if rc not in chapter_concept_ids[cid]:
                raise SystemExit(f"{cid}: relatedConceptId {rc} not in chapter")

        existing_xc = [x for x in ch.get("examConnections", []) if x["id"] != new_xc["id"]]
        ch["examConnections"] = existing_xc + [new_xc]
        existing_wi = [w for w in ch.get("whatIfs", []) if w["id"] != new_wi["id"]]
        ch["whatIfs"] = existing_wi + [new_wi]

        if len(ch["examConnections"]) < 3 or len(ch["whatIfs"]) < 3:
            raise SystemExit(f"{cid}: after top-up still below 3 (xc={len(ch['examConnections'])}, wi={len(ch['whatIfs'])})")
        n_xc += 1
        n_wi += 1

    PACK.write_text(json.dumps(pack, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Topped up {n_xc} chapters: +1 examConnection (xc03) and +1 whatIf (wi03) each.")


if __name__ == "__main__":
    main()
