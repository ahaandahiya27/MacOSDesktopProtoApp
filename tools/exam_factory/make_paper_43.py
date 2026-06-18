# -*- coding: utf-8 -*-
# Boss Challenge Paper 43 — Physical & Chemical Changes · Reproduction in Plants
# · Fractions & Decimals · The Triangle & its Properties
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: leans hard into FUSION. A rusting nail's mass gain becomes a
# DECIMAL sum; the fraction of a magnesium ribbon burnt becomes a FRACTION; the
# count of seeds that sprout becomes a fraction of a whole; pollen grains spread
# over a triangular field become AREA reasoning; the angle a seed-flicking pod
# makes becomes a TRIANGLE angle sum. The child meets a Science situation and
# reaches for a Maths skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_43_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_43_<SHORT>_QuestionPaper.pdf
#   Paper_43_<SHORT>_Questions.md
#   Paper_43_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "43"
SHORT = "PhysicalChemicalChanges_ReproductionInPlants_FractionsDecimals_Triangle"
TITLE = ("Physical & Chemical Changes · Reproduction in Plants · "
         "Fractions & Decimals · The Triangle & its Properties")
LABELS = {
    "PC": "Physical & Chemical Changes",
    "RP": "Reproduction in Plants",
    "FD": "Fractions & Decimals",
    "TR": "The Triangle & its Properties",
}

