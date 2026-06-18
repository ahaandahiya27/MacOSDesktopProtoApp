# -*- coding: utf-8 -*-
# Boss Challenge Paper 31 — Light · Transportation in Animals & Plants · Lines & Angles · Exponents & Powers
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans hard into FUSION. Several Lines-&-Angles items are wrapped in a
# Light scene (the angle of incidence equalling the angle of reflection, the angle a ray turns through
# on a plane mirror), and several Exponents items are set inside a Transportation context (heartbeats
# counted as powers of ten, the number of red blood cells written in exponent form). The child reads a
# Science context and applies a Maths skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_31_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_31_<SHORT>_QuestionPaper.pdf
#   Paper_31_<SHORT>_Questions.md
#   Paper_31_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "31"
SHORT = "Light_Transportation_LinesAngles_Exponents"
TITLE = ("Light · Transportation in Animals & Plants · Lines & Angles · Exponents & Powers")
LABELS = {
    "LT": "Light",
    "TR": "Transportation in Animals & Plants",
    "LA": "Lines & Angles",
    "EX": "Exponents & Powers",
}

# ---------- LIGHT (25) — Science ----------
LT = [
 ("LT","Light always travels from one place to another along a path that is:",
   "a straight line",
   C("In a single clear medium light moves in straight lines; that is why sharp shadows form.")+
   steps("Look at a torch beam in dust — it is straight","light does not bend on its own in air","so it travels in a straight line."),
   [("a curved arc","Light does not curve on its own in a uniform medium; it goes straight."),
    ("a zig-zag","Light has no reason to zig-zag in clear air; its path is straight."),
    ("a circle","A straight beam never loops into a circle by itself.")]),

 ("LT","A mirror with a flat, smooth reflecting surface is called a:",
   "plane mirror",
   C("A flat smooth reflecting surface is a plane mirror, the kind on your wall.")+
   steps("A bathroom mirror is flat, not curved","a flat reflecting surface has a special name","that name is a plane mirror."),
   [("concave mirror","A concave mirror curves inward like a spoon's bowl, not flat."),
    ("convex mirror","A convex mirror bulges outward like the back of a spoon, not flat."),
    ("lens","A lens lets light pass through and bends it; a mirror reflects light.")]),

 ("LT","The image you see of yourself in a plane mirror is always:",
   "erect and the same size",
   C("A plane mirror gives an upright image of exactly your own size.")+
   steps("Stand before a flat mirror","your reflection is the right way up","and just as tall as you — same size, erect."),
   [("upside down and bigger","A plane mirror never flips you upside down nor enlarges you."),
    ("erect but smaller","A plane mirror image is the same size, not smaller."),
    ("inverted but same size","The image is erect, not inverted, in a plane mirror.")]),

 ("LT","In a plane mirror your right hand appears to be the image's left hand. This swap is called:",
   "lateral inversion",
   C("Left and right appear interchanged in a plane mirror — lateral inversion.")+
   steps("Raise your right hand at a mirror","the image raises what looks like its left","this left-right swap is lateral inversion."),
   [("magnification","Magnification means a change of size, not a left-right swap."),
    ("refraction","Refraction is the bending of light through a medium, not a side swap."),
    ("dispersion","Dispersion is the splitting of white light into colours, not a swap.")]),

 ("LT","The image formed by a plane mirror cannot be caught on a screen, so it is called a:",
   "virtual image",
   C("A plane-mirror image only appears to be behind the glass; it cannot fall on a screen, so it is virtual.")+
   steps("Hold a screen behind the mirror","no image lands on it","an image that cannot be caught is virtual."),
   [("real image","A real image can be caught on a screen; the mirror's cannot."),
    ("shadow","A shadow is dark; a mirror image is bright and detailed."),
    ("reflection-free image","Every mirror image comes from reflection; this term is meaningless here.")]),

 ("LT","A mirror that curves inward, like the inside of a spoon's bowl, is a:",
   "concave mirror",
   C("A surface that caves inward is a concave mirror.")+
   steps("Look at the inner curve of a shiny spoon","it bends inward toward you","an inward-curving mirror is concave."),
   [("convex mirror","A convex mirror bulges outward, the opposite of caving in."),
    ("plane mirror","A plane mirror is flat, not curved inward."),
    ("plain glass","Plain glass lets light through; it is not a curved mirror.")]),

 ("LT","A concave mirror can gather light from a far object and form an image that is:",
   "real and can be caught on a screen",
   C("For a distant object a concave mirror forms a real image you can catch on a screen.")+
   steps("Point a concave mirror at a far lamp","slide a screen until a sharp spot appears","that catchable image is real."),
   [("virtual and never on a screen","For a far object the concave mirror's image is real, not virtual."),
    ("always the same size as you","Concave mirror images change size with distance; not always same size."),
    ("coloured like a rainbow","A concave mirror reflects, it does not split light into colours.")]),

 ("LT","A mirror that bulges outward, like the back of a spoon, always gives an image that is:",
   "erect and smaller (diminished)",
   C("A convex mirror always shows an upright, shrunken image, so it shows a wide view.")+
   steps("Look at the bulging back of a spoon","your face looks small and upright","a convex mirror gives an erect, diminished image."),
   [("inverted and larger","A convex mirror never inverts or enlarges the image."),
    ("real and on a screen","A convex mirror's image is virtual, not catchable on a screen."),
    ("the same size always","A convex image is smaller than the object, not the same size.")]),

 ("LT","Side mirrors on cars and scooters are convex because they:",
   "show a wider area of traffic behind",
   C("A convex mirror's wide field lets the driver see more of the road behind.")+
   steps("A convex mirror shrinks the image","shrinking fits more scene into the glass","so the driver sees a wider view of traffic."),
   [("magnify each vehicle","Convex mirrors shrink images; they do not magnify."),
    ("flip the road upside down","Convex mirrors give erect images, not upside-down ones."),
    ("only work at night","Convex mirrors work by day and night alike.")]),

 ("LT","A piece of glass that bends light passing through it to form images is a:",
   "lens",
   C("A lens is shaped glass that bends light passing through to make images.")+
   steps("A magnifying glass is curved glass","light passes through and bends","this image-forming glass is a lens."),
   [("plane mirror","A plane mirror reflects light; light does not pass through it."),
    ("prism","A prism splits white light into colours but is not used to form object images here."),
    ("screen","A screen only catches images; it does not bend light.")]),

 ("LT","A lens that is fatter in the middle than at its edges is a:",
   "convex lens",
   C("Thick-in-the-middle glass is a convex (converging) lens.")+
   steps("Feel a magnifying-glass lens","it is fat in the centre, thin at the rim","a thick-centred lens is convex."),
   [("concave lens","A concave lens is thinner in the middle, the opposite shape."),
    ("plane mirror","A plane mirror is flat glass that reflects, not a lens."),
    ("prism","A prism is a triangular block, not a centre-thick lens.")]),

 ("LT","A convex lens used to read tiny print acts as a:",
   "magnifying glass",
   C("Held close, a convex lens enlarges small print — it is a magnifying glass.")+
   steps("Hold a convex lens over small letters","the letters look bigger and upright","so a convex lens works as a magnifying glass."),
   [("a mirror","A magnifying glass lets light through; a mirror reflects it back."),
    ("a shrinking glass","A convex lens enlarges near objects, it does not shrink them."),
    ("a torch","A torch makes light; a magnifying lens only bends existing light.")]),

 ("LT","A lens that is thinner in the middle than at the edges always makes objects look:",
   "smaller",
   C("A concave lens (thin centre) spreads light out, so it shows a smaller, erect image.")+
   steps("A concave lens is thin in the middle","it spreads rays apart","so objects seen through it look smaller."),
   [("larger","A concave lens shrinks; it never enlarges objects."),
    ("upside down","A concave lens gives erect images, not inverted ones."),
    ("coloured","A concave lens does not split light into colours.")]),

 ("LT","White sunlight is split into its colours when it passes through a:",
   "prism",
   C("A glass prism bends each colour by a different amount, spreading white light into a band.")+
   steps("Send sunlight through a glass prism","each colour bends a little differently","white light spreads into its colours."),
   [("plane mirror","A plane mirror reflects light without splitting its colours."),
    ("convex lens","A convex lens mainly focuses light, not splits it into a spectrum."),
    ("sheet of paper","Paper just blocks or scatters light; it does not split colours.")]),

 ("LT","The band of seven colours obtained when white light is split is called the:",
   "spectrum",
   C("The ordered band of seven colours from split white light is the spectrum.")+
   steps("A prism spreads white light","the colours line up in order","that ordered band is the spectrum."),
   [("shadow","A shadow is a dark patch, not a band of colours."),
    ("reflection","Reflection is light bouncing back, not a colour band."),
    ("image","An image is a picture of an object, not the colour band itself.")]),

 ("LT","A rainbow in the sky is nature's way of splitting sunlight using tiny:",
   "water drops",
   C("Raindrops act like little prisms, splitting sunlight into the rainbow's colours.")+
   steps("After rain the air is full of water drops","sunlight passes through each drop and splits","so we see a rainbow of colours."),
   [("dust grains","Dust does not neatly split sunlight into a rainbow; water drops do."),
    ("ice cubes","A rainbow forms from airborne water drops, not ground ice cubes."),
    ("clouds alone","Clouds may hide the sun; it is the drops that split the light.")]),

 ("LT","We can see a non-luminous object such as a book only because it:",
   "reflects light into our eyes",
   C("A book makes no light of its own; we see it by the light it reflects to our eyes.")+
   steps("A book is non-luminous — it makes no light","light from a lamp or sun falls on it","it reflects some into our eyes, so we see it."),
   [("makes its own light","A book is non-luminous and makes no light of its own."),
    ("absorbs all the light","If it absorbed all light it would look black and unseen."),
    ("bends light like a lens","A solid book reflects light; it does not act as a lens.")]),

 ("LT","Bouncing of light back from a surface like a mirror is called:",
   "reflection",
   C("When light hits a mirror and bounces back, that is reflection.")+
   steps("Shine a torch at a mirror","the light bounces away from it","this bouncing back is reflection."),
   [("refraction","Refraction is the bending of light entering a new medium, not bouncing back."),
    ("dispersion","Dispersion is splitting white light into colours, not bouncing."),
    ("absorption","Absorption is light being soaked up, not bounced back.")]),

 ("LT","The image in a plane mirror appears to be as far behind the mirror as the object is:",
   "in front of it",
   C("A plane-mirror image sits as far behind the glass as the object stands in front.")+
   steps("Stand 30 cm from a flat mirror","your image looks 30 cm behind the glass","object distance equals image distance."),
   [("above the mirror","The image lies behind the mirror, not above it."),
    ("inside the glass","The image only appears behind the mirror, not within the glass itself."),
    ("twice as far behind","The image is the same distance behind, not double.")]),

 ("LT","A spoon's inside (bowl) makes your face look upside down when held far away because the inner surface acts like a:",
   "concave mirror",
   C("The bowl of a spoon is concave; from far away it forms an inverted image of your face.")+
   steps("Hold the bowl of a shiny spoon at arm's length","your face appears upside down","because the inner curve is a concave mirror."),
   [("convex mirror","The bulging back of the spoon is convex and gives an erect image."),
    ("plane mirror","A flat mirror would keep your face upright, not flip it."),
    ("lens","A spoon reflects light; it does not let light pass through like a lens.")]),

 ("LT","A real image, unlike a virtual one, is always:",
   "able to be caught on a screen",
   C("A real image actually forms in space and can land on a screen; a virtual one cannot.")+
   steps("Set up a screen where a concave mirror focuses a far lamp","a bright sharp image appears on the screen","such a catchable image is real."),
   [("formed behind the mirror","A real image forms in front of the mirror, not behind."),
    ("always upright","Real images from mirrors and lenses are often inverted, not always upright."),
    ("only seen in plane mirrors","Plane mirrors give virtual images, not real ones.")]),

 ("LT","If you move toward a plane mirror, your image moves:",
   "toward you by the same amount",
   C("As you approach a flat mirror, the image approaches the glass equally — it meets you halfway.")+
   steps("Object distance always equals image distance","step 10 cm closer","the image also comes 10 cm closer to the glass."),
   [("away from you","The image approaches as you approach; it does not retreat."),
    ("stays exactly still","The image moves with you; it does not stay put."),
    ("grows much larger","A plane-mirror image stays the same size as you move.")]),

 ("LT","A dentist uses a concave mirror to look at teeth because it can give an:",
   "enlarged, erect image when held close",
   C("Held near the tooth, a concave mirror shows a bigger, upright view, helping the dentist see detail.")+
   steps("A concave mirror held close to a small object","gives a magnified upright image","so the dentist sees the tooth larger."),
   [("smaller image of the tooth","A concave mirror held close enlarges, it does not shrink."),
    ("upside-down view for comfort","A close concave mirror gives an erect, not inverted, view."),
    ("colour-split image","A concave mirror does not split light into colours.")]),

 ("LT","Headlights of a car use a concave mirror behind the bulb to:",
   "throw the light forward as a strong beam",
   C("A concave mirror gathers the bulb's light and sends it out as a powerful forward beam.")+
   steps("Place a bulb near a concave mirror's focus","the mirror collects spreading light","and reflects it forward as a strong beam."),
   [("scatter light in all directions","The concave mirror focuses light forward, not scatters it everywhere."),
    ("split the light into colours","A headlight mirror reflects white light; it does not split colours."),
    ("dim the bulb to save power","The mirror brightens the beam ahead; it does not dim the bulb.")]),

 ("LT","Two plane mirrors facing each other in a kaleidoscope create:",
   "many repeated images of the coloured bits",
   C("Light bounces between the two mirrors again and again, making many images of the coloured pieces.")+
   steps("Mirrors face each other inside the tube","light reflects back and forth between them","each bounce adds another image, making a pattern."),
   [("a single small image","Repeated reflections make many images, not just one."),
    ("no image at all","Mirrors do form images; the kaleidoscope shows many."),
    ("a real image on a screen","Plane-mirror images are virtual, not screen-catchable.")]),
]

