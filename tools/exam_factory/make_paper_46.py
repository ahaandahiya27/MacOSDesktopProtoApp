# -*- coding: utf-8 -*-
# Boss Challenge Paper 46 — Light · Motion & Time ·
# Lines & Angles · Comparing Quantities
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: leans hard into FUSION. A reflected light ray becomes an
# ANGLE problem (incidence/reflection measured from the normal); a moving car's
# speed becomes a RATIO and a PERCENT; the turn of a clock hand becomes a
# fraction of a full angle. The child meets a Science situation and reaches for
# a Maths skill. Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_46_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_46_<SHORT>_QuestionPaper.pdf
#   Paper_46_<SHORT>_Questions.md
#   Paper_46_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "46"
SHORT = "Light_MotionTime_LinesAngles_ComparingQuantities"
TITLE = ("Light · Motion & Time · "
         "Lines & Angles · Comparing Quantities")
LABELS = {
    "LT": "Light",
    "MT": "Motion & Time",
    "LA": "Lines & Angles",
    "CQ": "Comparing Quantities",
}

# ---------- LIGHT (25) — Science (several fused with angles) ----------
LT = [
 ("LT","Light always travels from one point to another along a path that is:",
   "a straight line",
   C("In a uniform medium light travels in straight lines — this is rectilinear propagation, the reason shadows have sharp edges.")+
   steps("Cover and uncover a torch in a dusty room","the beam you see is perfectly straight","so light travels in straight lines.")+
   U("A laser pointer makes a straight dot on the wall — the beam never bends on its own in air."),
   [("a curved arc","Light does not curve by itself in a uniform medium; a sharp-edged shadow proves the path is straight."),
    ("a wavy zig-zag","A zig-zag path would blur every shadow; real shadows have crisp edges because light goes straight."),
    ("a widening spiral","A spiral path is not how light moves; the straight-line rule is what lets us aim a torch beam.")]),

 ("LT","When a ray of light strikes a polished mirror and bounces back, the bouncing-back of light is called:",
   "reflection",
   C("Reflection is the turning-back of light from a surface; a smooth mirror reflects a clear beam in a single direction.")+
   steps("Shine a torch at a mirror","the light returns into the room","this turning-back is reflection.")+
   U("You see yourself in a mirror only because light from your face reflects back to your eyes."),
   [("refraction","Refraction is the bending of light as it passes into a new medium like water, not bouncing off a mirror."),
    ("absorption","Absorption is light being soaked up and lost; a mirror reflects light rather than soaking it up."),
    ("dispersion","Dispersion is white light splitting into colours through a prism, not a ray bouncing off a mirror.")]),

 ("LT","In the law of reflection, the angle of incidence is always measured between the incoming ray and the:",
   "normal (line perpendicular to the mirror)",
   C("Both the angle of incidence and the angle of reflection are measured from the normal — the line drawn at 90° to the mirror at the point the ray hits.")+
   steps("Draw the line perpendicular to the mirror where the ray lands — that is the normal","the incoming ray makes an angle with this normal","that angle is the angle of incidence.")+
   U("A ruler held upright on a mirror shows the normal — every reflection angle is read from it, not from the glass surface."),
   [("mirror surface itself","Angles in the law of reflection are taken from the normal, not the mirror surface; a beam grazing the glass would mislead you."),
    ("ground below","The ground has nothing to do with reflection angles; the reference line is the normal at the strike point."),
    ("reflected ray","The reflected ray is the second ray, not the reference line; both rays are measured from the normal.")]),

 ("LT","A ray of light hits a plane mirror at an angle of incidence of 35°. The angle of reflection is:",
   "35°",
   C("The first law of reflection: the angle of reflection equals the angle of incidence. Both are measured from the normal.")+
   steps("Angle of incidence = 35°","law of reflection: angle of reflection = angle of incidence","so angle of reflection = 35°.")+
   U("Aim a torch at a mirror at a slant and the bright patch leaves at the same slant — equal angles, every time."),
   [("55°","55° is what you get by mistakenly subtracting from 90°; the reflection angle equals the incidence angle, which is 35°."),
    ("70°","70° doubles the angle; the law says reflection equals incidence, so it stays 35°, not 2×35°."),
    ("0°","A 0° reflection would mean the ray comes straight back, which only happens when incidence is 0°, not 35°.")]),

 ("LT","The image of your face formed by a flat (plane) mirror is:",
   "virtual, erect and the same size as your face",
   C("A plane mirror gives a virtual, upright image of the same size as the object, located as far behind the mirror as the object is in front.")+
   steps("The image cannot be caught on a screen → virtual","it is the right way up → erect","it is neither bigger nor smaller → same size.")+
   U("When you comb your hair the reflection is life-size and upright, so you can match every movement exactly."),
   [("real, inverted and smaller","A plane mirror never makes a real image; that description fits a far object in a concave mirror, not a flat one."),
    ("virtual, upside-down and larger","A plane-mirror image is upright and the same size, never upside-down or magnified."),
    ("real and the same size","The image is virtual — it only seems to be behind the glass and cannot be projected onto a screen.")]),

 ("LT","When you raise your right hand in front of a plane mirror, the image appears to raise its left hand. This left-right swap is called:",
   "lateral inversion",
   C("Lateral inversion is the apparent left-right reversal of an image in a plane mirror; up and down stay the same, only sides swap.")+
   steps("Right hand up → image's matching hand is on its left side","this is a left-for-right swap, not an up-down flip","such a swap is called lateral inversion.")+
   U("The word AMBULANCE is printed mirror-reversed on the front of the van so it reads correctly in a driver's mirror."),
   [("magnification","Magnification means a change in size; the plane-mirror image is the same size, only its sides are swapped."),
    ("dispersion","Dispersion is the splitting of white light into colours, nothing to do with the left-right swap of an image."),
    ("refraction","Refraction is light bending in a new medium; the side-swap in a mirror is lateral inversion.")]),

 ("LT","A mirror that caves inward, the way the inside of a steel spoon's bowl does, is a:",
   "concave mirror",
   C("A concave mirror caves inward and converges light to a focus; it can form a magnified image of a near object.")+
   steps("Picture the inside of a shiny spoon — it curves inward","a mirror with this inward-curving surface","is called a concave mirror.")+
   U("A dentist uses a small concave mirror to see an enlarged, upright image of a tooth."),
   [("convex mirror","A convex mirror bulges outward and spreads light apart; it cannot magnify like the inward-curving concave one."),
    ("plane mirror","A plane mirror is perfectly flat; the inward curve of a spoon's bowl belongs to a concave mirror."),
    ("cylindrical mirror","A cylindrical mirror curves in only one direction; the bowl-like inward curve described is a concave mirror.")]),

 ("LT","A convex mirror is used as a vehicle's side-view mirror mainly because it:",
   "gives a wider field of view (covers more area behind)",
   C("A convex mirror always forms a small, erect, virtual image and spreads the view over a wider area — so the driver sees more of the road behind.")+
   steps("A convex surface bulges outward and diverges light","this shrinks the image but packs in a wider scene","so the driver sees a larger stretch of traffic behind.")+
   U("The 'objects are closer than they appear' mirror on a car is convex — it trades size for a bigger view."),
   [("magnifies vehicles so they look closer","A convex mirror shrinks images; it widens the view, which is why distant cars look smaller, not larger."),
    ("forms a real image on the road","A convex mirror forms only virtual, erect images behind the glass, never a real image on the road."),
    ("removes the driver's blind spot completely","A convex mirror reduces but cannot fully erase blind spots; its real job is widening the field of view.")]),

 ("LT","White sunlight passed through a glass prism spreads out into a band of seven colours. This splitting of light is called:",
   "dispersion",
   C("Dispersion is the splitting of white light into its component colours (VIBGYOR) because each colour bends by a different amount in the prism.")+
   steps("White light enters a prism","each colour bends through a slightly different angle","they fan out as a spectrum — this is dispersion.")+
   U("A rainbow appears when raindrops act like tiny prisms and disperse sunlight into seven colours."),
   [("reflection","Reflection is light bouncing off a surface; the fanning of white light into colours by a prism is dispersion."),
    ("absorption","Absorption removes light; a prism does not soak up sunlight, it spreads it into colours — dispersion."),
    ("lateral inversion","Lateral inversion is a left-right image swap in a mirror, unrelated to splitting white light into colours.")]),

 ("LT","The correct order of the seven colours of the spectrum, from the one bent least to the one bent most by a prism, is remembered as:",
   "VIBGYOR (violet bends most, red least)",
   C("The spectrum is V-I-B-G-Y-O-R. Red is bent the least by a prism and violet the most, which is why VIBGYOR lists them in bending order.")+
   steps("White light splits in a prism","red deviates the least, violet the most","reading violet→red gives VIBGYOR.")+
   U("In a rainbow, red sits on the outer (top) edge and violet on the inner edge — the VIBGYOR order in the sky."),
   [("RoyGBiv with red bent most","Red is bent the LEAST, not the most; violet bends most, so the bending order runs violet→red."),
    ("only three colours: red, blue, green","White light disperses into seven colours, not three; the full set is VIBGYOR."),
    ("black, white and grey","Black, white and grey are not spectral colours; dispersion produces the seven hues of VIBGYOR.")]),

 ("LT","A spoon's shiny outer (back) surface acts like a convex mirror. Looking into it, your image appears:",
   "small and erect",
   C("The bulging outer side of a spoon behaves as a convex mirror, which always gives a diminished (small), erect, virtual image.")+
   steps("The outer spoon surface bulges outward → convex","a convex mirror always shrinks the image and keeps it upright","so you look small and the right way up.")+
   U("Turn a steel spoon over and your reflection on the back is tiny but upright — a convex mirror in your hand."),
   [("large and upside-down","A convex mirror never enlarges or flips; the inner (concave) side near your face can invert, but the outer side gives a small erect image."),
    ("the same size as a plane mirror","Only a flat mirror keeps life-size; the convex back of a spoon shrinks the image."),
    ("real and projected onto the wall","A convex mirror forms only a virtual image you cannot catch on a wall.")]),

 ("LT","A torch beam in a dark room shows up as a sharp straight streak. This is direct evidence that light:",
   "travels in straight lines",
   C("The visible straight streak of a beam in dust or mist is everyday proof of rectilinear propagation — light moves in straight lines.")+
   steps("Dust scatters a little light from the beam back to your eyes","the lit-up path you see is dead straight","so light must travel in straight lines.")+
   U("Sunbeams streaming through a gap in clouds appear as straight shafts of light for the same reason."),
   [("bends around the dust","Light does not noticeably bend around dust; the straight visible streak shows it goes in a straight line."),
    ("only travels in water","Light travels straight through air too — the beam is in air, and it is straight."),
    ("speeds up in a dark room","Darkness does not change light's path; the streak is straight because light travels in straight lines.")]),

 ("LT","Two plane mirrors are joined to make a kaleidoscope so that a few coloured beads form many beautiful symmetric patterns. The patterns are produced by:",
   "repeated reflections between the mirrors",
   C("In a kaleidoscope, light from the beads reflects back and forth between angled plane mirrors, so each bead is seen many times in a symmetric pattern.")+
   steps("Beads sit between two angled mirrors","each mirror reflects the beads, and reflects the other mirror's image too","these repeated reflections build the many-fold pattern.")+
   U("Every twist of a kaleidoscope makes a new symmetric design — same beads, many mirror reflections."),
   [("the beads multiplying inside the tube","The beads do not increase in number; their many images come from repeated reflections in the mirrors."),
    ("dispersion of white light by the beads","The patterns come from reflections, not from splitting white light into colours."),
    ("the glass bending the light by refraction","The repeating symmetric images are made by reflection between mirrors, not by refraction.")]),

 ("LT","An object stands 8 cm in front of a plane mirror. The image is formed:",
   "8 cm behind the mirror",
   C("In a plane mirror the image lies as far behind the mirror as the object is in front — the image distance equals the object distance.")+
   steps("Object distance in front = 8 cm","plane-mirror rule: image distance behind = object distance in front","so the image is 8 cm behind the mirror.")+
   U("Step back from a mirror and your reflection seems to step back the same amount — equal distances on both sides."),
   [("4 cm behind the mirror","The image is not halved; it sits the same 8 cm behind as the object is in front."),
    ("16 cm behind the mirror","The distance is not doubled; image distance equals object distance, so it is 8 cm, not 16 cm."),
    ("right on the mirror surface","The image appears 8 cm behind the glass, not on the surface itself.")]),

 ("LT","A magnifying glass that makes tiny print look larger is which kind of lens?",
   "a convex (converging) lens",
   C("A convex lens is thicker in the middle and converges light; held close to small print it forms an enlarged, erect, virtual image — a magnifying glass.")+
   steps("A magnifier makes near objects look bigger","this needs a lens that is thick in the middle and bends rays together","that is a convex (converging) lens.")+
   U("A hand lens used to read a map's fine names is a convex lens."),
   [("a concave (diverging) lens","A concave lens is thin in the middle and shrinks images; it cannot act as a magnifying glass."),
    ("a plane glass sheet","Flat glass neither converges nor diverges light, so it cannot magnify print."),
    ("a convex mirror","A convex mirror reflects and shrinks images; magnifying print needs a convex lens, not a mirror.")]),

 ("LT","A ray of light strikes a plane mirror along the normal itself (straight on, angle of incidence 0°). It is reflected:",
   "straight back along the same path",
   C("When incidence is 0° (the ray travels along the normal), the reflected ray also makes 0° with the normal, so it returns along its original path.")+
   steps("Angle of incidence = 0°","angle of reflection = angle of incidence = 0°","so the ray retraces its path straight back.")+
   U("Shine a torch dead-straight at a mirror and the spot comes back to the torch — straight in, straight out."),
   [("at 90° to the original path","A 90° turn would need a 45° incidence; here incidence is 0°, so the ray returns straight back."),
    ("at 45° to the mirror","With 0° incidence the reflected ray is also along the normal, not at 45°."),
    ("not reflected at all","Light striking a mirror is always reflected; at 0° incidence it simply returns along the same line.")]),

 ("LT","A periscope, used to see over a wall, sends light around the bend using:",
   "two plane mirrors set at 45°",
   C("A simple periscope uses two parallel plane mirrors each tilted at 45°, so light from the top is reflected down the tube and out to the eye.")+
   steps("Light enters the top, hits a 45° mirror, and turns downward","it travels down and hits a second 45° mirror","that turns it into your eye — you see over the wall.")+
   U("A submarine periscope works the same way, letting the crew see above the water from below."),
   [("a single curved lens","A periscope turns light around two bends with mirrors; one lens cannot redirect the view over a wall."),
    ("a glass prism that disperses light","Dispersion splits colours and is not what bends the view in a basic periscope — two 45° mirrors do."),
    ("a convex mirror at the top only","One convex mirror cannot carry the image down a straight tube; a periscope needs two angled plane mirrors.")]),

 ("LT","A ray of light makes an angle of 20° with the surface of a plane mirror. Measured from the normal, its angle of incidence is:",
   "70°",
   C("The normal is 90° to the mirror surface. If the ray makes 20° with the surface, it makes 90° − 20° = 70° with the normal — and angles are always taken from the normal.")+
   steps("Angle with the mirror surface = 20°","normal is at 90° to the surface","angle of incidence (from normal) = 90° − 20° = 70°.")+
   U("Lay a protractor on a mirror: a ray grazing low along the glass is at a big angle to the upright normal."),
   [("20°","20° is the angle with the surface, not with the normal; incidence is measured from the normal, giving 90° − 20° = 70°."),
    ("90°","90° would mean the ray runs flat along the mirror with no reflection; the actual incidence is 70°."),
    ("45°","45° would need a 45° tilt to the surface; here the surface angle is 20°, so incidence is 70°.")]),

 ("LT","After the 20°-to-the-surface ray above reflects, the total angle between the incident ray and the reflected ray (i + r from the normal) is:",
   "140°",
   C("Incidence = reflection = 70° (each from the normal). The two rays sit on opposite sides of the normal, so the angle between them is 70° + 70° = 140°.")+
   steps("Angle of incidence = 70°, angle of reflection = 70°","they lie on opposite sides of the normal","angle between the rays = 70° + 70° = 140°.")+
   U("A torch beam bouncing off a mirror at a shallow slant opens up into a wide V — here a 140° spread."),
   [("70°","70° is each single angle from the normal; the two rays together span 70° + 70° = 140°."),
    ("40°","40° comes from doubling the 20° surface angle; the angle between the rays is 2 × 70° = 140°."),
    ("180°","A 180° spread would mean the ray went straight through; reflection here folds it back to a 140° opening.")]),

 ("LT","Which of these objects is luminous — it gives out its own light?",
   "the Sun",
   C("A luminous object produces its own light. The Sun, a flame and a glowing bulb are luminous; the Moon and a book only reflect light.")+
   steps("Ask: does it make its own light, or only reflect light?","the Sun produces its own light by burning","so the Sun is luminous.")+
   U("At night a streetlamp is luminous, while the parked car beside it is seen only by reflected lamplight."),
   [("the Moon","The Moon makes no light of its own; it shines only by reflecting sunlight, so it is non-luminous."),
    ("a mirror","A mirror only reflects light that falls on it; it produces none of its own."),
    ("a white wall","A wall is seen by the light it reflects; it is non-luminous, unlike the self-shining Sun.")]),

 ("LT","What makes a real image different from a virtual one is that a real image:",
   "can be caught (projected) on a screen",
   C("A real image forms where light rays actually meet, so it can be cast on a screen. A virtual image only appears to be there and cannot be projected.")+
   steps("Real image → rays truly cross → can land on a screen","virtual image → rays only seem to come from a point → no screen image","so the screen test tells them apart.")+
   U("A cinema projector throws a real image onto the screen; your face in a mirror is a virtual image you cannot project."),
   [("is always upright","Real images are usually inverted, not upright; the defining test is that they can fall on a screen."),
    ("appears behind the mirror","An image behind a mirror is virtual; a real image forms in front, where light actually meets."),
    ("is made only by plane mirrors","Plane mirrors make virtual images; real images come from concave mirrors or convex lenses.")]),

 ("LT","A concave mirror is used in a torch or a car headlight behind the bulb because it can:",
   "send out a strong parallel beam of light",
   C("With the bulb at its focus, a concave mirror reflects the light into a near-parallel beam, throwing it far ahead — ideal for a headlight or torch.")+
   steps("Place the bulb at the focus of a concave mirror","rays reflected from the mirror come out almost parallel","this makes a strong forward beam.")+
   U("A car's headlight reflector is concave so the light reaches far down a dark road."),
   [("spread light in all directions","A concave reflector concentrates light into a forward beam; spreading light everywhere is the opposite of what it does."),
    ("split the light into seven colours","Splitting into colours is dispersion by a prism, not the job of a headlight's concave mirror."),
    ("shrink the bulb's image like a side-view mirror","Shrinking the view is a convex mirror's trait; the headlight uses a concave mirror to make a beam.")]),

 ("LT","Sunlight reflected off calm water can dazzle your eyes. Compared with a rough, choppy water surface, the calm surface gives:",
   "a clearer, mirror-like (regular) reflection",
   C("A smooth surface reflects parallel rays all in one direction (regular reflection), giving a clear image; a rough surface scatters rays (diffuse reflection).")+
   steps("Calm water is smooth → parallel rays reflect together → regular reflection","choppy water is rough → rays scatter every way → diffuse reflection","so calm water dazzles with a clear, mirror-like glare.")+
   U("A still lake at dawn mirrors the mountains; ruffle the water with wind and the reflection breaks into shimmer."),
   [("no reflection at all","Calm water reflects very well; that is exactly why it dazzles. Rough water still reflects, but scatters the light."),
    ("a spread-out, scattered glow","Scattered (diffuse) reflection comes from a ROUGH surface; smooth, calm water gives a clear regular reflection."),
    ("colours split like a rainbow","Splitting into colours is dispersion; calm water gives a clear single reflection, not a spectrum.")]),

 ("LT","Light from the Moon that lets us see it at night is:",
   "sunlight reflected by the Moon",
   C("The Moon is non-luminous: it makes no light of its own. We see it because it reflects light from the Sun toward Earth.")+
   steps("The Moon produces no light by itself","sunlight falls on the Moon and bounces off","that reflected sunlight reaches our eyes.")+
   U("During a lunar eclipse, Earth blocks the sunlight, the Moon gets no light to reflect, and it darkens."),
   [("the Moon's own glowing surface","The Moon does not glow on its own; it is non-luminous and only reflects the Sun's light."),
    ("starlight stored during the day","The Moon does not store starlight; what we see is reflected sunlight."),
    ("light made by the Moon's craters","Craters do not produce light; the Moon shines purely by reflected sunlight.")]),

 ("LT","Hold this printed word in front of a plane mirror: which letter looks exactly the same as its mirror image?",
   "O",
   C("Letters with a vertical line of symmetry (like O, A, H, M, T, U, V, W, X) look unchanged after the left-right swap of a plane mirror; letters like P, R, S, J do not.")+
   steps("A plane mirror swaps left and right (lateral inversion)","a letter symmetric about a vertical line is unchanged by a left-right swap","O is such a letter, so it reads the same.")+
   U("The word MOM written on a card reads MOM in the mirror, because each of its letters is vertically symmetric."),
   [("P","P is not symmetric about a vertical line, so the mirror flips its bump to the wrong side and it changes."),
    ("R","R has no vertical line of symmetry; in a mirror its leg and bump swap sides, so it looks different."),
    ("S","S is not vertically symmetric; the mirror reverses its curves, changing how it looks.")]),
]

