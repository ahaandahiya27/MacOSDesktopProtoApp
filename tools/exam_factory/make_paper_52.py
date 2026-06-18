# -*- coding: utf-8 -*-
# Boss Challenge Paper 52 — Light · Soil · Integers · Comparing Quantities
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: leans hard into FUSION. A mirror's magnification becomes a
# RATIO; a soil sample's water content becomes a PERCENTAGE; a cave below ground
# and a bird above it becomes a difference of INTEGERS; the fraction of light a
# surface reflects becomes a percent. The child meets a Science situation and
# reaches for a Maths skill.
# Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_52_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_52_<SHORT>_QuestionPaper.pdf
#   Paper_52_<SHORT>_Questions.md
#   Paper_52_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "52"
SHORT = "Light_Soil_Integers_ComparingQuantities"
TITLE = ("Light · Soil · Integers · Comparing Quantities")
LABELS = {
    "LI": "Light",
    "SO": "Soil",
    "IN": "Integers",
    "CQ": "Comparing Quantities",
}

# ---------- LIGHT (25) — several fused with ratios/integers ----------
LI = [
 ("LI","Light from a torch reaches your eye along the shortest path because light travels in:",
   "a straight line",
   C("Light travels in straight lines — this is rectilinear propagation. That is why a beam, a shadow's edge and a sight-line are all straight.")+
   steps("Aim a torch through a small hole","the bright spot lines up straight with the hole and the bulb","so light went in a straight line.")+
   U("A carpenter checks a plank is straight by sighting along its edge — trusting that light travels straight."),
   [("a curved path that bends around corners","If light bent around corners you could see behind walls; instead shadows form, proving straight-line travel."),
    ("a wavy zig-zag through air","Air does not make a torch beam zig-zag; the beam is straight, which is why it casts a sharp shadow."),
    ("only downward toward the ground","A torch can shine upward or sideways; light goes straight in whatever direction it is aimed, not just down.")]),

 ("LI","An object 12 cm in front of a plane mirror forms its image. The distance between the object and its image is:",
   "24 cm",
   C("A plane mirror forms an image as far behind the mirror as the object is in front. So image is 12 cm behind; object to image = 12 + 12 = 24 cm.")+
   steps("Object distance in front = 12 cm","image distance behind = 12 cm (equal)","gap = 12 + 12 = 24 cm.")+
   U("When you step toward a mirror, your reflection rushes to meet you twice as fast — because both distances change together."),
   [("12 cm","12 cm is the object's distance from the mirror alone; the image sits another 12 cm behind, so the full gap is 24 cm."),
    ("6 cm","6 cm halves the object distance; the image is the SAME 12 cm behind, making the object-to-image gap 24 cm."),
    ("0 cm","The image is not on the mirror surface; it appears 12 cm behind it, so object and image are 24 cm apart.")]),

 ("LI","When a ray of light strikes a mirror, the angle of incidence is always:",
   "equal to the angle of reflection",
   C("The law of reflection says the angle of incidence equals the angle of reflection, both measured from the normal (the line perpendicular to the mirror).")+
   steps("Measure the incoming ray from the normal -> angle of incidence","measure the reflected ray from the normal -> angle of reflection","the two angles are equal.")+
   U("A game of carrom or pool relies on this law — the ball leaves the cushion at the same angle it struck."),
   [("twice the angle of reflection","The two angles are exactly EQUAL, not double; doubling would make the reflected ray flatten against the mirror."),
    ("always 90 degrees","A 90 degree angle of incidence means the ray runs along the mirror and never reflects; the two angles are simply equal, whatever their size."),
    ("zero for every ray","Only a ray hitting straight along the normal has a zero angle; for a slanting ray the equal angles are not zero.")]),

 ("LI","A dentist uses a small mirror to see an enlarged image of a tooth. The mirror is:",
   "concave",
   C("A concave mirror curves inward and can form a magnified, erect image of a nearby object — perfect for seeing a tooth bigger than life.")+
   steps("Hold a face close to a concave mirror","the reflection looks larger and upright","that magnifying power is why dentists choose it.")+
   U("A shaving or make-up mirror is concave for the same reason — it enlarges the face for close work."),
   [("convex","A convex mirror always shrinks the image and widens the view; it would make the tooth look smaller, not bigger."),
    ("plane","A plane mirror shows the tooth the same size; the dentist needs it ENLARGED, which only a concave mirror gives up close."),
    ("a flat piece of glass","Plain flat glass without silvering barely reflects and gives no magnification; a curved concave mirror is needed.")]),

 ("LI","The wide-angle mirror on the side of a car shows a small, upright image and a large field of view. It is a:",
   "convex mirror",
   C("A convex mirror bulges outward, always forming a small, erect, virtual image while squeezing a wide scene into view — ideal for spotting traffic.")+
   steps("Curve a mirror outward","it gathers light from a wide region","giving a small upright image of a large area.")+
   U("Shops hang convex mirrors in corners so one mirror watches a whole aisle."),
   [("concave mirror","A concave mirror can enlarge and even flip the image and has a narrow useful view; it would not show a wide road safely."),
    ("plane mirror","A plane mirror shows true size but only a narrow strip; the convex shape is what packs a wide view into a small mirror."),
    ("a magnifying lens","A lens works by refraction through glass; a car's side mirror reflects, and its outward curve marks it as convex.")]),

 ("LI","The word AMBULANCE is painted reversed on the front of the vehicle so that, in a driver's mirror, it reads correctly. This is because a plane mirror causes:",
   "lateral inversion",
   C("A plane mirror swaps left and right — lateral inversion. Printing the word reversed cancels the swap, so the mirror shows it the right way round.")+
   steps("A mirror flips left and right","print AMBULANCE flipped on the bonnet","the mirror flips it back to normal for the driver ahead.")+
   U("Hold any printed word up to a mirror and watch the letters reverse — the same effect, used cleverly on ambulances."),
   [("magnification","Magnification changes SIZE, not left-right order; a plane mirror keeps size the same and only swaps sides."),
    ("dispersion","Dispersion splits white light into colours through a prism; it has nothing to do with letters reading backward in a mirror."),
    ("total reflection of colour","The colour is unchanged in a mirror; what flips is the LEFT-RIGHT orientation, called lateral inversion.")]),

 ("LI","An image that can be caught on a screen, because rays of light actually meet there, is called a:",
   "real image",
   C("A real image forms where reflected or refracted rays actually cross, so it can be projected onto a screen. A virtual image only appears to be there.")+
   steps("If light rays genuinely meet at a point","a screen placed there catches a picture","that projected picture is a real image.")+
   U("A cinema projector throws a real image onto the screen — rays truly meet on the cloth."),
   [("virtual image","A virtual image cannot be caught on a screen because the rays only SEEM to come from it; a real image is the one that projects."),
    ("erect image","'Erect' describes orientation, not whether it can be projected; the screen-catching property defines a REAL image."),
    ("diminished image","'Diminished' describes size only; whether a screen can catch it depends on rays actually meeting, which makes it real.")]),

 ("LI","Sunlight passing through a glass prism spreads into a band of seven colours. This splitting of white light is called:",
   "dispersion",
   C("White light is a mixture of seven colours. A prism bends each colour by a different amount, fanning them out — this is dispersion (VIBGYOR).")+
   steps("Send white sunlight into a prism","each colour bends by a slightly different angle","they spread into the band V-I-B-G-Y-O-R.")+
   U("A rainbow forms when raindrops act like tiny prisms, dispersing sunlight into a coloured arc."),
   [("reflection","Reflection bounces light off a surface keeping it white; the prism SPLITS the colours, which is dispersion."),
    ("lateral inversion","Lateral inversion is the left-right swap of a mirror image; it does not separate white light into colours."),
    ("magnification","Magnification changes size; spreading white light into seven colours is dispersion, not enlargement.")]),

 ("LI","Two plane mirrors are placed at right angles (90 degrees) to each other. The number of images of an object placed between them is:",
   "3",
   C("For mirrors at angle A, number of images = (360 / A) - 1. At 90 degrees that is 360/90 - 1 = 4 - 1 = 3.")+
   steps("Use images = 360 / angle - 1","= 360 / 90 - 1","= 4 - 1 = 3 images.")+
   U("A kaleidoscope uses angled mirrors to multiply one bead into many — the smaller the angle, the more images."),
   [("2","Using 360/90 gives 4, and subtracting 1 gives 3, not 2; 2 would come from a 120 degree angle."),
    ("4","4 is 360/90 before subtracting 1; the formula removes the object itself, leaving 3 images."),
    ("infinite","Infinite images appear only when mirrors are PARALLEL (angle 0); at 90 degrees the count is a finite 3.")]),

 ("LI","A 3 cm tall object placed before a concave mirror gives an image 9 cm tall. The ratio of image height to object height (the magnification) is:",
   "3 : 1",
   C("Magnification compares image height to object height as a ratio. Here 9 cm : 3 cm simplifies to 3 : 1, meaning the image is three times taller.")+
   steps("Write image : object = 9 : 3","divide both by 3","ratio = 3 : 1.")+
   U("A microscope's '40x' marking is exactly this idea — the image is forty times the size of the real object."),
   [("1 : 3","1 : 3 is upside down; that would mean the image is SMALLER. Image 9 over object 3 gives 3 : 1, an enlargement."),
    ("9 : 1","9 : 1 forgets to divide by the object's 3 cm; the simplified ratio of 9 : 3 is 3 : 1."),
    ("6 : 1","6 : 1 wrongly subtracts (9 - 3); magnification DIVIDES the heights, giving 9 / 3 = 3, so 3 : 1.")]),

 ("LI","We are able to see this page, even though it does not glow, because it:",
   "reflects light into our eyes",
   C("Non-luminous objects do not make their own light; we see them only when light from a source bounces off them into our eyes.")+
   steps("A source (Sun or bulb) lights the page","the page reflects that light","the reflected light enters the eye, so we see it.")+
   U("In a fully dark room the same page is invisible — no light to reflect — proving we see by reflected light."),
   [("produces its own light","A page is non-luminous; it makes no light of its own. We see it only by the light it reflects."),
    ("absorbs all the light falling on it","If it absorbed ALL light it would look pure black and be hard to see; it must REFLECT light to be visible."),
    ("bends light by refraction","Refraction is bending through a transparent medium; a paper page is seen because it REFLECTS, not refracts.")]),

 ("LI","Reflection of light from a rough, uneven surface, which sends rays off in many directions, is called:",
   "diffused (irregular) reflection",
   C("On a rough surface each tiny part faces a different way, so parallel rays scatter in many directions — diffused reflection. No clear image forms.")+
   steps("Parallel rays hit a bumpy surface","each bump reflects its ray a different way","the rays scatter, giving diffused reflection.")+
   U("A matte wall lets everyone in a room see it from any angle precisely because it scatters light diffusely."),
   [("regular reflection","Regular reflection happens on a SMOOTH surface like a mirror and forms a clear image; a rough surface scatters light instead."),
    ("total internal reflection","That is a special trapping of light inside glass or water; a rough wall simply scatters light in many directions."),
    ("dispersion","Dispersion splits white light into colours; a rough surface scatters rays directionally without separating their colours.")]),

 ("LI","A periscope, used to see over a wall, works using two plane mirrors fixed inside a tube at an angle of:",
   "45 degrees to the tube",
   C("Each mirror is set at 45 degrees so light turns through 90 degrees at the top, runs down the tube, and turns 90 degrees again to reach the eye.")+
   steps("Top mirror at 45 deg turns the view down the tube","light travels down","bottom mirror at 45 deg turns it into the eye.")+
   U("Sailors in submarines raise a periscope to see ships on the surface while staying hidden underwater."),
   [("90 degrees flat against the tube","A mirror flat across (90 deg to the path) would send light straight back; a 45 degree tilt is needed to turn the view by 90 degrees."),
    ("0 degrees, lying along the tube","A mirror lying flat along the tube cannot redirect light into and out of it; the 45 degree tilt does the turning."),
    ("30 degrees to the tube","30 degrees would not turn the light a clean 90 degrees down and across; the geometry needs 45 degrees at each mirror.")]),

 ("LI","A convex lens is thicker in the middle and bends parallel rays so that they:",
   "converge to a point",
   C("A convex (converging) lens is thickest at its centre and brings parallel rays together at its focus — which is why it can burn paper in sunlight.")+
   steps("Parallel sunlight enters a convex lens","the curved glass bends rays inward","they meet at the focal point, a bright hot spot.")+
   U("A magnifying glass is a convex lens; tilt it in the sun and the converged spot can scorch a dry leaf."),
   [("spread apart and never meet","Spreading rays apart is what a CONCAVE lens does; a convex lens, thicker in the middle, brings them together."),
    ("turn back the way they came","Lenses transmit light forward by bending it; they do not send parallel rays straight back like a mirror."),
    ("change colour to red","A simple lens does not recolour light; a convex lens CONVERGES the rays to a focus.")]),

 ("LI","In a rainbow the colours always appear in a fixed order, with the colour on the outer edge being:",
   "red",
   C("A rainbow runs from red on the outside to violet on the inside (VIBGYOR read inward). Red bends least, so it sits on the outer arc.")+
   steps("Raindrops disperse sunlight","red light bends the least, violet the most","so red lands on the outer edge of the arc.")+
   U("Spotting red on the outside is a quick way to tell a real rainbow from a flipped reflection or a painting."),
   [("violet","Violet bends the MOST and so forms the INNER edge of the rainbow; red, bending least, is on the outside."),
    ("green","Green sits in the MIDDLE of the band (the G in VIBGYOR), never on the outer edge, which is red."),
    ("white","A rainbow is white light already SPLIT into colours; there is no white band, and the outer edge is red.")]),

 ("LI","Standing between two parallel plane mirrors facing each other, you see an endless line of repeating images. The number of images formed is:",
   "infinite (very large)",
   C("Parallel mirrors keep reflecting each other's images back and forth, so in theory the number is infinite — each image becomes an object for the other mirror.")+
   steps("Mirror 1 makes an image","mirror 2 reflects that image","mirror 1 reflects it again... endlessly, giving infinite images.")+
   U("A barber's two facing mirrors let you see the back of your head in an unending tunnel of reflections."),
   [("exactly two","Two facing mirrors do not stop at two; each image is re-reflected again and again, giving an endless series."),
    ("three","Three is the count for mirrors at 90 degrees; PARALLEL mirrors give an effectively infinite number."),
    ("none","Each mirror clearly forms images; facing them toward each other multiplies the images endlessly, not to zero.")]),

 ("LI","A 5 cm tall pencil is held upright before a plane mirror. The height of its image in the mirror is:",
   "5 cm",
   C("A plane mirror forms an image of exactly the same size as the object — magnification 1 : 1. So a 5 cm pencil has a 5 cm image.")+
   steps("Plane mirror magnification = 1","image height = object height","= 5 cm.")+
   U("That is why you appear life-size in a bathroom mirror — a plane mirror never shrinks or enlarges."),
   [("10 cm","10 cm would be double size, but a plane mirror keeps the SAME size; the image is 5 cm tall."),
    ("2.5 cm","2.5 cm halves the height; a plane mirror does not shrink the object — the image stays 5 cm."),
    ("0 cm","The image is fully formed and the same size as the pencil, 5 cm tall, not zero.")]),

 ("LI","Of every 100 units of light striking it, a certain shiny surface reflects 80 units. The percentage of light it reflects is:",
   "80%",
   C("Percentage means 'out of 100'. Reflecting 80 units out of every 100 is, by definition, 80% — a highly reflective surface.")+
   steps("Reflected out of 100 = 80","percentage = 80 out of 100","= 80%.")+
   U("Mirror makers quote reflectivity as a percentage; a good bathroom mirror reflects well over 90% of the light."),
   [("20%","20% is the light NOT reflected (absorbed or passed through); the reflected part is 80 out of 100, i.e. 80%."),
    ("8%","8% misplaces a decimal; 80 out of 100 is 80%, not 8%."),
    ("800%","A surface cannot reflect more light than falls on it; 80 out of 100 is 80%, which is less than 100%.")]),

 ("LI","A concave mirror is used in a car's headlight and a torch chiefly to:",
   "gather light into a strong parallel beam",
   C("With the bulb at its focus, a concave mirror reflects the light into a powerful parallel beam that travels far ahead — exactly what a headlight needs.")+
   steps("Place the bulb at the focus of a concave mirror","rays reflect off the curve","they leave as a strong parallel beam.")+
   U("A lighthouse uses the same trick to throw a beam many kilometres out to sea."),
   [("spread the light in every direction","Spreading light everywhere wastes it; the concave mirror's job is to FOCUS the light into a forward beam."),
    ("change the colour of the bulb","A concave mirror does not recolour light; it shapes the bulb's light into a directed beam."),
    ("make the bulb last longer","Mirror shape does not affect bulb life; it is used to concentrate the light into a beam.")]),

 ("LI","A virtual image, such as the one you see in an ordinary plane mirror, differs from a real image because it:",
   "cannot be caught on a screen",
   C("A virtual image forms where rays only APPEAR to meet (behind the mirror). No light actually reaches that point, so a screen there catches nothing.")+
   steps("Rays seem to come from behind the mirror","but no real light is there","so a screen placed behind catches no picture.")+
   U("You can see yourself in a mirror but cannot project that reflection onto a wall — it is a virtual image."),
   [("is always upside down","A plane-mirror virtual image is upright, not inverted; the defining trait is that it CANNOT be projected."),
    ("is always larger than the object","A plane-mirror image is the same size; 'virtual' means it cannot be caught on a screen, regardless of size."),
    ("glows with its own light","A virtual image makes no light; it is simply where rays appear to come from and cannot be projected.")]),

 ("LI","A concave lens (thinner in the middle) always forms an image that is:",
   "virtual, erect and smaller than the object",
   C("A concave lens spreads rays apart, so they only appear to come from a point on the same side — giving a virtual, upright, diminished image for any object.")+
   steps("Parallel rays enter a concave lens","the thin-centred lens diverges them","they seem to come from a near point -> small, upright, virtual image.")+
   U("A peephole in a door uses a concave-style lens idea to give a small, wide, upright view of the visitor."),
   [("real, inverted and larger","A concave lens cannot make a real or enlarged image; it diverges light, always giving a small virtual upright image."),
    ("real and the same size","A concave lens never forms a real image; the image is virtual and smaller than the object."),
    ("inverted but the same size","A concave-lens image is upright (erect), not inverted, and is diminished, not same size.")]),

 ("LI","The image formed by a plane mirror is best described as:",
   "virtual, erect, same size and laterally inverted",
   C("A plane mirror gives an image that is virtual (cannot be projected), erect (upright), the same size as the object, and laterally inverted (left-right swapped).")+
   steps("It is behind the mirror -> virtual","upright -> erect","same size, with left and right swapped -> laterally inverted.")+
   U("Knowing these four facts explains why text looks reversed yet upright and life-size when held to a mirror."),
   [("real, inverted and magnified","A plane-mirror image is virtual and the same size, not real, upside-down or enlarged."),
    ("virtual, upside down and smaller","A plane mirror keeps the image upright and the same size; it is not inverted or diminished."),
    ("real, erect and the same size","The image cannot be caught on a screen, so it is VIRTUAL, not real, though it is erect and same size.")]),

 ("LI","Among a plane mirror, a concave mirror and a convex mirror, the one whose image is always smaller than the object is the:",
   "convex mirror",
   C("A convex mirror diverges reflected rays, so it always produces a diminished, erect, virtual image — never larger than the object.")+
   steps("Plane mirror -> same size","concave mirror -> can be larger or smaller","convex mirror -> always smaller.")+
   U("That 'always smaller' image is why convex mirrors squeeze a wide car-park into one small security mirror."),
   [("plane mirror","A plane mirror gives a SAME-size image, not a smaller one; the always-smaller image comes from a convex mirror."),
    ("concave mirror","A concave mirror can ENLARGE an object (as for a dentist); only the convex mirror always shrinks the image."),
    ("all three equally","The three behave differently: plane keeps size, concave can enlarge, convex always shrinks.")]),

 ("LI","A ray of light hits a plane mirror so that its angle of incidence is 30 degrees. The angle between the incident ray and the reflected ray is:",
   "60 degrees",
   C("Incidence equals reflection, so the reflected ray is also 30 degrees from the normal. The two rays lie on opposite sides of the normal, so the angle between them is 30 + 30 = 60 degrees.")+
   steps("Angle of reflection = angle of incidence = 30 deg","both measured from the normal, opposite sides","angle between rays = 30 + 30 = 60 deg.")+
   U("Aligning a laser to bounce at a known angle, as in some science demos, uses exactly this doubling rule."),
   [("30 degrees","30 degrees is each ray's angle from the NORMAL; the angle BETWEEN the two rays is the sum, 60 degrees."),
    ("90 degrees","90 degrees would need each ray at 45 degrees; here each is 30 degrees, so the rays are 60 degrees apart."),
    ("15 degrees","15 degrees halves the incidence; the angle between the rays is the SUM of the two equal angles, 60 degrees.")]),

 ("LI","Sunlight appears white, but a prism shows it is really made up of:",
   "seven colours mixed together",
   C("White sunlight is a blend of seven colours (VIBGYOR). A prism separates them, proving white light is a mixture, not a single colour.")+
   steps("Pass white light through a prism","it fans out into V-I-B-G-Y-O-R","so white light is a mixture of those seven colours.")+
   U("A spinning Newton's colour disc reverses the trick — mixing the seven colours back to near-white."),
   [("a single pure colour","If white light were a single colour a prism could not split it; it fans into seven colours, proving it is a mixture."),
    ("only red and blue","White light contains the whole VIBGYOR band of seven colours, not just two."),
    ("no colour at all","White is the result of all colours together, not the absence of colour; a prism reveals the seven hidden colours.")]),
]