# ---------- PHYSICAL & CHEMICAL CHANGES (25) — Science (some fused) ----------
PC = [
 ("PC","A change in which no new substance is formed and which can usually be reversed is called a:",
   "physical change",
   C("In a physical change only the look, size or state of a substance shifts; the substance itself stays the same.")+
   steps("Ask: is a new substance made?","If no — only shape, size or state changed","then it is a physical change.")+
   U("Folding paper or melting butter changes the form, not the substance — physical changes."),
   [("chemical change","A chemical change makes a new substance; here nothing new forms, so it is physical."),
    ("permanent change","Physical changes can usually be undone; 'permanent' fits chemical changes better."),
    ("nuclear change","Nuclear change alters the atom's core; everyday melting and folding are simply physical.")]),

 ("PC","Ice melting into water and water freezing back into ice are classic examples of a change that is:",
   "physical and reversible",
   C("Melting and freezing only swap the state of water between solid and liquid; the water itself never changes.")+
   steps("Solid ice warms and becomes liquid water","cool it and it returns to solid ice","no new substance — a reversible physical change.")+
   U("An ice cube in your drink melts, and a tray in the freezer makes ice again."),
   [("chemical and reversible","No new substance is born when ice melts, so it is physical, not chemical."),
    ("physical but irreversible","Frozen water can melt and melted water can freeze, so it is reversible."),
    ("chemical and irreversible","Melting forms no new material and can be undone, so neither word fits.")]),

 ("PC","When iron is left in damp air it slowly turns into a reddish-brown flaky layer; this rust is a sign of a:",
   "chemical change",
   C("Rust is a brand-new substance made when iron joins with oxygen and water, so rusting is chemical.")+
   steps("Iron meets oxygen and moisture in the air","they react to form reddish-brown iron oxide","a new substance appears — a chemical change.")+
   U("An old gate left in the rain grows a rusty crust that flakes off."),
   [("physical change","Rust is a new substance, not just a change of shape, so the change is chemical."),
    ("change of state only","Iron does not melt or freeze into rust; it reacts chemically to form a new solid."),
    ("a reversible change","You cannot simply turn rust back into shiny iron, marking it a chemical change.")]),

 ("PC","A nail of mass 8.0 g is left out and gains rust until it weighs 8.6 g. The extra 0.6 g comes mainly from the:",
   "oxygen it joined with from the air",
   C("Rust is iron combined with oxygen, so the added mass is the oxygen the iron pulled in from the air.")+
   steps("Rusting is iron reacting with oxygen and moisture","the oxygen becomes part of the new rust","so the nail gains the mass of that oxygen: 8.6 − 8.0 = 0.6 g.")+
   U("Weighing a rusted tin before and after shows it has grown heavier, not lighter."),
   [("water it dried out","Drying would make it lighter; the nail grew heavier because oxygen was added."),
    ("iron escaping into the air","Iron does not leave; extra atoms join it, so the mass goes up, not down."),
    ("dust settling on it","A neat 0.6 g gain matches oxygen combining chemically, not loose dust on the surface.")]),

 ("PC","Magnesium ribbon burns with a dazzling white light and leaves a white ash. The dazzling flame plus the new ash tell us this is a:",
   "chemical change",
   C("The white ash is magnesium oxide, a new substance, so burning magnesium is a chemical change.")+
   steps("Magnesium burns and combines with oxygen","a white powder, magnesium oxide, is left","a new substance forms — a chemical change.")+
   U("A sparkler burns brightly and leaves behind a grey-white ash that is not the original metal."),
   [("physical change","A new white powder forms, so this is chemical, not merely a change of shape."),
    ("change of state","Magnesium does not just melt; it reacts with oxygen to make a new substance."),
    ("reversible change","You cannot turn the white ash back into magnesium ribbon, so it is chemical.")]),

 ("PC","Three-quarters of a 20 cm magnesium ribbon is burnt away. The length of ribbon that turned to ash is:",
   "15 cm",
   C("Three-quarters of 20 cm means 3/4 × 20, which is 15 cm of ribbon converted to ash.")+
   steps("Find one-quarter: 20 ÷ 4 = 5 cm","three-quarters is 3 × 5 = 15 cm","so 15 cm of ribbon burnt to ash.")+
   U("Measuring how much of a sparkler has burnt tells you how much of the show is left."),
   [("5 cm","5 cm is only one-quarter; three-quarters is three times that, namely 15 cm."),
    ("12 cm","12 cm would be three-fifths of 20; three-quarters of 20 is 15 cm."),
    ("16 cm","16 cm is four-fifths; three-quarters of 20 cm works out to 15 cm.")]),

 ("PC","Burning a candle involves both kinds of change at once: the wax melting near the flame is physical, while the wax burning to give light and heat is:",
   "a chemical change",
   C("Melting wax just changes state, but burning wax makes new gases, so burning is chemical.")+
   steps("Heat near the flame melts solid wax to liquid — physical","wax vapour then burns, forming new gases","that burning is a chemical change.")+
   U("A birthday candle drips melted wax (physical) while its flame burns wax away (chemical)."),
   [("also a physical change","Burning makes new substances such as gases, so it is chemical, not physical."),
    ("no change at all","A burning candle clearly changes — it gives heat and light and shrinks chemically."),
    ("a change of state only","Burning is more than melting; it forms new gases, marking a chemical change.")]),

 ("PC","When you mix baking soda with vinegar it fizzes and bubbles of gas rush out. The fizzing tells you that a:",
   "new gas is being formed",
   C("The bubbles are carbon dioxide, a new substance, so the fizzing signals a chemical change.")+
   steps("Vinegar and baking soda react together","they make a new gas, carbon dioxide","the bubbles of new gas show a chemical change.")+
   U("A fizzy antacid tablet dropped in water bubbles as it makes gas."),
   [("the liquid is only getting colder","Bubbles of a new gas, not cooling, cause the fizz, marking a chemical change."),
    ("the soda is simply dissolving","Plain dissolving gives no gas; the rushing bubbles mean a new gas formed."),
    ("the vinegar is evaporating","Evaporation is slow and quiet; a brisk fizz shows a new gas being made.")]),

 ("PC","Curd setting from milk, food being cooked, and a leaf rotting are alike because each one is a:",
   "chemical change",
   C("In each case a new substance forms and the change cannot be simply undone, so all are chemical.")+
   steps("Milk turns to curd — a new substance","cooking and rotting also make new substances","none can be reversed, so all are chemical changes.")+
   U("Once milk becomes curd you cannot turn it back into fresh milk."),
   [("physical change","Each makes a new substance that cannot be undone, so the change is chemical."),
    ("reversible change","You cannot turn curd back to milk or un-cook food, so these are not reversible."),
    ("change of state only","More than a state change happens; new substances form, marking them chemical.")]),

 ("PC","Galvanisation protects iron from rusting by coating it with a thin layer of:",
   "zinc",
   C("A coat of zinc keeps air and moisture off the iron, so the iron cannot rust.")+
   steps("Rust needs iron to touch oxygen and water","a zinc layer blocks that contact","so galvanised iron resists rusting.")+
   U("Buckets and roofing sheets are galvanised so they last for years in the rain."),
   [("copper","Iron is galvanised with zinc, not copper; zinc is the metal used for this coat."),
    ("gold","Gold is far too costly to coat ordinary iron; the protective metal used is zinc."),
    ("lead","Lead is not used to galvanise iron; the standard protective coating is zinc.")]),

 ("PC","Dissolving sugar in water is called a physical change mainly because the sugar:",
   "can be recovered by evaporating the water",
   C("The sugar stays sugar; boiling off the water leaves it behind, so only the form changed.")+
   steps("Sugar spreads out among the water particles","no new substance is made","evaporate the water and the sugar returns — a physical change.")+
   U("Leaving sugary water in the sun until it dries leaves sticky sugar behind."),
   [("turns into a new sweet substance","Dissolved sugar is still sugar; nothing new forms, so the change is physical."),
    ("can never be got back again","You can recover the sugar by evaporating the water, which is why it is physical."),
    ("changes into water itself","Sugar does not become water; it merely spreads through it and can be recovered.")]),

 ("PC","A 2.5 g spoon of salt is stirred into water and then the water is fully evaporated. The mass of salt you get back is:",
   "2.5 g",
   C("Dissolving is a physical change, so no salt is lost; evaporating the water returns all 2.5 g.")+
   steps("Salt dissolves but is not destroyed","evaporating removes only the water","so all 2.5 g of salt is recovered.")+
   U("Sea water dried in shallow pans leaves behind the same salt that was dissolved in it."),
   [("0 g","Salt is not destroyed by dissolving; evaporating the water returns the full 2.5 g."),
    ("1.25 g","No salt is lost in a physical change, so you recover all 2.5 g, not half of it."),
    ("5 g","Mass cannot double; you get back exactly the 2.5 g you started with.")]),

 ("PC","When crystals of a substance are formed slowly from its hot solution, the process is called:",
   "crystallisation",
   C("Cooling a hot saturated solution slowly lets neat solid crystals grow out of it.")+
   steps("Dissolve the solid in hot water until no more dissolves","let the solution cool slowly","pure crystals separate out — crystallisation.")+
   U("Sugar candy (mishri) is made by letting crystals grow on a string in sugar solution."),
   [("evaporation","Evaporation drives off liquid as vapour; growing neat crystals is crystallisation."),
    ("condensation","Condensation turns a gas to liquid; forming solid crystals is crystallisation."),
    ("galvanisation","Galvanisation coats iron with zinc; growing crystals from solution is crystallisation.")]),

 ("PC","Souring of milk, rusting of iron and burning of wood are usually hard to reverse. This tells us that chemical changes are often:",
   "permanent",
   C("Because chemical changes make brand-new substances, you usually cannot turn them back, so they are permanent.")+
   steps("Each change makes a new substance","the new substance will not simply revert","so the change is usually permanent.")+
   U("Once wood has burnt to ash you cannot rebuild the original log."),
   [("temporary","New substances form that will not revert, so chemical changes are usually permanent."),
    ("easily reversed","Turning rust back to iron or ash back to wood is not easy, so they are permanent."),
    ("changes of state","These changes make new substances, not just new states, and are usually permanent.")]),

 ("PC","Ozone protects us from the Sun's harmful rays. Its formation from oxygen high in the air is a chemical change because:",
   "a new substance, ozone, is formed",
   C("Ozone is a different substance from ordinary oxygen, so making it is a chemical change.")+
   steps("Sunlight acts on oxygen high in the sky","this makes ozone, a new substance","forming a new substance is a chemical change.")+
   U("The ozone layer shields living things from harmful ultraviolet rays."),
   [("the oxygen only changes state","Oxygen does not just melt or freeze; it forms a new substance, ozone."),
    ("the air simply gets warmer","Warming alone is physical; here a new substance, ozone, is actually formed."),
    ("nothing new is made","Ozone is new and different from oxygen, so a new substance is indeed made.")]),

 ("PC","A blacksmith heats an iron rod until it glows and then hammers it into a curved shape. Bending the softened iron is a:",
   "physical change",
   C("Hammering only changes the rod's shape; it is still iron, so the change is physical.")+
   steps("Heating softens the iron without making a new substance","hammering bends it into a new shape","the iron is unchanged — a physical change.")+
   U("A blacksmith shapes a horseshoe from a straight bar without changing the metal itself."),
   [("chemical change","No new substance is made by bending; the iron stays iron, so it is physical."),
    ("rusting","Rusting needs air and moisture over time; hot hammering is just a shape change."),
    ("crystallisation","No crystals grow from a solution here; reshaping hot iron is a physical change.")]),

 ("PC","To slow the rusting of an iron chain you should mainly keep it:",
   "dry and away from moisture",
   C("Rust needs both air and water, so keeping iron dry starves the reaction and slows rusting.")+
   steps("Rusting needs oxygen and moisture together","remove the moisture by keeping the iron dry","without water the iron rusts far more slowly.")+
   U("Tools are wiped dry and oiled before being stored so they do not rust."),
   [("wet at all times","Water speeds rusting; keeping iron wet makes it rust faster, not slower."),
    ("buried in damp soil","Damp soil supplies the moisture rust needs, so it would rust faster."),
    ("painted with salty water","Salty water speeds rusting; a dry surface is what slows it down.")]),

 ("PC","Photosynthesis, in which a plant turns carbon dioxide and water into food using sunlight, is a chemical change because the plant:",
   "makes a new substance, sugar",
   C("The plant builds sugar, a brand-new substance, so photosynthesis is a chemical change.")+
   steps("Leaves take in carbon dioxide and water","sunlight powers them to make sugar","forming a new substance makes it a chemical change.")+
   U("A green plant in sunlight slowly builds up the starch you can test for in its leaves."),
   [("only changes the colour of light","The change makes new sugar, not just a colour shift, so it is chemical."),
    ("simply warms the water inside","Warming alone is physical; here new sugar is built, marking a chemical change."),
    ("freezes the carbon dioxide","No freezing happens; the gas is built into new sugar in a chemical change.")]),

 ("PC","A piece of paper torn into many small bits is still paper. Tearing paper is therefore a:",
   "physical change",
   C("Tearing changes only the size and shape of the paper; it is still paper, so it is physical.")+
   steps("The paper is cut into smaller pieces","no new substance forms","it is still paper — a physical change.")+
   U("Tearing a sheet into strips for a craft leaves you with the same paper, just smaller."),
   [("chemical change","Torn paper is still paper; no new substance forms, so the change is physical."),
    ("burning","Burning would make ash and gas; merely tearing leaves the paper unchanged."),
    ("an irreversible chemical change","Tearing makes no new substance, so it is a physical change, not chemical.")]),

 ("PC","In one experiment, 0.4 g of a metal reacts and another 0.4 g reacts the next day, while 0.2 g stays unreacted. The total mass of metal that reacted is:",
   "0.8 g",
   C("Add the two reacted amounts: 0.4 g plus 0.4 g gives 0.8 g of metal that reacted.")+
   steps("Day one: 0.4 g reacts","day two: another 0.4 g reacts","total reacted = 0.4 + 0.4 = 0.8 g.")+
   U("Adding up daily amounts of rust shows how much metal has been eaten away in all."),
   [("1.0 g","1.0 g would also count the 0.2 g that never reacted; only 0.4 + 0.4 = 0.8 g reacted."),
    ("0.4 g","0.4 g is just one day's amount; the two days add to 0.8 g."),
    ("0.2 g","0.2 g is the leftover unreacted metal, not the amount that reacted, which is 0.8 g.")]),

 ("PC","Setting of cement after water is added is a chemical change. The strongest clue is that the hardened cement:",
   "cannot be turned back into soft cement powder",
   C("A new hard substance forms that will not go back to powder, so setting cement is a chemical change.")+
   steps("Water reacts with the cement powder","a new hard solid forms","it cannot revert to powder — a chemical change.")+
   U("Once a concrete floor has set hard, you cannot stir it back into loose powder."),
   [("looks a little greyer than before","A colour hint is weak; the real clue is the new hard substance that cannot revert."),
    ("feels slightly cooler to touch","Temperature alone is weak evidence; the firm new solid that will not revert is the clue."),
    ("can easily be made into powder again","Set cement will not go back to powder, which is exactly why it is a chemical change.")]),

 ("PC","Melting of wax, boiling of water and dissolving of sugar are grouped together because each one is a:",
   "physical change",
   C("In every case no new substance is made and the change can be reversed, so all are physical.")+
   steps("Wax melts, water boils, sugar dissolves","no new substance forms in any of them","each can be reversed — all physical changes.")+
   U("Melted wax can be cooled back to solid, and boiled water can be condensed back to liquid."),
   [("chemical change","None of these makes a new substance, so they are physical, not chemical."),
    ("irreversible change","Each one can be reversed, so 'irreversible' does not fit these physical changes."),
    ("a change that makes a new substance","No new substance forms in any of them; they are simple physical changes.")]),

 ("PC","Rusting is faster near the sea. The main reason is that the salty sea air supplies extra:",
   "moisture and salt that speed the reaction",
   C("Salt and the damp sea air both speed rusting, so iron near the sea rusts faster.")+
   steps("Rust needs oxygen and moisture","sea air is damp and carries salt","the extra moisture and salt speed the rusting.")+
   U("Bicycles and gates in coastal towns rust much sooner than those far inland."),
   [("sunlight that melts the iron","Sunlight does not melt iron at the seaside; damp salty air is what speeds rusting."),
    ("sand that scratches the iron","Sand is not the cause; the moist, salty sea air drives the faster rusting."),
    ("cool air that freezes the iron","Cool air does not freeze iron; the damp salty air is what makes rust form faster.")]),

 ("PC","A burnt matchstick will not light again, but a melted ice cube can be re-frozen. This contrast shows that, in general:",
   "chemical changes are hard to reverse while many physical changes are not",
   C("Burning makes a new substance that will not revert, while melting only changes state and can be undone.")+
   steps("Burning a match is a chemical change — a new substance forms","melting and freezing ice are physical changes","so chemical changes resist reversal while physical ones often do not.")+
   U("You can refreeze water again and again, but you cannot un-burn a matchstick."),
   [("physical changes are always permanent","Many physical changes, like freezing, can be undone, so they are not always permanent."),
    ("chemical changes are always easy to reverse","Burning cannot be undone, showing chemical changes are usually hard to reverse."),
    ("both kinds of change are equally easy to reverse","A match cannot be un-burnt, so the two kinds are not equally reversible.")]),

 ("PC","Digesting food in your body, where it is broken down into new, simpler substances your cells can use, is best described as a:",
   "chemical change",
   C("Digestion breaks food into new, simpler substances, so it is a chemical change happening inside you.")+
   steps("Food is broken down in the body","new, simpler substances are formed","forming new substances makes it a chemical change.")+
   U("After a meal, your body chemically changes the food into substances it can absorb."),
   [("physical change","Digestion makes new simpler substances, not just a change of shape, so it is chemical."),
    ("change of state only","Food is not merely melted or frozen; it is chemically broken into new substances."),
    ("a reversible change","You cannot rebuild the original food from the digested substances, so it is chemical.")]),
]