# ---------- MOTION & TIME (25) — Science (several fused with ratio/percent) ----------
MT = [
 ("MT","The distance an object covers in one unit of time is called its:",
   "speed",
   C("Speed = distance ÷ time. It tells how fast an object moves — the distance covered in each unit of time.")+
   steps("Take the distance travelled","divide it by the time taken","the result, distance per unit time, is the speed.")+
   U("A cyclist covering 12 km in one hour has a speed of 12 km/h."),
   [("mass","Mass is the amount of matter in a body, measured in kilograms; it has nothing to do with how fast it moves."),
    ("force","Force is a push or pull; speed is distance per unit time, a different quantity."),
    ("weight","Weight is the pull of gravity on a body; speed is how much distance it covers per unit time.")]),

 ("MT","The SI (standard) unit of speed is:",
   "metre per second (m/s)",
   C("In the SI system distance is measured in metres and time in seconds, so the SI unit of speed is metre per second (m/s).")+
   steps("Speed = distance ÷ time","SI distance = metre, SI time = second","so SI speed = metre per second (m/s).")+
   U("A sprinter's top speed is often quoted in m/s in science books, e.g. about 10 m/s."),
   [("kilometre per hour (km/h)","km/h is a common everyday unit but not the SI unit; the SI unit uses metres and seconds, giving m/s."),
    ("metre (m)","A metre alone measures distance, not speed; speed needs distance divided by time."),
    ("second (s)","A second measures time only; speed is distance per second, i.e. m/s.")]),

 ("MT","An object that covers equal distances in equal intervals of time is said to be in:",
   "uniform motion",
   C("Uniform motion means the speed stays constant — equal distances in equal time intervals. Its distance-time graph is a straight line.")+
   steps("Check the distance covered in each equal time slot","if every slot has the same distance, the speed is constant","that constant-speed motion is uniform motion.")+
   U("A train cruising at a steady 60 km/h on a straight track is in uniform motion."),
   [("non-uniform motion","Non-uniform motion is when distances in equal times differ (speed changes); equal distances mean it is uniform."),
    ("circular motion","Circular motion describes the shape of the path, not whether the speed is steady; equal distances per time means uniform."),
    ("no motion (rest)","At rest no distance is covered; covering equal distances each interval means the object is moving uniformly.")]),

 ("MT","A car travels 150 km in 3 hours at a steady speed. Its speed is:",
   "50 km/h",
   C("Speed = distance ÷ time = 150 km ÷ 3 h = 50 km/h.")+
   steps("Distance = 150 km, time = 3 h","speed = distance ÷ time","speed = 150 ÷ 3 = 50 km/h.")+
   U("A road sign showing 'Delhi 150 km' means about a 3-hour drive at this steady 50 km/h."),
   [("450 km/h","450 comes from multiplying 150 × 3; speed is distance DIVIDED by time, giving 150 ÷ 3 = 50 km/h."),
    ("45 km/h","45 km/h is not 150 ÷ 3; the correct division gives exactly 50 km/h."),
    ("153 km/h","153 comes from adding 150 + 3; speed needs division, not addition, so 150 ÷ 3 = 50 km/h.")]),

 ("MT","The instrument in a vehicle that measures its speed at that moment is the:",
   "speedometer",
   C("A speedometer shows the vehicle's instantaneous speed (often in km/h); an odometer shows total distance travelled.")+
   steps("You want the speed right now","the dial that reads km/h on the dashboard","is the speedometer.")+
   U("Watching the speedometer keeps a driver within a 40 km/h school-zone limit."),
   [("odometer","An odometer records the total distance the vehicle has covered, not its current speed."),
    ("thermometer","A thermometer measures temperature, not speed."),
    ("barometer","A barometer measures air pressure; the speed dial is the speedometer.")]),

 ("MT","A simple pendulum's one complete to-and-fro swing (there and back) is called one:",
   "oscillation",
   C("One oscillation of a pendulum is a full to-and-fro motion; the time for one oscillation is its time period.")+
   steps("The bob swings out and returns to where it started","that complete there-and-back is one cycle","one such cycle is one oscillation.")+
   U("A wall-clock pendulum makes one oscillation roughly every second to keep time."),
   [("frequency","Frequency is the NUMBER of oscillations per second, not a single to-and-fro swing."),
    ("amplitude","Amplitude is how far the bob swings from the centre, not one complete swing."),
    ("time period for many swings","One to-and-fro is a single oscillation; the time period is the time taken for just one of them.")]),

 ("MT","The time taken by a simple pendulum to complete one oscillation is called its:",
   "time period",
   C("The time period is the seconds taken for one full oscillation. For a given pendulum it stays nearly constant, which is why pendulums keep time.")+
   steps("Count the time for one complete to-and-fro swing","that duration, in seconds, ","is the time period of the pendulum.")+
   U("A pendulum with a 2-second time period ticks once every second of swing — used in old clocks."),
   [("frequency","Frequency is oscillations per second; the time for ONE oscillation is the time period, its reciprocal."),
    ("amplitude","Amplitude is the size of the swing, measured in distance or angle, not in seconds."),
    ("speed","Speed is distance per time of the bob; the time for one oscillation is specifically the time period.")]),

 ("MT","On a distance-time graph, a straight line sloping upward represents:",
   "uniform speed",
   C("A straight, sloping distance-time line means equal distance in equal time — constant (uniform) speed. A curved line means changing speed.")+
   steps("Equal time steps each add the same distance","that plots as a straight slanting line","a straight slope means uniform speed.")+
   U("A train moving at steady speed traces a straight slanting line on its distance-time chart."),
   [("the object is at rest","At rest the distance does not change, so the line would be flat (horizontal), not a rising slope."),
    ("ever-increasing speed","Increasing speed bends the line into an upward curve; a straight slope means the speed is constant."),
    ("the object moving backward","A rising distance-time line shows forward motion at steady speed, not backward motion.")]),

 ("MT","On a distance-time graph, a horizontal (flat) line means the object is:",
   "at rest (not moving)",
   C("A flat distance-time line means distance is not changing as time passes — the object stays put, so it is at rest.")+
   steps("Time keeps increasing along the bottom","but the distance stays the same (line is flat)","no distance is covered, so the object is at rest.")+
   U("A parked bus traces a flat line on a distance-time graph until it starts moving again."),
   [("moving at top speed","Top speed would make the line rise steeply; a flat line means no distance is covered, i.e. rest."),
    ("speeding up","Speeding up curves the line upward; a flat line shows the object is not moving at all."),
    ("moving backward","Moving backward would make distance from the start fall; a flat line means no movement.")]),

 ("MT","To change a speed from km/h into m/s, you multiply by:",
   "5/18",
   C("1 km/h = 1000 m ÷ 3600 s = 5/18 m/s. So multiply a km/h value by 5/18 to get m/s.")+
   steps("1 km = 1000 m and 1 h = 3600 s","1 km/h = 1000/3600 m/s = 5/18 m/s","so multiply km/h by 5/18 to get m/s.")+
   U("A 72 km/h car is 72 × 5/18 = 20 m/s — handy when comparing with physics values in m/s."),
   [("18/5","18/5 is the reverse factor (m/s → km/h); going from km/h to m/s you multiply by 5/18."),
    ("1000","Multiplying only by 1000 ignores the seconds-in-an-hour part; the full factor is 1000/3600 = 5/18."),
    ("3600","3600 is the seconds in an hour alone; the complete km/h→m/s factor is 1000/3600 = 5/18.")]),

 ("MT","A bus covers 40 km in the first hour and 60 km in the second hour. Its average speed over the 2 hours is:",
   "50 km/h",
   C("Average speed = total distance ÷ total time = (40 + 60) km ÷ 2 h = 100 ÷ 2 = 50 km/h.")+
   steps("Total distance = 40 + 60 = 100 km","total time = 2 h","average speed = 100 ÷ 2 = 50 km/h.")+
   U("Trip computers in cars show this kind of average speed for a whole journey, not just the present moment."),
   [("100 km/h","100 km is the total DISTANCE, not the speed; dividing by the 2 hours gives 50 km/h."),
    ("20 km/h","20 km/h is too low; total 100 km over 2 h is 50 km/h, not 20."),
    ("10 km/h","10 km/h comes from subtracting 60 − 40 ÷ 2; average speed uses total distance ÷ total time = 50 km/h.")]),

 ("MT","In the SI system of measurement, time is measured in the base unit called the:",
   "second",
   C("The second is the SI base unit of time. Larger units like the minute (60 s), hour and day are built from it.")+
   steps("Ask which time unit is the SI base","minutes, hours and days are all defined from it","that base unit is the second.")+
   U("A stopwatch in a 100-metre race reads the runner's time in seconds and hundredths of a second."),
   [("minute","A minute is 60 seconds — a multiple of the base unit, not the SI base itself, which is the second."),
    ("hour","An hour is 3600 seconds; it is built from the SI base unit, the second."),
    ("day","A day is 86 400 seconds; the SI base unit of time is the second, not the day.")]),

 ("MT","A car's speed rises from 40 km/h to 50 km/h. The percentage increase in its speed is:",
   "25%",
   C("Percent increase = (increase ÷ original) × 100 = (10 ÷ 40) × 100 = 25%.")+
   steps("Increase = 50 − 40 = 10 km/h","fraction of the original = 10 ÷ 40 = 1/4","as a percent = 1/4 × 100 = 25%.")+
   U("A driver who reads '25% faster' knows the 40 km/h cruise has climbed to 50 km/h."),
   [("10%","10 is the size of the increase in km/h, not the percentage; (10 ÷ 40) × 100 = 25%, not 10%."),
    ("20%","20% would be 8 km/h on a 40 base; the actual jump of 10 km/h is (10 ÷ 40) × 100 = 25%."),
    ("50%","50% of 40 is 20 km/h; the increase is only 10 km/h, which is 25%, not 50%.")]),

 ("MT","Two cars have speeds 60 km/h and 90 km/h. The ratio of the first car's speed to the second is:",
   "2 : 3",
   C("Ratio 60 : 90 simplifies by dividing both by 30 to give 2 : 3.")+
   steps("Write the ratio 60 : 90","divide both parts by their HCF 30","60÷30 : 90÷30 = 2 : 3.")+
   U("Saying the speeds are 'in the ratio 2 to 3' is a quick way to compare two vehicles without the exact numbers."),
   [("3 : 2","3 : 2 reverses the order; the first speed (60) to the second (90) is 2 : 3, not 3 : 2."),
    ("6 : 9 only","6 : 9 is correct but not fully simplified; dividing further by 3 gives the simplest form 2 : 3."),
    ("1 : 2","1 : 2 would need speeds like 60 and 120; 60 : 90 reduces to 2 : 3.")]),

 ("MT","A train travels at a uniform 20 m/s. The distance it covers in 1 minute is:",
   "1200 m",
   C("Distance = speed × time. 1 minute = 60 s, so distance = 20 m/s × 60 s = 1200 m.")+
   steps("Speed = 20 m/s, time = 1 min = 60 s","distance = speed × time","distance = 20 × 60 = 1200 m.")+
   U("Knowing a metro runs at 20 m/s, you can tell it covers 1.2 km of track each minute."),
   [("20 m","20 m is the distance in just ONE second; over a full 60-second minute it is 20 × 60 = 1200 m."),
    ("120 m","120 m uses only 6 seconds, or forgets a zero; the full minute gives 20 × 60 = 1200 m."),
    ("72000 m","72000 m treats the speed as if it were per hour in seconds; 20 m/s for 60 s is 1200 m.")]),

 ("MT","Which of these natural events repeats at the most regular, fixed interval — useful as a way to measure time?",
   "the swinging of a pendulum",
   C("Periodic events with a fixed, repeating interval (a pendulum's swing, Earth's spin) are used to measure time; one-off or irregular events cannot.")+
   steps("Time-keeping needs an event that repeats at equal intervals","a pendulum swings to-and-fro in equal times","so its swing is used to measure time.")+
   U("Old grandfather clocks count a pendulum's steady swings to advance the hands."),
   [("a clap of thunder","Thunder happens at random, not at fixed intervals, so it cannot be used to measure time."),
    ("a falling leaf","A leaf falls once and irregularly; time-keeping needs a steadily repeating event like a pendulum."),
    ("a bursting balloon","A balloon bursts once at no fixed interval; only a regular periodic event can mark time.")]),

 ("MT","The odometer of a vehicle records the:",
   "total distance the vehicle has travelled",
   C("An odometer adds up the total distance covered by a vehicle over its lifetime, shown in kilometres; the speedometer shows current speed.")+
   steps("You want the total distance covered so far","the dial that keeps counting up in km","is the odometer.")+
   U("A used car with 80,000 km on its odometer has travelled that far in total."),
   [("speed at this moment","Current speed is shown by the speedometer; the odometer keeps the running total of distance."),
    ("fuel left in the tank","Fuel level is a separate gauge; the odometer measures distance travelled."),
    ("engine temperature","Temperature has its own gauge; the odometer's job is total distance.")]),

 ("MT","A boy walks to school at 4 km/h and cycles back along the same road at 12 km/h. Compared with walking, cycling is:",
   "3 times as fast",
   C("12 ÷ 4 = 3, so cycling is 3 times the walking speed (the speeds are in the ratio 1 : 3).")+
   steps("Walking speed = 4 km/h, cycling speed = 12 km/h","divide: 12 ÷ 4 = 3","so cycling is 3 times as fast as walking.")+
   U("That is why the ride home takes a third of the time the morning walk did, over the same road."),
   [("2 times as fast","12 is 4 multiplied by 3, not 2; cycling is 3 times the walking speed."),
    ("8 times as fast","8 comes from subtracting 12 − 4; 'how many times' needs division: 12 ÷ 4 = 3."),
    ("the same speed","The speeds differ — 12 km/h is well above 4 km/h, exactly 3 times as fast.")]),

 ("MT","Non-uniform motion is best described as motion in which the object:",
   "covers unequal distances in equal time intervals",
   C("In non-uniform motion the speed keeps changing, so the distances covered in equal time slots are unequal; the distance-time graph is a curve.")+
   steps("Look at distances in equal time slots","if they differ, the speed is changing","that changing-speed motion is non-uniform.")+
   U("A bus in city traffic — speeding up, slowing at lights — is in non-uniform motion."),
   [("covers equal distances in equal times","Equal distances in equal times is UNIFORM motion; non-uniform motion has unequal distances."),
    ("never moves at all","An object that never moves is at rest, not in non-uniform motion."),
    ("always moves in a circle","The shape of the path does not define non-uniform motion; changing speed does.")]),

 ("MT","A 100-metre runner finishes in 20 seconds. Her average speed is:",
   "5 m/s",
   C("Average speed = distance ÷ time = 100 m ÷ 20 s = 5 m/s.")+
   steps("Distance = 100 m, time = 20 s","average speed = distance ÷ time","100 ÷ 20 = 5 m/s.")+
   U("Coaches read these splits in m/s to compare runners over the same 100-metre track."),
   [("2000 m/s","2000 multiplies 100 × 20; speed is distance DIVIDED by time, giving 100 ÷ 20 = 5 m/s."),
    ("20 m/s","20 s is the time, not the speed; dividing 100 m by 20 s gives 5 m/s."),
    ("80 m/s","80 comes from subtracting 100 − 20; speed needs division, so 100 ÷ 20 = 5 m/s.")]),

 ("MT","Light travels far faster than sound. In a thunderstorm you usually:",
   "see the lightning before you hear the thunder",
   C("Light reaches you almost instantly, while sound travels much more slowly, so the flash is seen before the rumble is heard.")+
   steps("Lightning and thunder start together","light arrives at your eyes almost at once","sound lags behind, so you hear the thunder later.")+
   U("Counting seconds between flash and rumble tells you roughly how far away a storm is."),
   [("hear the thunder before the flash","Sound is slower than light, so the flash always arrives first; thunder lags behind."),
    ("see and hear them at exactly the same instant","Only if the storm were right on top of you; usually the slower sound arrives noticeably later."),
    ("hear the thunder but never see lightning","Lightning's light is fast and reaches you first; you normally see it before hearing thunder.")]),

 ("MT","A pendulum makes 30 complete oscillations in 60 seconds. Its time period (time for one oscillation) is:",
   "2 seconds",
   C("Time period = total time ÷ number of oscillations = 60 s ÷ 30 = 2 s.")+
   steps("Total time = 60 s for 30 oscillations","time period = total time ÷ number of oscillations","60 ÷ 30 = 2 s per oscillation.")+
   U("A pendulum tuned to a 2-second period is used to keep a slow, steady clock beat."),
   [("30 seconds","30 is the NUMBER of oscillations, not the time for one; divide 60 ÷ 30 = 2 s."),
    ("60 seconds","60 s is the total time for all 30 swings; one swing takes 60 ÷ 30 = 2 s."),
    ("0.5 seconds","0.5 s reverses the division (30 ÷ 60); time period is total time ÷ number = 60 ÷ 30 = 2 s.")]),

 ("MT","Two buses leave together. Bus P goes 80 km in 2 h; bus Q goes 90 km in 3 h. The faster bus is:",
   "bus P (40 km/h vs 30 km/h)",
   C("Compare speeds: P = 80 ÷ 2 = 40 km/h; Q = 90 ÷ 3 = 30 km/h. Since 40 > 30, bus P is faster.")+
   steps("Speed of P = 80 ÷ 2 = 40 km/h","speed of Q = 90 ÷ 3 = 30 km/h","40 > 30, so bus P is faster.")+
   U("Comparing speeds (not just distances) tells a traveller which service reaches town sooner."),
   [("bus Q, because it covered more distance","Q covered more distance but took more time; on speed (distance ÷ time) P wins, 40 vs 30 km/h."),
    ("both equal, since both are buses","Being buses says nothing about speed; P's 40 km/h beats Q's 30 km/h."),
    ("bus Q, because it took the longest time","Taking longer does not make a bus faster; P's higher speed of 40 km/h makes it the faster one.")]),

 ("MT","Distance is to the y-axis as time is to the x-axis on a distance-time graph. Choosing time along the bottom lets us read off:",
   "how far the object has gone by any given time",
   C("With time on the x-axis and distance on the y-axis, you go up from a chosen time to the line and read the distance covered by then.")+
   steps("Pick a time on the bottom axis","go straight up to the plotted line","read across to the distance axis — that is how far it had travelled.")+
   U("A train's schedule graph lets a station master read the train's position at any clock time."),
   [("the colour of the moving object","A distance-time graph carries no colour information; it links time to distance covered."),
    ("the mass of the object","Mass is not plotted on a distance-time graph; the axes show time and distance only."),
    ("the temperature at each second","Temperature is not on this graph; the y-axis reads distance for each time on the x-axis.")]),

 ("MT","A car runs at 60 km/h. The time it takes to cover 150 km is:",
   "2.5 hours",
   C("Time = distance ÷ speed = 150 ÷ 60 = 2.5 hours.")+
   steps("Distance = 150 km, speed = 60 km/h","time = distance ÷ speed","150 ÷ 60 = 2.5 hours.")+
   U("A trip planner uses this to say a 150 km drive at 60 km/h takes about two and a half hours."),
   [("90 hours","90 multiplies 150 × 0.6; time is distance ÷ speed = 150 ÷ 60 = 2.5 h."),
    ("210 hours","210 adds 150 + 60; time needs division, so 150 ÷ 60 = 2.5 h."),
    ("0.4 hours","0.4 reverses the division (60 ÷ 150); time = distance ÷ speed = 150 ÷ 60 = 2.5 h.")]),
]