# ---------- TRANSPORTATION IN ANIMALS & PLANTS (25) — Science ----------
TR = [
 ("TR","The red fluid that carries food, oxygen and wastes around the human body is:",
   "blood",
   C("Blood is the transport fluid carrying food, oxygen and wastes through the body.")+
   steps("Cells need food and oxygen delivered","and their wastes carried away","blood is the fluid that does this carrying."),
   [("saliva","Saliva helps digest food in the mouth; it does not circulate the body."),
    ("sweat","Sweat cools the skin; it is not the body's transport fluid."),
    ("bile","Bile helps digest fats in the gut; it is not the circulating fluid.")]),

 ("TR","The liquid part of blood, in which the cells float, is called:",
   "plasma",
   C("Plasma is the pale liquid of blood that carries the blood cells and dissolved substances.")+
   steps("Spin blood and the cells settle","a pale liquid stays on top","that liquid is plasma."),
   [("platelets","Platelets are tiny cell pieces for clotting, not the liquid part."),
    ("haemoglobin","Haemoglobin is a red substance inside red cells, not the liquid."),
    ("lymph","Lymph is a separate body fluid, not the liquid part of blood.")]),

 ("TR","The red colour of blood comes from a substance in red blood cells called:",
   "haemoglobin",
   C("Haemoglobin in red blood cells is red and carries oxygen, giving blood its colour.")+
   steps("Red cells are packed with a red pigment","that pigment grabs oxygen","its name is haemoglobin."),
   [("plasma","Plasma is the pale liquid, not the red pigment."),
    ("platelets","Platelets help clotting and are not the red pigment."),
    ("insulin","Insulin controls blood sugar; it has nothing to do with the red colour.")]),

 ("TR","The blood cells that fight germs and disease are the:",
   "white blood cells",
   C("White blood cells defend the body by attacking germs that enter it.")+
   steps("Germs can invade the body","a defence force is needed","white blood cells fight off the germs."),
   [("red blood cells","Red cells carry oxygen; they do not fight germs."),
    ("platelets","Platelets clot blood at cuts; they do not fight germs."),
    ("nerve cells","Nerve cells carry messages; they are not part of blood defence.")]),

 ("TR","When you cut your finger, the bleeding stops because tiny blood cell pieces called platelets help the blood to:",
   "clot",
   C("Platelets gather at the cut and help the blood clot, plugging the wound.")+
   steps("A cut lets blood escape","platelets rush to the spot","they help form a clot that seals the cut."),
   [("boil","Blood does not boil at a cut; platelets make it clot."),
    ("evaporate","Bleeding stops by clotting, not by the blood evaporating."),
    ("freeze","Blood does not freeze to stop a cut; it clots.")]),

 ("TR","The muscular organ that pumps blood all around the body is the:",
   "heart",
   C("The heart is a muscular pump that pushes blood through the whole body.")+
   steps("Blood must keep moving everywhere","something must push it","the heart pumps it round and round."),
   [("liver","The liver processes food and cleans blood; it does not pump it."),
    ("lung","Lungs add oxygen to blood; they do not pump it around."),
    ("kidney","Kidneys filter wastes from blood; they are not the pump.")]),

 ("TR","Blood vessels that carry blood away from the heart to the body are the:",
   "arteries",
   C("Arteries carry blood away from the heart, usually under high pressure.")+
   steps("Blood leaves the heart","it travels in thick strong tubes","these outgoing vessels are arteries."),
   [("veins","Veins bring blood back to the heart, not away from it."),
    ("capillaries","Capillaries are tiny vessels in tissues, not the main outgoing tubes."),
    ("nerves","Nerves carry signals, not blood.")]),

 ("TR","Blood vessels that bring blood back to the heart are the:",
   "veins",
   C("Veins return blood to the heart after it has delivered oxygen and food.")+
   steps("After serving the tissues, blood must come back","it flows through return tubes","these returning vessels are veins."),
   [("arteries","Arteries carry blood away from the heart, not back to it."),
    ("capillaries","Capillaries connect arteries to veins; they are not the main return tubes."),
    ("windpipe","The windpipe carries air, not blood.")]),

 ("TR","The extremely thin vessels where food and oxygen pass from blood into the cells are the:",
   "capillaries",
   C("Capillaries have walls one cell thick, so substances pass easily between blood and tissues.")+
   steps("Exchange needs very thin walls","the thinnest vessels connect arteries and veins","these are the capillaries."),
   [("arteries","Arteries have thick walls; exchange happens in thin capillaries."),
    ("veins","Veins return blood; the fine exchange happens in capillaries."),
    ("ureters","Ureters carry urine, not blood.")]),

 ("TR","The throbbing you feel at your wrist, caused by blood being pushed through an artery, is the:",
   "pulse",
   C("Each heartbeat pushes blood, and the resulting throb felt at the wrist is the pulse.")+
   steps("The heart beats and pushes blood","the artery wall springs out with each push","that felt beat at the wrist is the pulse."),
   [("clot","A clot is a plug that stops bleeding, not the wrist throb."),
    ("breath","Breath is air moving in and out, not the artery throb."),
    ("reflex","A reflex is a quick automatic action, not the wrist beat.")]),

 ("TR","The waste cleaning organs that filter the blood and make urine are the:",
   "kidneys",
   C("Kidneys filter wastes from the blood and turn them into urine.")+
   steps("Blood collects wastes from cells","these must be removed","the kidneys filter them out as urine."),
   [("lungs","Lungs remove waste carbon dioxide as gas, not urine."),
    ("heart","The heart pumps blood; it does not filter wastes into urine."),
    ("stomach","The stomach digests food; it does not make urine.")]),

 ("TR","The tube that carries urine from a kidney down to the urinary bladder is the:",
   "ureter",
   C("Each ureter carries urine from a kidney to the bladder for storage.")+
   steps("Kidneys make urine","it must travel to the storage bag","the ureter carries it to the bladder."),
   [("urethra","The urethra carries urine out of the body from the bladder, a later step."),
    ("artery","An artery carries blood, not urine."),
    ("windpipe","The windpipe carries air, not urine.")]),

 ("TR","Sweat helps the body by removing some water and salts and also by:",
   "cooling the body as it evaporates",
   C("As sweat dries off the skin it carries away heat, cooling the body.")+
   steps("Sweat sits on warm skin","it evaporates, taking heat with it","so the body cools down."),
   [("warming the body up","Evaporating sweat cools, it does not warm the body."),
    ("adding salt to the blood","Sweat removes some salt; it does not add salt to blood."),
    ("making the skin waterproof","Sweat does not waterproof the skin; it cools by evaporating.")]),

 ("TR","In plants, water and dissolved minerals are carried upward from the roots through tubes called:",
   "xylem",
   C("Xylem tubes carry water and minerals upward from the roots to the leaves.")+
   steps("Roots absorb water and minerals","these must rise to the leaves","the xylem tubes carry them up."),
   [("phloem","Phloem carries made food, not the upward water from roots."),
    ("stomata","Stomata are leaf pores for gas exchange, not transport tubes."),
    ("veins","Veins are animal vessels; plants use xylem for water.")]),

 ("TR","The tubes that carry food made in the leaves to all other parts of a plant are the:",
   "phloem",
   C("Phloem tubes distribute the food made in leaves to the rest of the plant.")+
   steps("Leaves make food by photosynthesis","this food must reach roots, stem and fruit","the phloem carries it everywhere."),
   [("xylem","Xylem carries water up from roots, not food from leaves."),
    ("roots","Roots absorb water; they are not the food-carrying tubes."),
    ("arteries","Arteries are animal vessels; plants use phloem for food.")]),

 ("TR","The continuous loss of water vapour mainly through the tiny pores of leaves is called:",
   "transpiration",
   C("Transpiration is the escape of water vapour from leaf pores, which helps pull water up.")+
   steps("Leaf pores open to the air","water vapour escapes through them","this loss is transpiration, and it pulls more water up."),
   [("respiration","Respiration releases energy from food; it is not water loss from leaves."),
    ("germination","Germination is a seed sprouting, not water loss."),
    ("condensation","Condensation is vapour turning to liquid, the reverse idea.")]),

 ("TR","The tiny pores on the underside of leaves through which water vapour and gases pass are the:",
   "stomata",
   C("Stomata are leaf pores that allow gas exchange and let water vapour escape.")+
   steps("Leaves must exchange gases and lose vapour","tiny openings are needed","these openings are the stomata."),
   [("xylem","Xylem are internal water tubes, not surface pores."),
    ("veins","Leaf veins are bundles of transport tubes, not the surface pores."),
    ("roots","Roots are below ground; stomata are pores on leaves.")]),

 ("TR","Transpiration from the leaves helps a plant by creating a pull that:",
   "draws water up from the roots",
   C("As leaves lose water vapour, a suction is created that pulls water up the xylem from the roots.")+
   steps("Water escapes from the leaves","this leaves the leaf tubes 'thirsty'","so water is pulled up from the roots to refill them."),
   [("pushes food down to the roots","That is the phloem's job; transpiration pulls water up."),
    ("cools the soil around the roots","Transpiration pulls water up; it does not chiefly cool the soil."),
    ("makes the roots grow longer","Transpiration moves water; it is not the cause of root length.")]),

 ("TR","Single-celled animals like Amoeba do not need a transport system because:",
   "substances reach every part by simple diffusion",
   C("In a tiny one-celled body, oxygen and food can spread directly to all parts, so no transport network is needed.")+
   steps("Amoeba is just one small cell","every part is close to the surface","so substances simply diffuse in and out — no blood needed."),
   [("they never need oxygen","Amoeba does need oxygen; it just gets it by diffusion."),
    ("they have tiny hearts","A one-celled Amoeba has no heart at all."),
    ("they store all food forever","Amoeba uses food continuously; it does not store it forever.")]),

 ("TR","The number of times the heart beats in one minute is called the:",
   "heartbeat rate (pulse rate)",
   C("Counting beats per minute gives the heartbeat or pulse rate.")+
   steps("Count how many times the heart beats","do it for exactly one minute","that count is the heartbeat (pulse) rate."),
   [("blood pressure","Blood pressure is the push of blood on vessel walls, not beats per minute."),
    ("clotting time","Clotting time is how long blood takes to seal a cut, not beats."),
    ("breathing depth","Breathing depth is about the lungs, not the heart's beats.")]),

 ("TR","Compared with arteries, the walls of veins are usually:",
   "thinner, and veins have valves",
   C("Veins carry low-pressure returning blood, so their walls are thinner and they have valves to stop backflow.")+
   steps("Blood in veins is under low pressure","thick walls are not needed","but valves are, to keep blood moving one way."),
   [("thicker, with no valves","Veins are thinner than arteries and do have valves."),
    ("exactly the same as arteries","Vein walls differ from artery walls; they are thinner."),
    ("made of bone","Blood vessel walls are soft tissue, never bone.")]),

 ("TR","Tall trees can raise water many metres to their topmost leaves mainly because of root pressure and:",
   "the pull created by transpiration",
   C("Transpiration from the leaves creates a strong upward pull that lifts water to the treetop.")+
   steps("Leaves at the top lose water vapour","this creates a pull in the xylem","helped by root pressure, water rises high."),
   [("the heart pumping it up","Plants have no heart; transpiration pull does the lifting."),
    ("wind blowing it upward","Wind does not push water up inside the trunk."),
    ("sunlight pushing the water","Sunlight drives transpiration, but does not itself push water up.")]),

 ("TR","Roots take in water from the soil through tiny hair-like outgrowths called:",
   "root hairs",
   C("Root hairs greatly increase the root surface so water and minerals are absorbed easily.")+
   steps("More surface means more absorption","roots grow many fine hairs","these root hairs soak up soil water."),
   [("stomata","Stomata are leaf pores, not the water-absorbing root parts."),
    ("petals","Petals are parts of a flower, not water-absorbing roots."),
    ("phloem","Phloem carries food; it is not the absorbing surface of roots.")]),

 ("TR","Excretion is the removal from the body of:",
   "harmful waste substances made by the body",
   C("Excretion gets rid of the waste products the body produces, such as urea and extra salts.")+
   steps("Body activities make wastes","keeping them would be harmful","so excretion removes them as urine, sweat and breath."),
   [("undigested food only","Removing undigested food is egestion; excretion removes body wastes."),
    ("useful food and oxygen","The body keeps useful food and oxygen; it removes wastes."),
    ("water that the body needs","Excretion removes excess and wastes, not water the body needs to keep.")]),

 ("TR","Into how many chambers is the human heart divided?",
   "four",
   C("The human heart has four chambers — two upper atria and two lower ventricles.")+
   steps("The upper two collect blood — the atria","the lower two pump it out — the ventricles","two plus two makes four chambers."),
   [("two","Two chambers describe a simpler animal heart, not the human one."),
    ("three","A three-chambered heart belongs to some other animals, not humans."),
    ("one","A single chamber cannot keep oxygen-rich and oxygen-poor blood apart; the human heart has four.")]),
]