# ---------- REPRODUCTION IN PLANTS (25) — Science (some fused) ----------
RP = [
 ("RP","The making of new individuals of the same kind by living things, so the species continues, is called:",
   "reproduction",
   C("Reproduction is how living things produce young ones like themselves so their kind does not die out.")+
   steps("Living things grow old and die","they make new individuals of the same kind","this making of offspring is reproduction.")+
   U("A mango tree drops seeds that grow into new mango trees, continuing its kind."),
   [("respiration","Respiration releases energy from food; making new individuals is reproduction."),
    ("germination","Germination is just a seed sprouting; the whole making of new plants is reproduction."),
    ("photosynthesis","Photosynthesis makes food in leaves; producing offspring is reproduction.")]),

 ("RP","Reproduction in which a new plant grows from a part of the parent plant, without seeds, is called:",
   "vegetative propagation",
   C("In vegetative propagation a piece of the parent — root, stem or leaf — grows into a whole new plant.")+
   steps("Take a part of the parent plant","that part grows roots and shoots","a new plant forms without any seed — vegetative propagation.")+
   U("A piece of potato with an 'eye' planted in soil grows into a new potato plant."),
   [("sexual reproduction","Sexual reproduction needs seeds from male and female cells; this uses a plant part instead."),
    ("pollination","Pollination is the transfer of pollen; growing a new plant from a part is vegetative propagation."),
    ("fertilisation","Fertilisation is the joining of male and female cells; growing from a plant part is vegetative.")]),

 ("RP","The small bud-like outgrowths on the leaf of a Bryophyllum plant are special because each one can:",
   "grow into a new plant",
   C("Each tiny bud on the leaf margin can fall, take root and become a whole new Bryophyllum plant.")+
   steps("Buds form along the edge of the leaf","a bud drops onto moist soil","it grows roots and shoots into a new plant.")+
   U("A single Bryophyllum leaf left on damp soil can sprout many little plants along its edge."),
   [("make food for the leaf","Food is made by the whole leaf in photosynthesis; these buds grow into new plants."),
    ("store extra water","The buds are not water stores; each one can grow into a brand-new plant."),
    ("turn into flowers only","The buds grow into complete new plants, not merely into flowers.")]),

 ("RP","Tiny plants such as yeast reproduce by forming a small bulge that grows and breaks away. This method is called:",
   "budding",
   C("In budding a small outgrowth, or bud, swells on the parent and then separates as a new individual.")+
   steps("A small bud appears on the parent yeast cell","the bud grows larger","it pinches off as a new yeast — budding.")+
   U("Yeast used to make bread multiplies quickly by budding in the warm dough."),
   [("fragmentation","Fragmentation is the parent breaking into pieces; a single bud pinching off is budding."),
    ("pollination","Pollination moves pollen between flowers; a bud separating from yeast is budding."),
    ("germination","Germination is a seed sprouting; a bud growing off a parent cell is budding.")]),

 ("RP","Some simple water plants like Spirogyra break into two or more pieces, and each piece grows into a new plant. This is called:",
   "fragmentation",
   C("In fragmentation the parent simply breaks into fragments, and each fragment grows into a new plant.")+
   steps("The thread-like plant breaks into pieces","each piece is a fragment of the parent","every fragment grows into a new plant — fragmentation.")+
   U("A mat of pond Spirogyra spreads quickly as broken threads each grow into new strands."),
   [("budding","Budding is a small bud pinching off; breaking into several pieces is fragmentation."),
    ("pollination","Pollination is pollen transfer between flowers; breaking into pieces is fragmentation."),
    ("fertilisation","Fertilisation joins male and female cells; the plant breaking into pieces is fragmentation.")]),

 ("RP","The tiny, light, dust-like reproductive units made in large numbers by ferns and mosses are called:",
   "spores",
   C("Spores are minute reproductive units that float in the air and grow into new plants where they land.")+
   steps("Ferns and mosses make many tiny spores","the light spores are carried by air","each spore that lands in a damp spot grows into a new plant.")+
   U("Bread left out grows mould because mould spores in the air settled and grew on it."),
   [("seeds","Seeds come from flowers and have a stored food supply; the dust-like units of ferns are spores."),
    ("buds","Buds are small outgrowths on a parent; the airborne dust-like units are spores."),
    ("fruits","Fruits are ripened ovaries that hold seeds; the tiny airborne units are spores.")]),

 ("RP","In a flower, the part that makes pollen grains and is the male reproductive part is the:",
   "stamen",
   C("The stamen is the male part of the flower; its top, the anther, makes the pollen grains.")+
   steps("Look at the flower's reproductive parts","the male part bears the pollen","that pollen-making part is the stamen.")+
   U("Brushing the centre of a lily leaves yellow pollen on your finger from its stamens."),
   [("pistil","The pistil is the female part of the flower; the male, pollen-making part is the stamen."),
    ("petal","Petals are coloured leaves that attract insects; the male part that makes pollen is the stamen."),
    ("sepal","Sepals are the small green parts protecting the bud; the male pollen-making part is the stamen.")]),

 ("RP","The female reproductive part of a flower, which includes the stigma, style and ovary, is the:",
   "pistil",
   C("The pistil is the flower's female part; its ovary holds the ovules that become seeds.")+
   steps("Find the central female part of the flower","it has a stigma on top, a style and an ovary below","this whole female part is the pistil.")+
   U("After pollination the ovary of the pistil swells and ripens into a fruit holding seeds."),
   [("stamen","The stamen is the male part that makes pollen; the female part is the pistil."),
    ("petal","Petals attract insects with colour; the female reproductive part is the pistil."),
    ("anther","The anther is the pollen-making tip of the stamen; the female part is the pistil.")]),

 ("RP","Carrying pollen grains from a flower's anther across to a stigma is the process known as:",
   "pollination",
   C("Pollination is the carrying of pollen from the anther to a stigma so that seeds can later form.")+
   steps("Pollen is made on the anther","it is carried to a stigma","this transfer of pollen is pollination.")+
   U("A bee crawling over flowers carries pollen from one bloom to the next, pollinating them."),
   [("fertilisation","Fertilisation is the later joining of male and female cells; the pollen transfer is pollination."),
    ("germination","Germination is a seed sprouting; carrying pollen to the stigma is pollination."),
    ("dispersal","Dispersal is the spreading of seeds; the transfer of pollen is pollination.")]),

 ("RP","When pollen lands on the stigma of a flower of the SAME plant, it is called:",
   "self-pollination",
   C("Self-pollination happens when a flower's own pollen, or pollen from the same plant, reaches its stigma.")+
   steps("Pollen leaves an anther","it reaches a stigma on the same plant","this is self-pollination.")+
   U("Many garden peas pollinate themselves inside the closed flower before it even opens."),
   [("cross-pollination","Cross-pollination carries pollen to a different plant; on the same plant it is self-pollination."),
    ("fertilisation","Fertilisation is cells joining after pollination; pollen reaching the same plant's stigma is self-pollination."),
    ("germination","Germination is a seed sprouting; pollen reaching the same plant's stigma is self-pollination.")]),

 ("RP","The joining of the male cell from the pollen with the female cell in the ovule, which forms the seed, is called:",
   "fertilisation",
   C("Fertilisation is the fusion of the male and female cells; the fertilised ovule then becomes a seed.")+
   steps("Pollen reaches the stigma (pollination)","the male cell travels down to the ovule","it joins the female cell — fertilisation, forming a seed.")+
   U("Only after fertilisation does a flower's ovule grow into a seed that can sprout."),
   [("pollination","Pollination only moves the pollen; the actual joining of male and female cells is fertilisation."),
    ("germination","Germination is the seed later sprouting; the joining of cells to form a seed is fertilisation."),
    ("budding","Budding is a bud pinching off a parent; cells joining to form a seed is fertilisation.")]),

 ("RP","In a field, 4 out of every 5 sown seeds sprout. The fraction of seeds that sprout is:",
   "4/5",
   C("Four sprouting out of every five sown is written directly as the fraction 4/5.")+
   steps("Seeds that sprout = 4","total seeds sown = 5","fraction that sprout = 4/5.")+
   U("A gardener uses such a fraction to judge how good a packet of seeds is."),
   [("1/5","1/5 is the fraction that did NOT sprout; the fraction that sprouted is 4/5."),
    ("5/4","5/4 is more than one whole, but a part of the seeds cannot exceed all of them; it is 4/5."),
    ("4/9","4/9 wrongly adds sprouted and total; the fraction sprouting is sprouted ÷ total = 4/5.")]),

 ("RP","A plant produces 200 seeds and 3/4 of them are eaten by birds. The number of seeds eaten is:",
   "150",
   C("Three-quarters of 200 means 3/4 × 200, which is 150 seeds eaten.")+
   steps("One-quarter of 200 is 200 ÷ 4 = 50","three-quarters is 3 × 50 = 150","so 150 seeds are eaten.")+
   U("Knowing what fraction of seeds is lost helps a farmer sow enough to get a good crop."),
   [("50","50 is only one-quarter of 200; three-quarters eaten is 150."),
    ("75","75 would be three-eighths of 200; three-quarters of 200 is 150."),
    ("100","100 is one-half of 200; three-quarters of 200 works out to 150.")]),

 ("RP","Seeds with wings or hair, such as those of the maple or the drumstick, are mainly spread by:",
   "wind",
   C("Light, winged or hairy seeds catch the breeze and are carried far by the wind.")+
   steps("The seed is light and has wings or hair","a breeze lifts and carries it","so wind spreads such seeds — wind dispersal.")+
   U("Dandelion seeds with feathery hairs drift across a field on the lightest breeze."),
   [("water","Water spreads seeds that float, like coconuts; light winged or hairy seeds are spread by wind."),
    ("animals","Animals carry sticky or tasty seeds; light winged and hairy seeds are carried by the wind."),
    ("exploding fruits","Some fruits burst to fling seeds, but winged and hairy seeds are carried by the wind.")]),

 ("RP","Seeds that have hooks or a sticky surface, like those of Xanthium, are usually carried away by:",
   "animals",
   C("Hooked or sticky seeds catch onto fur and clothes, so animals carry them to new places.")+
   steps("The seed has hooks or a sticky coat","it clings to the fur of a passing animal","the animal carries it far away — animal dispersal.")+
   U("Sticky 'burr' seeds clinging to a dog's coat get carried to new ground."),
   [("wind","Wind carries light, winged seeds; hooked or sticky seeds cling to animals instead."),
    ("water","Water carries floating seeds; hooked or sticky seeds are spread by clinging to animals."),
    ("self-bursting","Bursting flings seeds a short way; hooked, sticky seeds travel by clinging to animals.")]),

 ("RP","Spreading seeds far away from the parent plant is helpful mainly because it:",
   "reduces crowding and competition for water, minerals and sunlight",
   C("Scattering seeds wide means the new plants do not all crowd the parent, so each gets enough space and resources.")+
   steps("Seeds dropped under the parent would crowd together","crowded plants fight for water, minerals and light","spreading them out gives each plant room and resources.")+
   U("A forest stays healthy because dispersed seeds grow into trees spaced well apart."),
   [("makes the seeds heavier","Dispersal does not change a seed's weight; it spreads plants out to avoid crowding."),
    ("stops the seeds from sprouting","Dispersal helps seeds reach good ground to sprout, while reducing crowding."),
    ("turns the seeds into flowers","Seeds do not become flowers by being spread; dispersal simply avoids overcrowding.")]),

 ("RP","After fertilisation, the ovary of the flower grows and ripens into a:",
   "fruit",
   C("The fertilised ovary swells and ripens into the fruit, which protects the seeds inside it.")+
   steps("Fertilisation happens in the ovule","the ovary around it grows and ripens","that ripened ovary is the fruit.")+
   U("The mango you eat is the ripened ovary of a mango flower, with a seed inside."),
   [("a new flower","A fertilised ovary becomes a fruit, not another flower."),
    ("a root","Roots grow from a sprouting seed, not from the ovary; the ovary becomes a fruit."),
    ("a leaf","Leaves grow on the shoot, not from the ovary; the ovary ripens into a fruit.")]),

 ("RP","Gardeners often grow a new rose plant by planting a cut piece of its stem. This piece is called a:",
   "cutting",
   C("A cutting is a piece of stem planted so it grows roots and becomes a whole new plant.")+
   steps("Cut a healthy piece of stem from the parent","plant it in moist soil","it grows roots and shoots into a new plant — a cutting.")+
   U("Many rose and money-plant plants are grown from cuttings rather than from seeds."),
   [("spore","A spore is a tiny airborne unit from ferns and mosses; a planted stem piece is a cutting."),
    ("seed","A seed forms after fertilisation in a flower; a planted piece of stem is a cutting."),
    ("bud","A bud is a small outgrowth; the whole planted stem piece used to grow a new plant is a cutting.")]),

 ("RP","Bright petals, sweet smell and nectar in a flower are mainly there to:",
   "attract insects that help in pollination",
   C("Colour, scent and nectar draw insects, which then carry pollen from flower to flower.")+
   steps("Insects are drawn by bright petals, scent and nectar","they move from flower to flower for the nectar","carrying pollen as they go — helping pollination.")+
   U("A garden full of bright, scented flowers buzzes with bees moving pollen around."),
   [("frighten away all animals","Bright scented flowers attract helpful insects rather than scaring animals away."),
    ("make food for the plant","Food is made in the leaves; petals, scent and nectar attract pollinating insects."),
    ("store water for dry days","Petals do not store water; their colour and scent attract pollinating insects.")]),

 ("RP","A pod of a balsam plant suddenly bursts open and flings its seeds out. This is dispersal by:",
   "the bursting of the fruit itself",
   C("Some fruits build up tension and split open suddenly, throwing their seeds away from the parent.")+
   steps("The ripe pod dries and tightens","it splits open suddenly","the seeds are flung out — dispersal by bursting.")+
   U("A ripe balsam pod scatters its seeds when you just lightly touch it."),
   [("wind only","Bursting flings the seeds directly; it does not depend on a breeze to carry them out."),
    ("water only","No water is needed; the pod itself bursts open and throws the seeds."),
    ("sticky hooks","Hooks cling to animals; a balsam pod instead bursts open to fling its seeds.")]),

 ("RP","A seed is made up of a tiny baby plant called the embryo together with a store of:",
   "food for the young plant",
   C("Inside the seed is the embryo plus stored food that feeds the baby plant until it can make its own.")+
   steps("The seed holds a tiny embryo","beside it is stored food","this food feeds the embryo until its leaves can make food.")+
   U("A sprouting bean uses the food in its two halves before its first leaves open."),
   [("water for the soil","The seed stores food for the embryo, not water for the soil."),
    ("pollen for the flower","Pollen is made in flowers, not stored in a seed; the seed stores food for the embryo."),
    ("salt for the roots","Seeds store food for the young plant, not salt for the roots.")]),

 ("RP","A new plant grown by vegetative propagation, such as from a potato eye, is exactly like the parent because it:",
   "comes from a single parent and has the same features",
   C("Since it grows from one parent's own part, the new plant shares the parent's features closely.")+
   steps("The new plant grows from a part of one parent","no second parent's cells are involved","so it closely matches the parent's features.")+
   U("All the banana plants in a field grown from one parent give the same kind of fruit."),
   [("mixes features from two parents","Vegetative propagation uses one parent only, so it does not mix two parents' features."),
    ("always grows much larger than the parent","The new plant matches the parent; it does not automatically grow larger."),
    ("makes its own brand-new flowers first","It simply grows like the parent; matching the parent is the key point.")]),

 ("RP","A mango tree drops 60 seeds and only 1/3 of them land on good soil. The number that land on good soil is:",
   "20",
   C("One-third of 60 means 60 ÷ 3, which is 20 seeds landing on good soil.")+
   steps("Total seeds = 60","one-third = 60 ÷ 3","= 20 seeds on good soil.")+
   U("Knowing what fraction reaches good soil helps explain why trees make so many seeds."),
   [("3","3 wrongly divides into the fraction's bottom number; one-third of 60 is 60 ÷ 3 = 20."),
    ("30","30 is one-half of 60; one-third of 60 is 20."),
    ("40","40 is two-thirds of 60; one-third of 60 is 20.")]),

 ("RP","Out of 100 flowers on a tree, 0.25 of them turn into fruit. The number of flowers that become fruit is:",
   "25",
   C("0.25 of 100 means 0.25 × 100, which equals 25 flowers becoming fruit.")+
   steps("0.25 is the same as one-quarter","one-quarter of 100 is 100 ÷ 4","= 25 flowers become fruit.")+
   U("Gardeners notice many flowers fall and only a fraction become the fruit you finally eat."),
   [("4","4 confuses the share with the divisor; 0.25 of 100 is 25, not 4."),
    ("50","50 is one-half of 100; 0.25 of 100 is one-quarter, namely 25."),
    ("75","75 is three-quarters of 100; 0.25 of 100 is one-quarter, namely 25.")]),

 ("RP","Reproduction by seeds, which needs pollen and an egg from flowers, is called sexual reproduction because it involves:",
   "the joining of two different cells, male and female",
   C("Sexual reproduction needs a male cell and a female cell to join, unlike growing from a single plant part.")+
   steps("Pollen carries the male cell","the ovule holds the female cell","their joining (fertilisation) makes a seed — sexual reproduction.")+
   U("Crossing two different plants can give seeds for a new variety with mixed features."),
   [("only one parent's body part","Using one parent's part is vegetative propagation; sexual reproduction joins two cells."),
    ("breaking the plant into pieces","Breaking into pieces is fragmentation; sexual reproduction joins a male and female cell."),
    ("a bud pinching off the parent","A bud pinching off is budding; sexual reproduction joins two different cells.")]),
]

