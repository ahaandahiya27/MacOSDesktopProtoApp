# -*- coding: utf-8 -*-
# Boss Challenge Paper 18 — Reproduction in Plants · Forests
#                          · Symmetry · Algebraic Expressions
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans into FUSION — a flower/leaf context
# (Reproduction in Plants) wrapped around a Symmetry skill (lines of symmetry
# of petals and leaves), and a Forest context (rows of saplings, trees per
# grid) wrapped around an Algebraic-Expressions skill (forming and evaluating
# expressions). Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_18_<SHORT>_QuestionPaper.html  (pure HTML — questions + options, no answers)
#   Paper_18_<SHORT>_QuestionPaper.pdf
#   Paper_18_<SHORT>_Questions.md
#   Paper_18_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "18"
SHORT = "ReproductionPlants_Forests_Symmetry_AlgebraicExpr"
TITLE = "Reproduction in Plants · Forests · Symmetry · Algebraic Expressions"
LABELS = {
    "RP": "Reproduction in Plants",
    "FO": "Forests",
    "SY": "Symmetry",
    "AE": "Algebraic Expressions",
}

# ---------- REPRODUCTION IN PLANTS (25) — Science ----------
RP = [
 ("RP","A plant that grows a new plant from a single parent, with no joining of cells, is reproducing by the method called:",
   "asexual reproduction",
   C("When only one parent is involved and no cells fuse, the plant reproduces asexually.")+
   steps("Sexual reproduction needs male and female cells to join","Asexual reproduction needs just one parent","So a single-parent method is asexual reproduction.")+
   U("A potato sprouting many new plants from its eyes is doing exactly this — one parent, many copies."),
   [("sexual reproduction","Sexual reproduction needs two kinds of cells to fuse; here only one parent is involved."),
    ("pollination","Pollination is only the carrying of pollen, not the making of a whole new plant by itself."),
    ("germination","Germination is a seed sprouting; it is not a mode of reproduction by one parent.")]),

 ("RP","In yeast, a tiny bulge grows on the parent cell, gets bigger, and then breaks away as a new yeast. This way of reproducing is called:",
   "budding",
   C("In budding a small bud grows out of the parent, then separates as a new individual.")+
   steps("A bulge (bud) appears on the parent yeast","It grows and may form a chain of buds","Each bud breaks off as a new yeast cell.")+
   U("Bakers and brewers grow yeast in huge numbers this way to make bread rise and dough ferment."),
   [("fragmentation","Fragmentation is when a body breaks into pieces that each grow; budding grows a bud on the parent."),
    ("pollination","Pollination is a flowering-plant step; yeast has no flowers and reproduces by budding."),
    ("grafting","Grafting is a gardener joining two plants by hand, not what a single yeast cell does.")]),

 ("RP","A potato can grow a whole new plant from the small 'eyes' on its surface. Growing a new plant from a part of the plant body like this is called:",
   "vegetative propagation",
   C("When a new plant grows from a root, stem or leaf part, it is vegetative propagation.")+
   steps("The eyes of a potato are tiny buds on the stem","Each bud can sprout a new shoot and roots","A new plant grows from this body part — vegetative propagation.")+
   U("Farmers plant pieces of potato rather than seeds, because each eye reliably grows a new crop plant."),
   [("seed germination","Here no seed is used at all — the new plant grows from the potato's body, not a seed."),
    ("pollination","Pollination moves pollen between flowers; the potato eye does not need any flower."),
    ("fertilisation","Fertilisation is the joining of two cells; a sprouting potato eye needs no second cell.")]),

 ("RP","In a flower, the part that makes pollen — the male part — is the:",
   "stamen",
   C("The stamen is the male part of a flower; its tip, the anther, makes pollen.")+
   steps("A flower has male and female parts","The male part is the stamen, with an anther on top","The anther produces the pollen grains.")+
   U("Looking inside a hibiscus, the slender stalks dusted with yellow powder are the pollen-making stamens."),
   [("pistil","The pistil is the female part of the flower; it receives pollen, it does not make it."),
    ("petal","Petals are the bright leaves that attract insects; they make no pollen."),
    ("sepal","Sepals are the small green parts that protect the bud; they do not make pollen.")]),

 ("RP","The female part of a flower, which has the stigma, style and ovary, is called the:",
   "pistil",
   C("The pistil (carpel) is the female part: stigma on top, style in the middle, ovary at the base.")+
   steps("The male part is the stamen","The female part is the pistil","Stigma, style and ovary together make up the pistil.")+
   U("Inside the ovary at the base of the pistil, ovules wait to become the seeds of a future fruit."),
   [("stamen","The stamen is the male part that makes pollen, not the female part with the ovary."),
    ("anther","The anther is only the pollen-making tip of the stamen — a male part, not the pistil."),
    ("filament","The filament is the stalk that holds up the anther — part of the male stamen.")]),

 ("RP","The transfer of pollen from the anther of a flower to the stigma of a flower is called:",
   "pollination",
   C("Pollination is the movement of pollen from an anther onto a stigma.")+
   steps("Pollen forms in the anther (male part)","It must reach the stigma (female part) to make seeds","Carrying pollen from anther to stigma is pollination.")+
   U("A bee brushing pollen onto the next flower it visits is doing the plant's pollination for it."),
   [("fertilisation","Fertilisation comes after pollination — it is the joining of the cells, not the carrying of pollen."),
    ("germination","Germination is a seed sprouting into a seedling, not the carrying of pollen."),
    ("dispersal","Dispersal is the scattering of seeds away from the parent, a much later step.")]),

 ("RP","When the pollen of a flower lands on the stigma of a different flower of the same kind, it is called:",
   "cross-pollination",
   C("Pollen reaching a different flower of the same kind is cross-pollination.")+
   steps("Self-pollination = pollen lands on the same flower (or same plant)","Cross-pollination = pollen lands on a different flower","Different flower, same kind → cross-pollination.")+
   U("Insects carrying pollen between two mango trees give cross-pollination, mixing the parents' features."),
   [("self-pollination","Self-pollination is when pollen reaches the same flower; here it reaches a different one."),
    ("fertilisation","Fertilisation is the fusion of cells inside the ovule, not the kind of pollination."),
    ("vegetative propagation","Vegetative propagation uses no flowers or pollen at all.")]),

 ("RP","The joining (fusion) of the male cell from pollen with the female egg cell to form a single cell is called:",
   "fertilisation",
   C("Fertilisation is the fusion of the male and female cells to make one new cell, the zygote.")+
   steps("Pollination brings pollen to the stigma","A tube carries the male cell down to the egg","The two cells fuse — that fusion is fertilisation.")+
   U("Every seed in an apple began as a separate egg cell that was fertilised inside the flower."),
   [("pollination","Pollination only delivers pollen to the stigma; fertilisation is the fusing that follows."),
    ("germination","Germination is the sprouting of a finished seed, long after fertilisation."),
    ("budding","Budding is an asexual method with no joining of male and female cells.")]),

 ("RP","After fertilisation, the single cell that is formed and which later grows into the embryo of a seed is the:",
   "zygote",
   C("The cell formed right after the male and female cells fuse is called the zygote.")+
   steps("Male cell + egg cell fuse during fertilisation","The fused single cell is the zygote","The zygote divides and grows into the embryo inside the seed.")+
   U("Inside a bean seed, the little curled baby plant grew from one zygote made at fertilisation."),
   [("pollen","Pollen is the male part before fusion; the zygote forms only after pollen's cell joins the egg."),
    ("ovary","The ovary is the part of the flower that holds the ovules; it is not the fused single cell."),
    ("stigma","The stigma is the landing pad for pollen, not the cell formed by fertilisation.")]),

 ("RP","After fertilisation, the ovary of the flower grows and ripens into the:",
   "fruit",
   C("The ovary, which holds the ovules, grows into the fruit after fertilisation.")+
   steps("Ovules sit inside the ovary","Ovules become seeds after fertilisation","The ovary around them grows into the fruit.")+
   U("The juicy mango is a swollen ovary, and the big stone inside it is the seed it protects."),
   [("seed","The seed forms from the ovule inside; the ovary itself becomes the fruit around the seed."),
    ("flower","The flower withers after fertilisation; it is the ovary, not the whole flower, that becomes the fruit."),
    ("root","The root anchors the plant and takes up water; it has no part in forming the fruit.")]),

 ("RP","A seed grows from which part of the flower after fertilisation?",
   "the ovule",
   C("Each ovule inside the ovary becomes a seed after fertilisation.")+
   steps("The ovary holds one or more ovules","After fertilisation each ovule ripens","A ripened ovule is a seed.")+
   U("The many tiny seeds inside a tomato each grew from a separate ovule in the flower's ovary."),
   [("the petal","Petals attract insects and then fall off; they do not turn into seeds."),
    ("the anther","The anther made the pollen; it is a male part and does not become a seed."),
    ("the sepal","Sepals protect the bud and play no part in making the seed.")]),

 ("RP","Light seeds with hair or wings, such as those of the drumstick or the cotton plant, are usually carried away by:",
   "wind",
   C("Light, winged or hairy seeds are blown far from the parent by the wind.")+
   steps("Seeds must move away to avoid crowding the parent","Hairs and wings make a seed light and easily lifted","Such seeds are carried by the wind.")+
   U("On a breezy day you can watch fluffy seeds drift across a field, planting themselves far away."),
   [("water","Water carries seeds like the coconut that float; light hairy seeds ride the air, not a stream."),
    ("explosion","Some pods burst open, but hairy and winged seeds are spread mainly by being blown in the wind."),
    ("heat","Heat alone cannot move a seed; it is the moving air that carries light seeds away.")]),

 ("RP","The thick, fibrous husk of a coconut traps air and lets the seed float, so the coconut is spread mainly by:",
   "water",
   C("The coconut's airy husk lets it float, so rivers and the sea carry it to new shores.")+
   steps("A coconut is heavy but its husk holds trapped air","Trapped air lets the whole fruit float","Water then carries the floating coconut to a new place.")+
   U("Coconut palms grow along beaches because the sea floats their fruit from island to island."),
   [("wind","A coconut is far too heavy for wind to lift; it floats and rides on water instead."),
    ("insects","Insects are tiny and cannot move a heavy coconut; its airy husk lets water carry it."),
    ("birds","Birds cannot carry a whole coconut; the husk makes it float so water moves it.")]),

 ("RP","Seeds of plants such as Xanthium and Urena have tiny hooks or spines so that they can be spread by:",
   "clinging to the fur of animals",
   C("Hooked or spiny seeds catch on animal fur (or our clothes) and are carried away.")+
   steps("Some seeds have hooks, spines or sticky surfaces","These catch on the coats of passing animals","The animal carries them and drops them far off.")+
   U("Burrs that stick to your socks on a walk are seeds using your clothes for a free ride."),
   [("floating on water","These seeds are not built to float; their hooks are for grabbing onto fur, not for floating."),
    ("being blown by wind","Hooked seeds are too rough and heavy to be carried by wind; they grab fur instead."),
    ("bursting from a pod","A bursting pod throws seeds a short way; hooks are made to hitch a ride on animals.")]),

 ("RP","Why is it useful for a plant to have its seeds scattered far away rather than dropping them all at its own base?",
   "the new plants avoid crowding and competing with the parent for light and water",
   C("Spreading seeds out stops the young plants from fighting the parent for sunlight, water and space.")+
   steps("If all seeds fell at the parent's base they would be crowded","Crowded seedlings compete for the same light, water and nutrients","Spreading them out lets each find its own space to grow.")+
   U("A forest stays healthy because its seeds travel and fill clearings instead of piling up under one tree."),
   [("the seeds become heavier as they travel","Travelling does not change a seed's weight; dispersal is about finding space, not gaining weight."),
    ("the parent plant can then move to a new place","Plants cannot walk; it is the seeds that move, not the rooted parent."),
    ("it makes the flowers more colourful","Flower colour is set long before; dispersal happens after seeds form and does not change petals.")]),

 ("RP","Mosses and ferns do not make seeds. Instead they reproduce using tiny structures called:",
   "spores",
   C("Ferns and mosses make spores — tiny units that grow into new plants without seeds.")+
   steps("Some plants reproduce without flowers or seeds","They make dust-like spores instead","A spore that lands in a moist spot grows into a new plant.")+
   U("The brown dots on the back of a fern leaf are cases full of spores ready to drift away."),
   [("seeds","Ferns and mosses make no seeds at all; that is exactly why they use spores instead."),
    ("buds","Buds grow on the parent body; spores are tiny units released to grow on their own."),
    ("tubers","Tubers are swollen underground stems like the potato, not the dust-like units ferns use.")]),

 ("RP","A flower that has both the stamen (male part) and the pistil (female part), like the mustard flower, is called a:",
   "bisexual flower",
   C("A flower carrying both stamen and pistil is a bisexual (or perfect) flower.")+
   steps("Some flowers have only one kind of part","Mustard and China-rose flowers carry both stamen and pistil","Having both parts makes a flower bisexual.")+
   U("Most garden flowers you pick, like the China rose, are bisexual — male and female parts in one bloom."),
   [("unisexual flower","A unisexual flower has only the male OR only the female part, not both like the mustard flower."),
    ("artificial flower","An artificial flower is a man-made fake; this is a real flower with both natural parts."),
    ("compound flower","'Compound' is not the term for a flower's parts; having both parts makes it bisexual.")]),

 ("RP","The stigma at the top of the pistil is usually sticky. The most useful reason for this stickiness is that it:",
   "helps pollen grains stick to it during pollination",
   C("A sticky stigma catches and holds pollen grains so fertilisation can follow.")+
   steps("Pollen must land and stay on the stigma","A dry, smooth stigma would let pollen blow away","A sticky surface grips the pollen so it stays.")+
   U("The gummy tip of a lily's stigma is dusted with pollen that has stuck fast, ready to make seeds."),
   [("traps insects to eat them","Most flowers do not eat insects; the sticky stigma is for holding pollen, not catching food."),
    ("makes the flower smell sweet","Scent comes from other parts; the stigma's stickiness is about gripping pollen."),
    ("stores water for the plant","The stigma does not store water; its sticky surface is there to hold pollen grains.")]),

 ("RP","Bryophyllum can grow tiny new plantlets along the notches at the edge of its leaf. This is an example of reproduction from a:",
   "leaf",
   C("Bryophyllum's buds grow at the leaf margins, so it reproduces vegetatively from a leaf.")+
   steps("Vegetative propagation can use a root, stem or leaf","Bryophyllum grows buds in the notches of its leaf edge","Each bud drops off and grows — reproduction from a leaf.")+
   U("A single Bryophyllum leaf left on damp soil can sprout a whole row of new little plants."),
   [("flower","No flower is used here; the new plants grow straight from buds on the leaf's edge."),
    ("seed","No seed is involved — the plantlets bud directly from the leaf, a vegetative method."),
    ("root","The buds appear on the leaf margins, not on the root, in Bryophyllum.")]),

 ("RP","Rose and sugarcane plants are often grown by cutting a piece of the stem and planting it. This method is called growing from a:",
   "stem cutting",
   C("A piece of stem planted to grow a new plant is a stem cutting — a vegetative method.")+
   steps("A healthy stem piece is cut from the parent","It is pushed into moist soil","It grows roots and shoots into a new plant.")+
   U("Gardeners multiply rose bushes cheaply by snipping stems and rooting them, no seeds needed."),
   [("seed","No seed is used; a piece of the stem itself grows into the new plant."),
    ("spore","Spores are made by ferns and mosses; rose and sugarcane grow from stem cuttings."),
    ("bud of a flower","It is a piece of the stem, not a flower bud, that is planted to grow the new plant.")]),

 ("RP","In which case is the offspring exactly like the single parent, with no mixing of features from two parents?",
   "asexual reproduction",
   C("Asexual reproduction uses one parent, so the offspring is an exact copy of it.")+
   steps("Asexual reproduction has only one parent","No features are mixed in from a second parent","So the offspring is identical to the parent.")+
   U("Every plant grown from cuttings of one mango tree gives the same sweet mangoes as the parent tree."),
   [("sexual reproduction","Sexual reproduction mixes features from two parents, so offspring are not exact copies."),
    ("cross-pollination","Cross-pollination brings in a second parent's pollen, so features get mixed."),
    ("fertilisation by two flowers","Joining cells from two flowers mixes their features; the copy is not exact.")]),

 ("RP","Which of these is the correct order of events that leads to a seed?",
   "pollination → fertilisation → seed formation",
   C("Pollen is carried (pollination), the cells fuse (fertilisation), and then the seed forms.")+
   steps("First pollen reaches the stigma — pollination","Then the male and female cells fuse — fertilisation","Then the ovule ripens into a seed.")+
   U("Knowing this order helps a farmer understand why a flower must be pollinated before any fruit can set."),
   [("fertilisation → pollination → seed formation","Fertilisation cannot happen before pollen arrives; pollination must come first."),
    ("seed formation → pollination → fertilisation","A seed cannot form before pollination and fertilisation — it is the last step, not the first."),
    ("pollination → seed formation → fertilisation","The cells must fuse (fertilisation) before any seed can form, so this order is wrong.")]),

 ("RP","Some water plants like Spirogyra simply break into two or more pieces, and each piece grows into a new plant. This is called:",
   "fragmentation",
   C("When a plant body breaks into pieces that each grow into new plants, it is fragmentation.")+
   steps("The thread-like body of Spirogyra breaks into bits","Each broken piece keeps growing","Each grows into a complete new plant — fragmentation.")+
   U("A pond can turn green quickly as Spirogyra threads break and multiply into many new strands."),
   [("budding","In budding a bud grows on the parent; in fragmentation the body breaks into separate pieces."),
    ("pollination","Pollination involves flowers and pollen; Spirogyra has neither and simply fragments."),
    ("grafting","Grafting is a gardener joining plants by hand, not a body breaking into growing pieces.")]),

 ("RP","Why are the petals of many flowers brightly coloured and scented?",
   "to attract insects and birds that carry pollen",
   C("Bright, scented petals draw in insects and birds, which then carry pollen between flowers.")+
   steps("Many flowers need an animal to move their pollen","Bright colour and scent attract bees, butterflies and birds","These visitors carry pollen and help pollination.")+
   U("A butterfly drawn to a colourful flower for nectar leaves carrying pollen to the next bloom."),
   [("to protect the flower from rain","Petals are too delicate to act as an umbrella; their colour is for attracting pollinators."),
    ("to make food for the plant by photosynthesis","Green leaves make the food; bright petals are for attracting pollen-carriers."),
    ("to store seeds until they ripen","Seeds form and ripen inside the ovary, not in the petals.")]),

 ("RP","Inside a ripe bean seed, the tiny part that will grow into the roots, stem and leaves of the new plant is the:",
   "embryo",
   C("The embryo is the young plant inside the seed that grows into roots, stem and leaves.")+
   steps("A seed protects a tiny new plant","That tiny plant is the embryo","On germination the embryo grows into the full plant.")+
   U("When you split a soaked gram seed, the little hooked part you see is the embryo ready to sprout."),
   [("the seed coat","The seed coat is the outer cover that protects the seed; it is not the baby plant inside."),
    ("the stigma","The stigma is part of the flower, not part of the seed; it cannot grow into a new plant."),
    ("the pollen","Pollen is the male part before fertilisation; the embryo forms only after the cells join.")]),
]