# ---------- LINES & ANGLES (25) — Maths (several fused with Light) ----------
LA = [
 ("LA","A pair of angles whose measures together add up to 90° are called:",
   "complementary angles",
   C("A pair that sums to 90° is complementary.")+
   steps("Add the two angle measures","if the total is exactly 90°","they are complementary angles."),
   [("supplementary angles","Supplementary angles add to 180°, not 90°."),
    ("vertically opposite angles","Vertically opposite angles are equal, not a 90° sum."),
    ("adjacent angles","Adjacent angles just share an arm; they need not add to 90°.")]),

 ("LA","Two angles whose measures add up to 180° are called:",
   "supplementary angles",
   C("A pair that sums to 180° is supplementary.")+
   steps("Add the two angle measures","if the total is exactly 180°","they are supplementary angles."),
   [("complementary angles","Complementary angles add to 90°, not 180°."),
    ("equal angles","Equal angles need not total 180°."),
    ("right angles","A single right angle is 90°; supplementary is a 180° pair.")]),

 ("LA","The complement of a 35° angle is:",
   "55°",
   C("The complement is what is left after taking the angle from 90°.")+
   steps("Complement = 90° − the angle","90° − 35°","= 55°."),
   [("65°","65° would need the angle to be 25°, not 35°."),
    ("145°","145° comes from 180° − 35°, which is the supplement, not complement."),
    ("35°","An angle equal to itself is not its complement unless it is 45°.")]),

 ("LA","For an angle measuring 110°, its supplement works out to:",
   "70°",
   C("The supplement is what is left after taking the angle from 180°.")+
   steps("Supplement = 180° − the angle","180° − 110°","= 70°."),
   [("80°","80° would need the angle to be 100°, not 110°."),
    ("20°","20° comes from 90° − 70°, mixing up complement and supplement."),
    ("110°","An angle is its own supplement only if it is 90°.")]),

 ("LA","When two straight lines cross, the angles opposite each other at the crossing are always:",
   "equal",
   C("Vertically opposite angles formed by two crossing lines are equal.")+
   steps("Two lines cross at a point","the two angles facing each other","are vertically opposite and so are equal."),
   [("supplementary","Opposite angles are equal; the side-by-side ones are supplementary."),
    ("complementary","Crossing lines do not make the opposite pair add to 90°."),
    ("always 90°","Opposite angles are equal but only 90° if the lines are perpendicular.")]),

 ("LA","Two angles that share a common arm and a common vertex but do not overlap are:",
   "adjacent angles",
   C("Side-by-side angles sharing one arm and the vertex are adjacent.")+
   steps("They meet at the same point (vertex)","they share one ray (arm)","and lie on either side — so they are adjacent."),
   [("vertically opposite angles","Vertically opposite angles face each other across a crossing, not side by side."),
    ("complementary angles","Adjacent angles need not add to 90°."),
    ("alternate angles","Alternate angles arise with a transversal, not just a shared arm.")]),

 ("LA","Two adjacent angles whose outer arms form a straight line add up to:",
   "180°",
   C("Angles on a straight line (a linear pair) always total 180°.")+
   steps("The outer arms make one straight line","a straight angle is 180°","so the two parts add to 180°."),
   [("90°","A straight line is 180°, not 90°."),
    ("360°","A full turn is 360°; a straight line is half of that."),
    ("270°","270° is three right angles, more than a straight line.")]),

 ("LA","In a linear pair, if one angle is 125°, the other angle is:",
   "55°",
   C("A linear pair sums to 180°, so subtract to find the partner.")+
   steps("Two angles on a line add to 180°","180° − 125°","= 55°."),
   [("65°","65° would pair with 115°, not 125°."),
    ("35°","35° comes from 90° − 55°, a complement error."),
    ("125°","The two angles are not equal unless both are 90°.")]),

 ("LA","A line that crosses two other lines is called a:",
   "transversal",
   C("A line cutting across two lines is a transversal, creating eight angles.")+
   steps("Draw two lines","draw a third line cutting both","that cutting line is the transversal."),
   [("perpendicular","A perpendicular meets at 90°; a transversal need not."),
    ("diameter","A diameter is a chord of a circle, not a crossing line of two lines."),
    ("ray","A ray starts at a point and goes one way; that is not the crossing line idea.")]),

 ("LA","If a transversal crosses two parallel lines, then each pair of corresponding angles is:",
   "equal",
   C("Corresponding angles on parallel lines cut by a transversal are equal.")+
   steps("Parallel lines never meet","a transversal makes matching-position angles","these corresponding angles are equal."),
   [("supplementary","Corresponding angles are equal; co-interior angles are supplementary."),
    ("complementary","Corresponding angles are equal, not summing to 90°."),
    ("always right angles","They are equal but only 90° if the transversal is perpendicular.")]),

 ("LA","When a transversal cuts two parallel lines, a pair of alternate interior angles is:",
   "equal",
   C("Alternate interior angles on parallel lines are equal.")+
   steps("Look between the two parallel lines","at the angles on opposite sides of the transversal","these alternate interior angles are equal."),
   [("supplementary","Alternate interior angles are equal; co-interior ones are supplementary."),
    ("complementary","They are equal, not summing to 90°."),
    ("unequal always","On parallel lines alternate interior angles are always equal.")]),

 ("LA","When a transversal cuts two parallel lines, co-interior (same-side interior) angles add up to:",
   "180°",
   C("Co-interior angles on parallel lines are supplementary, totalling 180°.")+
   steps("Take the two interior angles on the same side","on parallel lines they are supplementary","so they add to 180°."),
   [("90°","Co-interior angles sum to 180°, not 90°."),
    ("360°","Two angles cannot make a full turn here; they sum to 180°."),
    ("equal to each other","Same-side interior angles add to 180°; they are not generally equal.")]),

 ("LA","An angle that is more than 90° but less than 180° is called:",
   "an obtuse angle",
   C("Between a right angle and a straight angle lies the obtuse range.")+
   steps("It is bigger than 90°","but smaller than 180°","so it is obtuse."),
   [("an acute angle","An acute angle is less than 90°, not more."),
    ("a right angle","A right angle is exactly 90°."),
    ("a reflex angle","A reflex angle is more than 180°.")]),

 ("LA","An angle greater than 180° but less than 360° is called:",
   "a reflex angle",
   C("The big angle beyond a straight line, but less than a full turn, is reflex.")+
   steps("Bigger than a straight angle (180°)","smaller than a full turn (360°)","so it is reflex."),
   [("an obtuse angle","An obtuse angle is between 90° and 180°, smaller than reflex."),
    ("a straight angle","A straight angle is exactly 180°."),
    ("a complete angle","A complete angle is exactly 360°.")]),

 ("LA","FUSION (Light): a ray of light strikes a plane mirror making a 30° angle with the mirror surface. The angle of incidence, measured from the normal, is:",
   "60°",
   C("The angle of incidence is measured from the normal, which is 90° to the mirror, not from the surface.")+
   steps("Angle with the surface = 30°","normal is 90° to the surface","angle from normal = 90° − 30° = 60°."),
   [("30°","30° is the angle with the surface, not from the normal."),
    ("90°","90° would mean the ray runs along the normal, not at 30° to the mirror."),
    ("120°","An angle of incidence cannot exceed 90°.")]),

 ("LA","FUSION (Light): the law of reflection says the angle of incidence equals the angle of reflection. If a ray hits a mirror at an angle of incidence of 40°, the angle of reflection is:",
   "40°",
   C("By the law of reflection, the reflected angle equals the incident angle.")+
   steps("Law of reflection: incidence = reflection","incidence is 40°","so reflection is also 40°."),
   [("50°","50° is the complement of 40°, not the reflection angle."),
    ("80°","80° is the sum of the two equal angles, not one of them."),
    ("20°","The reflection angle equals the incidence angle, not half of it.")]),

 ("LA","FUSION (Light): a light ray hits a plane mirror straight on, along the normal (angle of incidence 0°). The total angle between the incoming and reflected rays is:",
   "0°",
   C("If the ray comes in along the normal it reflects straight back on itself, so the two rays overlap.")+
   steps("Incidence 0° means the ray runs along the normal","reflection is also 0°","incoming and reflected rays lie together, so the angle between them is 0°."),
   [("90°","A 90° gap would need a 45° angle of incidence, not 0°."),
    ("180°","180° apart would mean the rays go opposite ways along a line, but here they overlap."),
    ("60°","A 60° gap needs a 30° angle of incidence, not 0°.")]),

 ("LA","FUSION (Light): for a ray reflecting off a plane mirror with angle of incidence 35°, the angle between the incident ray and the reflected ray equals:",
   "70°",
   C("The two rays sit on opposite sides of the normal, each at 35°, so the angle between them is the sum.")+
   steps("Incidence = reflection = 35°","they lie either side of the normal","angle between rays = 35° + 35° = 70°."),
   [("35°","35° is one angle from the normal, not the full angle between the rays."),
    ("90°","90° between the rays needs each angle to be 45°, not 35°."),
    ("17.5°","17.5° is half of 35°; the angle between the rays is the sum, not half.")]),

 ("LA","An angle exactly equal to 90° is a:",
   "right angle",
   C("A quarter turn is exactly 90° — a right angle.")+
   steps("A full turn is 360°","one quarter of it","is 90°, a right angle."),
   [("straight angle","A straight angle is 180°, not 90°."),
    ("acute angle","An acute angle is less than 90°."),
    ("reflex angle","A reflex angle is more than 180°.")]),

 ("LA","If two angles are equal and also supplementary, each one must be:",
   "90°",
   C("Two equal angles adding to 180° must each be half of 180°.")+
   steps("Let each angle be x","equal and supplementary means x + x = 180°","so x = 90°."),
   [("45°","Two 45° angles add to 90°, not 180°."),
    ("60°","Two 60° angles add to 120°, not 180°."),
    ("180°","Two 180° angles add to 360°, far more than a supplement.")]),

 ("LA","The angle made by two arms that point in exactly opposite directions along a straight line is a:",
   "straight angle of 180°",
   C("Opposite-pointing arms form a straight line, a straight angle of 180°.")+
   steps("The two arms point opposite ways","they make one straight line","that is a straight angle, 180°."),
   [("right angle of 90°","A right angle is a quarter turn, not a straight line."),
    ("full angle of 360°","A full angle is a complete turn back to start, not a straight line."),
    ("zero angle of 0°","A zero angle has the arms together, not opposite.")]),

 ("LA","Vertically opposite angles are formed when:",
   "two straight lines intersect",
   C("Crossing lines create two pairs of equal, vertically opposite angles.")+
   steps("Two lines cross at one point","four angles appear","the facing pairs are vertically opposite and equal."),
   [("two lines are parallel","Parallel lines never cross, so they form no vertically opposite pair."),
    ("a single ray is drawn","A single ray makes no intersection of two lines."),
    ("two lines never meet","Lines that never meet cannot make a vertical pair.")]),

 ("LA","If two parallel lines are cut by a transversal and one corresponding angle is 75°, then the matching corresponding angle is:",
   "75°",
   C("Corresponding angles on parallel lines are equal, so the matching angle is also 75°.")+
   steps("Corresponding angles are equal on parallel lines","one is 75°","so its match is also 75°."),
   [("105°","105° is the supplement; that is the co-interior partner, not the corresponding one."),
    ("15°","15° is the complement of 75°, not the corresponding angle."),
    ("90°","Corresponding angles equal the given 75°, not a right angle.")]),

 ("LA","Two lines in a plane that never meet, no matter how far they are extended, are called:",
   "parallel lines",
   C("Lines that stay the same distance apart and never meet are parallel.")+
   steps("Extend both lines as far as you like","they keep the same gap","never meeting, they are parallel."),
   [("perpendicular lines","Perpendicular lines do meet, at 90°."),
    ("intersecting lines","Intersecting lines cross at a point; parallel ones never do."),
    ("concurrent lines","Concurrent lines all pass through one point; parallels share none.")]),

 ("LA","An angle that measures less than 90° is called:",
   "an acute angle",
   C("Any angle smaller than a right angle is acute.")+
   steps("Compare the angle with 90°","if it is smaller than a right angle","it is acute."),
   [("an obtuse angle","An obtuse angle is more than 90°, not less."),
    ("a right angle","A right angle is exactly 90°, not less."),
    ("a reflex angle","A reflex angle is more than 180°, far bigger than acute.")]),
]