# ---------- FRACTIONS & DECIMALS (25) — Maths (some fused) ----------
FD = [
 ("FD","Multiplying the two fractions 1/2 and 1/3 together gives a product equal to:",
   "1/6",
   C("To multiply fractions, multiply the top numbers together and the bottom numbers together.")+
   steps("Multiply numerators: 1 × 1 = 1","multiply denominators: 2 × 3 = 6","so 1/2 × 1/3 = 1/6.")+
   U("Half of one-third of a cake is one-sixth of the whole cake."),
   [("2/5","2/5 comes from wrongly adding tops and bottoms; multiplying gives 1/6."),
    ("1/5","1/5 mixes up the denominators; 2 × 3 = 6, so the answer is 1/6."),
    ("2/6","Multiplying the tops gives 1, not 2, so the product is 1/6, not 2/6.")]),

 ("FD","The product 3/4 × 8 is equal to:",
   "6",
   C("To multiply a fraction by a whole number, multiply the whole number by the top and keep the bottom.")+
   steps("3/4 × 8 = (3 × 8) / 4","= 24 / 4","= 6.")+
   U("Three-quarters of 8 slices of pizza is 6 slices."),
   [("11","11 wrongly adds 3 and 8; you must multiply, giving 24 ÷ 4 = 6."),
    ("24","24 is only 3 × 8; you must still divide by 4 to get 6."),
    ("2","2 is one-quarter of 8; three-quarters of 8 is 6.")]),

 ("FD","Among the fractions 1/2, 2/3, 3/4 and 5/12, the one with the greatest value is:",
   "3/4",
   C("To compare fractions, make their bottoms the same and then compare the tops.")+
   steps("Write them with denominator 12: 1/2 = 6/12, 2/3 = 8/12, 3/4 = 9/12","compare the tops: 6, 8 and 9","9/12 is the biggest, so 3/4 is largest.")+
   U("Comparing fractions tells you which glass holds the most juice."),
   [("1/2","1/2 is 6/12, which is smaller than 3/4 (9/12)."),
    ("2/3","2/3 is 8/12, which is just below 3/4 (9/12)."),
    ("5/12","5/12 is the smallest here; 3/4 is 9/12, the largest.")]),

 ("FD","The decimal 0.75 written as a fraction in its simplest form is:",
   "3/4",
   C("0.75 means 75 hundredths, and 75/100 simplifies to 3/4.")+
   steps("0.75 = 75/100","divide top and bottom by 25","= 3/4.")+
   U("A 0.75 litre bottle holds three-quarters of a litre."),
   [("7/5","7/5 misreads the digits; 0.75 is 75/100, which simplifies to 3/4."),
    ("3/5","3/5 is 0.6, not 0.75; 0.75 simplifies to 3/4."),
    ("75/10","75/10 places the decimal wrongly; 0.75 is 75/100 = 3/4.")]),

 ("FD","The reciprocal of the fraction 2/5 is:",
   "5/2",
   C("The reciprocal of a fraction is found by swapping its top and bottom numbers.")+
   steps("Take 2/5","swap top and bottom","get 5/2.")+
   U("Reciprocals are used when you divide by a fraction — you multiply by the flipped fraction."),
   [("2/5","A number's reciprocal is its flip; the reciprocal of 2/5 is 5/2, not itself."),
    ("-2/5","Reciprocal means flipping, not changing the sign; it is 5/2."),
    ("7/10","7/10 has nothing to do with flipping 2/5; the reciprocal is 5/2.")]),

 ("FD","Dividing the fraction 1/2 by the fraction 1/4 gives an answer of:",
   "2",
   C("To divide by a fraction, multiply by its reciprocal — flip the second fraction and multiply.")+
   steps("1/2 ÷ 1/4 = 1/2 × 4/1","= 4/2","= 2.")+
   U("How many quarter-cups fit in half a cup? Exactly 2."),
   [("1/8","1/8 comes from multiplying instead of dividing; dividing gives 2."),
    ("1/2","1/2 ignores the division; flipping and multiplying gives 2."),
    ("8","8 flips the wrong fraction; flipping 1/4 to 4 gives 1/2 × 4 = 2.")]),

 ("FD","The sum 0.6 + 0.45 is equal to:",
   "1.05",
   C("Line up the decimal points and add, treating 0.6 as 0.60.")+
   steps("Write 0.60 + 0.45","add the hundredths and tenths","= 1.05.")+
   U("Adding two lengths in metres, like 0.6 m and 0.45 m, gives 1.05 m."),
   [("0.51","0.51 wrongly lines up the digits; 0.60 + 0.45 = 1.05."),
    ("1.5","1.5 misplaces the decimal; carefully adding gives 1.05."),
    ("0.105","0.105 has the decimal in the wrong place; the sum is 1.05.")]),

 ("FD","The product 0.2 × 0.3 is equal to:",
   "0.06",
   C("Multiply as whole numbers, then place the decimal point counting the total decimal places.")+
   steps("2 × 3 = 6","there are 1 + 1 = 2 decimal places in all","so 0.2 × 0.3 = 0.06.")+
   U("Finding 0.2 of a 0.3 m strip gives a piece 0.06 m long."),
   [("0.6","0.6 forgets one decimal place; with two places the answer is 0.06."),
    ("0.5","0.5 wrongly adds 0.2 and 0.3; multiplying gives 0.06."),
    ("6","6 ignores the decimal points entirely; the product is 0.06.")]),

 ("FD","The value of 2.5 ÷ 0.5 is:",
   "5",
   C("Multiply both numbers by 10 to clear the decimal, turning it into 25 ÷ 5.")+
   steps("2.5 ÷ 0.5 = 25 ÷ 5","= 5","check: 0.5 × 5 = 2.5.")+
   U("How many half-litre glasses fill a 2.5 litre jug? Exactly 5."),
   [("1.25","1.25 comes from dividing by 2 instead of 0.5; the answer is 5."),
    ("0.5","0.5 confuses the divisor with the answer; 2.5 ÷ 0.5 = 5."),
    ("12.5","12.5 multiplies instead of dividing; dividing gives 5.")]),

 ("FD","In the fraction 7/9, the number 9 below the line is called the:",
   "denominator",
   C("The denominator is the bottom number; it tells how many equal parts the whole is split into.")+
   steps("Look below the line in 7/9","that number, 9, names the equal parts in the whole","it is the denominator.")+
   U("In 7/9 of a pizza, the 9 says the pizza was cut into 9 equal slices."),
   [("numerator","The numerator is the TOP number, 7; the bottom number 9 is the denominator."),
    ("quotient","A quotient is the answer to a division; the bottom of a fraction is the denominator."),
    ("reciprocal","A reciprocal is a flipped fraction; the bottom number is called the denominator.")]),

 ("FD","A recipe needs 3/4 cup of flour for one cake. For 3 cakes you need:",
   "2 1/4 cups",
   C("Multiply the flour for one cake by 3: 3/4 × 3 gives the total flour needed.")+
   steps("3/4 × 3 = 9/4","9/4 = 2 with 1/4 left over","so 2 1/4 cups.")+
   U("Scaling up a recipe means multiplying each ingredient by the number of batches."),
   [("9/4 cups left as is","9/4 is correct as a value, but as a mixed number it is 2 1/4 cups."),
    ("1 1/4 cups","1 1/4 is too little; 3/4 × 3 = 9/4 = 2 1/4 cups."),
    ("3/4 cup","3/4 cup is enough for only one cake; three cakes need 2 1/4 cups.")]),

 ("FD","The fraction 12/16 written in its simplest form is:",
   "3/4",
   C("Divide the top and bottom by their highest common factor to simplify the fraction.")+
   steps("The highest common factor of 12 and 16 is 4","12 ÷ 4 = 3 and 16 ÷ 4 = 4","so 12/16 = 3/4.")+
   U("Simplest form makes fractions easier to compare and to picture."),
   [("6/8","6/8 is only partly simplified; dividing further by 2 gives 3/4."),
    ("4/3","4/3 flips the fraction; simplifying 12/16 keeps it as 3/4."),
    ("12/16","12/16 is not in simplest form; dividing both by 4 gives 3/4.")]),

 ("FD","Half of 1/2 is:",
   "1/4",
   C("Half of a number means multiplying it by 1/2, so half of 1/2 is 1/2 × 1/2.")+
   steps("1/2 × 1/2 = 1/4","multiply tops: 1 × 1 = 1","multiply bottoms: 2 × 2 = 4, giving 1/4.")+
   U("Cutting half a chapati into two equal pieces gives quarter-chapati pieces."),
   [("1","1 would be doubling, not halving; half of 1/2 is 1/4."),
    ("1/2","1/2 is the whole half; taking half of it gives 1/4."),
    ("2/2","2/2 equals one whole; half of 1/2 is the much smaller 1/4.")]),

 ("FD","Which decimal is equal to the fraction 1/5?",
   "0.2",
   C("Divide the top by the bottom: 1 ÷ 5 gives the decimal value of the fraction.")+
   steps("1 ÷ 5 = 0.2","check: 0.2 × 5 = 1","so 1/5 = 0.2.")+
   U("A 0.2 litre cup is one-fifth of a litre."),
   [("0.5","0.5 is 1/2, not 1/5; one-fifth is 0.2."),
    ("0.15","0.15 is between, but 1 ÷ 5 gives exactly 0.2."),
    ("1.5","1.5 is far bigger than one whole; 1/5 is 0.2.")]),

 ("FD","The value of 5/8 − 1/8 is:",
   "1/2",
   C("With the same bottom number, subtract the tops and keep the denominator, then simplify.")+
   steps("5/8 − 1/8 = 4/8","simplify 4/8 by dividing by 4","= 1/2.")+
   U("Eating 1/8 of a pizza after having 5/8 leaves 4/8, which is half a pizza... here it is what remains of the difference, 1/2."),
   [("4/16","4/16 wrongly changes the bottom; with equal bottoms you keep 8, getting 4/8 = 1/2."),
    ("6/8","6/8 adds instead of subtracting; 5/8 − 1/8 = 4/8 = 1/2."),
    ("4/8 only","4/8 is right but not simplest; it reduces to 1/2.")]),

 ("FD","A wire 2.4 m long is cut into 4 equal pieces. Each piece is:",
   "0.6 m",
   C("Share the length equally by dividing the total by the number of pieces.")+
   steps("2.4 ÷ 4","= 0.6","check: 0.6 × 4 = 2.4 m.")+
   U("Cutting a length of string into equal bits uses exactly this division."),
   [("0.8 m","0.8 m would come from dividing by 3; dividing 2.4 by 4 gives 0.6 m."),
    ("1.0 m","1.0 m is too long; 2.4 ÷ 4 = 0.6 m, and 4 × 1.0 would be 4 m."),
    ("0.06 m","0.06 m misplaces the decimal; 2.4 ÷ 4 = 0.6 m.")]),

 ("FD","Comparing 0.7 and 0.65, the larger number is:",
   "0.7",
   C("Compare decimals place by place, writing 0.7 as 0.70 so both have two places.")+
   steps("Write 0.70 and 0.65","compare tenths: 7 against 6","7 is larger, so 0.70 > 0.65.")+
   U("Comparing race times in seconds tells you who was faster."),
   [("0.65","0.65 has fewer tenths (6) than 0.70 (7), so it is the smaller number."),
    ("they are equal","0.70 and 0.65 differ in the tenths place, so they are not equal; 0.7 is larger."),
    ("cannot be compared","Decimals can always be compared place by place; here 0.7 is larger.")]),

 ("FD","Rewriting the improper fraction 7/2 in the form of a mixed number gives:",
   "3 1/2",
   C("Divide the top by the bottom; the quotient is the whole part and the remainder makes the fraction.")+
   steps("7 ÷ 2 = 3 remainder 1","the whole part is 3","the remainder 1 over 2 gives 3 1/2.")+
   U("Seven half-glasses of water make three and a half full glasses."),
   [("2 1/3","2 1/3 swaps the numbers; 7 ÷ 2 is 3 remainder 1, giving 3 1/2."),
    ("3 1/3","3 1/3 keeps the wrong bottom; the remainder 1 over 2 gives 3 1/2."),
    ("1 3/2","1 3/2 still has an improper part; the correct mixed number is 3 1/2.")]),

 ("FD","One-third of 0.9 is:",
   "0.3",
   C("One-third of a number means dividing it by 3.")+
   steps("0.9 ÷ 3","= 0.3","check: 0.3 × 3 = 0.9.")+
   U("Sharing 0.9 litre of milk equally among 3 cups puts 0.3 litre in each."),
   [("0.6","0.6 is two-thirds of 0.9; one-third is 0.3."),
    ("0.27","0.27 multiplies by 0.3 instead of dividing by 3; one-third of 0.9 is 0.3."),
    ("3","3 ignores the decimal; one-third of 0.9 is 0.3.")]),

 ("FD","The product 2/3 × 9/4 in its simplest form is:",
   "3/2",
   C("Multiply the tops and the bottoms, then simplify the result.")+
   steps("2/3 × 9/4 = 18/12","divide top and bottom by 6","= 3/2.")+
   U("Scaling one fraction of a recipe by another fraction uses this kind of multiplication."),
   [("18/12 left as is","18/12 is correct before simplifying; reduced it becomes 3/2."),
    ("11/7","11/7 wrongly adds across; multiplying and simplifying gives 3/2."),
    ("2/3","2/3 forgets to multiply by 9/4; the product simplifies to 3/2.")]),

 ("FD","Rohan reads 1/4 of a book on Monday and 2/4 of it on Tuesday. The fraction of the book he has read is:",
   "3/4",
   C("With the same denominator, add the numerators and keep the bottom number.")+
   steps("1/4 + 2/4","add tops: 1 + 2 = 3, keep bottom 4","= 3/4.")+
   U("Tracking what fraction of a book you've read tells you how much is left."),
   [("3/8","3/8 wrongly adds the bottoms too; with equal bottoms you keep 4, getting 3/4."),
    ("1/2","1/2 is only 2/4; adding 1/4 and 2/4 gives 3/4."),
    ("2/4","2/4 is just Tuesday's share; together with Monday it is 3/4.")]),

 ("FD","Multiplying the decimal number 1.2 by the whole number 5 gives a result of:",
   "6.0",
   C("Multiply as whole numbers, then place the decimal point with the same number of decimal places.")+
   steps("12 × 5 = 60","there is 1 decimal place","so 1.2 × 5 = 6.0.")+
   U("Buying 5 items at 1.2 units of weight each gives 6 units in total."),
   [("0.6","0.6 misplaces the decimal far too far; 1.2 × 5 = 6.0."),
    ("60","60 forgets the decimal place; the answer is 6.0."),
    ("5.2","5.2 adds 5 to 0.2 wrongly; multiplying gives 6.0.")]),

 ("FD","Which fraction is equivalent to 2/3?",
   "8/12",
   C("Equivalent fractions are found by multiplying top and bottom by the same number.")+
   steps("Multiply 2/3 by 4/4","2 × 4 = 8 and 3 × 4 = 12","so 2/3 = 8/12.")+
   U("Equivalent fractions let you compare or add fractions with different bottoms."),
   [("3/2","3/2 flips the fraction; an equivalent of 2/3 keeps the same value, like 8/12."),
    ("4/9","4/9 multiplies the numbers by different amounts; the equivalent is 8/12."),
    ("6/8","6/8 equals 3/4, not 2/3; the equivalent of 2/3 here is 8/12.")]),

 ("FD","The number 0.125 written as a fraction in simplest form is:",
   "1/8",
   C("0.125 means 125 thousandths, and 125/1000 simplifies to 1/8.")+
   steps("0.125 = 125/1000","divide top and bottom by 125","= 1/8.")+
   U("An eighth of a litre is 0.125 litre."),
   [("1/4","1/4 is 0.25, not 0.125; 0.125 simplifies to 1/8."),
    ("125/100","125/100 misplaces the decimal; 0.125 is 125/1000 = 1/8."),
    ("1/5","1/5 is 0.2, not 0.125; the correct fraction is 1/8.")]),

 ("FD","A jug holds 1.5 litre and a glass holds 0.25 litre. The number of full glasses the jug can fill is:",
   "6",
   C("Divide the jug's volume by one glass's volume to count the glasses.")+
   steps("1.5 ÷ 0.25","= 150 ÷ 25 = 6","check: 0.25 × 6 = 1.5 litre.")+
   U("Working out how many small cups a big bottle fills is exactly this division."),
   [("4","4 would empty only 1.0 litre; 1.5 ÷ 0.25 gives 6."),
    ("3","3 divides by 0.5 instead of 0.25; the answer is 6."),
    ("1.75","1.75 wrongly adds the two volumes; dividing gives 6 glasses.")]),
]