# ---------- SOIL (25) — several fused with percentages/integers ----------
SO = [
 ("SO","The dark, crumbly material in topsoil, formed from rotted dead plants and animals, is called:",
   "humus",
   C("Humus is decayed organic matter. It darkens the topsoil, holds moisture and supplies nutrients, making the soil fertile.")+
   steps("Dead leaves and animals decay","they form a dark spongy material","that material, humus, enriches the topsoil.")+
   U("A gardener's compost heap turns kitchen scraps into humus to feed the garden beds."),
   [("bedrock","Bedrock is the hard rock at the BOTTOM of the soil profile; humus is the dark organic matter in the topsoil."),
    ("clay","Clay is a type of fine mineral particle, not decayed life; the rotted organic matter is called humus."),
    ("gravel","Gravel is small stones; humus is the dark decayed plant-and-animal matter that enriches topsoil.")]),

 ("SO","Reading a soil profile from the surface downward, the correct order of layers is:",
   "topsoil, then subsoil, then bedrock",
   C("A soil profile has horizons: topsoil (A) richest in humus on top, subsoil (B) below, and hard bedrock (C) at the bottom.")+
   steps("Surface, dark and rich -> topsoil","next, more minerals less humus -> subsoil","hard unbroken rock at the base -> bedrock.")+
   U("When builders dig a foundation they pass through topsoil and subsoil before striking firm bedrock."),
   [("bedrock, then subsoil, then topsoil","That is upside down; bedrock is at the BOTTOM. From the surface down it is topsoil, subsoil, bedrock."),
    ("subsoil, then topsoil, then bedrock","Topsoil is the TOP layer, above the subsoil; the order from the surface is topsoil, subsoil, bedrock."),
    ("topsoil, then bedrock, then subsoil","Subsoil lies between topsoil and bedrock; bedrock is last, so the order is topsoil, subsoil, bedrock.")]),

 ("SO","The layer of a soil profile that is darkest and richest in humus, where most plant roots grow, is the:",
   "topsoil",
   C("Topsoil is the uppermost layer, dark with humus and full of nutrients, air and soil organisms — the zone where most roots feed.")+
   steps("Humus collects at the surface","making the top layer dark and fertile","roots crowd this topsoil to feed.")+
   U("Farmers protect topsoil from erosion because losing it means losing the most fertile part of the field."),
   [("subsoil","Subsoil has LESS humus and is paler; the dark humus-rich layer where roots feed is the topsoil above it."),
    ("bedrock","Bedrock is solid rock with no humus and no roots; the humus-rich rooting layer is the topsoil."),
    ("the water table","The water table is the underground level of saturated ground, not a humus-rich soil layer; that is the topsoil.")]),

 ("SO","The slow breaking down of rocks into fine particles by sun, water, wind and living things, which forms soil, is called:",
   "weathering",
   C("Weathering breaks big rocks into smaller and smaller pieces over very long times. These particles, mixed with humus, become soil.")+
   steps("Sun, rain, wind and roots attack rock","the rock cracks and crumbles over ages","the fine particles plus humus form soil.")+
   U("The sand on a riverbank is rock that weathering has ground down over thousands of years."),
   [("evaporation","Evaporation is water turning to vapour; it does not crush rock into soil. Rock break-down is weathering."),
    ("condensation","Condensation is vapour turning back to liquid; soil forms from rock by weathering, not condensation."),
    ("germination","Germination is a seed sprouting; the breaking of rock into soil particles is called weathering.")]),

 ("SO","Soil made of very fine, tightly packed particles that holds the most water and feels sticky when wet is:",
   "clayey soil",
   C("Clayey soil has the smallest particles packed closely, leaving tiny gaps. It traps water well, drains slowly and turns sticky when wet.")+
   steps("Tiny clay particles pack tightly","little air space, water held strongly","so clayey soil is sticky and water-retaining.")+
   U("Potters choose clayey soil because its fine sticky particles can be shaped and hold together."),
   [("sandy soil","Sandy soil has LARGE particles and big gaps, so water drains fast and it feels gritty, not sticky."),
    ("loamy soil","Loamy soil is a balanced mixture that drains moderately; the fine, sticky, water-holding soil is clayey."),
    ("gravelly soil","Gravel is coarse stones with huge gaps and almost no water retention; the sticky water-holder is clay.")]),

 ("SO","Through which soil does water drain (percolate) the fastest, because its large particles leave big air spaces?",
   "sandy soil",
   C("Sandy soil has large particles with wide gaps, so water rushes straight through — it has the highest percolation rate and the lowest water retention.")+
   steps("Big sand particles leave large gaps","water flows quickly through the gaps","so sandy soil percolates fastest.")+
   U("Cacti grow in sandy desert soil that drains so fast their roots never sit in water."),
   [("clayey soil","Clayey soil has the SMALLEST gaps, so water drains slowest; sandy soil with big gaps percolates fastest."),
    ("loamy soil","Loamy soil drains at a MIDDLE rate; the fastest-draining soil is sandy because of its large particles."),
    ("black cotton soil","Black cotton soil is clay-rich and holds water tightly; sandy soil is the fast-draining one.")]),

 ("SO","The soil best suited for growing most crops, because it holds enough water yet still drains and is rich in humus, is:",
   "loamy soil",
   C("Loamy soil is a balanced mixture of sand, silt and clay plus humus. It holds water for roots but still lets excess drain — ideal for farming.")+
   steps("Mix sand (drainage), clay (water-holding) and humus (nutrients)","you get a balanced soil","loam, the best general crop soil.")+
   U("Vegetable gardeners aim for crumbly loam because almost every common crop thrives in it."),
   [("pure clayey soil","Pure clay waterlogs roots and drains poorly; the balanced crop soil is loam, not heavy clay."),
    ("pure sandy soil","Pure sand drains too fast and holds few nutrients; loam, a balanced mixture, suits most crops best."),
    ("gravelly soil","Gravel holds almost no water or nutrients; the fertile, balanced soil for crops is loam.")]),

 ("SO","In a percolation test, 200 mL of water takes 40 minutes to pass through a soil sample. The percolation rate (amount per minute) is:",
   "5 mL per minute",
   C("Percolation rate = amount of water divided by time taken. Here 200 mL / 40 min = 5 mL per minute.")+
   steps("Rate = water / time","= 200 mL / 40 min","= 5 mL per minute.")+
   U("Comparing percolation rates this way tells a farmer how quickly a field will drain after heavy rain."),
   [("8 mL per minute","8 mL/min would need 320 mL in 40 minutes; 200 mL over 40 minutes is 5 mL per minute."),
    ("40 mL per minute","40 is the TIME in minutes, not the rate; the rate is 200 / 40 = 5 mL per minute."),
    ("0.2 mL per minute","0.2 divides 40 by 200 the wrong way; rate is water OVER time, 200 / 40 = 5 mL per minute.")]),

 ("SO","Paddy (rice) is grown in fields kept flooded with water. The most suitable soil for paddy is therefore:",
   "clayey soil",
   C("Rice needs standing water around its roots. Clayey soil, with its tiny gaps, holds water and drains slowly — keeping the paddy field flooded.")+
   steps("Rice roots need water held around them","clayey soil retains water and drains slowly","so clay keeps the paddy field flooded.")+
   U("The flooded, clay-bottomed terraces of rice farms stay full of water for weeks thanks to this property."),
   [("sandy soil","Sandy soil drains too fast to keep a paddy field flooded; clay, which holds water, suits rice."),
    ("loamy soil","Loam drains moderately and would not hold standing water as well as clay, which paddy needs."),
    ("gravelly soil","Gravel lets water rush straight through; rice needs the water-holding clayey soil instead.")]),

 ("SO","Earthworms are called a farmer's friend mainly because, as they burrow, they:",
   "loosen the soil and let in air",
   C("Earthworms tunnel through soil, mixing it and creating channels. This aeration and loosening help roots breathe and water soak in.")+
   steps("Worms burrow through the soil","their tunnels add air spaces and mix layers","so roots get air and water drains in better.")+
   U("Gardeners welcome earthworms as a sign of healthy, well-aerated soil."),
   [("eat the roots of crops","Earthworms feed on dead organic matter, not living roots; they HELP crops by aerating the soil."),
    ("make the soil more acidic","Earthworms do not acidify soil; their burrowing aerates and loosens it, which helps plants."),
    ("drink up all the soil water","Earthworms do not drain the soil of water; their tunnels actually help water soak in.")]),

 ("SO","A soil sample of mass 100 g is dried and loses 18 g as water vapour. The percentage of water in the original sample was:",
   "18%",
   C("Percentage of water = (water mass / total mass) x 100 = (18 / 100) x 100 = 18%.")+
   steps("Water lost = 18 g out of 100 g","percent = 18 / 100 x 100","= 18%.")+
   U("Soil scientists measure moisture exactly this way to decide whether a field needs irrigation."),
   [("82%","82% is the DRY soil that remained; the WATER was 18 g out of 100 g, i.e. 18%."),
    ("1.8%","1.8% misplaces a decimal; 18 out of 100 is 18%, not 1.8%."),
    ("36%","36% wrongly doubles the figure; 18 g of water in 100 g of soil is exactly 18%.")]),

 ("SO","Listed from largest particle to smallest, the correct order is:",
   "gravel, sand, silt, clay",
   C("Soil particles are graded by size: gravel (biggest), then sand, then silt, then clay (smallest). Size controls drainage and water-holding.")+
   steps("Stones -> gravel (largest)","grit -> sand","fine dust -> silt","finest of all -> clay.")+
   U("Engineers sort soil by these grades to judge whether ground will drain or hold water under a building."),
   [("clay, silt, sand, gravel","That is smallest to largest; the question asks LARGEST first, which is gravel, sand, silt, clay."),
    ("sand, gravel, clay, silt","Gravel is bigger than sand, and silt is bigger than clay; the order is gravel, sand, silt, clay."),
    ("silt, clay, sand, gravel","Silt and clay are the SMALL particles, not the largest; the order from biggest is gravel, sand, silt, clay.")]),

 ("SO","The five main components found in a sample of fertile soil are minerals, humus, water, air and:",
   "living organisms",
   C("Soil is a living system: rock-derived minerals, humus, water and air, plus living organisms such as worms, insects and microbes.")+
   steps("Rock particles -> minerals","decayed matter -> humus","held in gaps -> water and air","plus the creatures living in it -> living organisms.")+
   U("Healthy garden soil teems with worms and microbes — the living component that keeps it fertile."),
   [("plastic","Plastic is a pollutant, not a natural component of soil; the living component is the organisms in it."),
    ("acid","Acid is not one of soil's components; the fifth component alongside minerals, humus, water and air is living organisms."),
    ("salt","Excess salt harms soil; the natural fifth component is the living organisms, not salt.")]),

 ("SO","Dumping plastic bags, factory chemicals and excess fertilizer onto land leads to:",
   "soil pollution",
   C("Soil pollution is the adding of harmful substances — plastics, chemicals, excess fertilizer — that damage soil fertility and the life within it.")+
   steps("Harmful waste is dumped on land","it poisons soil organisms and ruins structure","this is soil pollution.")+
   U("Banning thin plastic bags is one step many cities take to cut soil pollution."),
   [("weathering","Weathering is the natural break-up of rock into soil; adding harmful waste is pollution, not weathering."),
    ("percolation","Percolation is water draining through soil; dumping harmful substances is soil pollution."),
    ("germination","Germination is a seed sprouting; harming land with waste is soil pollution.")]),

 ("SO","Two soils are tested: through Soil X, 300 mL of water passes in 30 minutes; through Soil Y, 300 mL passes in 60 minutes. The ratio of their percolation rates (X : Y) is:",
   "2 : 1",
   C("Rate X = 300/30 = 10 mL/min; Rate Y = 300/60 = 5 mL/min. The ratio 10 : 5 simplifies to 2 : 1 — X drains twice as fast.")+
   steps("Rate X = 300 / 30 = 10 mL/min","rate Y = 300 / 60 = 5 mL/min","ratio = 10 : 5 = 2 : 1.")+
   U("Comparing two fields' drainage as a ratio helps a farmer pick which one to plant after the rains."),
   [("1 : 2","1 : 2 is reversed; Soil X (10 mL/min) is FASTER than Soil Y (5 mL/min), so the ratio X : Y is 2 : 1."),
    ("1 : 1","The two rates are not equal: 10 mL/min versus 5 mL/min gives 2 : 1, not 1 : 1."),
    ("30 : 60","30 : 60 compares the TIMES, not the rates; faster soil has the bigger rate, so the rate ratio is 2 : 1.")]),

 ("SO","Why is the hard, unbroken layer at the very bottom of a soil profile called bedrock the most difficult to dig through?",
   "it is solid, unweathered rock not yet broken into particles",
   C("Bedrock is the parent rock that has not yet been weathered into soil. Being solid and unbroken, it is far harder than the loose layers above.")+
   steps("Topsoil and subsoil are broken-up particles","bedrock has NOT been weathered into particles","so it stays solid and hard to dig.")+
   U("Tunnel builders must use heavy machinery once they reach the bedrock beneath the looser soil."),
   [("it is full of soft humus","Humus is in the TOPSOIL, not the bedrock; bedrock is hard because it is solid unweathered rock."),
    ("it is mostly water","Bedrock is dry solid rock, not water; its hardness comes from being unweathered rock."),
    ("it has the most air spaces","Bedrock has almost NO air spaces; the loose top layers do. Its solidity makes it hard to dig.")]),

 ("SO","On a hot afternoon, soil loses moisture because the Sun's heat causes the water in it to:",
   "evaporate into the air",
   C("Heat turns the water held between soil particles into vapour, which escapes into the air — so the soil dries out, especially the surface.")+
   steps("The Sun heats the moist soil","water changes to vapour (evaporation)","the vapour escapes, drying the soil.")+
   U("Farmers mulch fields with straw to shade the soil and slow this evaporation, saving water."),
   [("freeze into ice","Heat does the opposite of freezing; warm soil loses water by evaporation, not by turning to ice."),
    ("turn into humus","Humus comes from decayed life, not from water; the Sun dries soil by evaporating its water."),
    ("sink down to the bedrock","Surface drying is mainly evaporation into the air, not water sinking to the bedrock.")]),

 ("SO","Farmers add manure and compost to their fields chiefly to:",
   "replace humus and return nutrients to the soil",
   C("Crops remove nutrients as they grow. Manure and compost add back humus and nutrients, keeping the soil fertile for the next crop.")+
   steps("Each crop takes nutrients from the soil","manure and compost are rich in humus and nutrients","adding them restores the soil's fertility.")+
   U("Rotating in a cover crop and ploughing it back is another way farmers return humus to tired fields."),
   [("to make the soil drain faster","Manure does not speed drainage; it restores HUMUS and nutrients to keep the soil fertile."),
    ("to kill all the earthworms","Earthworms are helpful and manure supports them; the aim is to replenish humus and nutrients."),
    ("to turn the soil into bedrock","Soil never becomes bedrock; manure is added to renew humus and nutrients, not to harden the soil.")]),

 ("SO","Compared with the hot surface on a summer day, the soil deep inside a cave stays:",
   "cooler",
   C("Soil and rock are poor conductors and shield the depths from the Sun, so deep ground and caves stay cool even when the surface bakes.")+
   steps("The Sun heats only the surface","soil insulates the layers below","so deep soil and caves stay cooler than the surface.")+
   U("Old houses used underground cellars as natural cool stores for food before refrigerators existed."),
   [("hotter than the surface","Deep soil is shielded from the Sun, so it is COOLER, not hotter, than the baking surface."),
    ("exactly the same temperature","Surface heat barely reaches deep down; the cave stays noticeably COOLER than the hot surface."),
    ("always at freezing point","Caves are cool but usually well above freezing; they are simply cooler than the hot summer surface.")]),

 ("SO","The amount of water a soil can hold against gravity, before extra water drains away, is called its:",
   "water-holding capacity",
   C("Water-holding capacity is how much water a soil keeps in its pores after the excess has drained — high for clay, low for sand.")+
   steps("Pour water through soil","some drains away, some is held in the pores","the held amount is the water-holding capacity.")+
   U("Choosing a potting mix with the right water-holding capacity keeps houseplants neither parched nor waterlogged."),
   [("percolation rate","Percolation rate is how FAST water drains through; the amount RETAINED is the water-holding capacity."),
    ("humus content","Humus content is the amount of decayed matter; the water a soil keeps is its water-holding capacity."),
    ("particle size","Particle size influences it but is not the same thing; the retained water itself is the water-holding capacity.")]),

 ("SO","Of every 50 mL of water poured onto a soil sample, 30 mL drains out the bottom. The percentage of water that drained through is:",
   "60%",
   C("Fraction drained = 30 out of 50 = 30/50. As a percentage that is (30/50) x 100 = 60%.")+
   steps("Drained = 30 mL of the 50 mL","percent = 30 / 50 x 100","= 60%.")+
   U("Drainage percentages like this tell builders whether a plot needs extra drains before construction."),
   [("30%","30% would mean 30 mL out of 100; here it is 30 out of 50, which is 60%."),
    ("40%","40% is the fraction RETAINED (20 of 50); the part that DRAINED, 30 of 50, is 60%."),
    ("20%","20% ignores the total of 50 mL; 30 mL out of 50 mL is 60%, not 20%.")]),

 ("SO","Plants grown in pure clayey soil often grow poorly mainly because the soil:",
   "holds too much water and lets in too little air",
   C("Clay's tiny gaps trap water and squeeze out air. Roots, which need air to breathe, suffocate and rot in such waterlogged, poorly aerated soil.")+
   steps("Clay packs tightly with tiny gaps","water fills the gaps, pushing out air","roots starve of air and the plant grows poorly.")+
   U("Gardeners dig sand and compost into heavy clay beds to open up air spaces for healthier roots."),
   [("drains away water far too quickly","That is the fault of SANDY soil; clay holds too much water and too little air, which is the real problem."),
    ("contains far too much humus","Clay is usually LOW in humus; the trouble is poor aeration and waterlogging, not excess humus."),
    ("has particles that are far too large","Clay particles are the SMALLEST; their tininess packs out the air, which is why roots struggle.")]),

 ("SO","Black soil, found in the Deccan region and excellent for cotton, is also known as:",
   "black cotton soil (regur)",
   C("Black cotton soil, or regur, is a fine clay-rich soil that holds moisture well and is famous for growing cotton in the Deccan.")+
   steps("Fine dark clay-rich soil of the Deccan","holds water well, suits cotton","is called black cotton soil, or regur.")+
   U("Cotton farmers in Maharashtra rely on this moisture-holding black soil for their crop."),
   [("laterite soil","Laterite is a reddish soil of high-rainfall regions; the dark cotton-growing soil is black cotton soil (regur)."),
    ("desert sandy soil","Desert sandy soil is pale and drains fast; the dark moisture-holding cotton soil is black cotton soil."),
    ("alluvial soil","Alluvial soil is deposited by rivers; the black, clay-rich cotton soil of the Deccan is regur.")]),

 ("SO","Which property of topsoil most directly explains why it is the layer farmers most want to protect from erosion?",
   "it is the layer richest in humus and nutrients",
   C("Topsoil holds the humus and nutrients crops depend on. Once erosion strips it away, the poorer subsoil left behind grows far less.")+
   steps("Topsoil is rich in humus and nutrients","crops feed mainly from this layer","losing it to erosion ruins fertility, so it is protected.")+
   U("Planting trees and grass along field edges holds the precious topsoil in place against wind and rain."),
   [("it is the hardest layer to dig","The hardest layer is bedrock at the bottom; topsoil is protected because it is the most FERTILE, not the hardest."),
    ("it contains the bedrock","Bedrock is the bottom layer, not part of topsoil; topsoil matters because it holds humus and nutrients."),
    ("it has the largest stones","Large stones are not what makes topsoil valuable; its humus and nutrient richness is why it is protected.")]),

 ("SO","Before sowing seeds a farmer ploughs and loosens the soil mainly so that:",
   "air and water can reach the roots and roots can spread easily",
   C("Ploughing breaks up packed soil, opening air spaces. Loose soil lets air and water reach the seeds and roots, and lets tender roots push through easily.")+
   steps("Packed soil has few air gaps","ploughing loosens it and opens spaces","so air, water and growing roots move through freely.")+
   U("Gardeners turn over a flower bed with a fork for the same reason before planting."),
   [("the soil becomes harder for water to enter","Loosening does the OPPOSITE — it makes water soak in more easily, not less."),
    ("all the humus is removed from the field","Ploughing mixes humus in rather than removing it; its purpose is to aerate and loosen the soil."),
    ("the soil turns into solid bedrock","Soil never becomes bedrock; ploughing loosens it so air, water and roots move freely.")]),
]