# ---------- EXPONENTS & POWERS (25) — Maths (several fused with Transportation) ----------
EX = [
 ("EX","In the expression 5³, the number 5 is called the:",
   "base",
   C("The repeated number is the base; the small raised number is the exponent.")+
   steps("5³ means 5 × 5 × 5","the number being multiplied is 5","so 5 is the base."),
   [("exponent","The exponent is the small raised 3, not the 5."),
    ("product","The product is the answer 125, not the base."),
    ("factor count","That is what the exponent tells; the base is the 5.")]),

 ("EX","In the expression 2⁶, the small raised number 6 is the:",
   "exponent",
   C("The raised number telling how many times to multiply is the exponent.")+
   steps("2⁶ means multiply 2 six times","the small 6 gives that count","so 6 is the exponent."),
   [("base","The base is the 2 being multiplied, not the 6."),
    ("sum","6 is not a sum of the factors; it is the exponent."),
    ("quotient","6 here counts factors; it is the exponent, not a quotient.")]),

 ("EX","Worked out in full, the value of 3⁴ is:",
   "81",
   C("3⁴ means 3 multiplied by itself four times.")+
   steps("3 × 3 = 9","9 × 3 = 27","27 × 3 = 81."),
   [("12","12 is 3 × 4, treating the exponent as a multiplier — a common slip."),
    ("64","64 is 4³, the base and exponent swapped."),
    ("27","27 is 3³, one factor short.")]),

 ("EX","The value of 10⁵ is:",
   "1,00,000",
   C("10 raised to a power is 1 followed by that many zeros.")+
   steps("10⁵ = 1 followed by 5 zeros","that is 100000","written 1,00,000."),
   [("10,000","10,000 is 10⁴, one zero short."),
    ("50","50 is 10 × 5, treating the exponent as a multiplier."),
    ("1,000","1,000 is 10³, two zeros short.")]),

 ("EX","Using laws of exponents, 2³ × 2⁴ equals:",
   "2⁷",
   C("When multiplying powers with the same base, add the exponents.")+
   steps("Same base 2","add exponents: 3 + 4 = 7","so the answer is 2⁷."),
   [("2¹²","2¹² comes from multiplying the exponents (3 × 4), which is wrong for this rule."),
    ("4⁷","The base stays 2, not 4, when multiplying same-base powers."),
    ("2¹","2¹ would come from subtracting; here we add the exponents.")]),

 ("EX","Using laws of exponents, 5⁶ ÷ 5² equals:",
   "5⁴",
   C("When dividing powers with the same base, subtract the exponents.")+
   steps("Same base 5","subtract exponents: 6 − 2 = 4","so the answer is 5⁴."),
   [("5³","5³ would need 6 − 3; here it is 6 − 2 = 4."),
    ("5⁸","5⁸ comes from adding exponents, but division means subtracting."),
    ("1⁴","The base stays 5 in division of like bases, not 1.")]),

 ("EX","The value of any non-zero number raised to the power 0, such as 7⁰, is:",
   "1",
   C("Any non-zero number to the power zero equals 1.")+
   steps("7⁰ follows the rule a⁰ = 1","for any non-zero a","so 7⁰ = 1."),
   [("0","Zero is the exponent, not the answer; a⁰ = 1, not 0."),
    ("7","7 is 7¹, not 7⁰."),
    ("70","70 mixes the base and exponent into a number; a⁰ = 1.")]),

 ("EX","Using the power-of-a-power law, (2³)² equals:",
   "2⁶",
   C("To raise a power to another power, multiply the exponents.")+
   steps("(2³)² means 2³ multiplied by itself","multiply exponents: 3 × 2 = 6","so it is 2⁶."),
   [("2⁵","2⁵ comes from adding exponents; the power-of-power rule multiplies them."),
    ("2⁹","2⁹ would be 3 × 3; here it is 3 × 2 = 6."),
    ("4⁶","The base stays 2, not 4, under this rule.")]),

 ("EX","Expressed in standard (scientific) form, the number 47000 is:",
   "4.7 × 10⁴",
   C("Standard form writes a number as a value between 1 and 10 times a power of ten.")+
   steps("Move the decimal to get 4.7","count places moved: 4","so 47000 = 4.7 × 10⁴."),
   [("47 × 10³","The first number must be between 1 and 10; 47 is too big."),
    ("4.7 × 10³","Moving the decimal in 47000 gives 4 places, so 10⁴, not 10³."),
    ("0.47 × 10⁵","The first number must be at least 1; 0.47 is too small.")]),

 ("EX","Written as a power of 2, the number 32 is:",
   "2⁵",
   C("Keep multiplying 2 until you reach 32 and count the factors.")+
   steps("2 × 2 × 2 × 2 × 2","that is five 2's","equal to 32, so 2⁵."),
   [("2⁴","2⁴ = 16, not 32."),
    ("2⁶","2⁶ = 64, too many factors."),
    ("5²","5² = 25, a different number entirely.")]),

 ("EX","Expanded as repeated multiplication, 4³ means:",
   "4 × 4 × 4",
   C("The exponent 3 tells you to use the base 4 three times in a product.")+
   steps("Base is 4, exponent is 3","write 4 three times with × signs","4 × 4 × 4."),
   [("4 × 3","That is multiplying base by exponent, not repeated multiplication."),
    ("3 × 3 × 3 × 3","That is 3⁴, base and exponent swapped."),
    ("4 + 4 + 4","Exponents mean repeated multiplication, not addition.")]),

 ("EX","FUSION (Transportation): a resting heart beats about 72 times a minute. The number of beats in one minute, written in standard form to 1 decimal place, is closest to:",
   "7.2 × 10¹",
   C("Standard form needs a value between 1 and 10 times a power of ten; 72 = 7.2 × 10.")+
   steps("72 beats in a minute","write as 7.2 × 10","that is 7.2 × 10¹."),
   [("72 × 10⁰","72 is not between 1 and 10, so it is not proper standard form."),
    ("7.2 × 10²","7.2 × 10² is 720, ten times too many."),
    ("0.72 × 10²","The leading number must be at least 1; 0.72 is too small.")]),

 ("EX","FUSION (Transportation): a heart beating 72 times a minute beats about 72 × 60 = 4320 times an hour. In standard form, 4320 is:",
   "4.32 × 10³",
   C("Move the decimal so the first number lies between 1 and 10, counting the places.")+
   steps("4320 → 4.320","decimal moved 3 places","so 4320 = 4.32 × 10³."),
   [("4.32 × 10²","10² gives 432, ten times too small."),
    ("43.2 × 10²","The first number 43.2 is more than 10, so not standard form."),
    ("4.32 × 10⁴","10⁴ gives 43200, ten times too large.")]),

 ("EX","FUSION (Transportation): one drop of blood holds roughly 5,000,000 red blood cells. Written in standard form, this count is:",
   "5 × 10⁶",
   C("Count the zeros: 5,000,000 is a 5 followed by six zeros, so 5 × 10⁶.")+
   steps("5,000,000 = 5 followed by 6 zeros","that is 5 × 1,000,000","= 5 × 10⁶."),
   [("5 × 10⁵","10⁵ is 500,000, ten times too few."),
    ("5 × 10⁷","10⁷ is 50,000,000, ten times too many."),
    ("50 × 10⁵","The leading number must be between 1 and 10; 50 is too big.")]),

 ("EX","FUSION (Transportation): an adult body holds about 5 litres of blood. Written in millilitres (1 litre = 1000 mL), 5 litres in standard form is:",
   "5 × 10³ mL",
   C("5 litres × 1000 = 5000 mL, which is 5 × 10³ mL.")+
   steps("5 × 1000 mL = 5000 mL","5000 = 5 followed by 3 zeros","= 5 × 10³ mL."),
   [("5 × 10² mL","10² gives 500 mL, ten times too little."),
    ("5 × 10⁴ mL","10⁴ gives 50000 mL, ten times too much."),
    ("50 × 10² mL","The leading number 50 is more than 10, not standard form.")]),

 ("EX","The number 1,00,00,000 (one crore) is written as a power of ten as:",
   "10⁷",
   C("Count the zeros after the 1: one crore has seven zeros.")+
   steps("1,00,00,000 = 1 followed by 7 zeros","a 1 with n zeros is 10ⁿ","so this is 10⁷."),
   [("10⁶","10⁶ is ten lakh (1,000,000), one zero short of a crore."),
    ("10⁸","10⁸ is ten crore, one zero too many."),
    ("7¹⁰","7¹⁰ is a completely different, far larger number.")]),

 ("EX","Using laws of exponents, 3⁵ ÷ 3⁵ equals:",
   "1",
   C("Dividing a power by itself gives the base to the power 0, which is 1.")+
   steps("Subtract exponents: 5 − 5 = 0","3⁰ by the zero rule","equals 1."),
   [("0","Subtracting the exponents gives 0, but 3⁰ = 1, not 0."),
    ("3","3 is 3¹, but 5 − 5 gives exponent 0, so the answer is 1."),
    ("3⁰ left unsimplified","3⁰ does simplify, and its value is 1.")]),

 ("EX","Comparing the two powers, which is greater — 2⁵ or 5²?",
   "2⁵, because it equals 32 while 5² equals 25",
   C("Work out both powers and compare the results.")+
   steps("2⁵ = 32","5² = 25","32 > 25, so 2⁵ is greater."),
   [("5², because it equals 50","5² is 25, not 50, and 25 is less than 32."),
    ("They are equal","2⁵ = 32 and 5² = 25 are not equal."),
    ("5², because the base is bigger","A bigger base does not always win; here 2⁵ = 32 beats 5² = 25.")]),

 ("EX","Writing 64 as a power of 4 gives:",
   "4³",
   C("Multiply 4 by itself until you reach 64 and count the factors.")+
   steps("4 × 4 = 16","16 × 4 = 64","that is three 4's, so 4³."),
   [("4²","4² = 16, not 64."),
    ("4⁴","4⁴ = 256, too many factors."),
    ("6⁴","6⁴ is a different, far larger number.")]),

 ("EX","Using laws of exponents, (a × b)² equals:",
   "a² × b²",
   C("A product raised to a power means each factor is raised to that power.")+
   steps("(a × b)² = (a × b)(a × b)","group the a's and b's","= a² × b²."),
   [("a² + b²","Squaring a product multiplies the squares; it does not add them."),
    ("a × b²","Both factors are squared, not just b."),
    ("2ab","2ab comes from a different expansion, not (a × b)².")]),

 ("EX","The value of 1 raised to any power, such as 1⁹, is:",
   "1",
   C("One multiplied by itself any number of times stays 1.")+
   steps("1 × 1 = 1","multiplying by 1 never changes the value","so 1⁹ = 1."),
   [("9","9 is the exponent, not the value; 1⁹ = 1."),
    ("0","1 to any power is 1, never 0."),
    ("19","19 mashes base and exponent together; 1⁹ = 1.")]),

 ("EX","Written in standard form, the number 0.0006 is:",
   "6 × 10⁻⁴",
   C("For a small number, move the decimal right and use a negative power of ten.")+
   steps("0.0006 → 6","decimal moved 4 places to the right","so 0.0006 = 6 × 10⁻⁴."),
   [("6 × 10⁴","A positive power would make a huge number, not a tiny one."),
    ("6 × 10⁻³","10⁻³ gives 0.006, ten times too big."),
    ("0.6 × 10⁻³","The leading number should be between 1 and 10; 0.6 is too small.")]),

 ("EX","Using laws of exponents, 7⁴ × 7⁰ equals:",
   "7⁴",
   C("Since 7⁰ = 1, multiplying by it leaves the other power unchanged.")+
   steps("Add exponents: 4 + 0 = 4","so 7⁴ × 7⁰ = 7⁴","(also 7⁰ = 1, so multiplying changes nothing)."),
   [("7⁰","7⁰ = 1; the surviving power is 7⁴, not 7⁰."),
    ("0","Multiplying by 7⁰ = 1 keeps 7⁴; it does not give 0."),
    ("7⁵","Adding 4 + 0 gives 4, not 5.")]),

 ("EX","The value of 2¹⁰ is:",
   "1024",
   C("Double repeatedly ten times starting from 1, or build up the powers of 2.")+
   steps("2⁵ = 32","2¹⁰ = 32 × 32","= 1024."),
   [("100","100 is 10², not a power of 2."),
    ("512","512 is 2⁹, one doubling short."),
    ("2048","2048 is 2¹¹, one doubling too many.")]),

 ("EX","The number 1000 written as a power of ten is:",
   "10³",
   C("A 1 followed by some zeros is ten raised to the count of those zeros.")+
   steps("1000 = 1 followed by 3 zeros","a 1 with 3 zeros is 10³","so 1000 = 10³."),
   [("10²","10² is 100, one zero short of 1000."),
    ("10⁴","10⁴ is 10000, one zero too many."),
    ("3¹⁰","3¹⁰ is a completely different, far larger number than 1000.")]),
]