# ---------- THE TRIANGLE & ITS PROPERTIES (25) — Maths (some fused) ----------
TR = [
 ("TR","In any triangle, the three angles measured inside it together add up to exactly:",
   "180°",
   C("No matter the triangle's shape, its three inside angles always add up to 180 degrees.")+
   steps("Take any triangle and measure its three angles","add the three measures","the total is always 180°.")+
   U("Builders rely on this to check that a triangular frame is drawn correctly."),
   [("90°","90° is a single right angle; the three angles of a triangle add to 180°."),
    ("360°","360° is the angle sum of a four-sided shape; a triangle's three angles add to 180°."),
    ("270°","270° is too large; the three interior angles of a triangle always total 180°.")]),

 ("TR","If a triangle's first two angles measure 50° and 60°, then its remaining angle must be:",
   "70°",
   C("Since the three angles add to 180°, subtract the two known angles from 180°.")+
   steps("Add the known angles: 50 + 60 = 110","subtract from 180: 180 − 110","= 70°.")+
   U("Finding a missing angle this way checks a triangular drawing is consistent."),
   [("110°","110° is the sum of the two given angles, not the third one, which is 70°."),
    ("80°","80° would not make the angles total 180°; the third angle is 70°."),
    ("60°","60° repeats a given angle; subtracting from 180 gives 70°.")]),

 ("TR","When every one of a triangle's three sides has exactly the same length, we call it:",
   "an equilateral triangle",
   C("An equilateral triangle has all three sides equal, and so all three angles are equal too.")+
   steps("Check the three sides","all three are equal in length","so it is an equilateral triangle.")+
   U("A well-made triangular road sign is often equilateral, with equal sides."),
   [("an isosceles triangle","An isosceles triangle has only two equal sides; all three equal makes it equilateral."),
    ("a scalene triangle","A scalene triangle has all sides different; all three equal makes it equilateral."),
    ("a right triangle","A right triangle has a 90° angle; equal sides on all three makes it equilateral.")]),

 ("TR","A triangle that has exactly two equal sides is called:",
   "an isosceles triangle",
   C("An isosceles triangle has two equal sides, and the two angles opposite them are also equal.")+
   steps("Compare the three sides","exactly two are equal","so the triangle is isosceles.")+
   U("A simple tent often forms an isosceles triangle with its two equal sloping sides."),
   [("an equilateral triangle","An equilateral triangle has all THREE sides equal; two equal makes it isosceles."),
    ("a scalene triangle","A scalene triangle has no equal sides; two equal sides make it isosceles."),
    ("a right triangle","A right triangle is named for its 90° angle; two equal sides make it isosceles.")]),

 ("TR","When no two sides of a triangle share the same length at all, the triangle is called:",
   "a scalene triangle",
   C("A scalene triangle has no two sides equal, so all three of its angles are different too.")+
   steps("Compare the three sides","no two of them are equal","so the triangle is scalene.")+
   U("Many ordinary triangular pieces of land are scalene, with three unequal sides."),
   [("an equilateral triangle","An equilateral triangle has all sides equal; all different makes it scalene."),
    ("an isosceles triangle","An isosceles triangle has two equal sides; all sides different makes it scalene."),
    ("an acute triangle","Acute describes angles under 90°; sides all different makes it scalene.")]),

 ("TR","A triangle that contains one right angle of 90° is called:",
   "a right-angled triangle",
   C("A right-angled triangle has one angle equal to 90°; its longest side is the hypotenuse.")+
   steps("Look at the three angles","one of them is exactly 90°","so it is a right-angled triangle.")+
   U("The corner of a set square is a right angle in a right-angled triangle."),
   [("an equilateral triangle","An equilateral triangle's angles are all 60°, none of them 90°; a 90° angle makes it right-angled."),
    ("an obtuse triangle","An obtuse triangle has an angle above 90°; one of exactly 90° makes it right-angled."),
    ("an acute triangle","An acute triangle's angles are all below 90°; one exactly 90° makes it right-angled.")]),

 ("TR","An exterior angle of a triangle equals the sum of the two:",
   "interior opposite angles",
   C("An exterior angle of a triangle equals the sum of the two interior angles not next to it.")+
   steps("Pick an exterior angle at one corner","find the two interior angles far from it","their sum equals the exterior angle.")+
   U("This shortcut lets you find an angle without first finding all three interior angles."),
   [("adjacent interior angles","The exterior angle pairs with its neighbour to make 180°; it equals the two FAR interior angles."),
    ("base angles only","It is not just the base angles; it equals the two interior angles opposite to it."),
    ("right angles in the figure","The rule is about the two opposite interior angles, not right angles.")]),

 ("TR","In a triangle, an exterior angle is 120° and one interior opposite angle is 70°. The other interior opposite angle is:",
   "50°",
   C("The exterior angle equals the sum of the two interior opposite angles, so subtract the known one.")+
   steps("Exterior angle = sum of opposite interiors: 120 = 70 + ?","subtract: 120 − 70","= 50°.")+
   U("Surveyors use the exterior-angle rule to find an unknown angle quickly."),
   [("190°","190° wrongly adds instead of subtracting; 120 − 70 gives 50°."),
    ("60°","60° does not satisfy 70 + ? = 120; the answer is 50°."),
    ("120°","120° is the exterior angle itself, not the missing interior angle, which is 50°.")]),

 ("TR","The longest side of a right-angled triangle, which lies opposite the right angle, is called the:",
   "hypotenuse",
   C("The hypotenuse is the side facing the right angle and is always the longest side.")+
   steps("Find the 90° angle","look at the side directly opposite it","that longest side is the hypotenuse.")+
   U("In a ladder leaning on a wall, the ladder itself is the hypotenuse of the triangle."),
   [("base","The base is a side along the bottom; the side opposite the right angle is the hypotenuse."),
    ("altitude","The altitude is a height drawn to a side; the side opposite the right angle is the hypotenuse."),
    ("median","A median joins a vertex to a midpoint; the side opposite the right angle is the hypotenuse.")]),

 ("TR","By the Pythagoras property, in a right triangle with legs 3 and 4, the hypotenuse is:",
   "5",
   C("Pythagoras says the square of the hypotenuse equals the sum of the squares of the other two sides.")+
   steps("Square the legs: 3² + 4² = 9 + 16 = 25","the hypotenuse squared is 25","so the hypotenuse is √25 = 5.")+
   U("Carpenters use the 3-4-5 rule to make a perfect right-angled corner."),
   [("7","7 just adds 3 and 4; Pythagoras needs squares, giving √25 = 5."),
    ("12","12 multiplies 3 and 4; the hypotenuse from squares is 5."),
    ("25","25 is the SQUARE of the hypotenuse; the hypotenuse itself is √25 = 5.")]),

 ("TR","A line segment joining a vertex of a triangle to the midpoint of the opposite side is called a:",
   "median",
   C("A median runs from a corner to the middle of the side facing it, splitting that side in half.")+
   steps("Choose a vertex of the triangle","find the midpoint of the opposite side","join them — that segment is a median.")+
   U("The three medians of a triangle meet at its balance point, the centroid."),
   [("altitude","An altitude is the perpendicular height from a vertex; the one to the side's midpoint is a median."),
    ("hypotenuse","The hypotenuse is a side of a right triangle, not a line to a midpoint; that is a median."),
    ("base","The base is a side of the triangle; the segment to the opposite midpoint is a median.")]),

 ("TR","The perpendicular line segment drawn from a vertex to the opposite side of a triangle is the:",
   "altitude",
   C("An altitude is the height of the triangle: the perpendicular from a vertex straight to the opposite side.")+
   steps("Pick a vertex","drop a line perpendicular to the opposite side","that perpendicular segment is the altitude.")+
   U("The altitude of a triangle is the height you use in the area formula."),
   [("median","A median goes to the midpoint, not perpendicularly; the perpendicular one is the altitude."),
    ("hypotenuse","The hypotenuse is a side of a right triangle; the perpendicular height is the altitude."),
    ("exterior angle","An exterior angle is an angle, not a segment; the perpendicular height is the altitude.")]),

 ("TR","Which set of side lengths can actually form a triangle?",
   "3 cm, 4 cm, 6 cm",
   C("Three lengths form a triangle only if the sum of any two sides is greater than the third side.")+
   steps("Check 3 + 4 = 7, which is greater than 6","the other pairs also pass (3+6>4, 4+6>3)","so 3, 4 and 6 cm can form a triangle.")+
   U("Before cutting sticks for a triangular frame, you check this rule so the ends meet."),
   [("1 cm, 2 cm, 5 cm","1 + 2 = 3, which is less than 5, so these cannot form a triangle."),
    ("2 cm, 2 cm, 5 cm","2 + 2 = 4, which is less than 5, so the sides cannot close into a triangle."),
    ("1 cm, 1 cm, 3 cm","1 + 1 = 2, which is less than 3, so no triangle can be made.")]),

 ("TR","In an isosceles triangle the two equal sides each meet the base, and the two base angles are:",
   "equal to each other",
   C("In an isosceles triangle the angles opposite the two equal sides — the base angles — are equal.")+
   steps("The two slanting sides are equal","the angles opposite equal sides are equal","so the base angles are equal.")+
   U("A symmetric tent leans the same on both sides because its base angles are equal."),
   [("always right angles","Base angles are equal to each other but need not be 90°."),
    ("always 60° each","Only an equilateral triangle has 60° angles; isosceles base angles are simply equal."),
    ("always different","In an isosceles triangle the two base angles are equal, not different.")]),

 ("TR","In an equilateral triangle, where all the sides match, every single one of its angles measures:",
   "60°",
   C("An equilateral triangle's three equal angles share 180° equally, so each is 180 ÷ 3 = 60°.")+
   steps("All three angles are equal","they add to 180°","each is 180 ÷ 3 = 60°.")+
   U("A drawing triangle (set square) with all 60° angles is equilateral."),
   [("90°","90° angles would total 270°; equal angles summing to 180° give 60° each."),
    ("45°","45° each would total only 135°; the equal angles of an equilateral triangle are 60°."),
    ("120°","120° each would total 360°; each angle of an equilateral triangle is 60°.")]),

 ("TR","Is it possible for one single triangle to contain two separate right angles of 90° each?",
   "No, because the three angles would add up to more than 180°",
   C("Two right angles already make 180°, leaving nothing for the third angle, which is impossible.")+
   steps("Two right angles = 90 + 90 = 180°","the third angle would need to be more than 0","but the total would then exceed 180°, so it cannot happen.")+
   U("This is why no triangle can have two square corners."),
   [("Yes, if the sides are very long","Side length cannot rescue it; two right angles already use the full 180°."),
    ("Yes, in a right-angled triangle","A right triangle has only ONE right angle; two would exceed 180°."),
    ("Yes, if it is equilateral","An equilateral triangle has 60° angles, not right angles; two right angles are impossible.")]),

 ("TR","A right-angled triangle has legs 6 cm and 8 cm. The length of the hypotenuse is:",
   "10 cm",
   C("By Pythagoras, the hypotenuse squared equals the sum of the squares of the two legs.")+
   steps("6² + 8² = 36 + 64 = 100","the hypotenuse squared is 100","so the hypotenuse is √100 = 10 cm.")+
   U("This 6-8-10 set is a scaled 3-4-5 triangle used to square up building corners."),
   [("14 cm","14 just adds 6 and 8; Pythagoras gives √100 = 10 cm."),
    ("48 cm","48 multiplies the legs; the hypotenuse from squares is 10 cm."),
    ("100 cm","100 is the SQUARE of the hypotenuse; the hypotenuse itself is √100 = 10 cm.")]),

 ("TR","Two angles of a triangle measure 90° and 45°. Such a triangle is BOTH:",
   "right-angled and isosceles",
   C("It has a 90° angle (right-angled), and the third angle is also 45°, so two angles equal means two equal sides (isosceles).")+
   steps("Third angle = 180 − 90 − 45 = 45°","two angles are 45°, so two sides are equal — isosceles","and one angle is 90° — right-angled.")+
   U("A 45-45-90 set square is exactly this right-angled isosceles triangle."),
   [("equilateral and acute","Equilateral needs three 60° angles, and a 90° angle is not acute; this is right-angled isosceles."),
    ("obtuse and scalene","No angle here exceeds 90°, and two angles are equal, so it is right-angled and isosceles."),
    ("right-angled and equilateral","An equilateral triangle has no 90° angle; this one is right-angled and isosceles.")]),

 ("TR","A roof is a triangle with a base of 8 m and a height of 3 m. Its area is:",
   "12 m²",
   C("The area of a triangle is half the base times the height.")+
   steps("Area = 1/2 × base × height","= 1/2 × 8 × 3","= 12 m².")+
   U("Working out a triangular roof's area tells a builder how much sheeting to buy."),
   [("24 m²","24 m² forgets the half; area is 1/2 × 8 × 3 = 12 m²."),
    ("11 m²","11 m² wrongly adds 8 and 3; the area is 1/2 × 8 × 3 = 12 m²."),
    ("6 m²","6 m² halves only one number; the area is 1/2 × 8 × 3 = 12 m².")]),

 ("TR","In a triangle the angles are in the ratio 1 : 2 : 3. The largest angle is:",
   "90°",
   C("The parts add to 1 + 2 + 3 = 6, so each part is 180 ÷ 6 = 30°, and the largest is 3 parts.")+
   steps("Total parts = 1 + 2 + 3 = 6","one part = 180 ÷ 6 = 30°","largest = 3 × 30 = 90°.")+
   U("Ratios let you split a known total, like 180°, into shaped parts."),
   [("60°","60° is two parts (2 × 30); the largest is three parts, namely 90°."),
    ("30°","30° is just one part; the largest angle is 3 parts, namely 90°."),
    ("120°","120° would overshoot; the three angles 30°, 60° and 90° add to 180°.")]),

 ("TR","A triangular garden has sides 5 m, 7 m and 9 m. The length of fencing needed to go all around it is:",
   "21 m",
   C("The perimeter of a triangle is the sum of its three side lengths.")+
   steps("Add the sides: 5 + 7 + 9","= 21","so 21 m of fencing is needed.")+
   U("Adding up the sides tells you how much fencing or border a plot needs."),
   [("12 m","12 m adds only two sides; all three give 5 + 7 + 9 = 21 m."),
    ("315 m","315 m multiplies the sides; the perimeter is the sum, 21 m."),
    ("63 m","63 m multiplies wrongly; the perimeter is 5 + 7 + 9 = 21 m.")]),

 ("TR","A triangle has one angle of 100°. This triangle is:",
   "an obtuse triangle",
   C("A triangle with one angle greater than 90° is an obtuse triangle.")+
   steps("Look at the largest angle, 100°","100° is greater than 90°","so the triangle is obtuse.")+
   U("A wide, low triangular shape often has one obtuse angle like this."),
   [("a right triangle","A right triangle's largest angle is exactly 90°; 100° makes it obtuse."),
    ("an acute triangle","An acute triangle has all angles below 90°; a 100° angle makes it obtuse."),
    ("an equilateral triangle","An equilateral triangle has all 60° angles; a 100° angle makes it obtuse.")]),

 ("TR","The three medians of a triangle always meet at a single point called the:",
   "centroid",
   C("The centroid is where the three medians cross; it is the triangle's balance point.")+
   steps("Draw all three medians","they cross at one common point","that point is the centroid.")+
   U("A flat triangular sheet balances perfectly on a pin placed at its centroid."),
   [("hypotenuse","The hypotenuse is a side of a right triangle, not a meeting point of medians; that is the centroid."),
    ("vertex","A vertex is a corner; the medians meet at the centroid, inside the triangle."),
    ("right angle","A right angle is a 90° angle; the medians meet at the centroid.")]),

 ("TR","In an isosceles triangle each of the two equal base angles is 65°. The third angle (the vertex angle) is:",
   "50°",
   C("The angles add to 180°, so subtract the two equal base angles from 180°.")+
   steps("Two base angles: 65 + 65 = 130","subtract from 180: 180 − 130","= 50°.")+
   U("Knowing two equal angles lets you find the apex angle of a symmetric frame."),
   [("65°","65° repeats a base angle; the vertex angle is 180 − 130 = 50°."),
    ("115°","115° wrongly subtracts only one base angle; both give 180 − 130 = 50°."),
    ("130°","130° is the sum of the two base angles, not the third angle, which is 50°.")]),

 ("TR","A triangle with all three angles less than 90° is called:",
   "an acute triangle",
   C("An acute triangle has every one of its three angles smaller than a right angle of 90°.")+
   steps("Look at all three angles","each one is less than 90°","so the triangle is acute.")+
   U("An equilateral triangle, with its three 60° angles, is one example of an acute triangle."),
   [("an obtuse triangle","An obtuse triangle has one angle greater than 90°; all angles below 90° makes it acute."),
    ("a right triangle","A right triangle has one 90° angle; all three below 90° makes it acute."),
    ("a scalene triangle","Scalene describes unequal sides, not angles; all angles below 90° makes it acute.")]),
]

# ---------- assemble: interleave so no two consecutive share a chapter ----------
assert all(len(b) == 25 for b in (PC, RP, FD, TR)), [len(PC), len(RP), len(FD), len(TR)]
items = []
for i in range(25):
    items += [PC[i], RP[i], FD[i], TR[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=43023,
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
    split = "/".join(str(counts[c]) for c in ("PC", "RP", "FD", "TR"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Physical & Chemical Changes",
                     "Reproduction in Plants",
                     "Fractions & Decimals",
                     "The Triangle & its Properties"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