# ---------- INTEGERS (25) — several fused with Light/Soil context ----------
IN = [
 ("IN","The result of adding any integer to its additive inverse (its opposite) is always:",
   "0",
   C("An integer and its additive inverse are equal in size but opposite in sign, so they cancel: e.g. 7 + (-7) = 0.")+
   steps("Take an integer and its opposite","they cancel each other","their sum is 0.")+
   U("Depositing the exact amount you owe clears a debt to a zero balance — the same cancelling idea."),
   [("1","Adding opposites gives 0, not 1; 1 is the multiplicative, not additive, identity behaviour."),
    ("the integer itself","Adding 0 leaves a number unchanged, but here we add its OPPOSITE, which gives 0."),
    ("a negative number","Opposites cancel exactly to 0; the result is neither positive nor negative.")]),

 ("IN","The value of (-7) + (+3) is:",
   "-4",
   C("Adding numbers of opposite signs: subtract the smaller size from the larger and keep the larger's sign. 7 - 3 = 4, and the larger size is negative, so -4.")+
   steps("Sizes 7 and 3, opposite signs","subtract: 7 - 3 = 4","larger size is negative, so answer = -4.")+
   U("Starting 7 steps below a mark and moving 3 steps up leaves you 4 steps below — at -4."),
   [("-10","-10 would come from ADDING the sizes; with opposite signs you SUBTRACT, giving -4."),
    ("+4","The sign should follow the larger number, which is -7, so the answer is -4, not +4."),
    ("+10","+10 adds the sizes and picks the wrong sign; opposite signs subtract to give -4.")]),

 ("IN","The product (-5) x (-4) equals:",
   "+20",
   C("Multiplying two negative integers gives a positive product. 5 x 4 = 20, and negative times negative is positive, so +20.")+
   steps("Multiply the sizes: 5 x 4 = 20","negative x negative = positive","so the answer is +20.")+
   U("Removing (negative) a debt (negative) repeatedly leaves you better off — two negatives making a positive."),
   [("-20","Negative times negative is POSITIVE, not negative; (-5) x (-4) = +20."),
    ("-9","-9 adds the numbers instead of multiplying; (-5) x (-4) means 5 x 4 = 20, positive."),
    ("+9","+9 adds rather than multiplies; the product of 5 and 4 is 20, and the sign is positive, so +20.")]),

 ("IN","A diver is 12 m below the sea surface, shown as -12 m. She rises 5 m. Her new position is:",
   "-7 m",
   C("Rising means moving toward the surface, so add a positive: -12 + 5 = -7 m. She is now 7 m below the surface.")+
   steps("Start at -12 m","rise 5 m -> add +5","-12 + 5 = -7 m.")+
   U("A submarine's depth gauge changes exactly like this as it climbs toward the surface."),
   [("-17 m","-17 would mean diving DEEPER; rising 5 m adds +5, giving -12 + 5 = -7 m."),
    ("+7 m","+7 m would be 7 m ABOVE the surface; she is still below it, at -7 m."),
    ("-5 m","-5 m subtracts wrongly; starting at -12 and rising 5 gives -7 m, not -5 m.")]),

 ("IN","On a number line, which of these integers is the greatest?",
   "-3",
   C("On a number line, the number farther to the right is greater. Among -3, -7, -10 and -20, the value -3 lies farthest right, so it is the greatest.")+
   steps("Place -3, -7, -10, -20 on the line","-3 is farthest to the right","so -3 is the greatest.")+
   U("A temperature of -3 deg C is warmer than -7 deg C, just as -3 is greater on the number line."),
   [("-7","-7 lies to the LEFT of -3, so it is smaller; -3 is the greatest of the four."),
    ("-10","-10 is farther left still, hence smaller; the greatest value is -3."),
    ("-20","-20 is the smallest, being farthest left; the greatest is -3.")]),

 ("IN","When you simplify 5 - (-3), the result is:",
   "8",
   C("Subtracting a negative is the same as adding its positive: 5 - (-3) = 5 + 3 = 8.")+
   steps("Subtracting -3 means adding +3","5 + 3","= 8.")+
   U("Wiping out a 3-unit debt (taking away a negative) leaves you 3 better off — adding, not subtracting."),
   [("2","2 comes from 5 - 3; but subtracting a NEGATIVE adds, giving 5 + 3 = 8."),
    ("-8","-8 has the wrong sign; 5 - (-3) becomes 5 + 3 = +8."),
    ("-2","-2 mishandles both signs; 5 - (-3) = 5 + 3 = 8.")]),

 ("IN","The temperature in a hill town was 4 deg C at noon and fell by 9 degrees by midnight. The midnight temperature was:",
   "-5 deg C",
   C("A fall of 9 degrees means subtract 9: 4 - 9 = -5 deg C, which is 5 degrees below zero.")+
   steps("Start at 4 deg C","fall of 9 -> subtract 9","4 - 9 = -5 deg C.")+
   U("Weather reports use negative numbers exactly this way to show temperatures below freezing."),
   [("13 deg C","13 ADDS the 9 degrees; a FALL means subtract, giving 4 - 9 = -5 deg C."),
    ("5 deg C","5 deg C drops the negative sign; 4 - 9 lands BELOW zero at -5 deg C."),
    ("-13 deg C","-13 subtracts from a wrong start or adds extra; 4 - 9 is exactly -5 deg C.")]),

 ("IN","Among all the negative integers, the greatest (largest in value) one is:",
   "-1",
   C("Negative integers get smaller as they go left (-1, -2, -3, ...). The one closest to zero, -1, is the largest of them all.")+
   steps("List negatives: -1, -2, -3, ...","-1 is closest to zero","so -1 is the greatest negative integer.")+
   U("Of two small debts, owing 1 rupee (-1) is the 'best' position — the greatest of the negatives."),
   [("0","0 is neither positive nor negative; the greatest NEGATIVE integer is -1."),
    ("-100","-100 is far to the left and very small; the greatest negative integer is -1."),
    ("1","1 is positive, not negative; among negatives the greatest is -1.")]),

 ("IN","The product (-1) x (-1) x (-1) equals:",
   "-1",
   C("Each pair of negatives makes a positive, but three negatives leave one unpaired. An odd number of negative factors gives a negative product: -1.")+
   steps("(-1) x (-1) = +1","+1 x (-1) = -1","three negatives (odd) -> negative result, -1.")+
   U("Reversing a direction an odd number of times leaves you facing the opposite way — like an odd count of negatives."),
   [("+1","+1 would need an EVEN number of negatives; three negatives (odd) give -1."),
    ("-3","-3 adds the numbers; multiplying three (-1)s gives -1, not -3."),
    ("+3","+3 both adds and picks the wrong sign; the product of three (-1)s is -1.")]),

 ("IN","A cave floor is 8 m below ground level (-8 m) and a bird hovers 6 m above the ground (+6 m). The vertical distance between the bird and the cave floor is:",
   "14 m",
   C("Distance between two levels is the difference of their positions: (+6) - (-8) = 6 + 8 = 14 m apart.")+
   steps("Bird at +6 m, cave floor at -8 m","distance = 6 - (-8) = 6 + 8","= 14 m.")+
   U("Working out the gap between an underground room and a rooftop antenna uses the same above/below subtraction."),
   [("2 m","2 m comes from 8 - 6; because one is above and one below, you ADD: 6 + 8 = 14 m."),
    ("-2 m","Distance is never negative, and -2 mishandles the signs; the gap is 6 + 8 = 14 m."),
    ("48 m","48 multiplies 6 and 8; vertical distance is their SUM here, 14 m, not the product.")]),

 ("IN","The value of (+6) x (-3) is:",
   "-18",
   C("A positive times a negative gives a negative product. 6 x 3 = 18, and the sign is negative, so -18.")+
   steps("Multiply sizes: 6 x 3 = 18","positive x negative = negative","so the answer is -18.")+
   U("Losing 3 rupees on each of 6 days is a total change of -18 rupees — positive count times negative loss."),
   [("+18","Positive times negative is NEGATIVE; (+6) x (-3) = -18, not +18."),
    ("-3","-3 forgets to multiply by 6; six lots of -3 make -18."),
    ("+3","+3 mishandles both the count and the sign; (+6) x (-3) = -18.")]),

 ("IN","The value of (-20) / (+4) is:",
   "-5",
   C("Dividing a negative by a positive gives a negative quotient. 20 / 4 = 5, and the sign is negative, so -5.")+
   steps("Divide sizes: 20 / 4 = 5","negative / positive = negative","so the answer is -5.")+
   U("Sharing a 20-rupee shortfall (-20) equally among 4 friends means each is down 5 rupees, -5."),
   [("+5","Negative divided by positive is NEGATIVE; (-20) / 4 = -5, not +5."),
    ("-16","-16 subtracts 4 from 20; division gives 20 / 4 = 5, with a negative sign, so -5."),
    ("-80","-80 multiplies instead of dividing; (-20) / 4 = -5.")]),

 ("IN","Using the distributive rule, (-3) x (4 + (-6)) equals:",
   "6",
   C("First add inside the bracket: 4 + (-6) = -2. Then (-3) x (-2) = +6 (negative times negative is positive).")+
   steps("4 + (-6) = -2","(-3) x (-2)","= +6.")+
   U("Grouping then multiplying like this is how shopkeepers quickly total repeated gains and losses."),
   [("-6","-6 has the wrong sign; (-3) x (-2) is negative times negative = +6."),
    ("-30","-30 mishandles the bracket as 4 + 6 = 10; correctly 4 + (-6) = -2, so the answer is +6."),
    ("30","30 uses 4 + 6 = 10 inside; the bracket is actually -2, giving (-3) x (-2) = +6.")]),

 ("IN","The predecessor of -9 (the integer just before it) is:",
   "-10",
   C("The predecessor is one less. Going one step left from -9 on the number line lands on -10.")+
   steps("Predecessor means subtract 1","-9 - 1","= -10.")+
   U("If a freezer at -9 deg C drops one more degree, it reads -10 deg C — its predecessor."),
   [("-8","-8 is one MORE than -9 (the successor); the predecessor (one less) is -10."),
    ("-9","-9 is the number itself; its predecessor is one less, -10."),
    ("10","10 is positive and unrelated; the predecessor of -9 is -10.")]),

 ("IN","The absolute value of -8, written |-8|, is:",
   "8",
   C("Absolute value is the distance from zero, always non-negative. -8 is 8 units from zero, so |-8| = 8.")+
   steps("Absolute value = distance from 0","-8 is 8 units from 0","so |-8| = 8.")+
   U("A depth of 8 m below sea level and a height of 8 m above both sit 8 units from sea level — equal absolute values."),
   [("-8","Absolute value is never negative; the distance of -8 from zero is +8."),
    ("0","-8 is 8 units from zero, not 0; |-8| = 8."),
    ("16","16 wrongly doubles the value; the distance of -8 from zero is 8.")]),

 ("IN","The result of dividing any non-zero integer by zero is:",
   "not defined",
   C("Division asks 'how many zeros make this number?' No count of zeros ever totals a non-zero number, so division by zero is not defined.")+
   steps("Ask: zero times what gives, say, 5?","no number works (0 times anything is 0)","so dividing by zero is not defined.")+
   U("A calculator shows 'Error' for 5 / 0 precisely because the operation is undefined."),
   [("0","Dividing by zero is not the same as getting 0; the operation has NO defined result."),
    ("the number itself","Dividing a number by 1 returns it, but dividing by ZERO is not defined at all."),
    ("infinity, as a whole number","Infinity is not an integer answer; in school maths division by zero is simply not defined.")]),

 ("IN","Arranged in ascending order (smallest first), the integers -2, 5, -8, 0 become:",
   "-8, -2, 0, 5",
   C("Ascending means smallest to largest. The most negative comes first: -8, then -2, then 0, then 5.")+
   steps("Most negative first: -8","then -2, then 0","then the positive 5.")+
   U("Sorting daily temperatures from coldest to warmest follows the same smallest-first order."),
   [("5, 0, -2, -8","That is DESCENDING (largest first); ascending puts the smallest, -8, first."),
    ("0, -2, -8, 5","0 is not the smallest; -8 and -2 are smaller, so the order starts -8, -2, then 0, 5."),
    ("-2, -8, 0, 5","-8 is smaller than -2, so it must come first; the order is -8, -2, 0, 5.")]),

 ("IN","Multiplying any integer by -1 has the effect of:",
   "reversing its sign",
   C("Multiplying by -1 flips a positive to negative and a negative to positive, while keeping the size the same: -1 x 7 = -7, -1 x (-7) = 7.")+
   steps("-1 x (+7) = -7","-1 x (-7) = +7","so the sign reverses, size unchanged.")+
   U("Pressing the +/- key on a calculator multiplies the display by -1, flipping its sign."),
   [("doubling its size","Multiplying by -1 keeps the SIZE the same; it only flips the sign."),
    ("making it zero","Multiplying by -1 never gives zero (unless the number was 0); it reverses the sign."),
    ("leaving it unchanged","Multiplying by +1 leaves a number unchanged; multiplying by -1 REVERSES its sign.")]),

 ("IN","The successor of -1 (the integer just after it) is:",
   "0",
   C("The successor is one more. One step right from -1 on the number line lands on 0.")+
   steps("Successor means add 1","-1 + 1","= 0.")+
   U("A thermometer rising one degree from -1 deg C reads 0 deg C — the successor."),
   [("-2","-2 is one LESS than -1 (the predecessor); the successor (one more) is 0."),
    ("1","1 is two more than -1; the successor is just one more, which is 0."),
    ("-1","-1 is the number itself; its successor is one more, 0.")]),

 ("IN","The sum (-15) + (+15) is:",
   "0",
   C("These are opposites (additive inverses) of equal size, so they cancel: -15 + 15 = 0.")+
   steps("-15 and +15 are opposites","opposites cancel","sum = 0.")+
   U("Earning back exactly what you lost returns your balance to zero — opposites cancelling."),
   [("30","30 ADDS the sizes; opposite signs of equal size cancel to 0."),
    ("-30","-30 also wrongly adds the sizes; the opposites cancel to 0."),
    ("15","15 keeps one value; the two opposites cancel completely to 0.")]),

 ("IN","The product of three negative integers, such as (-2) x (-3) x (-1), is:",
   "negative",
   C("Negatives multiply in pairs to give positives; an ODD number of negatives leaves the product negative. Three negatives -> negative.")+
   steps("(-2) x (-3) = +6","+6 x (-1) = -6","three (odd) negatives -> negative product.")+
   U("Counting an odd number of sign-flips always lands you on the opposite sign — the rule behind this."),
   [("positive","A positive needs an EVEN number of negatives; three negatives (odd) give a negative product."),
    ("zero","None of the factors is zero, so the product is not zero; with three negatives it is negative."),
    ("equal to 1","The product's value is -6 here, and in general it is negative, not 1.")]),

 ("IN","On a number line, starting at 0 and taking two steps of -3 each, you land on:",
   "-6",
   C("Two steps of -3 means -3 + (-3) = -6, or 2 x (-3) = -6. You move 6 units to the left of zero.")+
   steps("Step 1: 0 + (-3) = -3","step 2: -3 + (-3) = -6","land on -6.")+
   U("Owing 3 rupees on two separate days leaves you 6 rupees down, at -6."),
   [("6","Steps of -3 go LEFT, to negatives; the result is -6, not +6."),
    ("-3","-3 is only ONE step; two steps of -3 reach -6."),
    ("0","Moving left from 0 does not return to 0; two steps of -3 land on -6.")]),

 ("IN","The additive identity, the integer that leaves any number unchanged when added, is:",
   "0",
   C("Adding 0 to any integer leaves it exactly the same: 7 + 0 = 7. So 0 is the additive identity.")+
   steps("Add 0 to any integer","the integer is unchanged","so 0 is the additive identity.")+
   U("Adding nothing to your bank balance leaves it the same — zero is the 'do-nothing' number for addition."),
   [("1","1 is the MULTIPLICATIVE identity (n x 1 = n); for ADDITION the identity is 0."),
    ("-1","Adding -1 changes a number; the value that leaves it unchanged is 0."),
    ("the number itself","The identity is a single fixed integer, 0, that works for every number, not the number itself.")]),

 ("IN","Reading the integers on a thermometer, which is the LOWEST (coldest) temperature?",
   "-12 deg C",
   C("Lower temperatures are more negative. Among 0, -5, -12 and 3 deg C, -12 is the most negative, so it is the lowest.")+
   steps("Compare 3, 0, -5, -12","the most negative is -12","so -12 deg C is the lowest.")+
   U("Choosing the coldest setting on a freezer dial means picking the most negative temperature."),
   [("-5 deg C","-5 is colder than 0 but warmer than -12; the lowest is -12 deg C."),
    ("0 deg C","0 deg C is warmer than both -5 and -12; the lowest is -12 deg C."),
    ("3 deg C","3 deg C is the WARMEST of these; the coldest is -12 deg C.")]),

 ("IN","Subtracting, (-4) - (-9) comes to:",
   "5",
   C("Subtracting a negative is the same as adding its positive: (-4) - (-9) = -4 + 9 = 5.")+
   steps("Subtracting -9 means adding +9","-4 + 9","= 5.")+
   U("Cancelling a 9-unit debt while 4 units down leaves you 5 units ahead — taking away a negative."),
   [("-13","-13 ADDS the sizes with a negative sign; subtracting a negative adds, giving -4 + 9 = 5."),
    ("-5","-5 has the wrong sign; -4 + 9 lands at +5, not -5."),
    ("13","13 adds the sizes; (-4) - (-9) = -4 + 9 = 5, not 13.")]),
]