# ---------- LINES & ANGLES (25) — Maths (several fused with light/clock) ----------
LA = [
 ("LA","When the measures of two angles together make exactly 90°, the angles are called:",
   "complementary angles",
   C("Complementary angles sum to 90°. (Supplementary angles sum to 180° — don't mix them up.)")+
   steps("Add the two angle measures","if the total is exactly 90°","the angles are complementary.")+
   U("The two acute corners of a right-angled set-square add to 90° — they are complementary."),
   [("supplementary angles","Supplementary angles add to 180°, not 90°; angles summing to 90° are complementary."),
    ("vertically opposite angles","Vertically opposite angles are equal to each other; they need not add to 90°."),
    ("adjacent angles","Adjacent angles merely share an arm and vertex; that says nothing about a 90° sum.")]),

 ("LA","When the measures of two angles together make exactly 180°, the angles are called:",
   "supplementary angles",
   C("Supplementary angles sum to 180°. A straight line splits into two supplementary angles (a linear pair).")+
   steps("Add the two angle measures","if the total is exactly 180°","the angles are supplementary.")+
   U("The two angles on a straight road where a side path meets it add to 180° — they are supplementary."),
   [("complementary angles","Complementary angles add to 90°, not 180°; angles totalling 180° are supplementary."),
    ("corresponding angles","Corresponding angles are equal pairs formed by a transversal; they need not add to 180°."),
    ("right angles","A single right angle is exactly 90°; two angles adding to 180° are supplementary, not 'right'.")]),

 ("LA","An angle measures 35°. Its complement works out to:",
   "55°",
   C("Complementary angles add to 90°, so the complement of 35° is 90° − 35° = 55°.")+
   steps("Complement means the angle that completes 90°","90° − 35° = 55°","so the complement is 55°.")+
   U("If a ramp rises at 35° to the floor, it leans 55° from the upright wall — the two add to 90°."),
   [("65°","65° would pair with 25°, not 35°; the complement of 35° is 90° − 35° = 55°."),
    ("145°","145° is the SUPPLEMENT (180° − 35°), not the complement; the complement uses 90°, giving 55°."),
    ("35°","35° equals the angle itself; its complement is what is left to reach 90°, namely 55°.")]),

 ("LA","An angle measures 110°. Its supplement works out to:",
   "70°",
   C("Supplementary angles add to 180°, so the supplement of 110° is 180° − 110° = 70°.")+
   steps("Supplement means the angle that completes 180°","180° − 110° = 70°","so the supplement is 70°.")+
   U("Two angles on one side of a straight fence post that read 110° and 70° together make the straight 180°."),
   [("20°","20° would be the complement-style leftover from 90°+? ; the supplement uses 180°, giving 180° − 110° = 70°."),
    ("250°","250° is more than 180°, impossible for a supplement; 180° − 110° = 70°."),
    ("110°","110° is the angle itself; its supplement is the rest of the straight angle, 70°.")]),

 ("LA","Where two straight lines intersect, the two angles lying directly across from each other at the point of crossing are:",
   "equal (vertically opposite angles)",
   C("Vertically opposite angles, formed when two lines intersect, are always equal in measure.")+
   steps("Two lines cross at a point","the angles opposite each other across the point are vertically opposite","such angles are always equal.")+
   U("Where two roads cross in an X, the angle on one side equals the angle directly across from it."),
   [("always 90° each","They are equal to each other but not necessarily 90°; only if the lines are perpendicular."),
    ("always supplementary (add to 180°)","Adjacent angles at the crossing add to 180°, but the OPPOSITE pair are equal, not supplementary."),
    ("always complementary (add to 90°)","Vertically opposite angles are equal; they are not required to add to 90°.")]),

 ("LA","When two angles have the same vertex and one shared arm, sitting on opposite sides of that arm, they are called:",
   "adjacent angles",
   C("Adjacent angles share a vertex and one arm and do not overlap, sitting on opposite sides of the common arm.")+
   steps("They meet at the same vertex","they share one common arm","and lie on opposite sides of it — so they are adjacent.")+
   U("On a clock face, the angle from 12-to-2 and the angle from 2-to-4 share the 2-o'clock arm — they are adjacent."),
   [("vertically opposite angles","Vertically opposite angles sit across a crossing and share NO arm; adjacent angles share an arm."),
    ("alternate angles","Alternate angles are formed by a transversal cutting two lines, not by simply sharing one arm."),
    ("complementary angles","Sharing a vertex and arm does not force a 90° sum, so they need not be complementary.")]),

 ("LA","Two adjacent angles whose outer arms form a straight line make a:",
   "linear pair (they add to 180°)",
   C("A linear pair is two adjacent angles whose non-common arms make a straight line; their measures always add to 180°.")+
   steps("The two angles sit side by side sharing one arm","their outer arms lie in a straight line","so together they make 180° — a linear pair.")+
   U("A door swinging from a straight wall splits the straight 180° into two angles that form a linear pair."),
   [("a right angle pair (90° total)","A linear pair sits on a straight line, so it totals 180°, not 90°."),
    ("vertically opposite angles","Vertically opposite angles are across a crossing and are equal; a linear pair is adjacent and sums to 180°."),
    ("complementary angles","Complementary angles total 90°; a linear pair on a straight line totals 180°.")]),

 ("LA","An angle that is greater than 90° but less than 180° is called:",
   "an obtuse angle",
   C("An obtuse angle lies between 90° and 180°. (Below 90° is acute; exactly 90° is right; above 180° is reflex.)")+
   steps("Check the size: more than 90° but less than 180°","that range is named obtuse","so the angle is obtuse.")+
   U("The wide-open angle of a laptop screen tilted well back from its keyboard is obtuse."),
   [("an acute angle","An acute angle is LESS than 90°; an angle between 90° and 180° is obtuse."),
    ("a right angle","A right angle is exactly 90°; obtuse angles are bigger than 90°."),
    ("a reflex angle","A reflex angle is MORE than 180°; the 90°-to-180° range is obtuse.")]),

 ("LA","A ray of light reflects off a mirror so that the angle of incidence equals the angle of reflection. If each is 50°, the angle between the incident and reflected rays is:",
   "100°",
   C("The two rays sit on opposite sides of the normal, each 50° from it, so the angle between them is 50° + 50° = 100°.")+
   steps("Angle of incidence = angle of reflection = 50°","they lie on opposite sides of the normal","angle between rays = 50° + 50° = 100°.")+
   U("A torch beam bouncing off a mirror at a moderate slant opens into a 100° V between the in- and out-beams."),
   [("50°","50° is each single angle from the normal; the two rays together span 50° + 50° = 100°."),
    ("40°","40° comes from 90° − 50°; the angle between the rays is the sum 50° + 50° = 100°."),
    ("130°","130° would need each angle to be 65°; with 50° each the rays span 100°.")]),

 ("LA","When a transversal cuts two parallel lines, a pair of corresponding angles are:",
   "equal",
   C("With parallel lines, corresponding angles (same position at each crossing) are equal — a key parallel-line rule.")+
   steps("Mark angles in the same position at both crossings","because the lines are parallel","these corresponding angles are equal.")+
   U("The matching angles a slanting telephone wire makes with two parallel rooftops are equal — corresponding angles."),
   [("supplementary (add to 180°)","Co-interior (allied) angles add to 180°, but CORRESPONDING angles are equal under parallel lines."),
    ("complementary (add to 90°)","Corresponding angles are equal to each other, not paired to make 90°."),
    ("always 90°","They are equal whatever their size; they are only 90° if the transversal is perpendicular.")]),

 ("LA","When a transversal cuts two parallel lines, a pair of co-interior (allied) angles are:",
   "supplementary (add to 180°)",
   C("Co-interior angles lie on the same side of the transversal between the two parallel lines; they add up to 180°.")+
   steps("Find the two interior angles on the same side of the transversal","because the lines are parallel","these co-interior angles sum to 180°.")+
   U("The two inside angles on one side where a road crosses two parallel kerbs add to a straight 180°."),
   [("equal","Alternate and corresponding angles are equal; co-interior angles are SUPPLEMENTARY, adding to 180°."),
    ("complementary (add to 90°)","Co-interior angles add to 180°, not 90°."),
    ("always 45° each","Their sizes vary; what is fixed is that the co-interior pair sums to 180°.")]),

 ("LA","An angle that is exactly 180° looks like a straight line and is called a:",
   "straight angle",
   C("A straight angle measures exactly 180° — its two arms point in opposite directions along a straight line.")+
   steps("The arms of the angle point in exactly opposite directions","forming one straight line","that 180° angle is a straight angle.")+
   U("A see-saw lying perfectly flat makes a straight 180° angle from end to end."),
   [("a right angle","A right angle is 90°; a 180° angle is a straight angle, twice as big."),
    ("a reflex angle","A reflex angle is more than 180°; exactly 180° is a straight angle."),
    ("a complete angle","A complete angle is a full 360° turn; 180° is half of that, a straight angle.")]),

 ("LA","An angle whose measure lies somewhere between 180° and 360° is called:",
   "a reflex angle",
   C("A reflex angle is bigger than a straight angle (180°) but less than a full turn (360°).")+
   steps("Check the size: between 180° and 360°","that wide range is named reflex","so the angle is reflex.")+
   U("The large outside angle you sweep going the 'long way' around a clock from 12 to 1 is reflex."),
   [("an obtuse angle","An obtuse angle is between 90° and 180°; bigger than 180° is reflex."),
    ("a straight angle","A straight angle is exactly 180°; more than 180° is reflex."),
    ("a complete angle","A complete angle is exactly 360°; between 180° and 360° is reflex.")]),

 ("LA","At exactly 3 o'clock, the angle made between a clock's hour hand and its minute hand is:",
   "90°",
   C("At 3 o'clock the minute hand points to 12 and the hour hand to 3, which are a quarter-turn apart — 90°.")+
   steps("Minute hand at 12, hour hand at 3","that is 3 of the 12 hour-marks apart = 3/12 of 360°","3/12 × 360° = 90°.")+
   U("A clock reading 3:00 makes a perfect right angle — a handy real-life right angle to spot."),
   [("180°","180° would be hands pointing exactly opposite, like 6 o'clock, not 3 o'clock's quarter turn of 90°."),
    ("45°","45° is half of 90°; at 3 o'clock the hands are a full quarter-turn, i.e. 90° apart."),
    ("120°","120° is the 4-hour gap angle; the 3 o'clock gap of 3 hour-marks is 90°.")]),

 ("LA","Through how many degrees does the minute hand of a clock turn in 15 minutes?",
   "90°",
   C("The minute hand sweeps a full 360° in 60 minutes, so in 15 minutes it turns 15/60 × 360° = 90°.")+
   steps("Full turn = 360° in 60 minutes","15 minutes is 15/60 = 1/4 of an hour","1/4 × 360° = 90°.")+
   U("From :00 to :15 the minute hand makes a clean quarter-turn — a 90° sweep."),
   [("15°","15° treats minutes as degrees directly; the minute hand turns 6° per minute, so 15 min = 90°."),
    ("45°","45° is half the correct turn; a quarter of 360° is 90°, not 45°."),
    ("180°","180° is half a full turn (30 minutes); 15 minutes is a quarter turn, 90°.")]),

 ("LA","Two complementary angles are in the ratio 2 : 3. The smaller angle is:",
   "36°",
   C("The parts are 2 + 3 = 5, sharing 90°. Each part = 90° ÷ 5 = 18°, so the smaller (2 parts) = 2 × 18° = 36°.")+
   steps("Sum of complementary angles = 90°","ratio parts 2 + 3 = 5, so one part = 90° ÷ 5 = 18°","smaller = 2 × 18° = 36°.")+
   U("Splitting a right-angle corner in a 2 : 3 ratio gives pieces of 36° and 54°."),
   [("54°","54° is the LARGER angle (3 parts); the smaller is the 2-part share, 36°."),
    ("18°","18° is just ONE part; the smaller angle is 2 parts, i.e. 2 × 18° = 36°."),
    ("60°","60° fits a 2 : 3 split of 150°, not of 90°; for complementary angles the smaller is 36°.")]),

 ("LA","Two supplementary angles are equal. Each angle measures:",
   "90°",
   C("Equal supplementary angles each take half of 180°, so each is 180° ÷ 2 = 90°.")+
   steps("Supplementary angles add to 180°","if they are equal, split 180° into two equal parts","each = 180° ÷ 2 = 90°.")+
   U("A straight wall cut by a perpendicular post makes two equal 90° angles on either side."),
   [("45°","45° each would total only 90°; equal supplementary angles must total 180°, so each is 90°."),
    ("180°","180° is the TOTAL of both; each equal angle is half of that, 90°."),
    ("60°","Two 60° angles total 120°, not 180°; equal supplementary angles are 90° each.")]),

 ("LA","When a transversal cuts two parallel lines, a pair of alternate interior angles are:",
   "equal",
   C("Alternate interior angles lie between the parallel lines on opposite sides of the transversal and are equal.")+
   steps("Find the interior angles on opposite sides of the transversal","because the lines are parallel","these alternate interior angles are equal.")+
   U("The Z-shape made by a slanting beam crossing two parallel rails shows equal alternate angles."),
   [("supplementary (add to 180°)","CO-interior angles add to 180°; ALTERNATE interior angles are equal."),
    ("complementary (add to 90°)","Alternate interior angles are equal to each other, not a 90° pair."),
    ("always 30° each","Their size varies with the transversal; what holds is that the alternate pair are equal.")]),

 ("LA","The angle between the two hands of a clock at 6 o'clock is:",
   "180°",
   C("At 6 o'clock the hands point in exactly opposite directions (12 and 6), making a straight angle of 180°.")+
   steps("Minute hand at 12, hour hand at 6","they point opposite ways along a straight line","so the angle between them is 180°.")+
   U("A clock at 6:00 shows its hands in a straight line — a 180° straight angle."),
   [("90°","90° is the 3 o'clock right angle; at 6 o'clock the hands are opposite, giving 180°."),
    ("360°","360° is a full turn back to the start; opposite hands span half that, 180°."),
    ("60°","60° is the gap of two hour-marks; at 6 o'clock the hands are 6 marks (half the dial) apart, 180°.")]),

 ("LA","If one angle of a linear pair is 65°, the other angle is:",
   "115°",
   C("A linear pair adds to 180°, so the other angle is 180° − 65° = 115°.")+
   steps("Linear pair sum = 180°","other angle = 180° − 65°","= 115°.")+
   U("Where a slanting branch meets a straight trunk, the two angles on the line read 65° and 115°."),
   [("25°","25° is the complement (90° − 65°); a linear pair uses 180°, giving 180° − 65° = 115°."),
    ("65°","65° is the given angle; its linear-pair partner is the rest of 180°, namely 115°."),
    ("180°","180° is the TOTAL of both angles, not one of them; the missing angle is 180° − 65° = 115°.")]),

 ("LA","Two lines in a plane that never meet, however far they are extended, are said to be:",
   "parallel",
   C("Parallel lines stay the same distance apart and never intersect, no matter how far they are extended.")+
   steps("Extend both lines endlessly in both directions","if they never cross and keep a fixed gap","they are parallel.")+
   U("The two rails of a railway track are parallel — they run side by side without ever meeting."),
   [("perpendicular","Perpendicular lines DO meet, crossing at 90°; lines that never meet are parallel."),
    ("intersecting","Intersecting lines cross at a point; parallel lines never cross."),
    ("concurrent","Concurrent lines all pass through one common point; parallel lines share no point.")]),

 ("LA","Two lines that cross each other and make an angle of 90° at the crossing are called:",
   "perpendicular lines",
   C("Perpendicular lines intersect at right angles (90°). The symbol ⊥ marks this relationship.")+
   steps("The lines cross at a point","the angle at the crossing is exactly 90°","so the lines are perpendicular.")+
   U("The corner where two walls of a room meet shows perpendicular lines — a neat 90° corner."),
   [("parallel lines","Parallel lines never meet; perpendicular lines meet at 90°."),
    ("alternate lines","'Alternate' describes angle pairs, not a relationship between two lines crossing at 90°."),
    ("oblique lines","Oblique lines cross at an angle that is NOT 90°; a 90° crossing is perpendicular.")]),

 ("LA","An angle of 360° (a full turn back to the starting arm) is called:",
   "a complete angle",
   C("A complete (full) angle is one whole revolution of 360°, bringing the rotating arm back to its start.")+
   steps("Turn the arm once all the way around","it returns to where it began after 360°","that full turn is a complete angle.")+
   U("The minute hand sweeps a complete 360° angle once every hour."),
   [("a straight angle","A straight angle is only 180°, half a turn; a full 360° turn is a complete angle."),
    ("a reflex angle","A reflex angle is between 180° and 360°; exactly 360° is a complete angle."),
    ("a right angle","A right angle is 90°, a quarter of a complete 360° angle.")]),

 ("LA","The measure of an angle that is its own complement is:",
   "45°",
   C("If an angle equals its own complement, the two equal angles add to 90°, so each is 90° ÷ 2 = 45°.")+
   steps("Angle + its complement = 90°","they are equal, so 2 × angle = 90°","angle = 90° ÷ 2 = 45°.")+
   U("The diagonal of a square makes equal 45° angles with both sides — each is its own complement."),
   [("90°","90° has no complement left (90 − 90 = 0); an angle equal to its complement is 45°."),
    ("30°","30°'s complement is 60°, which is not equal to 30°; the self-complement is 45°."),
    ("60°","60°'s complement is 30°, not equal to 60°; only 45° equals its own complement.")]),

 ("LA","Two angles forming a linear pair are in the ratio 1 : 2. The larger angle is:",
   "120°",
   C("A linear pair adds to 180°. With parts 1 + 2 = 3, one part = 180° ÷ 3 = 60°, so the larger (2 parts) = 120°.")+
   steps("Linear pair sum = 180°","parts 1 + 2 = 3, so one part = 180° ÷ 3 = 60°","larger = 2 × 60° = 120°.")+
   U("Splitting a straight 180° edge in a 1 : 2 ratio gives angles of 60° and 120°."),
   [("60°","60° is the SMALLER angle (1 part); the larger is 2 parts, i.e. 120°."),
    ("90°","90° would come from an equal 1 : 1 split; a 1 : 2 split of 180° gives 60° and 120°."),
    ("45°","45° fits a split of 90°, not a linear pair; here the larger angle is 120°.")]),
]