# ---------- USE-CASE STRINGS (25 each) ----------
LT_UC = [
 "Knowing light travels straight is why a torch beam makes a sharp-edged shadow on a wall.",
 "Spotting a plane mirror is the first step when you fix a mirror on your wardrobe door.",
 "Same-size erect images are why a full-length plane mirror shows your whole outfit truly.",
 "Lateral inversion is why the word AMBULANCE is printed back-to-front on the van's bonnet.",
 "Calling a mirror image virtual explains why you can never catch your reflection on paper.",
 "Recognising a concave mirror helps you understand the shaving and make-up mirrors at home.",
 "Real images on a screen are how a concave mirror focuses a distant lamp to a bright spot.",
 "Erect shrunken images explain why a convex shop mirror watches a whole aisle at once.",
 "Wide-view convex side mirrors are why a scooter rider sees more traffic creeping up behind.",
 "Knowing a lens bends light is the idea behind every magnifying glass and spectacle.",
 "Spotting a convex lens helps you pick the right magnifier to read a tiny medicine label.",
 "A convex magnifying glass is what a stamp collector uses to enlarge a small postmark.",
 "Knowing a concave lens shrinks objects explains the lenses in some short-sight spectacles.",
 "A prism splitting white light is the science behind a glass chandelier's coloured sparkle.",
 "Naming the spectrum helps you remember the seven-colour order of a rainbow.",
 "Water drops splitting sunlight is why a rainbow appears after a passing shower.",
 "Reflected-light seeing explains why a dark room hides even a brightly coloured book.",
 "Reflection is the rule behind every mirror, periscope and shiny shop window you pass.",
 "Equal-distance images explain why your reflection seems to step back as you step back.",
 "A spoon's concave bowl flipping your face shows mirror curving in everyday cutlery.",
 "Screen-catchable real images are the basis of how a film projector throws a picture.",
 "Image-meets-you behaviour is why you can comb your hair right up close to a mirror.",
 "Enlarging concave mirrors are why a dentist can inspect the back of a tiny tooth.",
 "Forward-beaming concave mirrors are why car headlights light the road far ahead.",
 "Repeated mirror images are the trick that fills a kaleidoscope with endless patterns.",
]