# ---------- FORESTS (25) — Science ----------
FO = [
 ("FO","The branchy top of the tallest forest trees spread out so that they touch and form a green roof over the forest. This roof is called the:",
   "canopy",
   C("The upper layer made by the spreading tops of the tallest trees is the canopy.")+
   steps("Tall trees have wide, leafy tops","Their tops meet and overlap high above the ground","This continuous leafy roof is the canopy.")+
   U("Standing in a dense forest you notice little sunlight reaches the floor because the canopy blocks it."),
   [("understorey","The understorey is the layer of shorter trees BELOW the canopy, not the topmost roof."),
    ("humus","Humus is the dark, rotted leaf matter on the forest floor, not a layer of treetops."),
    ("crown","A crown is the leafy top of one single tree; the canopy is the roof made by many crowns together.")]),

 ("FO","The branchy, leafy top part of a single tree is called its:",
   "crown",
   C("The crown is the spreading leafy top of one tree.")+
   steps("A tree has a trunk and branches","The branches and leaves at the top form the crown","Many crowns together make the forest canopy.")+
   U("A banyan's enormous spreading crown can shade a whole village square on a hot afternoon."),
   [("canopy","The canopy is the roof made by MANY tree-tops together; a crown is just one tree's top."),
    ("root","The root is the underground part that anchors the tree, the opposite end from the crown."),
    ("herb","A herb is a small soft plant near the ground, not the leafy top of a tall tree.")]),

 ("FO","In a forest, the dark-coloured material formed when dead leaves and animal remains rot and mix into the soil is called:",
   "humus",
   C("Humus is the dark, rich matter formed when dead leaves and remains decompose into the soil.")+
   steps("Dead leaves and remains fall to the forest floor","Tiny organisms rot and break them down","The dark rotted matter that mixes into the soil is humus.")+
   U("A gardener adds leaf-humus to pots because it makes the soil dark, soft and full of nutrients."),
   [("canopy","The canopy is the leafy roof high above; humus is the rotted matter down in the soil."),
    ("sapling","A sapling is a young tree; humus is the rotted dead matter that feeds such young plants."),
    ("crown","A crown is the top of a tree; humus is the dark rotted material in the soil below.")]),

 ("FO","The small living things in the soil that break down dead leaves and dead animals into simple substances are called:",
   "decomposers",
   C("Microorganisms that rot dead matter into simple substances are called decomposers.")+
   steps("Dead plants and animals pile up on the forest floor","Fungi and bacteria feed on them and break them down","These rotting helpers are the decomposers.")+
   U("Because decomposers keep working, a forest floor never buries itself under years of dead leaves."),
   [("producers","Producers are green plants that MAKE food; decomposers break DOWN dead matter."),
    ("herbivores","Herbivores are animals that eat living plants, not the microbes that rot dead matter."),
    ("predators","Predators hunt and eat other animals; they do not break down dead matter into soil.")]),

 ("FO","Forests are often called the 'green lungs' of the Earth because they:",
   "release oxygen and take in carbon dioxide",
   C("Forest plants give out oxygen and soak up carbon dioxide, keeping the air's balance like lungs.")+
   steps("Plants take in carbon dioxide and release oxygen by day","Animals breathe in that oxygen","So forests keep the oxygen–carbon-dioxide balance — like lungs.")+
   U("Clearing large forests worries scientists because it weakens the planet's natural air-cleaning system."),
   [("release carbon dioxide and take in oxygen","That is the opposite — by day forests RELEASE oxygen and TAKE IN carbon dioxide."),
    ("store water and release it as ice","Forests do hold water, but the 'green lungs' name is about the oxygen they release."),
    ("make the soil dry and hard","Forests keep soil moist and soft; the 'lungs' idea is about cleaning the air.")]),

 ("FO","Why does the soil under a thick forest hardly get washed away even during heavy rain?",
   "the roots of the trees hold the soil firmly in place",
   C("A dense network of roots grips the soil so the rain cannot wash it away.")+
   steps("Rain water flowing over bare soil carries it away (erosion)","Forest roots spread through the soil and bind it","Bound soil stays put even in heavy rain.")+
   U("On a bare hillside the rain cuts deep gullies, while a wooded slope beside it stays whole."),
   [("the canopy turns the rain into steam","The canopy slows the rain's fall, but it is the ROOTS gripping the soil that stop erosion."),
    ("the soil in forests is made of stone","Forest soil is rich and soft, not stone; roots are what hold it together."),
    ("rain never falls inside forests","Rain certainly falls in forests; the roots simply stop that rain from washing the soil off.")]),

 ("FO","A simple food chain in a forest could be: grass → deer → tiger. In this chain, the grass is the:",
   "producer",
   C("Green plants like grass make their own food, so they are the producers of the chain.")+
   steps("A food chain starts with something that makes food","Grass makes its own food by photosynthesis","So grass is the producer at the start of the chain.")+
   U("Every forest food chain begins with a green producer, because all the animals' food traces back to plants."),
   [("consumer","Consumers eat other living things; grass MAKES its own food, so it is a producer, not a consumer."),
    ("decomposer","Decomposers rot dead matter; living grass that makes food is a producer."),
    ("predator","A predator hunts other animals; grass is a plant and the producer of the chain.")]),

 ("FO","In the food chain grass → deer → tiger, the deer is best described as a:",
   "herbivore that is eaten by the tiger",
   C("The deer eats only plants (a herbivore) and is itself hunted by the tiger.")+
   steps("The deer eats grass — so it is a plant-eater (herbivore)","The tiger eats the deer","So the deer is a herbivore that the tiger eats.")+
   U("This is why protecting deer also matters for tigers — remove the deer and the tiger has nothing to eat."),
   [("producer that makes its own food","Only the grass makes its own food; the deer must eat plants, so it is a consumer."),
    ("decomposer that rots dead leaves","The deer eats living grass; decomposers are the microbes that rot dead matter."),
    ("plant that the grass feeds on","The deer is an animal that eats the grass, not a plant fed by it.")]),

 ("FO","Many separate food chains in a forest cross and link with one another. This whole network of connected food chains is called a:",
   "food web",
   C("Several food chains linked together form a food web.")+
   steps("One animal often eats many kinds of food","So many food chains share the same plants and animals","All these linked chains together make a food web.")+
   U("A food web shows that if one animal vanishes, several others in the forest are affected at once."),
   [("food chain","A single food chain is just one straight line; many crossing chains together make a web."),
    ("canopy","The canopy is the forest's leafy roof, not a network of who-eats-whom."),
    ("humus","Humus is rotted matter in the soil, not a network of feeding links.")]),

 ("FO","Forests help bring rain to a region mainly because the trees:",
   "give out water vapour from their leaves, which helps clouds form",
   C("Trees release water vapour from their leaves (transpiration), and this vapour helps form rain clouds.")+
   steps("Trees draw up water and release vapour from their leaves","This vapour rises and cools in the air","Cooled vapour forms clouds that bring rain.")+
   U("Areas that lose their forests often see less rain, because the vapour that fed the clouds is gone."),
   [("burn and send smoke into the sky","Burning forests does not bring rain; it is the water vapour from healthy leaves that helps clouds form."),
    ("block the wind completely","Trees slow the wind a little, but rain comes from the water vapour they release, not from blocking wind."),
    ("store rain inside their trunks","Trunks hold only a little water; the rain-making role comes from vapour given off by the leaves.")]),

 ("FO","Why does the forest floor not get buried under huge piles of dead leaves year after year?",
   "decomposers keep rotting the dead leaves into humus",
   C("Decomposers break the fallen leaves down into humus, so they never pile up forever.")+
   steps("Leaves fall to the forest floor all year","Fungi and bacteria rot them down","They turn into humus and mix into the soil, so no big pile builds up.")+
   U("This recycling is why a forest renews its own soil without anyone ever clearing the dead leaves."),
   [("animals eat all the fallen leaves","Animals eat only some leaves; it is the decomposers that rot the rest into humus."),
    ("the wind blows every dead leaf away","Wind moves a few leaves, but the decomposers are what actually break the leaves down."),
    ("dead leaves dissolve in rain water","Leaves do not simply dissolve in rain; decomposers are needed to break them down.")]),

 ("FO","A young tree, still growing toward its full size, is called a:",
   "sapling",
   C("A sapling is a young tree that is still growing.")+
   steps("A seed germinates into a seedling","The seedling grows into a young tree","That young tree is called a sapling.")+
   U("When clearings open in the forest, sunlight lets new saplings shoot up and replace fallen trees."),
   [("herb","A herb is a small soft plant that stays low; a sapling is a young tree that will grow tall."),
    ("humus","Humus is rotted dead matter in the soil, not a young living tree."),
    ("canopy","The canopy is the high leafy roof of grown trees, not a single young tree.")]),

 ("FO","Forests are described as a renewable resource. This means that:",
   "if used wisely, forests can grow back and renew themselves",
   C("A renewable resource can be replaced over time; a well-managed forest grows back.")+
   steps("Forests reseed themselves and grow new trees","If we do not take more than can grow back, they renew","So forests are a renewable resource if used wisely.")+
   U("Foresters replant after careful cutting, so the woodland keeps providing timber for the future."),
   [("forests can never be used up no matter what","They renew only if used wisely; cutting far too fast can still destroy a forest."),
    ("once cut, a forest can never come back","Forests CAN regrow — that is exactly why they are called renewable."),
    ("forests are made by factories when needed","Forests grow naturally from seeds and saplings; no factory can manufacture one.")]),

 ("FO","The layer of short, shade-loving trees and shrubs that grows below the tall canopy trees is called the:",
   "understorey",
   C("The understorey is the layer of shorter trees and shrubs beneath the canopy.")+
   steps("Tall trees form the canopy on top","Below them, shorter trees and shrubs grow in the shade","This shaded middle layer is the understorey.")+
   U("Shade-loving birds and animals make their home in the cool, dim understorey beneath the treetops."),
   [("canopy","The canopy is the topmost roof of the tallest trees; the understorey is the layer below it."),
    ("humus","Humus is rotted matter in the soil, not a layer of living shrubs and short trees."),
    ("crown","A crown is the leafy top of one tree, not the shaded layer of shrubs below the canopy.")]),

 ("FO","Cutting down large areas of forest, called deforestation, can lead to:",
   "more soil erosion and floods",
   C("Without tree roots to hold the soil and soak up water, erosion and floods increase.")+
   steps("Tree roots normally bind the soil and slow rain water","Remove the trees and the soil washes away easily","Water rushes off the bare land, causing erosion and floods.")+
   U("Hillsides stripped of forest often suffer landslides and floods that the trees once held back."),
   [("cleaner air and more oxygen","Removing forests gives LESS oxygen and dirtier air, not more; it also worsens erosion."),
    ("more rainfall every year","Deforestation usually REDUCES rainfall, because the trees that released vapour are gone."),
    ("richer, deeper soil","Bare soil is washed away and grows poorer, not richer, when the forest is removed.")]),

 ("FO","In a forest, the nutrients of a dead tree are not lost forever because:",
   "decomposers return them to the soil for new plants to use",
   C("Decomposers break dead matter into nutrients that go back into the soil and feed new plants.")+
   steps("A dead tree is full of stored nutrients","Decomposers break the dead wood down","The freed nutrients enter the soil and are taken up by living plants.")+
   U("This recycling means a forest can keep growing for centuries without anyone adding fertiliser."),
   [("the nutrients evaporate into the air and are gone","Nutrients are not lost to the air; decomposers return them to the soil for reuse."),
    ("the dead tree turns straight into a new tree","A dead tree does not become a tree; its nutrients are recycled through the soil first."),
    ("animals carry all the nutrients out of the forest","The nutrients stay in the forest, recycled into the soil by decomposers.")]),

 ("FO","Which group of living things in a forest can make its own food and so supports all the animals?",
   "the green plants",
   C("Only green plants make their own food, and every animal's food traces back to them.")+
   steps("Animals cannot make their own food","Green plants make food using sunlight","So plants feed the herbivores, which in turn feed the carnivores.")+
   U("Protecting a forest's plants matters most, because losing them would starve every animal that lives there."),
   [("the carnivores","Carnivores eat other animals; they cannot make their own food, so they depend on plants."),
    ("the decomposers","Decomposers break down dead matter; they do not make fresh food for the forest."),
    ("the herbivores","Herbivores eat plants but cannot make food themselves; the green plants are the food-makers.")]),

 ("FO","Forests help refill the underground water (groundwater) because:",
   "water sinks slowly into the soil instead of running off quickly",
   C("Tree roots and humus slow the rain so it soaks into the ground and recharges groundwater.")+
   steps("Rain falling on a forest is slowed by leaves, roots and humus","The slowed water sinks into the soft soil","It seeps down and refills the underground water store.")+
   U("Wells and springs near forests often stay full, because the forest keeps recharging the groundwater."),
   [("trees pump water up from the rocks","Trees draw water UP and use it; it is the rain soaking down that refills the groundwater."),
    ("the canopy turns rain into groundwater directly","The canopy only slows the rain; the water must still soak into the soil to become groundwater."),
    ("forests stop all rain from reaching the ground","Rain does reach the forest floor and soaks in — that is how groundwater is recharged.")]),

 ("FO","Which of the following is a benefit a forest provides to people and wildlife?",
   "wood, medicines, clean air and homes for many animals",
   C("Forests give wood, medicines, clean air, and a home (habitat) for countless creatures.")+
   steps("Forests supply useful materials like wood and medicines","They clean the air and help bring rain","They are also the home of a huge variety of animals.")+
   U("Many everyday medicines first came from plants that grow only in forests."),
   [("only firewood and nothing else","Forests give far more than firewood — wood, medicines, clean air, and homes for wildlife too."),
    ("dust storms and dry weather","Forests REDUCE dust and dryness; they cool and moisten the air rather than causing storms."),
    ("noise and pollution","Forests soak up noise and clean the air; they do not create pollution.")]),

 ("FO","Insects and birds visiting forest flowers help the forest grow by:",
   "carrying pollen from flower to flower",
   C("As they move between flowers, insects and birds carry pollen and help the plants make seeds.")+
   steps("Forest flowers need pollen carried to make seeds","Insects and birds visit flowers for nectar","They pick up and drop pollen, pollinating the plants.")+
   U("Fewer bees in an area can mean fewer fruits and seeds, because pollination drops."),
   [("eating all the forest's seeds","Eating seeds would reduce new plants; carrying pollen HELPS the forest make seeds."),
    ("cutting down old trees","Insects and birds do not cut trees; they help by carrying pollen between flowers."),
    ("drying up the forest soil","Pollinators do not dry the soil; they help plants reproduce by moving pollen.")]),

 ("FO","Animals that eat fruits and then drop the seeds far away help the forest by:",
   "spreading the seeds to new places where they can grow",
   C("By carrying and dropping seeds away from the parent tree, animals help spread the forest.")+
   steps("Animals eat fruit and move around the forest","The hard seeds pass through or are dropped elsewhere","New plants grow far from the parent — spreading the forest.")+
   U("Many big forest trees rely on animals like monkeys and birds to plant their seeds for them."),
   [("keeping all the seeds in one place","Spreading seeds out is the help; keeping them in one place would crowd the seedlings."),
    ("stopping new trees from growing","Dropping seeds in new places HELPS new trees grow, not stops them."),
    ("eating the roots of grown trees","These animals eat fruit and spread seeds; they are not eating the roots of trees.")]),

 ("FO","Which statement about the layers of a forest is correct?",
   "the canopy is at the top, with the understorey and forest-floor herbs below it",
   C("From top to bottom: the canopy, then the understorey, then the herbs of the forest floor.")+
   steps("The tallest trees form the canopy on top","Shorter trees and shrubs make the understorey below","Small soft herbs grow lowest, on the forest floor.")+
   U("This layering lets many kinds of plants and animals share one forest, each at its own height."),
   [("the herbs grow above the canopy","Herbs are the lowest, ground-level plants; the canopy of tall trees is the highest layer."),
    ("the understorey is the highest layer","The understorey is BELOW the canopy, not the highest layer of the forest."),
    ("all the layers are exactly the same height","The layers differ in height — that is the whole point of canopy, understorey and floor.")]),

 ("FO","Forests are important for keeping the air's gases balanced because they:",
   "use up carbon dioxide and add oxygen during the day",
   C("By day, forest plants take in carbon dioxide and release oxygen, balancing the air.")+
   steps("Animals and burning add carbon dioxide to the air","Forest plants take in this carbon dioxide by day","They release oxygen, keeping the balance of gases.")+
   U("Large forests act like the planet's air-conditioner, steadily trading carbon dioxide for oxygen."),
   [("use up oxygen and add carbon dioxide all day","That is the reverse — by day forests take in carbon dioxide and give out oxygen."),
    ("remove all gases from the air","Forests balance the gases; they do not strip the air of everything."),
    ("turn carbon dioxide into stone","Plants use carbon dioxide to make food, not to make stone.")]),

 ("FO","The best way to protect a forest while still using its wood is to:",
   "cut trees carefully and plant new ones to replace them",
   C("Careful cutting plus replanting lets a forest keep providing wood while it renews itself.")+
   steps("A forest renews itself if not over-cut","Replanting replaces the trees that are taken","Careful use plus replanting keeps the forest healthy.")+
   U("Well-managed woodlands can supply timber year after year without ever disappearing."),
   [("cut down the whole forest at once","Clearing it all at once destroys the forest; careful cutting and replanting keeps it alive."),
    ("never use any wood from forests at all","Wood can be used wisely; the key is careful cutting and replanting, not avoiding it entirely."),
    ("burn the old trees to make room","Burning the forest destroys it; replanting after careful cutting is the protective way.")]),

 ("FO","A forest gives many kinds of animals a place to live, find food and raise their young. Such a natural home is called the animal's:",
   "habitat",
   C("The natural place where an animal lives and finds its food and shelter is its habitat.")+
   steps("Animals need a place to live, eat and breed","A forest provides all of this for many creatures","That natural home is called a habitat.")+
   U("Clearing a forest destroys the habitat of its animals, leaving them with nowhere to live."),
   [("canopy","The canopy is only the leafy roof of the forest, not the whole natural home of an animal."),
    ("humus","Humus is the rotted matter in the soil; an animal's natural home is called its habitat."),
    ("food chain","A food chain shows who eats whom; the place where an animal lives is its habitat.")]),
]