# ---------- COMPARING QUANTITIES (25) — Maths (several fused with motion/light) ----------
CQ = [
 ("CQ","To write the fraction 3/5 as a percentage, you compute:",
   "60%",
   C("A percentage is a fraction out of 100. 3/5 = 3 ÷ 5 × 100% = 60%.")+
   steps("Percentage = fraction × 100","3/5 × 100 = 300 ÷ 5","= 60%.")+
   U("Scoring 3 out of every 5 marks means a 60% result on a test."),
   [("35%","35% just glues the digits 3 and 5 together; 3/5 as a percent is 3 ÷ 5 × 100 = 60%."),
    ("53%","53% reverses the digits; the actual value of 3/5 is 60%."),
    ("30%","30% is 3/10, not 3/5; converting 3/5 gives 60%.")]),

 ("CQ","Find the value of 25% of 80:",
   "20",
   C("25% means 25/100 = 1/4, so 25% of 80 is 1/4 × 80 = 20.")+
   steps("25% = 25/100 = 1/4","1/4 of 80 = 80 ÷ 4","= 20.")+
   U("A 25% discount on an ₹80 item knocks off ₹20, leaving ₹60."),
   [("25","25 is the percentage figure itself, not 25% of 80; one quarter of 80 is 20."),
    ("40","40 is HALF (50%) of 80; a quarter (25%) of 80 is 20."),
    ("55","55 is 80 − 25, not a percentage of 80; 25% of 80 is 20.")]),

 ("CQ","The ratio 12 : 18 written in its simplest form is:",
   "2 : 3",
   C("Divide both terms by their HCF, 6: 12 ÷ 6 : 18 ÷ 6 = 2 : 3.")+
   steps("Find the HCF of 12 and 18 → 6","divide both by 6","12÷6 : 18÷6 = 2 : 3.")+
   U("A recipe needing 12 spoons of flour to 18 of water simplifies to a 2 : 3 mix."),
   [("3 : 2","3 : 2 reverses the order; 12 : 18 simplifies to 2 : 3, keeping 12 first."),
    ("6 : 9","6 : 9 is partly reduced but not simplest; dividing again by 3 gives 2 : 3."),
    ("1 : 2","1 : 2 would come from 12 : 24; 12 : 18 reduces to 2 : 3, not 1 : 2.")]),

 ("CQ","A shopkeeper buys a toy for ₹200 and sells it for ₹250. His profit percent is:",
   "25%",
   C("Profit = 250 − 200 = ₹50. Profit% = (profit ÷ cost price) × 100 = (50 ÷ 200) × 100 = 25%.")+
   steps("Profit = SP − CP = 250 − 200 = ₹50","profit% = (profit ÷ CP) × 100","= (50 ÷ 200) × 100 = 25%.")+
   U("A trader uses profit% to compare deals fairly, regardless of how costly each item was."),
   [("50%","50% would mean a ₹100 profit on ₹200; the actual ₹50 profit is (50 ÷ 200) × 100 = 25%."),
    ("20%","20% is profit over SELLING price (50 ÷ 250); profit% is taken on the COST price, giving 25%."),
    ("12.5%","12.5% halves the answer; (50 ÷ 200) × 100 is 25%, not 12.5%.")]),

 ("CQ","A ₹500 jacket is sold at a 10% discount. The discount amount is:",
   "₹50",
   C("Discount = 10% of ₹500 = 10/100 × 500 = ₹50.")+
   steps("Discount = 10% of 500","= 10/100 × 500","= ₹50.")+
   U("A '10% off' tag on a ₹500 jacket saves you ₹50, so you pay ₹450."),
   [("₹10","₹10 is just the percentage number; 10% of ₹500 is 10/100 × 500 = ₹50."),
    ("₹100","₹100 would be a 20% discount; 10% of ₹500 is ₹50."),
    ("₹450","₹450 is the PRICE you pay after the discount, not the discount itself, which is ₹50.")]),

 ("CQ","Convert 0.75 into a percentage:",
   "75%",
   C("To turn a decimal into a percent, multiply by 100: 0.75 × 100 = 75%.")+
   steps("Percent = decimal × 100","0.75 × 100","= 75%.")+
   U("A battery showing 0.75 of its charge is at 75% — three-quarters full."),
   [("7.5%","7.5% multiplies by only 10; converting a decimal to a percent multiplies by 100, giving 75%."),
    ("0.75%","0.75% forgets to multiply by 100; 0.75 as a percent is 75%."),
    ("750%","750% multiplies by 1000; the correct factor is 100, so 0.75 = 75%.")]),

 ("CQ","If 5 pens cost ₹40, then by the unitary method 8 pens cost:",
   "₹64",
   C("First find the cost of one pen: ₹40 ÷ 5 = ₹8. Then 8 pens cost 8 × ₹8 = ₹64.")+
   steps("Cost of 1 pen = 40 ÷ 5 = ₹8","cost of 8 pens = 8 × 8","= ₹64.")+
   U("The unitary method lets a shopper scale any 'so many for so much' price up or down."),
   [("₹50","₹50 just adds ₹10; using the unit price of ₹8, eight pens cost 8 × 8 = ₹64."),
    ("₹320","₹320 multiplies 40 × 8 without first finding the unit price; the answer is 8 × ₹8 = ₹64."),
    ("₹48","₹48 uses 6 pens or wrong arithmetic; 8 pens at ₹8 each is ₹64.")]),

 ("CQ","A car's speed is 40 km/h in town and 60 km/h on the highway. By what percent is the highway speed greater than the town speed?",
   "50%",
   C("Increase = 60 − 40 = 20 km/h. Percent increase = (20 ÷ 40) × 100 = 50%.")+
   steps("Increase = 60 − 40 = 20 km/h","percent on the town speed = (20 ÷ 40) × 100","= 50%.")+
   U("A travel app might say the highway leg is '50% faster' than the town leg — same idea."),
   [("20%","20 is the increase in km/h, not the percent; (20 ÷ 40) × 100 = 50%."),
    ("33%","33% uses 60 as the base (20 ÷ 60); percent INCREASE is on the original 40, giving 50%."),
    ("60%","60 is the highway speed value; the percent increase over 40 is (20 ÷ 40) × 100 = 50%.")]),

 ("CQ","In a class of 40 students, 60% passed a test. The number of students who passed is:",
   "24",
   C("60% of 40 = 60/100 × 40 = 24 students.")+
   steps("Passed = 60% of 40","= 60/100 × 40","= 24 students.")+
   U("A teacher reporting '60% passed' in a class of 40 means 24 students cleared the test."),
   [("60","60 is the percentage, but there are only 40 students; 60% of 40 is 24."),
    ("16","16 is the number who FAILED (40% of 40); the number who passed is 24."),
    ("30","30 would be 75% of 40; 60% of 40 is 24.")]),

 ("CQ","Find the simple interest earned when ₹1000 is kept at 5% per year for 2 years:",
   "₹100",
   C("Simple interest = (P × R × T) ÷ 100 = (1000 × 5 × 2) ÷ 100 = ₹100.")+
   steps("SI = (P × R × T) ÷ 100","= (1000 × 5 × 2) ÷ 100","= 10000 ÷ 100 = ₹100.")+
   U("Putting ₹1000 in a 5% savings scheme earns ₹100 of interest over two years."),
   [("₹50","₹50 is the interest for ONE year; over 2 years it doubles to ₹100."),
    ("₹200","₹200 would need 10% or 4 years; at 5% for 2 years it is ₹100."),
    ("₹1100","₹1100 is the total AMOUNT (principal + interest); the interest alone is ₹100.")]),

 ("CQ","Out of 50 light bulbs in a shop, 40 are working. The percentage of working bulbs is:",
   "80%",
   C("Percentage = (40 ÷ 50) × 100 = 80%.")+
   steps("Fraction working = 40/50","× 100 = (40 ÷ 50) × 100","= 80%.")+
   U("A quality check reporting '80% working' for a box of 50 bulbs means 40 light up."),
   [("40%","40 is the COUNT of working bulbs, not the percent; (40 ÷ 50) × 100 = 80%."),
    ("20%","20% is the percentage of FAULTY bulbs (10 of 50); the working share is 80%."),
    ("90%","90% would be 45 of 50 working; here 40 of 50 work, which is 80%.")]),

 ("CQ","Two numbers are in the ratio 3 : 4 and their sum is 56. The smaller number is:",
   "24",
   C("Total parts = 3 + 4 = 7. One part = 56 ÷ 7 = 8. Smaller (3 parts) = 3 × 8 = 24.")+
   steps("Parts = 3 + 4 = 7","one part = 56 ÷ 7 = 8","smaller = 3 × 8 = 24.")+
   U("Sharing 56 sweets between two children in a 3 : 4 ratio gives the smaller share 24."),
   [("32","32 is the LARGER share (4 parts); the smaller is 3 parts, i.e. 24."),
    ("8","8 is just ONE part; the smaller number is 3 parts, 3 × 8 = 24."),
    ("28","28 is half of 56 (an equal split); a 3 : 4 split makes the smaller part 24.")]),

 ("CQ","A price rises from ₹80 to ₹100. The percentage increase is:",
   "25%",
   C("Increase = 100 − 80 = ₹20. Percent increase = (20 ÷ 80) × 100 = 25%.")+
   steps("Increase = 100 − 80 = ₹20","percent on the original = (20 ÷ 80) × 100","= 25%.")+
   U("A notebook going from ₹80 to ₹100 has gone up by 25%."),
   [("20%","₹20 is the rise in rupees, not the percent; (20 ÷ 80) × 100 = 25%."),
    ("25 rupees","The question asks for a percentage, not rupees; the increase of ₹20 is 25%."),
    ("125%","125% is the NEW price as a percent of the old; the INCREASE is 25%.")]),

 ("CQ","Express 2 : 5 as a percentage:",
   "40%",
   C("2 : 5 means the fraction 2/5 = 2 ÷ 5 × 100% = 40%.")+
   steps("Ratio 2 : 5 → fraction 2/5","2/5 × 100","= 40%.")+
   U("If 2 out of every 5 fruits in a basket are mangoes, mangoes make up 40%."),
   [("25%","25% is 1/4; the ratio 2 : 5 is the fraction 2/5 = 40%."),
    ("20%","20% is 1/5; 2 : 5 means 2/5, which is 40%."),
    ("50%","50% is 1/2; 2 : 5 simplifies to 40%, not half.")]),

 ("CQ","A shirt costing ₹600 is sold at a loss of 15%. The loss amount is:",
   "₹90",
   C("Loss = 15% of ₹600 = 15/100 × 600 = ₹90.")+
   steps("Loss = 15% of 600","= 15/100 × 600","= ₹90.")+
   U("A clearance sale at a 15% loss on a ₹600 shirt means the shop loses ₹90 on it."),
   [("₹15","₹15 is just the percentage figure; 15% of ₹600 is ₹90."),
    ("₹510","₹510 is the SELLING price after the loss, not the loss itself, which is ₹90."),
    ("₹90 profit","It is a LOSS of ₹90, not a profit; the amount is correct but the sign is wrong.")]),

 ("CQ","A pendulum completes 45 swings out of an expected 60 in a faulty test. The percent of expected swings it managed is:",
   "75%",
   C("Percentage = (45 ÷ 60) × 100 = 75%.")+
   steps("Fraction done = 45/60","× 100 = (45 ÷ 60) × 100","= 75%.")+
   U("A science-lab log might note the pendulum performed at 75% of the expected count."),
   [("45%","45 is the COUNT of swings, not the percent; (45 ÷ 60) × 100 = 75%."),
    ("60%","60 is the expected total, not the percent achieved; 45 of 60 is 75%."),
    ("25%","25% is the share it MISSED (15 of 60); the share it managed is 75%.")]),

 ("CQ","If 30% of a number is 60, the number is:",
   "200",
   C("Let the number be N. 30% of N = 60 → 0.30 × N = 60 → N = 60 ÷ 0.30 = 200.")+
   steps("0.30 × N = 60","N = 60 ÷ 0.30","= 200.")+
   U("If a 30% deposit comes to ₹60, the full price works out to ₹200."),
   [("18","18 is 30% of 60, the reverse of what is asked; here 30% of the number IS 60, giving 200."),
    ("90","90 is 60 + 30; you must divide 60 by 0.30, getting 200."),
    ("600","600 divides by 0.1 (10%), not 0.3; 60 ÷ 0.30 = 200.")]),

 ("CQ","The ratio of 50 paise to ₹2 (in the same unit) is:",
   "1 : 4",
   C("Convert to the same unit: ₹2 = 200 paise. Ratio = 50 : 200 = 1 : 4 after dividing by 50.")+
   steps("₹2 = 200 paise (same unit as 50 paise)","ratio = 50 : 200","÷50 → 1 : 4.")+
   U("Comparing money amounts needs the same unit first — 50 paise is one-quarter of ₹2."),
   [("25 : 1","25 : 1 flips and mis-scales; in paise the ratio 50 : 200 reduces to 1 : 4."),
    ("50 : 2","50 : 2 mixes paise with rupees; convert ₹2 to 200 paise first, giving 1 : 4."),
    ("1 : 2","1 : 2 would need ₹1; 50 paise to ₹2 (200 paise) is 1 : 4.")]),

 ("CQ","A bag has 20 red and 30 blue marbles. Red marbles form what percent of the total?",
   "40%",
   C("Total = 20 + 30 = 50. Red percent = (20 ÷ 50) × 100 = 40%.")+
   steps("Total marbles = 20 + 30 = 50","red fraction = 20/50","× 100 = 40%.")+
   U("Saying '40% of the marbles are red' is a clear way to describe the mix at a glance."),
   [("20%","20 is the COUNT of red marbles, not the percent; (20 ÷ 50) × 100 = 40%."),
    ("60%","60% is the BLUE share (30 of 50); the red share is 40%."),
    ("66%","66% would be 20 out of 30, ignoring that the total is 50; red of total is 40%.")]),

 ("CQ","A cyclist covers 36 km in 90 minutes. Her speed in km per hour is:",
   "24 km/h",
   C("90 minutes = 1.5 hours. Speed = distance ÷ time = 36 ÷ 1.5 = 24 km/h.")+
   steps("Time = 90 min = 1.5 h","speed = distance ÷ time = 36 ÷ 1.5","= 24 km/h.")+
   U("Converting minutes to hours first lets you read a cyclist's pace as a clean 24 km/h."),
   [("40 km/h","40 km/h treats 90 minutes as 0.9 h; 90 min is 1.5 h, giving 36 ÷ 1.5 = 24 km/h."),
    ("36 km/h","36 km is the distance, and the time is 1.5 h, so the speed is 36 ÷ 1.5 = 24 km/h, not 36."),
    ("54 km/h","54 multiplies 36 × 1.5; speed is distance DIVIDED by time, giving 24 km/h.")]),

 ("CQ","A number is increased by 20% and the result is 120. The original number was:",
   "100",
   C("After a 20% rise the number becomes 120% of the original: 1.20 × N = 120, so N = 120 ÷ 1.20 = 100.")+
   steps("New = 120% of original = 1.20 × N","1.20 × N = 120","N = 120 ÷ 1.20 = 100.")+
   U("If a salary after a 20% raise is ₹120, the salary before the raise was ₹100."),
   [("96","96 subtracts 20% of 120; but 120 is AFTER the rise, so N = 120 ÷ 1.20 = 100."),
    ("140","140 adds 20 to 120; the original is found by dividing by 1.20, giving 100."),
    ("24","24 is 20% of 120; the original number is 120 ÷ 1.20 = 100.")]),

 ("CQ","Half of a right angle, expressed as a percentage of a full turn (360°), is:",
   "12.5%",
   C("Half a right angle = 45°. As a percent of 360°: (45 ÷ 360) × 100 = 12.5%.")+
   steps("Half a right angle = 90° ÷ 2 = 45°","fraction of full turn = 45/360 = 1/8","1/8 × 100 = 12.5%.")+
   U("A 45° slice of a full circular pie chart is one-eighth, i.e. 12.5% of the whole."),
   [("25%","25% is 90° (a full right angle) out of 360°; HALF a right angle, 45°, is 12.5%."),
    ("50%","50% would be 180°; 45° is only 12.5% of the full 360° turn."),
    ("45%","45 is the angle in DEGREES, not its percent of 360°; that percent is 12.5%.")]),

 ("CQ","A 2-litre bottle is 35% full of juice. The amount of juice, in millilitres, is:",
   "700 mL",
   C("2 litres = 2000 mL. 35% of 2000 mL = 35/100 × 2000 = 700 mL.")+
   steps("2 L = 2000 mL","35% of 2000 = 35/100 × 2000","= 700 mL.")+
   U("Reading '35% full' on a 2-litre bottle tells you there are 700 mL of juice inside."),
   [("35 mL","35 is just the percentage; 35% of 2000 mL is 700 mL."),
    ("70 mL","70 mL is 35% of 200 mL, not of 2000 mL; the correct amount is 700 mL."),
    ("1300 mL","1300 mL is the EMPTY part (65%); the juice (35%) is 700 mL.")]),

 ("CQ","A train's speed drops from 100 km/h to 75 km/h. The percentage decrease is:",
   "25%",
   C("Decrease = 100 − 75 = 25 km/h. Percent decrease = (25 ÷ 100) × 100 = 25%.")+
   steps("Decrease = 100 − 75 = 25 km/h","percent on the original 100 = (25 ÷ 100) × 100","= 25%.")+
   U("A slow-down notice saying the train is '25% slower' matches a drop from 100 to 75 km/h."),
   [("75%","75 is the NEW speed as a percent of the old; the DECREASE is 25%."),
    ("33%","33% uses 75 as the base; percent DECREASE is on the original 100, giving 25%."),
    ("50%","50% of 100 is a 50 km/h drop; the actual drop of 25 km/h is 25%.")]),

 ("CQ","A glass pane lets through 80% of the light falling on it. If 500 units of light strike it, the amount passing through is:",
   "400 units",
   C("80% of 500 = 80/100 × 500 = 400 units pass through; the other 20% (100 units) is reflected or absorbed.")+
   steps("Light passing = 80% of 500","= 80/100 × 500","= 400 units.")+
   U("A clean window passing 80% of daylight lets 400 of every 500 units of sunlight into the room."),
   [("80 units","80 is just the percentage figure; 80% of 500 units is 400 units."),
    ("100 units","100 units is the 20% that does NOT pass through; the part that passes is 400 units."),
    ("580 units","580 adds 80 to 500; the light that passes is 80% of 500 = 400 units.")]),
]

# ---------- assemble: interleave so no two consecutive share a chapter ----------
assert all(len(b) == 25 for b in (LT, MT, LA, CQ)), [len(LT), len(MT), len(LA), len(CQ)]
items = []
for i in range(25):
    items += [LT[i], MT[i], LA[i], CQ[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=46031,
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
    split = "/".join(str(counts[c]) for c in ("LT", "MT", "LA", "CQ"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Light",
                     "Motion & Time",
                     "Lines & Angles",
                     "Comparing Quantities"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