TR_UC = [
 "Knowing blood carries food and oxygen is why a balanced diet reaches every cell.",
 "Naming plasma helps you read a blood-test report that lists its watery part.",
 "Haemoglobin's oxygen-carrying role explains why low iron leaves a person tired and pale.",
 "White-cell defence is why doctors check this count when a body is fighting an infection.",
 "Clotting platelets are why a small cut seals itself instead of bleeding forever.",
 "Picturing the heart as a pump explains why exercise makes it beat faster and harder.",
 "Knowing arteries carry blood away is how a nurse explains where a pulse can be felt.",
 "Knowing veins return blood explains why blood is usually drawn from a vein in the arm.",
 "Thin capillaries are why oxygen can slip from blood straight into a working muscle.",
 "Feeling your pulse is a simple way to count your heart rate after running.",
 "Kidneys filtering blood is why a person with kidney trouble may need dialysis.",
 "The ureter's path helps you understand where a painful kidney stone can get stuck.",
 "Sweat cooling by evaporation is why a fan on damp skin feels so refreshing.",
 "Xylem carrying water up is why a cut flower in coloured water turns that colour.",
 "Phloem carrying food explains how a fruit far from the leaves still grows sweet.",
 "Understanding transpiration is why a potted plant wilts on a hot, windy day.",
 "Knowing stomata are leaf pores explains why leaves feel cool and lose water from below.",
 "Transpiration pull is how a tall tree lifts water many metres without any pump.",
 "Diffusion in tiny bodies is why a single-celled pond animal needs no blood at all.",
 "Heart-rate counting is a quick fitness check a coach uses before and after a sprint.",
 "Valves in veins are why standing too long can make blood pool and ankles swell.",
 "Transpiration plus root pressure is the answer to how forests move tonnes of water daily.",
 "Root hairs soaking up water are why gardeners avoid damaging fine roots when transplanting.",
 "Excretion of wastes is why drinking water helps the kidneys flush out body wastes.",
 "Knowing the heart has four chambers explains why doctors listen for two separate beat sounds.",
]