# ---------- SYMMETRY (25) — Maths ----------
SY = [
 ("SY","A line that divides a figure into two halves that are exact mirror images of each other is called a:",
   "line of symmetry",
   C("A line of symmetry splits a figure into two matching mirror halves.")+
   steps("Fold a figure along a line","If the two halves match exactly, that fold line is special","It is called a line of symmetry.")+
   U("Folding a paper heart down the middle and seeing the halves match shows its line of symmetry."),
   [("number line","A number line is for plotting numbers, not for splitting a figure into mirror halves."),
    ("line of best fit","A line of best fit is used in graphs of data, not for symmetry of a shape."),
    ("diagonal of a square","A diagonal is just one line of a square; not every diagonal is a line of symmetry, and the general name is 'line of symmetry'.")]),

 ("SY","A square can be folded into two matching halves in several ways; in total, how many lines of symmetry does it have?",
   "4",
   C("A square has 4 lines of symmetry: 2 through the middles of opposite sides and 2 along the diagonals.")+
   steps("Two lines join the midpoints of opposite sides","Two lines run along the diagonals","2 + 2 = 4 lines of symmetry.")+
   U("Folding a square napkin in all four of these ways makes its edges line up perfectly each time."),
   [("2","A square has more than a rectangle's 2 lines — its diagonals are lines of symmetry too, giving 4."),
    ("1","One line is far too few; a square's high symmetry gives it 4 lines."),
    ("0","A square is highly symmetric; it has 4 lines of symmetry, not none.")]),

 ("SY","A rectangle that is not a square has how many lines of symmetry?",
   "2",
   C("A non-square rectangle has 2 lines of symmetry, through the midpoints of the opposite sides.")+
   steps("One line joins the midpoints of the long sides","One line joins the midpoints of the short sides","Its diagonals do NOT give mirror halves, so there are only 2.")+
   U("Folding a sheet of A4 paper edge-to-edge works twice, but folding corner-to-corner does not match up."),
   [("4","Only a square has 4; a non-square rectangle's diagonals are not lines of symmetry, so it has just 2."),
    ("1","A rectangle has two such folds, not one — one across and one along it."),
    ("0","A rectangle does have symmetry — 2 lines, through the midpoints of opposite sides.")]),

 ("SY","How many lines of symmetry does an equilateral triangle (all three sides equal) have?",
   "3",
   C("An equilateral triangle has 3 lines of symmetry, one from each corner to the middle of the opposite side.")+
   steps("Each corner has a matching line to the opposite side's midpoint","There are three corners","So there are 3 lines of symmetry.")+
   U("A perfectly even triangular road sign can be folded three different ways with its halves matching."),
   [("1","One line fits an isosceles triangle; an EQUILATERAL triangle has all sides equal, giving 3."),
    ("2","An equilateral triangle has 3 lines, one per corner — not 2."),
    ("0","An equilateral triangle is very symmetric; it has 3 lines of symmetry, not none.")]),

 ("SY","How many lines of symmetry does an isosceles triangle (only two sides equal) have?",
   "1",
   C("An isosceles triangle has just 1 line of symmetry, down from the top corner between the equal sides.")+
   steps("Only two sides are equal","One fold line runs from the apex to the middle of the base","So there is exactly 1 line of symmetry.")+
   U("A slice of pizza shaped like an isosceles triangle folds neatly in half just one way."),
   [("3","Three lines belong to an EQUILATERAL triangle; with only two equal sides there is just 1."),
    ("2","An isosceles triangle has only one fold that matches, not two."),
    ("0","It does have one line of symmetry, down the middle between the two equal sides.")]),

 ("SY","A scalene triangle, with all three sides of different lengths, has how many lines of symmetry?",
   "0",
   C("A scalene triangle has no line of symmetry, because no fold makes the halves match.")+
   steps("All three sides are different lengths","No fold line gives two matching halves","So it has 0 lines of symmetry.")+
   U("An oddly shaped triangular off-cut of wood cannot be folded into matching halves any way you try."),
   [("1","With all sides different, no fold matches; even one line of symmetry is impossible — it has 0."),
    ("3","Three lines need all sides equal; a scalene triangle has none equal, so 0 lines."),
    ("2","A scalene triangle has no matching fold at all, so the count is 0, not 2.")]),

 ("SY","Through its centre, a round disc can be folded into matching halves in how many different ways — that is, its number of lines of symmetry is:",
   "an unlimited (infinite) number",
   C("A circle has infinitely many lines of symmetry — every line through its centre is one.")+
   steps("Any straight line through the centre splits the circle into matching halves","There are countless such lines","So a circle has an unlimited number of lines of symmetry.")+
   U("No matter which way you fold a perfectly round paper disc through its centre, the halves always match."),
   [("only 2","A circle has far more than 2 — every line through its centre is a line of symmetry."),
    ("only 4","Even 4 is far too few; a circle has infinitely many lines of symmetry."),
    ("0","A circle is the most symmetric shape of all; it has unlimited lines, not none.")]),

 ("SY","How many lines of symmetry does a regular pentagon (5 equal sides) have?",
   "5",
   C("A regular pentagon has 5 lines of symmetry, one through each corner and the midpoint of the opposite side.")+
   steps("A regular polygon has as many lines of symmetry as it has sides","A pentagon has 5 sides","So it has 5 lines of symmetry.")+
   U("A neatly drawn five-pointed star, based on a regular pentagon, has the same five lines of symmetry."),
   [("4","A pentagon has 5 sides, so it has 5 lines of symmetry, not 4."),
    ("2","Two lines is far too few for a regular five-sided shape; it has 5."),
    ("10","A regular pentagon has 5 lines of symmetry — equal to its number of sides, not double it.")]),

 ("SY","A regular hexagon has 6 equal sides. How many lines of symmetry does it have?",
   "6",
   C("A regular hexagon has 6 lines of symmetry, matching its 6 sides.")+
   steps("A regular polygon has lines of symmetry equal to its number of sides","A hexagon has 6 sides","So it has 6 lines of symmetry.")+
   U("The six-sided cells of a honeycomb each share this neat six-fold symmetry."),
   [("3","A regular hexagon has 6 lines of symmetry, one for each side, not 3."),
    ("12","The number of lines equals the number of sides (6), not double it."),
    ("4","Four is the square's count; a regular hexagon has 6 lines of symmetry.")]),

 ("SY","For any regular polygon, the number of lines of symmetry is equal to:",
   "the number of its sides",
   C("A regular polygon has exactly as many lines of symmetry as it has sides.")+
   steps("Each side has a matching line of symmetry through the figure's centre","So a 5-sided shape has 5, a 6-sided shape has 6","In general, lines of symmetry = number of sides.")+
   U("Knowing this, you can instantly say a regular 10-sided shape has 10 lines of symmetry."),
   [("always just 2","Only some shapes have 2; a regular polygon has as many lines as it has sides."),
    ("half the number of its sides","No — it is the full number of sides, not half. A pentagon (5 sides) has 5 lines, not 2 or 3."),
    ("twice the number of its sides","It is exactly the number of sides, not twice it; a hexagon has 6 lines, not 12.")]),

 ("SY","The capital letter A (block form) has how many lines of symmetry?",
   "1 (a vertical line down the middle)",
   C("The block letter A has one vertical line of symmetry down its centre.")+
   steps("Imagine folding the letter A left-to-right","The two halves match","So it has 1 (vertical) line of symmetry.")+
   U("Designers use such letter symmetry to make logos look balanced and tidy."),
   [("2 lines","The letter A matches only when folded vertically, not horizontally, so it has just 1 line."),
    ("0 lines","Block A does have symmetry — fold it down the middle and the halves match — so 1 line."),
    ("1 horizontal line","A's matching fold is VERTICAL (down the middle), not horizontal.")]),

 ("SY","The capital letter H (block form) has how many lines of symmetry?",
   "2 (one vertical and one horizontal)",
   C("Block letter H matches both when folded down the middle and across the middle, giving 2 lines.")+
   steps("Fold H left-to-right — the halves match (vertical line)","Fold H top-to-bottom — the halves match (horizontal line)","So it has 2 lines of symmetry.")+
   U("This double symmetry is why the letter H looks the same upside down as it does the right way up."),
   [("1","H matches BOTH ways — vertically and horizontally — so it has 2 lines, not 1."),
    ("0","Block H is very symmetric; it has 2 lines of symmetry, not none."),
    ("4","H has only the vertical and horizontal folds that match — 2 lines, not 4.")]),

 ("SY","Turning a square about its centre, the smallest angle of turn that makes it look exactly the same as before is:",
   "90°",
   C("A square looks the same after a quarter turn, which is 90°.")+
   steps("A full turn is 360°","A square repeats four times in a full turn","360° ÷ 4 = 90°.")+
   U("A square tile dropped back into its hole fits after a 90° turn, looking just as it did before."),
   [("180°","A square looks the same after only 90°, sooner than 180°; 90° is the smallest such angle."),
    ("45°","A 45° turn leaves the square tilted, not matching its start; the smallest matching turn is 90°."),
    ("360°","A full 360° turn always matches, but the SMALLEST matching turn for a square is 90°.")]),

 ("SY","An equilateral triangle has rotational symmetry of order:",
   "3",
   C("Turned about its centre, an equilateral triangle matches itself 3 times in a full turn — order 3.")+
   steps("A full turn is 360°","The triangle matches every 120° (360° ÷ 3)","So it matches 3 times — order of rotational symmetry is 3.")+
   U("A triangular spinner stops looking 'turned' after every 120°, matching its starting look three times around."),
   [("1","Order 1 means no real rotational symmetry; an equilateral triangle matches 3 times, so order 3."),
    ("2","An equilateral triangle matches every 120°, giving 3 matches per turn, not 2."),
    ("6","It matches 3 times in a full turn (every 120°), so the order is 3, not 6.")]),

 ("SY","What is the order of rotational symmetry of a rectangle that is not a square?",
   "2",
   C("A non-square rectangle matches itself twice in a full turn — at 180° and at 360° — so order 2.")+
   steps("Turn the rectangle about its centre","It matches its start after a 180° turn","That gives 2 matches in a full turn — order 2.")+
   U("A rectangular photo frame fits back the same way after a half turn (180°), but not after a quarter turn."),
   [("4","Only a square matches 4 times; a non-square rectangle matches just twice, so order 2."),
    ("1","A rectangle does have rotational symmetry — it matches after 180°, giving order 2, not 1."),
    ("3","A rectangle matches every 180°, giving 2 matches per turn, not 3.")]),

 ("SY","A figure that looks the same only after a full 360° turn is said to have rotational symmetry of order:",
   "1",
   C("Matching only after a full 360° turn means order 1 — effectively no real rotational symmetry.")+
   steps("Every figure matches itself after a full 360° turn","If that is the ONLY matching turn, it matches once","So the order of rotational symmetry is 1.")+
   U("A plain shoe matches itself only after a full turn, so its rotational symmetry is order 1."),
   [("0","Every figure matches after a full turn, so the lowest order is 1, never 0."),
    ("2","Order 2 needs a match at 180° too; matching ONLY at 360° gives order 1."),
    ("4","Order 4 needs matches every 90°; matching only at a full turn gives order 1.")]),

 ("SY","A parallelogram (slanted, not a rectangle) has how many lines of symmetry?",
   "0",
   C("A general parallelogram has no line of symmetry, though it does have rotational symmetry of order 2.")+
   steps("Try folding a slanted parallelogram any way","No fold makes the two halves match","So it has 0 lines of symmetry.")+
   U("A leaning parallelogram shape cannot be folded into matching halves, unlike a rectangle."),
   [("2","A rectangle has 2, but a slanted parallelogram has none — no fold matches its halves."),
    ("4","Four lines belong to a square; a slanted parallelogram has 0 lines of symmetry."),
    ("1","Even one line of symmetry is impossible for a slanted parallelogram; the count is 0.")]),

 ("SY","Which of these shapes has an unlimited (infinite) number of lines of symmetry?",
   "a circle",
   C("A circle is the one shape here with infinitely many lines of symmetry.")+
   steps("Every straight line through a circle's centre is a line of symmetry","There are countless such lines","So a circle has infinitely many lines of symmetry.")+
   U("A round coin or wheel can be folded through its centre any way and still match perfectly."),
   [("a square","A square has exactly 4 lines of symmetry, not an unlimited number."),
    ("an equilateral triangle","An equilateral triangle has just 3 lines of symmetry, far from unlimited."),
    ("a rectangle","A rectangle has only 2 lines of symmetry, not infinitely many.")]),

 ("SY","A leaf is folded along its central vein (the midrib) and the two halves match exactly. The midrib is acting as the leaf's:",
   "line of symmetry",
   C("The midrib divides the leaf into two matching mirror halves, so it is a line of symmetry.")+
   steps("Fold the leaf along its central vein","The left and right halves match","So the midrib is a line of symmetry of the leaf.")+
   U("Many leaves are nearly symmetric, which is why a pressed leaf folds so neatly along its midrib."),
   [("line of best fit","A line of best fit belongs to data graphs, not to the matching halves of a leaf."),
    ("number line","A number line is for plotting numbers; the midrib is a fold that gives mirror halves."),
    ("axis of rotation","Folding for mirror halves gives a line of symmetry; an axis of rotation is about turning, not folding.")]),

 ("SY","A regular flower has 6 identical petals spaced evenly around its centre. How many lines of symmetry does this flower pattern have?",
   "6",
   C("With 6 identical petals evenly spaced, the flower has 6 lines of symmetry, like a regular hexagon.")+
   steps("Evenly spaced identical petals act like a regular polygon's sides","6 petals behave like a 6-sided figure","So there are 6 lines of symmetry.")+
   U("This is why many flowers look perfectly balanced no matter which way you turn the photo."),
   [("3","With 6 evenly spaced identical petals, there are 6 matching folds, not 3."),
    ("1","A flower with 6 identical, evenly spaced petals has many lines of symmetry — 6, not just 1."),
    ("12","The number of lines equals the number of evenly spaced petals (6), not double it.")]),

 ("SY","The capital letter S (block form) has no line of symmetry, but turning it 180° gives the same shape. Its rotational symmetry has order:",
   "2",
   C("Block S matches itself after a 180° turn, so it has rotational symmetry of order 2 (with no line of symmetry).")+
   steps("Fold S any way — no halves match, so 0 lines of symmetry","Turn S by 180° — it looks the same","Matching twice in a full turn means order 2.")+
   U("The letter S looks correct even when a sign with it is turned upside down — that is its order-2 symmetry."),
   [("1","S DOES match after a 180° turn, so its rotational order is 2, not 1."),
    ("0","The lowest possible order is 1, and S actually reaches 2 by matching at 180°."),
    ("4","S matches only at 180° and 360°, giving order 2, not 4.")]),

 ("SY","A regular octagon (a stop-sign shape) has 8 equal sides. How many lines of symmetry does it have?",
   "8",
   C("A regular octagon has 8 lines of symmetry, equal to its 8 sides.")+
   steps("A regular polygon has lines of symmetry equal to its sides","An octagon has 8 sides","So it has 8 lines of symmetry.")+
   U("A road stop sign, shaped like a regular octagon, looks balanced because of its 8 lines of symmetry."),
   [("4","An octagon has 8 sides, so 8 lines of symmetry, not 4."),
    ("6","Six lines belong to a regular hexagon; an octagon has 8."),
    ("16","The number of lines equals the number of sides (8), not double it.")]),

 ("SY","A rhombus (a 'diamond' with all four sides equal but not a square) has its lines of symmetry along its:",
   "two diagonals",
   C("A rhombus has 2 lines of symmetry, and they lie along its two diagonals.")+
   steps("Fold a rhombus along a diagonal — the halves match","Both diagonals work this way","So its 2 lines of symmetry are the diagonals.")+
   U("A kite-shaped or diamond tile folds neatly into matching halves along its diagonals."),
   [("midpoints of opposite sides","Those folds work for a rectangle, not a rhombus; a rhombus folds along its diagonals."),
    ("four sides at once","A rhombus has only 2 lines of symmetry — its diagonals — not one per side."),
    ("centre point only","Symmetry needs a line, not just a point; the rhombus's lines lie along its two diagonals.")]),

 ("SY","Reflection symmetry of a figure is exactly the same idea as the figure having a:",
   "line of symmetry",
   C("Reflection symmetry and line symmetry mean the same thing — a mirror line splits the figure into matching halves.")+
   steps("Reflection means a mirror image","A figure with reflection symmetry has a mirror line","That mirror line is the line of symmetry.")+
   U("Holding a mirror along a butterfly's middle shows the right half mirrored into the left — its line of symmetry."),
   [("rotational symmetry","Rotational symmetry is about turning, not mirroring; reflection symmetry is line symmetry."),
    ("number of sides","The number of sides does not define reflection symmetry; a mirror line does."),
    ("centre of the figure","A single centre point is not a mirror line; reflection symmetry needs a line of symmetry.")]),

 ("SY","The block capital letter B has how many lines of symmetry?",
   "1 (a horizontal line across the middle)",
   C("Block letter B matches only when folded top-to-bottom, so it has 1 horizontal line of symmetry.")+
   steps("Fold B top-to-bottom — the halves match (horizontal line)","Fold B left-to-right — the halves do NOT match","So it has just 1 (horizontal) line of symmetry.")+
   U("Spotting which way a letter folds neatly helps designers balance signs and logos."),
   [("2 lines","B matches only when folded horizontally, not vertically, so it has 1 line, not 2."),
    ("0 lines","Block B does fold neatly across the middle, so it has 1 line of symmetry, not none."),
    ("1 vertical line","B's matching fold is HORIZONTAL (across the middle), not vertical.")]),
]