# ---------- COMPARING QUANTITIES (25) — several fused with Science ----------
CQ = [
 ("CQ","Reduced to its lowest terms, the ratio 6 : 9 becomes:",
   "2 : 3",
   C("Divide both parts of a ratio by their highest common factor. The HCF of 6 and 9 is 3, so 6 : 9 becomes 2 : 3.")+
   steps("HCF of 6 and 9 is 3","divide both: 6/3 : 9/3","= 2 : 3.")+
   U("A recipe calling for 6 cups flour to 9 cups water is the same as 2 : 3 — handy for scaling down."),
   [("3 : 2","3 : 2 reverses the order; 6 : 9 simplifies to 2 : 3, keeping the smaller number first."),
    ("6 : 9","6 : 9 is not yet in SIMPLEST form; dividing by the HCF 3 gives 2 : 3."),
    ("1 : 2","1 : 2 would need parts in a 1-to-2 ratio; 6 : 9 reduces to 2 : 3, not 1 : 2.")]),

 ("CQ","Converted into a percentage, the fraction 3/5 equals:",
   "60%",
   C("To turn a fraction into a percent, multiply by 100. (3/5) x 100 = 60, so 3/5 = 60%.")+
   steps("Multiply the fraction by 100","(3/5) x 100 = 300/5","= 60%.")+
   U("Scoring 3 out of every 5 questions correct means a test result of 60%."),
   [("35%","35% just reads off the digits 3 and 5; (3/5) x 100 is actually 60%."),
    ("53%","53% swaps the digits; the value of 3/5 as a percent is 60%."),
    ("30%","30% would be 3/10; the fraction 3/5 equals 60%.")]),

 ("CQ","What is 25% of the number 80?",
   "20",
   C("25% means 25/100, or one quarter. One quarter of 80 is 80 / 4 = 20.")+
   steps("25% = 1/4","1/4 of 80 = 80 / 4","= 20.")+
   U("A 25%-off sale on an 80-rupee item saves you 20 rupees."),
   [("25","25 is the PERCENTAGE figure, not 25% OF 80; one quarter of 80 is 20."),
    ("40","40 is 50% (half) of 80; 25% is a quarter, which is 20."),
    ("55","55 is 80 minus 25; 25% of 80 is 80 / 4 = 20.")]),

 ("CQ","A student scored 15 marks out of 25 in a test. As a percentage, the score is:",
   "60%",
   C("Percentage = (marks scored / total marks) x 100 = (15 / 25) x 100 = 60%.")+
   steps("Score = 15 of 25","(15 / 25) x 100","= 60%.")+
   U("Report cards convert raw marks to percentages exactly this way so different tests can be compared."),
   [("15%","15% just repeats the raw marks; out of 25 they become (15/25) x 100 = 60%."),
    ("40%","40% is the part MISSED (10 of 25); the part SCORED, 15 of 25, is 60%."),
    ("75%","75% would be 15 out of 20; here the total is 25, giving 60%.")]),

 ("CQ","In a concave mirror a 4 cm object forms a 12 cm image. The magnification, as the ratio image : object, is:",
   "3 : 1",
   C("Magnification compares image height to object height. 12 cm : 4 cm divides by 4 to give 3 : 1 — the image is three times taller.")+
   steps("Image : object = 12 : 4","divide both by 4","= 3 : 1.")+
   U("Telescope and microscope makers quote this image-to-object ratio as the instrument's magnification."),
   [("1 : 3","1 : 3 is upside down and would mean the image is smaller; 12 over 4 gives 3 : 1, an enlargement."),
    ("4 : 12","4 : 12 is not simplified and is reversed; image : object is 12 : 4 = 3 : 1."),
    ("8 : 1","8 : 1 subtracts (12 - 4); magnification DIVIDES, giving 12 / 4 = 3, so 3 : 1.")]),

 ("CQ","The simple interest on Rs 2000 at 5% per year for 2 years is:",
   "Rs 200",
   C("Simple interest = (P x R x T) / 100 = (2000 x 5 x 2) / 100 = 20000 / 100 = Rs 200.")+
   steps("SI = P x R x T / 100","= 2000 x 5 x 2 / 100","= 20000 / 100 = Rs 200.")+
   U("Knowing how interest is figured lets you check a bank's working on a small fixed deposit."),
   [("Rs 100","Rs 100 is the interest for just ONE year; over 2 years it is doubled to Rs 200."),
    ("Rs 2000","Rs 2000 is the PRINCIPAL, not the interest; the interest earned is Rs 200."),
    ("Rs 2200","Rs 2200 is principal PLUS interest (the amount); the interest alone is Rs 200.")]),

 ("CQ","A shopkeeper buys a pen for Rs 40 and sells it for Rs 50. The profit percentage is:",
   "25%",
   C("Profit = 50 - 40 = Rs 10. Profit% = (profit / cost price) x 100 = (10 / 40) x 100 = 25%.")+
   steps("Profit = 50 - 40 = 10","profit% = (10 / 40) x 100","= 25%.")+
   U("Traders quote profit as a percentage of cost so deals of different sizes can be compared fairly."),
   [("10%","10% uses the rupee profit as if it were the percent; profit% is (10/40) x 100 = 25%."),
    ("20%","20% divides the profit by the SELLING price (10/50); profit% uses the COST, giving 25%."),
    ("50%","50% overstates it; a Rs 10 profit on a Rs 40 cost is 25%, not 50%.")]),

 ("CQ","If 2 kg of apples cost Rs 50, then 5 kg of the same apples cost (by the unitary method):",
   "Rs 125",
   C("Find the cost of 1 kg first: 50 / 2 = Rs 25. Then 5 kg cost 25 x 5 = Rs 125.")+
   steps("1 kg costs 50 / 2 = Rs 25","5 kg cost 25 x 5","= Rs 125.")+
   U("Working out the price per kilo is how shoppers compare which pack is the better deal."),
   [("Rs 100","Rs 100 forgets a kilo; at Rs 25 per kg, 5 kg cost 125, not 100."),
    ("Rs 150","Rs 150 overcounts; 5 kg at Rs 25 each is exactly Rs 125."),
    ("Rs 250","Rs 250 uses the wrong per-kg price; 1 kg is Rs 25, so 5 kg is Rs 125.")]),

 ("CQ","A surface reflects 3 out of every 5 units of light that fall on it. The percentage of light it reflects is:",
   "60%",
   C("Reflecting 3 out of 5 is the fraction 3/5. As a percent, (3/5) x 100 = 60%.")+
   steps("Reflected = 3 of 5","(3/5) x 100","= 60%.")+
   U("Manufacturers rate a mirror's or solar panel's surface by such reflect/absorb percentages."),
   [("3%","3% just reads the digit 3; 3 out of 5 is (3/5) x 100 = 60%."),
    ("40%","40% is the part NOT reflected (2 of 5); the reflected part, 3 of 5, is 60%."),
    ("35%","35% reads off the digits 3 and 5; the actual value of 3/5 is 60%.")]),

 ("CQ","A jacket priced at Rs 800 is sold at a 10% discount. The discount amount is:",
   "Rs 80",
   C("Discount = 10% of the marked price = (10/100) x 800 = Rs 80.")+
   steps("Discount = 10% of 800","= (10/100) x 800","= Rs 80.")+
   U("Reading a '10% off' tag this way tells you instantly how many rupees you save."),
   [("Rs 10","Rs 10 is the percentage figure, not 10% OF 800; the discount is Rs 80."),
    ("Rs 720","Rs 720 is the PRICE AFTER discount (800 - 80); the discount itself is Rs 80."),
    ("Rs 100","Rs 100 would be 12.5% of 800; 10% of 800 is Rs 80.")]),

 ("CQ","The decimal 0.35 expressed as a percentage is:",
   "35%",
   C("To convert a decimal to a percent, multiply by 100. 0.35 x 100 = 35%.")+
   steps("Multiply by 100","0.35 x 100","= 35%.")+
   U("A 0.35 probability of rain is the same as a 35% chance — the form a forecast usually uses."),
   [("3.5%","3.5% multiplies by 10, not 100; 0.35 x 100 is 35%."),
    ("0.35%","0.35% forgets to multiply by 100 at all; 0.35 = 35%."),
    ("350%","350% multiplies by 1000; 0.35 x 100 is 35%.")]),

 ("CQ","A soil sample contains 9 mL of water in every 60 mL of soil. The percentage of water is:",
   "15%",
   C("Percentage = (water / total) x 100 = (9 / 60) x 100 = 900/60 = 15%.")+
   steps("Water = 9 of 60 mL","(9 / 60) x 100","= 15%.")+
   U("Agricultural labs report soil moisture as a percentage to decide irrigation needs."),
   [("9%","9% just reads the millilitres; out of 60 mL the figure is (9/60) x 100 = 15%."),
    ("60%","60% reads off the total instead of computing; 9 of 60 is 15%, not 60%."),
    ("25%","25% would be 15 of 60; here 9 of 60 gives 15%.")]),

 ("CQ","Which is the larger ratio, 3 : 4 or 5 : 8?",
   "3 : 4",
   C("Compare as fractions with a common denominator. 3/4 = 6/8 and 5/8 stays 5/8. Since 6/8 > 5/8, the ratio 3 : 4 is larger.")+
   steps("3 : 4 = 3/4 = 6/8","5 : 8 = 5/8","6/8 > 5/8, so 3 : 4 is larger.")+
   U("Comparing two juice mixes by their concentrate-to-water ratio tells you which tastes stronger."),
   [("5 : 8","5 : 8 equals 5/8, which is LESS than 3/4 (= 6/8); so 3 : 4 is the larger ratio."),
    ("they are equal","3/4 is 6/8, not 5/8, so the ratios are not equal; 3 : 4 is larger."),
    ("cannot be compared","Ratios can always be compared as fractions; here 3 : 4 (6/8) beats 5 : 8.")]),

 ("CQ","If the simple interest earned is Rs 300 on a principal of Rs 2000, the amount (principal plus interest) is:",
   "Rs 2300",
   C("Amount = principal + interest = 2000 + 300 = Rs 2300.")+
   steps("Amount = principal + SI","= 2000 + 300","= Rs 2300.")+
   U("When a deposit matures, the bank pays back this amount — your money plus the interest it earned."),
   [("Rs 300","Rs 300 is only the INTEREST; the amount also includes the Rs 2000 principal, giving Rs 2300."),
    ("Rs 2000","Rs 2000 is only the PRINCIPAL; adding the Rs 300 interest gives the amount, Rs 2300."),
    ("Rs 1700","Rs 1700 SUBTRACTS the interest; the amount ADDS it, giving Rs 2300.")]),

 ("CQ","The ratio 2 : 5 expressed as a percentage is:",
   "40%",
   C("Write the ratio as a fraction 2/5, then multiply by 100: (2/5) x 100 = 40%.")+
   steps("2 : 5 = 2/5","(2/5) x 100","= 40%.")+
   U("Saying 2 out of 5 people prefer a brand is the same as a 40% preference in a survey."),
   [("25%","25% is 1/4; the ratio 2 : 5 is 2/5, which is 40%."),
    ("20%","20% is 1/5; the ratio 2 : 5 is TWO fifths, giving 40%."),
    ("50%","50% is half (1/2); 2 : 5 is 2/5 = 40%.")]),

 ("CQ","60% of the 25 students in a class chose science as their favourite subject. The number of such students is:",
   "15",
   C("60% of 25 = (60/100) x 25 = 0.6 x 25 = 15 students.")+
   steps("60% of 25 = (60/100) x 25","= 0.6 x 25","= 15.")+
   U("Survey results often turn a percentage back into actual numbers of people this way."),
   [("60","60 is the PERCENTAGE, not the count; 60% of 25 students is 15."),
    ("10","10 is the 40% who did NOT choose science; the 60% who did is 15."),
    ("25","25 is the WHOLE class; 60% of them is 15 students.")]),

 ("CQ","The price of a notebook rises from Rs 20 to Rs 25. The percentage increase is:",
   "25%",
   C("Increase = 25 - 20 = Rs 5. Percentage increase = (increase / original) x 100 = (5 / 20) x 100 = 25%.")+
   steps("Rise = 25 - 20 = 5","(5 / 20) x 100","= 25%.")+
   U("News reports give price rises as percentages so a small and a large item's changes can be compared."),
   [("5%","5% treats the rupee rise as the percent; (5/20) x 100 is 25%."),
    ("20%","20% divides the rise by the NEW price (5/25); percentage increase uses the ORIGINAL, giving 25%."),
    ("50%","50% overstates it; a Rs 5 rise on Rs 20 is 25%, not 50%.")]),

 ("CQ","Two ratios are equivalent when they simplify to the same value. Which ratio is equivalent to 3 : 4?",
   "9 : 12",
   C("Multiply both parts of 3 : 4 by the same number. 3 x 3 : 4 x 3 = 9 : 12, which simplifies back to 3 : 4.")+
   steps("Multiply both parts of 3 : 4 by 3","= 9 : 12","9 : 12 simplifies to 3 : 4 -> equivalent.")+
   U("Scaling a recipe up keeps the same ratio of ingredients — 3 : 4 becomes 9 : 12 when tripled."),
   [("4 : 3","4 : 3 reverses the order, giving a different value; the equivalent of 3 : 4 is 9 : 12."),
    ("6 : 12","6 : 12 simplifies to 1 : 2, not 3 : 4; the equivalent ratio is 9 : 12."),
    ("3 : 8","3 : 8 simplifies to 3 : 8, not 3 : 4; the equivalent ratio is 9 : 12.")]),

 ("CQ","Out of 100 units of light striking a window, 90 units pass through. The percentage of light transmitted is:",
   "90%",
   C("Percentage means out of 100. With 90 of every 100 units passing through, the transmission is 90%.")+
   steps("Transmitted = 90 of 100","percent = 90 out of 100","= 90%.")+
   U("Glass and sunglasses are rated by what percentage of light they let through, exactly like this."),
   [("10%","10% is the light BLOCKED or reflected; the part that PASSES, 90 of 100, is 90%."),
    ("9%","9% misplaces a decimal; 90 out of 100 is 90%, not 9%."),
    ("100%","If all 100 passed it would be 100%, but only 90 do, giving 90%.")]),

 ("CQ","The percentage 40% written as a fraction in simplest form is:",
   "2/5",
   C("40% means 40/100. Dividing top and bottom by their HCF, 20, gives 2/5.")+
   steps("40% = 40/100","divide both by 20","= 2/5.")+
   U("Reading '40% of the class' as 2 out of every 5 students makes a survey easier to picture."),
   [("4/10","4/10 is correct but NOT simplest; dividing by 2 again gives 2/5."),
    ("1/4","1/4 is 25%, not 40%; 40% as a simplest fraction is 2/5."),
    ("2/4","2/4 simplifies to 1/2 (50%); 40% is 2/5.")]),

 ("CQ","A 50-litre water tank is 30% full. The volume of water in it is:",
   "15 litres",
   C("30% of 50 litres = (30/100) x 50 = 0.3 x 50 = 15 litres.")+
   steps("30% of 50 = (30/100) x 50","= 0.3 x 50","= 15 litres.")+
   U("A fuel gauge reading 30% on a 50-litre tank means about 15 litres remain."),
   [("30 litres","30 is the PERCENTAGE figure, not 30% OF 50; the volume is 15 litres."),
    ("20 litres","20 litres would be 40% of 50; 30% of 50 is 15 litres."),
    ("35 litres","35 litres is the EMPTY 70%; the water (30%) is 15 litres.")]),

 ("CQ","If 5 pencils cost Rs 30, the cost of 8 such pencils is:",
   "Rs 48",
   C("One pencil costs 30 / 5 = Rs 6. Eight pencils cost 6 x 8 = Rs 48.")+
   steps("1 pencil = 30 / 5 = Rs 6","8 pencils = 6 x 8","= Rs 48.")+
   U("Working out the unit price lets you budget for any number of items at once."),
   [("Rs 30","Rs 30 is the cost of just 5 pencils; 8 pencils at Rs 6 each cost Rs 48."),
    ("Rs 40","Rs 40 undercounts; 8 pencils at Rs 6 each is Rs 48, not Rs 40."),
    ("Rs 56","Rs 56 overcounts; at Rs 6 per pencil, 8 cost Rs 48.")]),

 ("CQ","A magnified image is 7 times the height of the object. Written as a ratio, image height : object height is:",
   "7 : 1",
   C("If the image is 7 times the object, then for every 1 unit of object there are 7 units of image, a ratio of 7 : 1.")+
   steps("Image is 7 times the object","so image : object = 7 : 1","= 7 : 1.")+
   U("A '7x' label on a magnifying glass or binoculars means exactly this 7 : 1 enlargement."),
   [("1 : 7","1 : 7 is upside down and would mean the image is SMALLER; a 7-times enlargement is 7 : 1."),
    ("7 : 7","7 : 7 simplifies to 1 : 1 (same size); a 7-times image is 7 : 1."),
    ("14 : 1","14 : 1 doubles the factor; an image 7 times the object is 7 : 1.")]),

 ("CQ","A class of 40 students has 24 girls. The percentage of girls in the class is:",
   "60%",
   C("Percentage of girls = (24 / 40) x 100 = 2400/40 = 60%.")+
   steps("Girls = 24 of 40","(24 / 40) x 100","= 60%.")+
   U("Schools report class composition as percentages so classes of different sizes can be compared."),
   [("24%","24% just repeats the count; out of 40 it becomes (24/40) x 100 = 60%."),
    ("40%","40% is the percentage of BOYS (16 of 40); the girls, 24 of 40, are 60%."),
    ("16%","16% reads off the boys' count; the girls' percentage is (24/40) x 100 = 60%.")]),

 ("CQ","If 20% of a number is 40, then the number itself is:",
   "200",
   C("20% of the number is 40, so the whole (100%) is found by working back: 40 is one fifth of the number, so the number is 40 x 5 = 200.")+
   steps("20% = 40, so 1% = 40 / 20 = 2","100% = 2 x 100","= 200.")+
   U("Working back from a percentage like this finds an original price when only the tax or tip amount is known."),
   [("8","8 takes 20% OF 40; here 40 IS the 20%, so the whole is 40 x 5 = 200."),
    ("60","60 adds 20 to 40; to find the whole from 20% you scale up, giving 200."),
    ("400","400 doubles too far (treats 40 as 10%); since 40 is 20%, the number is 40 x 5 = 200.")]),
]

# ---------- assemble: interleave so no two consecutive share a chapter ----------
assert all(len(b) == 25 for b in (LI, SO, IN, CQ)), [len(LI), len(SO), len(IN), len(CQ)]
items = []
for i in range(25):
    items += [LI[i], SO[i], IN[i], CQ[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=52131,
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
    split = "/".join(str(counts[c]) for c in ("LI", "SO", "IN", "CQ"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Light",
                     "Soil",
                     "Integers",
                     "Comparing Quantities"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