LA_UC = [
 "Complementary angles help a carpenter check two cuts that must add up to a square corner.",
 "Supplementary angles are how you check two angles that should make a straight edge.",
 "Finding a complement quickly is handy when a 90° bracket leaves one angle to work out.",
 "Finding a supplement is how you size the second angle of a straight road junction.",
 "Equal vertically opposite angles let you measure one crossing angle and know its partner.",
 "Adjacent angles describe the two slices either side of a shared spoke on a wheel.",
 "Linear-pair 180° is why a see-saw's two arms make a straight line through the pivot.",
 "Linear-pair subtraction finds a door's open angle from the gap left against the wall.",
 "Spotting a transversal helps you read the angles where a road cuts across two rail lines.",
 "Equal corresponding angles let a draughtsman copy an angle across two parallel guide lines.",
 "Equal alternate angles are the rule a tiler uses to keep a zig-zag pattern lined up.",
 "Co-interior 180° helps a designer check same-side angles between two parallel borders.",
 "Naming an obtuse angle helps describe the wide lean of a reclining chair back.",
 "Naming a reflex angle helps describe how far past straight a clock's hands have swung.",
 "Surface-to-normal conversion is exactly what a physics student does in a mirror experiment.",
 "Equal incidence and reflection is how you aim a torch off a mirror to hit a target.",
 "Straight-back reflection along the normal is why a ball thrown straight at a wall returns.",
 "Adding the two reflection angles tells you how sharply a mirror turns a light beam.",
 "Recognising a right angle is how a mason checks a wall meets the floor squarely.",
 "Equal-and-supplementary reasoning is a quick proof that a perpendicular makes 90° angles.",
 "Naming a straight angle helps describe a perfectly level, fully opened folding ruler.",
 "Knowing crossing lines make vertical angles helps read a road sign's crossed-lines symbol.",
 "Equal corresponding angles let a surveyor transfer a slope across parallel field boundaries.",
 "Knowing parallel lines never meet is why railway tracks are laid an even gap apart.",
 "Naming an acute angle helps describe the sharp tip of a slice of pizza or a pencil point.",
]