# ---------- ALGEBRAIC EXPRESSIONS (25) — Maths ----------
AE = [
 ("AE","In algebra, a letter such as x or n that can stand for different numbers is called a:",
   "variable",
   C("A letter that can take different values is called a variable.")+
   steps("Fixed numbers like 5 are constants","A letter standing for an unknown or changing value is a variable","So x and n are variables.")+
   U("When you write 'let the number of marks be x', that x is a variable standing in for any value."),
   [("constant","A constant is a fixed number like 7; a letter that can change value is a variable."),
    ("coefficient","A coefficient is the number multiplying a variable, not the changing letter itself."),
    ("equation","An equation is a full statement with an equals sign, not a single changing letter.")]),

 ("AE","In the term 7x, the number 7 that multiplies the variable x is called the:",
   "coefficient",
   C("The number multiplying a variable in a term is the coefficient.")+
   steps("A term like 7x is a number times a variable","Here 7 multiplies x","So 7 is the coefficient of x.")+
   U("If a shop sells x pens for 7 rupees each, the 7 in 7x is the coefficient — the price per pen."),
   [("variable","The variable is x; the number 7 in front of it is the coefficient."),
    ("constant","A constant stands alone with no variable; 7 here is multiplying x, so it is a coefficient."),
    ("exponent","An exponent is a small power like the 2 in x²; the 7 in 7x is a coefficient.")]),

 ("AE","Which of the following pairs are LIKE terms (terms that can be added together directly)?",
   "5x and 3x",
   C("Like terms have exactly the same variable part, so 5x and 3x are like terms.")+
   steps("Like terms must have the same letters to the same powers","5x and 3x both have just x","So they are like terms and can be added directly.")+
   U("Like terms combine the way 5 apples and 3 apples make 8 apples — same kind, so they add."),
   [("5x and 3y","x and y are different letters, so 5x and 3y are UNLIKE terms and cannot be added directly."),
    ("5x and 3x²","x and x² are different powers, so these are unlike terms; only matching powers are 'like'."),
    ("5 and 3x","A plain number and a term with x are unlike; 5 has no x, so they are not like terms.")]),

 ("AE","Adding the like terms, 2x + 3x equals:",
   "5x",
   C("Like terms add by adding their coefficients: 2x + 3x = (2 + 3)x = 5x.")+
   steps("Both terms have the same variable x","Add the coefficients: 2 + 3 = 5","Keep the x: 2x + 3x = 5x.")+
   U("If you walk 2x metres then 3x metres more, you have gone 5x metres in all."),
   [("6x","Adding like terms adds the coefficients (2 + 3 = 5); 6 would come from multiplying, not adding."),
    ("5x²","The power of x does not change when you add; 2x + 3x = 5x, not 5x²."),
    ("23x","You add the coefficients (2 + 3 = 5), you do not stick the digits together to get 23.")]),

 ("AE","Write 'a number x increased by 5' as an algebraic expression:",
   "x + 5",
   C("'Increased by 5' means add 5, so the expression is x + 5.")+
   steps("Start with the number x","'Increased by 5' means add 5","So the expression is x + 5.")+
   U("If you had x toffees and were given 5 more, you would now have x + 5 toffees."),
   [("5x","5x means 5 times x; 'increased by 5' means ADD 5, giving x + 5."),
    ("x − 5","x − 5 means decreased by 5; 'increased by 5' is x + 5."),
    ("x ÷ 5","Dividing by 5 is not 'increased by 5'; adding 5 gives x + 5.")]),

 ("AE","Write 'twice a number n, then add 3' as an algebraic expression:",
   "2n + 3",
   C("'Twice n' is 2n, and 'add 3' gives 2n + 3.")+
   steps("'Twice the number' means 2 × n = 2n","Then 'add 3' means + 3","So the expression is 2n + 3.")+
   U("If a taxi charges 2 rupees per km (2n) plus a fixed 3 rupees, the fare is 2n + 3."),
   [("2 + 3n","Here 'twice the number' is 2n, not 3n; the correct expression is 2n + 3."),
    ("2(n + 3)","2(n + 3) means doubling AFTER adding 3; the words say double first, then add 3, giving 2n + 3."),
    ("n + 3","n + 3 only adds 3; it misses 'twice the number'. The answer is 2n + 3.")]),

 ("AE","In the term −4y, the coefficient of y (including its sign) is:",
   "−4",
   C("The coefficient is the number with its sign, so in −4y it is −4.")+
   steps("A coefficient carries its sign","In −4y the number multiplying y is −4","So the coefficient is −4, not just 4.")+
   U("Tracking the minus sign matters in algebra, the same way a debt of 4 rupees differs from 4 in hand."),
   [("4","The coefficient keeps its sign, so it is −4, not 4."),
    ("y","y is the variable; the coefficient is the number in front, which is −4."),
    ("−4y","−4y is the whole term; the coefficient is just the number part, −4.")]),

 ("AE","An algebraic expression that has exactly one term, such as 7x, is called a:",
   "monomial",
   C("An expression with just one term is a monomial.")+
   steps("Count the terms in the expression","7x has only one term","One term means it is a monomial.")+
   U("Naming expressions by their number of terms helps you describe and compare them quickly."),
   [("binomial","A binomial has TWO terms, like x + 3; 7x has only one, so it is a monomial."),
    ("trinomial","A trinomial has THREE terms; 7x is a single term, a monomial."),
    ("equation","An equation has an equals sign; 7x is just one term — a monomial.")]),

 ("AE","An expression with exactly two terms, such as 2x + 5, is called a:",
   "binomial",
   C("An expression with two terms is a binomial.")+
   steps("Count the terms separated by + or −","2x + 5 has two terms: 2x and 5","Two terms means a binomial.")+
   U("'Bi' means two, the same root as in 'bicycle' (two wheels), so a binomial has two terms."),
   [("monomial","A monomial has only ONE term; 2x + 5 has two, so it is a binomial."),
    ("trinomial","A trinomial has THREE terms; 2x + 5 has only two, so it is a binomial."),
    ("variable","A variable is a single letter; 2x + 5 is a two-term expression, a binomial.")]),

 ("AE","What is the value of the expression 3x + 2 when x = 4?",
   "14",
   C("Put x = 4 into 3x + 2: 3 × 4 + 2 = 12 + 2 = 14.")+
   steps("Replace x with 4: 3 × 4 + 2","3 × 4 = 12","12 + 2 = 14.")+
   U("If a notebook costs 3 rupees each (3x) plus a 2-rupee bag, then 4 notebooks cost 3×4 + 2 = 14 rupees."),
   [("18","18 would come from (3 + 2) × 4 wrongly; correctly 3 × 4 = 12, then + 2 = 14."),
    ("9","9 ignores the multiplication; 3 × 4 is 12, and 12 + 2 = 14, not 9."),
    ("20","20 wrongly multiplies the whole thing; the value is 3×4 + 2 = 14.")]),

 ("AE","In the expression 5x + 8, the term 8, which has no variable, is called the:",
   "constant term",
   C("A term with no variable, like 8, is the constant term — its value never changes.")+
   steps("5x changes when x changes","8 has no variable and stays the same","So 8 is the constant term.")+
   U("In a fare of 5x + 8, the 8 is a fixed booking charge you pay no matter how far you go."),
   [("coefficient","A coefficient multiplies a variable (the 5 in 5x); 8 stands alone as the constant term."),
    ("variable","A variable is a changing letter like x; 8 is a fixed number, the constant term."),
    ("like term","'Like term' compares two terms; 8 by itself is simply the constant term.")]),

 ("AE","Subtracting like terms, 9a − 4a equals:",
   "5a",
   C("Subtract the coefficients of the like terms: 9a − 4a = (9 − 4)a = 5a.")+
   steps("Both terms have the same variable a","Subtract the coefficients: 9 − 4 = 5","Keep the a: 9a − 4a = 5a.")+
   U("If you had 9a rupees and spent 4a rupees, you would be left with 5a rupees."),
   [("13a","Subtraction takes away (9 − 4 = 5); adding would give 13, but the sign here is minus."),
    ("5","The variable a stays; 9a − 4a = 5a, not just 5."),
    ("5a²","The power of a does not change on subtracting; the answer is 5a, not 5a².")]),

 ("AE","Write 'the number of legs on c cows' as an algebraic expression (each cow has 4 legs):",
   "4c",
   C("Each cow has 4 legs, so c cows have 4 × c = 4c legs.")+
   steps("One cow has 4 legs","c cows have 4 legs each","Total legs = 4 × c = 4c.")+
   U("If a farm has c cows, you can quickly find the total legs as 4c without counting them all."),
   [("c + 4","Adding 4 gives only 4 extra legs in total; each cow has 4 legs, so it is 4 × c = 4c."),
    ("c ÷ 4","Dividing by 4 would shrink the count; multiplying gives the total: 4c."),
    ("4 + c","This adds c to 4 instead of multiplying; the total legs are 4c.")]),

 ("AE","The perimeter of a square with side of length s can be written as the expression:",
   "4s",
   C("A square has 4 equal sides, so its perimeter is 4 × s = 4s.")+
   steps("A square has 4 sides, each of length s","Perimeter is the total of all sides","s + s + s + s = 4s.")+
   U("To fence a square plot of side s metres, you need 4s metres of fencing."),
   [("s + 4","Adding 4 gives the wrong total; four sides of length s give 4 × s = 4s."),
    ("s²","s² is the AREA of the square, not the perimeter; the perimeter is 4s."),
    ("2s","2s would be only two sides; a square has four sides, giving 4s.")]),

 ("AE","Which of these is a TRINOMIAL (an expression with exactly three terms)?",
   "x² + 2x + 1",
   C("A trinomial has three terms; x² + 2x + 1 has the three terms x², 2x and 1.")+
   steps("Count the terms separated by + or −","x² + 2x + 1 has three terms","Three terms means a trinomial.")+
   U("'Tri' means three, as in 'tricycle' (three wheels), so a trinomial has three terms."),
   [("2x + 1","2x + 1 has only TWO terms, so it is a binomial, not a trinomial."),
    ("7x","7x has only ONE term, so it is a monomial, not a trinomial."),
    ("5","5 is a single constant term, a monomial, not a trinomial.")]),

 ("AE","Adding the expressions (2x + 3) and (4x + 5) gives:",
   "6x + 8",
   C("Add like terms: 2x + 4x = 6x, and 3 + 5 = 8, giving 6x + 8.")+
   steps("Group the x-terms: 2x + 4x = 6x","Group the constants: 3 + 5 = 8","Put them together: 6x + 8.")+
   U("Adding two bills, each part-fixed and part-per-item, works exactly this way — like with like."),
   [("6x + 15","The constants add to 3 + 5 = 8, not 15; the answer is 6x + 8."),
    ("8x + 8","The x-terms add to 2x + 4x = 6x, not 8x; the answer is 6x + 8."),
    ("6x²+ 8","Adding 2x and 4x keeps the power: 6x, not 6x²; the answer is 6x + 8.")]),

 ("AE","Subtracting (x + 2) from (5x + 7) gives:",
   "4x + 5",
   C("Subtract term by term: 5x − x = 4x and 7 − 2 = 5, giving 4x + 5.")+
   steps("Subtract the x-terms: 5x − x = 4x","Subtract the constants: 7 − 2 = 5","Result: 4x + 5.")+
   U("Finding how much more one cost expression is than another is exactly this kind of subtraction."),
   [("6x + 9","Subtraction takes away; 5x − x = 4x and 7 − 2 = 5, not adding to 6x + 9."),
    ("4x + 9","The constants subtract: 7 − 2 = 5, not 9; the answer is 4x + 5."),
    ("5x + 5","The x-terms subtract: 5x − x = 4x, not 5x; the answer is 4x + 5.")]),

 ("AE","A forest department plants saplings in rows, with exactly 12 saplings in each row. The number of saplings in r rows is best written as:",
   "12r",
   C("With 12 saplings per row, r rows hold 12 × r = 12r saplings.")+
   steps("One row has 12 saplings","r rows have 12 saplings each","Total = 12 × r = 12r.")+
   U("A forester can find the total saplings for any number of rows just by working out 12r."),
   [("12 + r","Adding r gives only r extra; with 12 per row over r rows the total is 12 × r = 12r."),
    ("r ÷ 12","Dividing shrinks the count; multiplying 12 by r gives the total, 12r."),
    ("12 − r","Subtracting makes no sense here; the total saplings are 12r.")]),

 ("AE","A nursery sells each plant for ₹15. Adding a fixed delivery charge of ₹40, the total cost for p plants is:",
   "15p + 40",
   C("p plants cost 15p, and the fixed ₹40 delivery is added, giving 15p + 40.")+
   steps("Each plant costs ₹15, so p plants cost 15 × p = 15p","Add the fixed delivery of ₹40","Total cost = 15p + 40.")+
   U("This kind of 'so-much-each plus a fixed charge' expression appears on many real bills."),
   [("15 + 40p","Here 15 is the price PER plant (so 15p) and 40 is the one-time fixed charge, giving 15p + 40."),
    ("55p","You cannot add 15 and 40 into one rate; the per-plant 15p and fixed 40 stay separate: 15p + 40."),
    ("15p − 40","The delivery charge is ADDED, not subtracted; the total is 15p + 40.")]),

 ("AE","In the term 6mn, the factors (the parts multiplied together) are:",
   "6, m and n",
   C("6mn is the product 6 × m × n, so its factors are 6, m and n.")+
   steps("A term is built by multiplying factors","6mn means 6 × m × n","So the factors are 6, m and n.")+
   U("Breaking a term into its factors helps when you later simplify or compare algebraic terms."),
   [("6 and mn only","mn is itself m × n, so the separate factors are 6, m and n — three factors, not two."),
    ("6 + m + n","6mn is a PRODUCT, not a sum; its factors are multiplied: 6, m and n."),
    ("only 6","6 is just one factor; the term 6mn also has the factors m and n.")]),

 ("AE","Which statement about the expression 4x + 9 is correct?",
   "4 is the coefficient of x and 9 is the constant term",
   C("In 4x + 9, the 4 multiplies x (the coefficient) and 9 stands alone (the constant term).")+
   steps("4x is a number times a variable — 4 is the coefficient","9 has no variable — it is the constant term","So 4 is the coefficient and 9 is the constant.")+
   U("Reading an expression this way lets you see at a glance which part changes and which is fixed."),
   [("9 is the coefficient of x and 4 is the constant","It is the other way round: 4 multiplies x (coefficient) and 9 is the constant term."),
    ("both 4 and 9 are coefficients of x","Only 4 multiplies x; 9 has no variable, so 9 is the constant term, not a coefficient."),
    ("x is the constant term","x is the variable; the constant term is 9, the part with no variable.")]),

 ("AE","What is the value of the expression 2n − 1 when n = 6?",
   "11",
   C("Put n = 6 into 2n − 1: 2 × 6 − 1 = 12 − 1 = 11.")+
   steps("Replace n with 6: 2 × 6 − 1","2 × 6 = 12","12 − 1 = 11.")+
   U("Such substitution lets you turn a general rule like 2n − 1 into an exact number whenever you know n."),
   [("13","2 × 6 = 12, then SUBTRACT 1 to get 11; adding 1 wrongly gives 13."),
    ("10","2 × 6 = 12, and 12 − 1 = 11, not 10."),
    ("12","You must still subtract the 1: 12 − 1 = 11, not 12.")]),

 ("AE","In the number pattern 5, 10, 15, 20, … each term is 5 times its position. The expression for the nth term is:",
   "5n",
   C("Each term is 5 times its position number, so the nth term is 5 × n = 5n.")+
   steps("1st term = 5 × 1, 2nd = 5 × 2, 3rd = 5 × 3","Each term is 5 times its position","So the nth term is 5n.")+
   U("A rule like 5n lets you jump straight to, say, the 100th term (500) without listing them all."),
   [("n + 5","n + 5 only adds 5 each time from n; here each term is 5 TIMES the position, so 5n."),
    ("5 + n","Adding n to 5 does not give 5, 10, 15, …; multiplying does: 5n."),
    ("n − 5","Subtracting 5 gives a shrinking list, not 5, 10, 15, …; the rule is 5n.")]),

 ("AE","Simplifying 3x + 2y + 5x − y by collecting like terms gives:",
   "8x + y",
   C("Collect the x-terms (3x + 5x = 8x) and the y-terms (2y − y = y) to get 8x + y.")+
   steps("x-terms: 3x + 5x = 8x","y-terms: 2y − y = y","Combine: 8x + y.")+
   U("Tidying an expression into like groups makes it far easier to use or to put a value into."),
   [("10xy","x and y are different variables and cannot be merged into one xy term; the answer is 8x + y."),
    ("8x + 3y","The y-terms give 2y − y = y, not 3y; the answer is 8x + y."),
    ("8x − y","The y-terms give 2y − y = +y, not −y; the answer is 8x + y.")]),

 ("AE","The perimeter of a rectangle with length l and breadth b can be written as the expression:",
   "2l + 2b",
   C("A rectangle has two lengths and two breadths, so its perimeter is l + l + b + b = 2l + 2b.")+
   steps("A rectangle has 2 sides of length l and 2 of breadth b","Add them all: l + l + b + b","Collect like terms: 2l + 2b.")+
   U("To fence a rectangular garden of length l and breadth b, you need 2l + 2b metres of fencing."),
   [("l + b","l + b is only one length plus one breadth; a rectangle has two of each, giving 2l + 2b."),
    ("lb","lb (l × b) is the AREA of the rectangle, not its perimeter; the perimeter is 2l + 2b."),
    ("4l","4l would suit a square of side l; a rectangle has two different sides, giving 2l + 2b.")]),
]

assert len(RP) == 25 and len(FO) == 25 and len(SY) == 25 and len(AE) == 25

# Interleave so no two consecutive questions share a chapter; Science/Maths alternate.
items = []
for i in range(25):
    items += [RP[i], SY[i], FO[i], AE[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=18371,
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
    split = "/".join(str(counts[c]) for c in ("RP", "SY", "FO", "AE"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Reproduction in Plants", "Forests",
                     "Symmetry", "Algebraic Expressions"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