EX_UC = [
 "Naming the base helps you read a calculator's power key without confusing the two numbers.",
 "Naming the exponent stops you from multiplying base by power instead of repeating it.",
 "Working out 3⁴ is the kind of quick power a student needs in area and volume sums.",
 "Powers of ten like 10⁵ are how scientists write very large counts without endless zeros.",
 "The add-exponents rule speeds up multiplying big powers in one neat step.",
 "The subtract-exponents rule is how you simplify a fraction of two like powers fast.",
 "The a⁰ = 1 rule saves you from wrongly writing zero when an exponent vanishes.",
 "The power-of-a-power rule helps simplify nested brackets in algebra quickly.",
 "Standard form lets an astronomer write a star's distance compactly as a power of ten.",
 "Writing 32 as 2⁵ is the kind of pattern that helps in computer memory sizes.",
 "Expanding 4³ correctly is what keeps a volume calculation from going badly wrong.",
 "Standard form of a heart rate shows how biology data is tidied for a science report.",
 "Standard form of beats-per-hour shows how repeated counts grow into large tidy numbers.",
 "Writing red-cell counts as 5 × 10⁶ is how a lab records huge cell numbers neatly.",
 "Converting litres of blood to millilitres in standard form links biology to powers of ten.",
 "Writing a crore as 10⁷ helps you compare Indian large numbers with powers of ten.",
 "The divide-to-one result reminds you a quantity over itself always simplifies to 1.",
 "Comparing 2⁵ and 5² warns you that a bigger base does not always make a bigger power.",
 "Writing 64 as 4³ is the kind of factor-spotting useful in simplifying surds later.",
 "The (a × b)² rule is a shortcut for squaring a product in one clean move.",
 "The 1-to-any-power rule stops silly errors when 1 appears with a big exponent.",
 "Negative powers in standard form let a chemist write a tiny measurement like 6 × 10⁻⁴.",
 "Multiplying by a power of zero shows why a factor of 1 never changes a product.",
 "Knowing 2¹⁰ = 1024 is why a kilobyte of memory is 1024, not 1000, bytes.",
 "Writing 1000 as 10³ is how a shopkeeper tidies a thousand into a neat power of ten.",
]


def _with_uc(lst, ucs):
    assert len(lst) == len(ucs) == 25
    out = []
    for it, uc in zip(lst, ucs):
        code, stem, correct, html, distr = it
        out.append((code, stem, correct, html + U(uc), distr))
    return out


LT = _with_uc(LT, LT_UC)
TR = _with_uc(TR, TR_UC)
LA = _with_uc(LA, LA_UC)
EX = _with_uc(EX, EX_UC)

items = []
for i in range(25):
    items += [LT[i], TR[i], LA[i], EX[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=31411,
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
    split = "/".join(str(counts[c]) for c in ("LT", "TR", "LA", "EX"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Light",
                     "Transportation in Animals & Plants",
                     "Lines & Angles",
                     "Exponents & Powers"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
