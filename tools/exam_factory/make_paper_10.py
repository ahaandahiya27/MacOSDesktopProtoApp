# -*- coding: utf-8 -*-
# Boss Challenge Paper 10 — Symmetry · Light · Arithmetic Expressions · Physical & Chemical Changes
# Content-only. Uses the dependency-free examfactory engine.
# Produces, under Resources/BossChallengePapers/:
#   Paper_10_<SHORT>_QuestionPaper.html  (pure HTML — questions + options, no answers)
#   Paper_10_<SHORT>_QuestionPaper.pdf
#   Paper_10_<SHORT>_Questions.md
#   Paper_10_<SHORT>_Solutions.html
import os, sys, shutil, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "10"
SHORT = "Symmetry_Light_ArithExpr_PhysChem"
TITLE = "Symmetry · Light · Arithmetic Expressions · Physical & Chemical Changes"
LABELS = {
    "SYM":   "Symmetry",
    "LIGHT": "Light",
    "AEX":   "Arithmetic Expressions",
    "PCC":   "Physical & Chemical Changes",
}

# ---------- SYMMETRY (25) — Maths ----------
SYM = [
 ("SYM","A figure has a line of symmetry when a mirror placed on that line shows that:",
   "one half is the exact mirror image of the other half",
   C("A line of symmetry folds a figure into two halves that match perfectly, each being the reflection of the other.")+
   steps("Place a mirror along the line","Look at the half plus its reflection","If it rebuilds the whole figure, the line is a line of symmetry.")+
   U("This is why you can fold a paper butterfly in half and the two wings land exactly on top of each other."),
   [("the two halves are different shapes","If the halves differed, the fold would NOT match, so it would not be a line of symmetry."),
    ("the figure has no halves at all","A line of symmetry splits the figure into two halves, so it must have halves."),
    ("the figure becomes larger","Reflection does not change size; the halves stay the same size.")]),

 ("SYM","How many lines of symmetry does a square have?",
   "4",
   C("A square can be folded onto itself along 4 lines: 2 through the midpoints of opposite sides and 2 along the diagonals.")+
   steps("2 lines join midpoints of opposite sides","2 lines lie along the diagonals","2 + 2 = 4 lines of symmetry.")+
   U("Floor tiles are square so they look the same however you turn or flip them while laying them."),
   [("2","2 covers only the side-to-side folds; the diagonals are lines of symmetry too."),
    ("1","A square has many more than one; even a rectangle beats that."),
    ("8","8 is the count of symmetries including rotations, not lines of symmetry; there are only 4 lines.")]),

 ("SYM","How many lines of symmetry does a rectangle (that is not a square) have?",
   "2",
   C("A non-square rectangle folds onto itself only along the two lines joining midpoints of opposite sides.")+
   steps("One horizontal fold through the middle works","One vertical fold through the middle works","Its diagonals do NOT match, so there are only 2.")+
   U("A door folds neatly top-to-bottom and side-to-side, but not corner-to-corner."),
   [("4","4 belongs to a square; a rectangle's diagonals are not lines of symmetry."),
    ("1","Both a horizontal and a vertical fold work, so there are 2, not 1."),
    ("0","A rectangle clearly has matching halves, so it has more than zero.")]),

 ("SYM","How many lines of symmetry does an equilateral triangle have?",
   "3",
   C("An equilateral triangle has a line of symmetry through each vertex and the midpoint of the opposite side.")+
   steps("All three sides are equal","Each vertex gives one matching fold","3 vertices -> 3 lines of symmetry.")+
   U("This balance is why a triangular road sign looks the same no matter which corner points up."),
   [("1","1 is for an isosceles triangle; an equilateral one has three equal sides and three lines."),
    ("2","An equilateral triangle is more symmetric than 2; every vertex gives a line."),
    ("0","A scalene triangle has 0; an equilateral one is far more symmetric.")]),

 ("SYM","How many lines of symmetry does a circle have?",
   "infinitely many",
   C("Every straight line drawn through the centre of a circle divides it into two matching halves.")+
   steps("Pick any line through the centre","It splits the circle into two equal halves","There is no limit to such lines -> infinitely many.")+
   U("That perfect all-round symmetry is why wheels are circular — they roll the same in every direction."),
   [("4","A circle is far more symmetric than a square; any diameter is a line of symmetry."),
    ("1","Only one would mean a single fold; a circle works for every diameter."),
    ("8","8 is still a finite number; a circle has unlimited lines of symmetry.")]),

 ("SYM","An isosceles triangle (only two sides equal) has how many lines of symmetry?",
   "1",
   C("The single line of symmetry runs from the vertex between the two equal sides to the midpoint of the base.")+
   steps("Two sides are equal, the third differs","Only the fold through the apex matches","So there is exactly 1 line of symmetry.")+
   U("A slice of pizza or an ice-cream cone shows this single up-and-down balance."),
   [("3","3 needs all three sides equal (equilateral); here only two are equal."),
    ("2","Only the apex fold matches; the other two folds do not, so it is 1."),
    ("0","An isosceles triangle does have one matching fold, so it is not zero.")]),

 ("SYM","How many lines of symmetry does a scalene triangle (all sides different) have?",
   "0",
   C("With every side a different length, no fold can make the two halves match.")+
   steps("All three sides differ","No fold lines up the sides","So there are 0 lines of symmetry.")+
   U("Many natural rock and land shapes are scalene — beautifully irregular with no clean fold."),
   [("1","A single fold would need at least two equal sides; a scalene triangle has none."),
    ("3","3 lines need all sides equal; a scalene triangle has all sides different."),
    ("2","Even two lines need two equal sides; here every side is different, so it is 0.")]),

 ("SYM","Which capital letter has a vertical line of symmetry?",
   "A",
   C("A vertical line down the middle of 'A' leaves its left and right halves as mirror images.")+
   steps("Draw a vertical line down the middle of A","The left and right halves match","So A has a vertical line of symmetry.")+
   U("Designers lean on such letters to make logos look balanced and steady."),
   [("F","F has no matching half about any line, so it has no line of symmetry."),
    ("P","P is lopsided; neither a vertical nor a horizontal fold matches."),
    ("R","R cannot be folded into two matching halves, so it has no line of symmetry.")]),

 ("SYM","Which capital letter has a HORIZONTAL line of symmetry?",
   "B",
   C("A horizontal line across the middle of 'B' makes its top half mirror its bottom half.")+
   steps("Draw a horizontal line through the middle of B","Top and bottom halves match","So B has a horizontal line of symmetry.")+
   U("Letters like B, C, D and E read the same when reflected in still water from above."),
   [("A","A's symmetry is vertical, not horizontal; a sideways fold does not match."),
    ("R","R has no line of symmetry in any direction."),
    ("F","F cannot be folded into matching halves, so it has none.")]),

 ("SYM","How many lines of symmetry does the capital letter H have?",
   "2",
   C("H matches across a vertical fold and across a horizontal fold.")+
   steps("Vertical fold: left and right halves match","Horizontal fold: top and bottom halves match","2 matching folds -> 2 lines of symmetry.")+
   U("That double balance is why H looks the same in a mirror and upside down."),
   [("1","H matches in BOTH directions, so it has 2 lines, not 1."),
    ("0","H clearly folds into matching halves, so it is not zero."),
    ("4","H has only a vertical and a horizontal line; its diagonals do not match, so it is 2.")]),

 ("SYM","A regular pentagon has how many lines of symmetry?",
   "5",
   C("A regular polygon with all sides and angles equal has as many lines of symmetry as it has sides.")+
   steps("A pentagon has 5 equal sides","Each vertex gives one matching fold","5 sides -> 5 lines of symmetry.")+
   U("The five-fold balance of a starfish and a pentagon are the same idea."),
   [("4","4 is a square's count; a regular pentagon has 5 sides and 5 lines."),
    ("1","A regular pentagon is highly symmetric — far more than a single fold."),
    ("10","10 counts rotations as well; there are only 5 lines of symmetry.")]),

 ("SYM","A regular hexagon has how many lines of symmetry?",
   "6",
   C("A regular hexagon, with 6 equal sides, has 6 lines of symmetry.")+
   steps("A regular polygon has as many lines as sides","A hexagon has 6 equal sides","So it has 6 lines of symmetry.")+
   U("Honeycomb cells are regular hexagons — that symmetry lets them tile with no gaps."),
   [("3","3 is for an equilateral triangle; a hexagon has 6 sides and 6 lines."),
    ("12","12 mixes in rotational counts; only 6 are lines of symmetry."),
    ("4","A hexagon has 6 sides, so 6 lines, not 4.")]),

 ("SYM","The ORDER of rotational symmetry of a square is:",
   "4",
   C("Order of rotational symmetry is how many times a figure looks the same in one full 360 turn.")+
   steps("Turn a square by 90 -> looks the same","It matches at 90, 180, 270 and 360","That is 4 matching positions -> order 4.")+
   U("A square table looks unchanged each quarter-turn, handy when four people sit around it."),
   [("1","Order 1 means it matches only after a full turn; a square matches every 90."),
    ("2","2 is a rectangle's order; a square matches at every quarter turn, giving 4."),
    ("8","8 counts reflections too; the rotational order alone is 4.")]),

 ("SYM","The smallest angle by which a square must be turned to look the same is:",
   "90 degrees",
   C("Divide a full turn of 360 by the order of rotational symmetry (4 for a square).")+
   steps("Order of rotational symmetry of a square = 4","360 / 4 = 90","So the smallest turn is 90 degrees.")+
   U("A ceiling fan with four blades looks identical after each 90 of spin."),
   [("180 degrees","A square matches sooner than half a turn — at 90 already."),
    ("45 degrees","Turn a square 45 and the corners no longer line up; it does not match."),
    ("360 degrees","Every figure matches at 360; a square matches much earlier, at 90.")]),

 ("SYM","The order of rotational symmetry of an equilateral triangle is:",
   "3",
   C("An equilateral triangle matches itself three times in a full turn.")+
   steps("Turn it by 120 -> looks the same","Matches at 120, 240 and 360","That is 3 positions -> order 3.")+
   U("A three-blade wind turbine looks the same after every third of a turn."),
   [("1","It matches more than once in a turn; specifically every 120, giving order 3."),
    ("6","6 mixes in reflections; the rotational order is 3."),
    ("2","2 is a rectangle's order; a triangle has order 3.")]),

 ("SYM","Through what smallest angle must an equilateral triangle be turned to look the same?",
   "120 degrees",
   C("360 divided by the order of rotational symmetry (3) gives the smallest matching turn.")+
   steps("Order of rotational symmetry = 3","360 / 3 = 120","So the smallest turn is 120 degrees.")+
   U("This is the angle between the arms of the three-pointed Mercedes-Benz star."),
   [("90 degrees","90 fits a square (order 4), not a triangle (order 3)."),
    ("60 degrees","Turn a triangle just 60 and its corners do not match yet."),
    ("180 degrees","A triangle matches before half a turn — at 120.")]),

 ("SYM","A figure that looks the same ONLY after a full 360 turn has rotational symmetry of order:",
   "1",
   C("If the only matching position is the full turn, the order is 1 — the lowest possible.")+
   steps("It never matches part-way through a turn","It matches only at 360","So the order of rotational symmetry is 1.")+
   U("Most everyday irregular shapes, like a single shoe, have order 1."),
   [("0","Every figure matches at least once (at 360), so the smallest order is 1, not 0."),
    ("2","Order 2 would mean it also matches at 180; here it matches only at 360."),
    ("4","Order 4 matches every 90; this figure matches only after the full turn.")]),

 ("SYM","The order of rotational symmetry of a rectangle (not a square) is:",
   "2",
   C("A rectangle looks the same after a half turn and after a full turn.")+
   steps("Turn it 180 -> looks the same","Matches at 180 and 360","That is 2 positions -> order 2.")+
   U("A rectangular playing card looks identical when you spin it halfway round."),
   [("4","4 is a square's order; a rectangle only matches at 180 and 360."),
    ("1","A rectangle matches at the half turn too, so its order is 2, not 1."),
    ("3","Order 3 (every 120) fits a triangle, not a rectangle.")]),

 ("SYM","Which capital letter has rotational symmetry of order 2 (looks the same after a half turn)?",
   "S",
   C("Turn S by 180 and it lands back on itself, so its rotational order is 2.")+
   steps("Rotate S half a turn (180)","It looks exactly the same","So S has rotational symmetry of order 2.")+
   U("Letters S, N and Z share this 'upside-down looks the same' trick."),
   [("A","Turn A upside down and it looks like a tent point-down — not the same, so order 1."),
    ("T","T flipped 180 points downward; it does not match, so its order is 1."),
    ("B","B turned 180 does not look like B, so it has rotational order 1.")]),

 ("SYM","A regular polygon with n equal sides has how many lines of symmetry?",
   "n",
   C("A regular polygon has exactly as many lines of symmetry as it has sides.")+
   steps("Triangle (3 sides) -> 3 lines","Square (4 sides) -> 4 lines","So an n-sided regular polygon has n lines.")+
   U("This rule lets a designer instantly know a regular 12-sided clock face has 12 lines of symmetry."),
   [("2n","2n doubles the real count; an n-gon has exactly n lines of symmetry."),
    ("n - 1","Every side contributes a line, so it is n, not one fewer."),
    ("4","4 is fixed for a square only; the count grows with the number of sides.")]),

 ("SYM","You hold the capital letter A in front of a vertical plane mirror and its reflection looks exactly like A. This is because A has:",
   "a vertical line of symmetry",
   C("A vertical mirror reflects left-to-right; a letter with a vertical line of symmetry is its own mirror image.")+
   steps("A vertical mirror swaps left and right","A's left and right halves already match","So its reflection looks the same as A.")+
   U("This links Symmetry with Light: shop signs use such letters so they read correctly in a mirror too."),
   [("a horizontal line of symmetry","A horizontal line would matter for a mirror laid flat, not a vertical one facing the letter."),
    ("rotational symmetry of order 2","A does not look the same upside down, so this is not the reason."),
    ("no line of symmetry","If A had no line of symmetry its mirror image would look different; it does match.")]),

 ("SYM","The line of symmetry of the capital letter T is:",
   "vertical",
   C("Only a vertical fold down the middle of T makes its two halves match.")+
   steps("Fold T left-to-right about a vertical line -> halves match","A horizontal fold does NOT match (the stem sticks down)","So T's line of symmetry is vertical.")+
   U("That single vertical balance is why T looks tidy and upright on a keyboard."),
   [("horizontal","A horizontal fold leaves the stem unmatched, so it is not a line of symmetry."),
    ("diagonal","No slanted fold makes the halves of T match."),
    ("both vertical and horizontal","Only the vertical fold matches; the horizontal one does not.")]),

 ("SYM","A rhombus (a slanted square) has how many lines of symmetry?",
   "2",
   C("A rhombus folds onto itself only along its two diagonals.")+
   steps("Both diagonals are folds that match","The lines through side-midpoints do NOT match","So a rhombus has 2 lines of symmetry.")+
   U("The diamond shapes on playing cards are rhombuses with this two-diagonal balance."),
   [("4","4 is a square's count; a slanted rhombus matches only along its diagonals."),
    ("1","Both diagonals work as folds, so there are 2 lines, not 1."),
    ("0","A rhombus does have matching folds along its diagonals, so it is not zero.")]),

 ("SYM","Through what smallest angle must a regular hexagon be turned to look the same?",
   "60 degrees",
   C("360 divided by the order of rotational symmetry (6 for a hexagon) gives the smallest matching turn.")+
   steps("A regular hexagon has rotational order 6","360 / 6 = 60","So the smallest turn is 60 degrees.")+
   U("A hexagonal bolt head fits a spanner the same way after each 60 turn."),
   [("90 degrees","90 fits a square (order 4); a hexagon matches sooner, at 60."),
    ("120 degrees","120 fits a triangle (order 3); a hexagon matches at 60."),
    ("30 degrees","Turn a hexagon just 30 and its corners do not line up yet.")]),

 ("SYM","What is the order of rotational symmetry of a circle?",
   "infinite",
   C("A circle looks the same after a turn of ANY size, so it matches itself unlimited times in a full turn.")+
   steps("Turn a circle by any angle at all","It always looks the same","So the order of rotational symmetry is infinite.")+
   U("A spinning coin or wheel looks unchanged at every instant of its turn because of this."),
   [("4","A circle is far more symmetric than a square; it matches at every angle."),
    ("1","Order 1 matches only at 360; a circle matches at every angle, so it is infinite."),
    ("360","360 is the number of degrees in a turn, not the order; the order is infinite.")]),
]

# ---------- LIGHT (25) — Science ----------
LIGHT = [
 ("LIGHT","In a uniform medium like clear air, light travels:",
   "in straight lines",
   C("Light moves in straight-line paths, which is why shadows have sharp edges and we cannot see around corners.")+
   steps("Light leaves a source","In one clear medium it does not bend on its own","So it travels in straight lines.")+
   U("A torch beam in dust shows a straight bright streak — proof light goes straight."),
   [("in curved paths","In a single clear medium light does not curve on its own; it goes straight."),
    ("in zig-zag steps","Light has no built-in zig-zag; in uniform air its path is straight."),
    ("in widening spirals","Light does not spiral; its path in a clear medium is a straight line.")]),

 ("LIGHT","We are able to see an ordinary (non-luminous) object such as a book because:",
   "light from a source bounces off it into our eyes",
   C("Non-luminous objects make no light of their own; we see them by the light they reflect into our eyes.")+
   steps("A source (Sun, lamp) lights the object","The object reflects some light","That reflected light enters our eyes -> we see it.")+
   U("This is why you cannot read a book in a completely dark room — there is no light for it to reflect."),
   [("the book makes its own light","A book is non-luminous; it makes no light, it only reflects it."),
    ("our eyes send out rays to it","Eyes do not shoot out light; they receive light coming in."),
    ("the book absorbs all the light","If it absorbed all light, none would reach our eyes and we could not see it.")]),

 ("LIGHT","The bouncing back of light when it strikes a shiny surface is called:",
   "reflection",
   C("When light hits a polished surface it turns back into the same medium — this is reflection.")+
   steps("Light travels to a mirror-like surface","It bounces back instead of passing through","This bouncing back is called reflection.")+
   U("A still pond reflecting trees and sky is everyday reflection at work."),
   [("absorption","Absorption is light being soaked up and not coming back, the opposite of bouncing back."),
    ("dispersion","Dispersion is the splitting of white light into colours, not bouncing back."),
    ("germination","Germination is a seed sprouting — nothing to do with light at all.")]),

 ("LIGHT","When light reflects from a plane mirror, the angle of incidence is:",
   "equal to the angle of reflection",
   C("The law of reflection states the incoming and outgoing rays make equal angles with the surface's normal.")+
   steps("Measure the angle the incoming ray makes","Measure the angle the reflected ray makes","The two angles are always equal.")+
   U("This equal-angle rule lets players bank a carrom striker or pool ball off a cushion accurately."),
   [("larger than the angle of reflection","The two angles are exactly equal, neither larger nor smaller."),
    ("smaller than the angle of reflection","Reflection keeps the angles equal, so it cannot be smaller."),
    ("always zero","Only a head-on ray gives zero; in general both angles are equal but not zero.")]),

 ("LIGHT","The image of your face in a flat (plane) mirror is:",
   "virtual, erect, the same size, and laterally inverted",
   C("A plane mirror forms an upright, same-size image that cannot be caught on a screen and has left and right swapped.")+
   steps("It cannot be formed on a screen -> virtual","It is upright and the same size as you","Your left and right appear swapped -> laterally inverted.")+
   U("That left-right swap is why the word on the front of an ambulance is written reversed."),
   [("real, upside down, and magnified","A plane mirror image is virtual and the same size, not a magnified real image."),
    ("smaller than the object","A plane mirror keeps the image exactly the same size as the object."),
    ("formed on a screen behind the mirror","A plane mirror image is virtual and cannot be caught on any screen.")]),

 ("LIGHT","In a plane mirror, the image appears to be:",
   "as far behind the mirror as the object is in front of it",
   C("The image distance behind a plane mirror equals the object distance in front.")+
   steps("Stand 30 cm from the mirror","Your image appears 30 cm behind the glass","Image distance = object distance.")+
   U("Step back from a mirror and your reflection seems to move back by exactly the same amount."),
   [("right on the surface of the mirror","The image looks like it is behind the glass, not on its surface."),
    ("twice as far behind as the object is in front","The distances are equal, not doubled."),
    ("at the centre of the room","The image position depends on the object's distance, not the room's centre.")]),

 ("LIGHT","'Lateral inversion' in a plane mirror means:",
   "the left and right of the image are interchanged",
   C("A plane mirror swaps left and right, so your right hand looks like the image's left hand.")+
   steps("Raise your right hand before a mirror","The image raises what looks like its left hand","Left and right are interchanged -> lateral inversion.")+
   U("This is why printed text held to a mirror reads backwards."),
   [("top and bottom are interchanged","A plane mirror swaps left and right, not top and bottom; the image stays upright."),
    ("the image becomes smaller","Lateral inversion is about the left-right swap, not a change in size."),
    ("the colours are reversed","Colours are unchanged; only left and right are swapped.")]),

 ("LIGHT","A mirror whose reflecting surface curves inward (like the inside of a spoon) is a:",
   "concave mirror",
   C("A concave mirror caves inward; its reflecting surface is on the inner side of the curve.")+
   steps("Look at the inner, hollow side of a shiny spoon","That curved-in surface is concave","So it is a concave mirror.")+
   U("Shaving and makeup mirrors are concave because they can enlarge your face."),
   [("convex mirror","A convex mirror bulges outward, the opposite of curving inward."),
    ("plane mirror","A plane mirror is flat, not curved at all."),
    ("transparent lens","A lens lets light pass through; a mirror reflects, and this one curves inward.")]),

 ("LIGHT","A mirror whose reflecting surface bulges outward (like the back of a spoon) is a:",
   "convex mirror",
   C("A convex mirror curves outward; its reflecting surface is on the outer side of the bulge.")+
   steps("Look at the outer, bulging side of a shiny spoon","That curved-out surface is convex","So it is a convex mirror.")+
   U("Curved security mirrors in shops are convex because they show a wide view."),
   [("concave mirror","A concave mirror caves inward, the opposite of bulging outward."),
    ("plane mirror","A plane mirror is flat; this surface is clearly curved outward."),
    ("magnifying lens","A lens transmits light; a mirror reflects, and this one bulges outward.")]),

 ("LIGHT","A convex mirror always forms an image that is:",
   "smaller (diminished) and erect",
   C("Because it spreads light outward, a convex mirror always gives an upright, reduced image.")+
   steps("A convex mirror bulges out and spreads rays","The image is always upright","And always smaller than the object.")+
   U("That is why a car's convex side mirror warns 'objects are closer than they appear'."),
   [("larger and upside down","A convex mirror image is smaller and upright, never magnified or inverted."),
    ("the same size as the object","A convex mirror always shrinks the image; it is never the same size."),
    ("real and on a screen","A convex mirror gives a virtual image that cannot be caught on a screen.")]),

 ("LIGHT","Convex mirrors are used as rear-view mirrors in vehicles mainly because they:",
   "give a wider field of view",
   C("A convex mirror spreads the reflected rays, letting the driver see a large area in a small mirror.")+
   steps("A convex surface bends rays outward","More of the scene fits into the mirror","So the driver gets a wide view of traffic behind.")+
   U("This wide view helps a driver spot vehicles in the next lane while changing lanes."),
   [("magnify approaching vehicles","A convex mirror shrinks images; it does not magnify."),
    ("show an upside-down image of the road","Convex mirrors give upright images, which is exactly what a driver needs."),
    ("absorb the glare of headlights","Their job is a wide view, not absorbing light; they still reflect headlights.")]),

 ("LIGHT","When the object is very close to it, a concave mirror can form an image that is:",
   "magnified (enlarged) and erect",
   C("Held close, a concave mirror produces a larger, upright image of the object.")+
   steps("Bring your face close to a concave mirror","The reflected rays form an enlarged image","It is upright and bigger than your face.")+
   U("That is exactly how a concave shaving or makeup mirror helps you see fine detail."),
   [("always smaller and upright","A close object in a concave mirror gives a LARGER image, not a smaller one."),
    ("the same size as the object","A concave mirror enlarges a near object; it is not the same size."),
    ("flat and colourless","Mirrors do not strip colour; a near object gives an enlarged, full-colour image.")]),

 ("LIGHT","A dentist uses a concave mirror because it:",
   "gives an enlarged image of the teeth",
   C("Held near a tooth, a concave mirror magnifies it so tiny cavities are easy to see.")+
   steps("The mirror is placed close to a tooth","A concave mirror enlarges a nearby object","So the dentist sees the tooth bigger and clearer.")+
   U("The same enlarging trick helps a jeweller inspect tiny gemstones."),
   [("makes the teeth look smaller","A concave mirror enlarges near objects; a dentist needs them larger, not smaller."),
    ("shows a wide view of the whole mouth","A wide view is the job of a convex mirror; the dentist needs magnification."),
    ("turns the teeth upside down","The dentist wants a clear enlarged image, which a close concave mirror provides upright.")]),

 ("LIGHT","Ordinary white light (sunlight) is actually made up of:",
   "seven colours mixed together",
   C("Sunlight is a blend of seven colours; together they appear white to our eyes.")+
   steps("Pass sunlight through a prism","It fans out into a band of colours","So white light is a mix of seven colours.")+
   U("A spinning colour-disc (Newton's disc) blends those colours back into near-white."),
   [("a single pure colour","White light is a mixture of many colours, not one pure colour."),
    ("only black and white","Black is the absence of light; white light contains all the colours."),
    ("only red and blue","White light has the full set of seven colours, not just two.")]),

 ("LIGHT","The splitting of white light into its component colours is called:",
   "dispersion",
   C("When white light passes through a prism, it separates into a spectrum of colours — dispersion.")+
   steps("White light enters a prism","Each colour bends by a slightly different amount","They spread out into a band -> dispersion.")+
   U("A glass paperweight or crystal making colour patches on a wall is dispersion in action."),
   [("reflection","Reflection is light bouncing back, not splitting into colours."),
    ("evaporation","Evaporation is a liquid turning to vapour — nothing to do with light."),
    ("condensation","Condensation is vapour turning to liquid; it does not split light.")]),

 ("LIGHT","A rainbow forms in the sky because raindrops act like tiny:",
   "prisms that split sunlight into colours",
   C("Each raindrop bends and disperses sunlight, spreading it into the colours of a rainbow.")+
   steps("Sunlight enters a raindrop","The drop disperses it like a prism","Millions of drops together make the arc of colours.")+
   U("You can make your own rainbow with a garden hose spray facing away from the Sun."),
   [("mirrors that only reflect light","A rainbow needs the light to split into colours, which mirrors do not do."),
    ("lenses that magnify the Sun","Magnifying does not create colours; dispersion in the drops does."),
    ("filters that remove all colour","Raindrops reveal the colours by splitting light, not remove them.")]),

 ("LIGHT","Listed from one end of the spectrum to the other (VIBGYOR), the seven colours run from:",
   "violet at one end to red at the other",
   C("The spectrum order VIBGYOR begins with violet and ends with red.")+
   steps("V-I-B-G-Y-O-R spells the order","V is violet (start)","R is red (end).")+
   U("Knowing VIBGYOR helps you name the bands of a rainbow from inside to outside."),
   [("black at one end to white at the other","Black and white are not spectrum colours; the band runs violet to red."),
    ("brown at one end to grey at the other","Brown and grey are not part of VIBGYOR; the ends are violet and red."),
    ("pink at one end to gold at the other","Pink and gold are not spectrum colours; the spectrum runs violet to red.")]),

 ("LIGHT","A lens that is thicker in the middle than at the edges is a:",
   "convex (converging) lens",
   C("A convex lens bulges in the middle and bends parallel rays to meet at a point.")+
   steps("Feel a hand-lens: thick centre, thin edge","Such a lens converges light to a point","So it is a convex (converging) lens.")+
   U("A magnifying glass used to read tiny print is a convex lens."),
   [("concave (diverging) lens","A concave lens is thinner in the middle, the opposite of this."),
    ("plane mirror","A plane mirror is flat and reflects; a lens is curved and transmits light."),
    ("convex mirror","A mirror reflects light; the question describes a lens that light passes through.")]),

 ("LIGHT","A lens that is thinner in the middle than at the edges is a:",
   "concave (diverging) lens",
   C("A concave lens caves in at the middle and spreads parallel rays apart.")+
   steps("Such a lens is thin in the centre, thick at the edge","It makes parallel rays diverge","So it is a concave (diverging) lens.")+
   U("Spectacles for short-sighted people use concave lenses."),
   [("convex (converging) lens","A convex lens is thicker in the middle, the opposite of this."),
    ("concave mirror","A mirror reflects light; this is a lens, which light passes through."),
    ("plane glass sheet","A flat glass sheet has the same thickness throughout; this lens is thinner in the middle.")]),

 ("LIGHT","A convex lens can act as a magnifying glass because it forms a:",
   "magnified, erect image of a nearby object",
   C("Held close to an object, a convex lens produces an enlarged upright image.")+
   steps("Place a convex lens near small print","It bends the rays to form a larger image","The image is upright and magnified.")+
   U("Stamp collectors and watch repairers use convex lenses to see tiny details."),
   [("smaller, inverted image","Used as a magnifier the image is larger and upright, not small and inverted."),
    ("colourless shadow of the object","A lens forms a clear magnified image, not a shadow."),
    ("real image on the lens itself","A magnifying glass gives a virtual, enlarged image, not one stuck on the lens.")]),

 ("LIGHT","The picture thrown onto a cinema screen, where the light actually meets, is an example of a:",
   "real image",
   C("A real image is formed where light rays actually meet and can be caught on a screen.")+
   steps("Light from the projector converges on the screen","The rays truly meet there","An image you can catch on a screen is a real image.")+
   U("The sharp image on a cinema screen is real — that is why it appears on the cloth."),
   [("virtual image","A virtual image cannot be caught on a screen; a cinema image is on the screen, so it is real."),
    ("shadow","A shadow is dark with no detail; a cinema screen shows a full bright image."),
    ("mirror image","A plane mirror image is virtual; the cinema image lands on a screen, so it is real.")]),

 ("LIGHT","The image in a plane mirror cannot be caught on a screen, so it is described as:",
   "a virtual image",
   C("A virtual image only appears to be there; light does not actually meet, so no screen can catch it.")+
   steps("Put a screen where a mirror image seems to be","Nothing forms on the screen","An image that cannot be caught on a screen is virtual.")+
   U("Your bathroom-mirror reflection is virtual — you can never project it onto paper."),
   [("a real image","A real image can be caught on a screen; a plane mirror image cannot, so it is virtual."),
    ("a shadow","A shadow is a dark patch, not a detailed reflection like a mirror image."),
    ("a dispersed image","Dispersion is about colours splitting; it does not describe a mirror image.")]),

 ("LIGHT","The word AMBULANCE is printed reversed on the front of the vehicle so that, in a driver's mirror, it:",
   "reads the correct way round",
   C("A plane mirror laterally inverts (swaps left-right); reversing the print cancels that swap, so it reads correctly in the mirror.")+
   steps("A plane mirror swaps left and right","Printing the word already reversed pre-cancels the swap","So the mirror shows it the normal way round.")+
   U("This links Symmetry's left-right flip with Light's lateral inversion — clever real-world use."),
   [("looks even more reversed","Reversing it first cancels the mirror's flip, so it ends up correct, not doubly reversed."),
    ("turns upside down","A plane mirror swaps left-right, not top-bottom, so the word does not flip upside down."),
    ("changes colour","A mirror does not change colours; the reversed printing is about left-right reading.")]),

 ("LIGHT","A green leaf looks green because, of all the colours in white light, it mostly:",
   "reflects green light and absorbs the rest",
   C("An object's colour is the colour it reflects to our eyes; the other colours are absorbed.")+
   steps("White light (all colours) hits the leaf","The leaf absorbs most colours","It reflects green, so we see green.")+
   U("A red apple works the same way — it reflects red and soaks up the other colours."),
   [("absorbs green light and reflects the rest","If it absorbed green, we would NOT see green; it reflects green to look green."),
    ("creates green light of its own","A leaf is non-luminous; it cannot make light, only reflect it."),
    ("turns all light into green","The leaf does not convert colours; it simply reflects the green already in white light.")]),

 ("LIGHT","A real image differs from a virtual image because a real image:",
   "can be obtained on a screen",
   C("Real images form where light actually meets, so they can be projected onto a screen; virtual ones cannot.")+
   steps("Real image: rays truly meet -> catch it on a screen","Virtual image: rays only appear to meet -> no screen image","So 'can be caught on a screen' marks a real image.")+
   U("A film projector makes a real image on the screen; a mirror makes a virtual one you cannot project."),
   [("is always upright","Real images are often inverted (as in a projector), so 'always upright' is wrong."),
    ("is always smaller","Real images can be larger, smaller, or equal in size, so this is not what defines them."),
    ("appears behind a mirror","An image behind a mirror is virtual, not real.")]),
]

# ---------- ARITHMETIC EXPRESSIONS (25) — Maths ----------
AEX = [
 ("AEX","In the expression 3 + 4 x 2, which operation must be carried out first?",
   "the multiplication (4 x 2)",
   C("By the order of operations, multiplication and division come before addition and subtraction.")+
   steps("Spot the operations: + and x","x is done before +","So multiply 4 x 2 first.")+
   U("Calculators follow this same rule, which is why typing it gives 11, not 14."),
   [("the addition (3 + 4)","Addition comes after multiplication, so 4 x 2 is done before 3 + 4."),
    ("whichever is written on the left","Position does not decide order; multiplication outranks addition."),
    ("both at the same time","Operations are not all done together; multiplication is taken before addition.")]),

 ("AEX","Evaluate 3 + 4 x 2.",
   "11",
   C("Do the multiplication first, then the addition.")+
   steps("4 x 2 = 8","3 + 8 = 11","So the value is 11.")+
   U("Getting this order right matters when totalling a bill with several priced items."),
   [("14","14 comes from adding first (3 + 4 = 7, then x 2); multiplication must come first."),
    ("9","9 ignores doubling the 4; 4 x 2 = 8, then + 3 = 11."),
    ("24","24 multiplies everything together; only 4 x 2 is multiplied here.")]),

 ("AEX","First add inside the brackets, then work out the value of (3 + 4) x 2.",
   "14",
   C("Brackets are done first, so add inside the brackets before multiplying.")+
   steps("Inside brackets: 3 + 4 = 7","Then 7 x 2 = 14","So the value is 14.")+
   U("Brackets are how a shopkeeper says 'add these, THEN double it' without confusion."),
   [("11","11 is the value WITHOUT brackets (3 + 4 x 2); the brackets change it to 14."),
    ("9","9 ignores the multiplication; after adding inside brackets you must still x 2."),
    ("24","24 multiplies the wrong numbers; inside the brackets is 7, and 7 x 2 = 14.")]),

 ("AEX","Brackets in an arithmetic expression are an instruction to:",
   "work out whatever is inside them first",
   C("Brackets group operations and tell you to evaluate the inside before anything else.")+
   steps("See brackets -> handle the inside first","Then continue with the rest","So brackets take top priority.")+
   U("Recipes use the same idea: '(mix the dry items) then add to the wet items'."),
   [("multiply the numbers inside","Brackets do not force multiplication; you do whatever operation is inside, first."),
    ("ignore the numbers inside","Brackets highlight the inside as most important, the opposite of ignoring it."),
    ("add the numbers inside to the answer twice","Brackets are computed once, first; nothing is added twice.")]),

 ("AEX","Evaluate 20 - 6 / 2.",
   "17",
   C("Division is done before subtraction in the order of operations.")+
   steps("6 / 2 = 3","20 - 3 = 17","So the value is 17.")+
   U("This order keeps shared-cost calculations correct when you split one part of a bill."),
   [("7","7 subtracts first (20 - 6 = 14, then / 2); division must come before subtraction."),
    ("14","14 stops after 20 - 6 and forgets to divide; 6 / 2 = 3 comes first."),
    ("10","10 mishandles the order; the right path is 20 - 3 = 17.")]),

 ("AEX","Evaluate 12 / (6 - 2).",
   "3",
   C("Do the bracket first, then divide.")+
   steps("Inside brackets: 6 - 2 = 4","12 / 4 = 3","So the value is 3.")+
   U("Brackets here mean 'first find the group of 4, then share 12 among them'."),
   [("4","4 ignores the division; after 6 - 2 = 4 you must still divide 12 by it."),
    ("0","0 is not possible; 12 / 4 = 3, a clear positive value."),
    ("6","6 divides by the wrong number; the bracket gives 4, and 12 / 4 = 3.")]),

 ("AEX","In the expression 5 + 7 - 3, the separate terms are:",
   "5, +7 and -3",
   C("Terms in an expression are the parts joined by + and - signs, each carrying its own sign.")+
   steps("Split at the + and - signs","First term 5, second term +7, third term -3","So the terms are 5, +7 and -3.")+
   U("Seeing the terms lets you safely rearrange a sum, like grouping money you owe and money you have."),
   [("5, 7 and 3 with no signs","Each term carries the sign in front of it, so the third is -3, not 3."),
    ("5 x 7 x 3","These are added and subtracted, not multiplied; they are not factors."),
    ("just 5 and 7","The -3 is also a term; there are three terms in all.")]),

 ("AEX","Which sign correctly fills the gap: (4 + 5) ___ (5 + 4)?",
   "= (they are equal)",
   C("Addition can be done in any order (it is commutative), so 4 + 5 equals 5 + 4.")+
   steps("4 + 5 = 9","5 + 4 = 9","Both are 9, so the sign is =.")+
   U("This is why it does not matter which item you scan first at a checkout — the total is the same."),
   [("> (greater than)","Both sides equal 9, so neither is greater."),
    ("< (less than)","Both sides equal 9, so neither is less."),
    ("cannot be compared","Two whole-number sums can always be compared; here they are equal.")]),

 ("AEX","Compare the two expressions: 7 x 3 ___ 7 + 3.",
   "> (the product is greater)",
   C("Multiplying gives a much bigger result than adding for these numbers.")+
   steps("7 x 3 = 21","7 + 3 = 10","21 is greater than 10, so the sign is >.")+
   U("This shows why repeated buying (x) costs far more than a single extra item (+)."),
   [("< (the sum is greater)","The sum is 10 and the product is 21, so the product is greater, not the sum."),
    ("= (they are equal)","21 and 10 are different, so they are not equal."),
    ("they cannot be compared","Both are numbers (21 and 10) and can certainly be compared.")]),

 ("AEX","Evaluate 6 x (10 + 2).",
   "72",
   C("Do the bracket first, then multiply; this also matches 6 x 10 + 6 x 2.")+
   steps("Inside brackets: 10 + 2 = 12","6 x 12 = 72","Check: 6 x 10 + 6 x 2 = 60 + 12 = 72.")+
   U("Buying 6 combo-meals at (10 + 2) rupees each costs 72 — the bracket bundles the price."),
   [("62","62 multiplies only the 10 and forgets the 2; 6 x 12 = 72."),
    ("18","18 just adds 6 + 10 + 2; the 6 must MULTIPLY the bracket, giving 72."),
    ("38","38 mishandles the bracket; 6 x (10 + 2) = 6 x 12 = 72.")]),

 ("AEX","Using the spreading-out (distributive) idea, 8 x 13 equals 8 x 10 + 8 x 3 =",
   "104",
   C("Breaking 13 into 10 + 3 lets you multiply the easy parts and add them.")+
   steps("8 x 10 = 80","8 x 3 = 24","80 + 24 = 104.")+
   U("This is the mental trick shopkeepers use to multiply quickly without paper."),
   [("84","84 forgets the 8 x 3 part; 80 + 24 = 104."),
    ("110","110 over-counts; the correct split gives 80 + 24 = 104."),
    ("96","96 uses the wrong parts; 8 x 10 + 8 x 3 = 80 + 24 = 104.")]),

 ("AEX","If you add the SAME number to both sides of a true equality, the two sides:",
   "stay equal to each other",
   C("Doing the same thing to both sides of an equality keeps the balance.")+
   steps("Start with two equal sides","Add the same number to each","They remain equal -> balance is kept.")+
   U("A balance scale stays level if you add the same weight to both pans."),
   [("become unequal","Adding the same amount to both keeps them equal, not unequal."),
    ("both become zero","Adding a number does not force the sides to zero; they just stay equal."),
    ("swap their values","The sides keep their own values plus the added number; they do not swap.")]),

 ("AEX","Given that 15 + 9 = 24, what sign fills the gap: (15 + 9 + 6) ___ (24 + 6)?",
   "= (still equal)",
   C("Both sides started equal and the same 6 was added to each, so they remain equal.")+
   steps("15 + 9 = 24 (given)","Add 6 to each side","24 + 6 = 30 on both sides, so the sign is =.")+
   U("This 'do the same to both sides' rule is the heart of solving equations later on."),
   [("> (left is greater)","The same 6 was added to both sides, so they stay equal, not greater."),
    ("< (left is smaller)","Adding equally to both keeps them equal, so neither is smaller."),
    ("cannot be decided","Since the starting sides were equal and 6 was added to each, they are equal.")]),

 ("AEX","Evaluate 2 x 3 + 4 x 5.",
   "26",
   C("Do both multiplications first, then add the results.")+
   steps("2 x 3 = 6","4 x 5 = 20","6 + 20 = 26.")+
   U("Totalling two different bulk buys (6 of one, 20 of another) works exactly this way."),
   [("70","70 adds 3 + 4 in the middle first; each multiplication must be done before adding."),
    ("50","50 multiplies across the +; only 2x3 and 4x5 are products, giving 6 + 20 = 26."),
    ("14","14 forgets one product; 2 x 3 + 4 x 5 = 6 + 20 = 26.")]),

 ("AEX","Where should brackets go to make 3 + 5 x 2 equal 16?",
   "(3 + 5) x 2",
   C("Putting the addition in brackets forces it first, then the doubling.")+
   steps("(3 + 5) = 8","8 x 2 = 16","So (3 + 5) x 2 gives 16.")+
   U("Brackets let you reshape the meaning of a sum to get the result you want."),
   [("3 + (5 x 2)","3 + (5 x 2) = 3 + 10 = 13, not 16; this is the same as the original."),
    ("(3 + 5 x 2)","Brackets round the whole thing still do x first inside, giving 13, not 16."),
    ("3 x (5 + 2)","3 x (5 + 2) = 21, which is not 16.")]),

 ("AEX","Evaluate 100 - (40 + 25).",
   "35",
   C("Add inside the bracket first, then subtract from 100.")+
   steps("Inside brackets: 40 + 25 = 65","100 - 65 = 35","So the value is 35.")+
   U("If you spend 40 then 25 from 100 rupees, the bracket totals the spend and 35 is left."),
   [("85","85 only subtracts the 40 and forgets the 25; the bracket totals 65."),
    ("65","65 is the value inside the bracket, not the final answer; subtract it from 100."),
    ("15","15 over-subtracts; 100 - 65 = 35.")]),

 ("AEX","Taking 7 out as a common factor, 7 x 6 - 7 x 2 equals 7 x (6 - 2) =",
   "28",
   C("Both products share the factor 7, so you can group: 7 x (6 - 2).")+
   steps("7 is common to both terms","7 x (6 - 2) = 7 x 4","7 x 4 = 28.")+
   U("Pulling out a common factor is a quick way to simplify before you calculate."),
   [("56","56 forgets to subtract; it is 7 x (6 - 2) = 7 x 4 = 28, not 7 x 8."),
    ("12","12 just does 6 + 2 + something; the grouped form is 7 x 4 = 28."),
    ("32","32 mishandles the factor; 7 x (6 - 2) = 7 x 4 = 28.")]),

 ("AEX","Which is larger: 12 + 12 + 12 or 12 x 3?",
   "they are equal",
   C("Multiplying by 3 is just a short way of adding the number three times.")+
   steps("12 + 12 + 12 = 36","12 x 3 = 36","Both equal 36, so they are equal.")+
   U("This is the very meaning of multiplication — repeated addition."),
   [("12 + 12 + 12 is larger","Both equal 36; repeated addition and the matching multiplication agree."),
    ("12 x 3 is larger","Both equal 36; multiplication by 3 is exactly adding three 12s."),
    ("12 x 3 is smaller","12 x 3 = 36 is the same as the sum, not smaller.")]),

 ("AEX","Removing the brackets, 9 + (4 + 6) equals:",
   "19",
   C("With only additions, brackets do not change the value (addition is associative).")+
   steps("Inside brackets: 4 + 6 = 10","9 + 10 = 19","Same as 9 + 4 + 6 = 19.")+
   U("This is why you can total a list of prices in any grouping and still get the same sum."),
   [("9","9 ignores the bracket entirely; you must still add the 10 inside it."),
    ("15","15 forgets the 4; 9 + (4 + 6) = 9 + 10 = 19."),
    ("54","54 multiplies instead of adds; here everything is addition, giving 19.")]),

 ("AEX","A candle 18 cm tall burns down 2 cm each hour. The expression for its height left after h hours is 18 - 2 x h. After 4 hours the height left is:",
   "10 cm",
   C("Substitute h = 4, do the multiplication first, then subtract.")+
   steps("2 x h = 2 x 4 = 8","18 - 8 = 10","So 10 cm of candle is left.")+
   U("This links Arithmetic Expressions with a physical change (burning) — an expression predicts the result."),
   [("16 cm","16 cm subtracts only one hour's 2 cm; after 4 hours it is 2 x 4 = 8 cm burnt."),
    ("8 cm","8 cm is how much BURNED away, not how much is LEFT (18 - 8 = 10)."),
    ("72 cm","72 cm multiplies the whole expression; you must subtract 2 x h from 18, giving 10.")]),

 ("AEX","Evaluate 50 - 2 x (5 + 3).",
   "34",
   C("Do the bracket first, then the multiplication, then the subtraction.")+
   steps("Inside brackets: 5 + 3 = 8","2 x 8 = 16","50 - 16 = 34.")+
   U("Order of operations keeps multi-step money sums (a fixed amount minus several equal costs) correct."),
   [("384","384 wrongly subtracts before multiplying ((50-2)x8); the bracket and x come first."),
    ("42","42 forgets to double; 2 x (5 + 3) = 16, then 50 - 16 = 34."),
    ("16","16 is just the 2 x (5 + 3) part; you must still subtract it from 50.")]),

 ("AEX","Evaluate 1000 / (10 x 10).",
   "10",
   C("Work out the bracket first, then divide.")+
   steps("Inside brackets: 10 x 10 = 100","1000 / 100 = 10","So the value is 10.")+
   U("Sharing 1000 equally among 100 people gives 10 each — the bracket forms the group of 100."),
   [("100","100 is the value inside the bracket, not the final answer; divide 1000 by it."),
    ("1","1 over-divides; 1000 / 100 = 10, not 1."),
    ("1000","1000 ignores the division; after the bracket you must still divide by 100.")]),

 ("AEX","The expression 3 x n gives what value when n = 7?",
   "21",
   C("Replace the letter n with 7 and multiply.")+
   steps("3 x n with n = 7","3 x 7","= 21.")+
   U("A letter standing for an unknown number is how algebra grows out of arithmetic expressions."),
   [("10","10 adds 3 + 7; the expression says MULTIPLY 3 by n, giving 21."),
    ("37","37 just writes 3 and 7 side by side; 3 x 7 = 21."),
    ("4","4 subtracts; the operation is multiplication, so 3 x 7 = 21.")]),

 ("AEX","Evaluate 4 + 4 / 4 + 4.",
   "9",
   C("Division is done before the additions.")+
   steps("4 / 4 = 1","Now 4 + 1 + 4","= 9.")+
   U("Knowing division goes first stops a common mistake in step-by-step calculations."),
   [("3","3 adds everything first then divides; division must be done before the additions."),
    ("12","12 ignores the division; 4 / 4 = 1, so the sum is 4 + 1 + 4 = 9."),
    ("16","16 adds all four 4s; the middle pair is divided, giving 9.")]),

 ("AEX","Without full calculation, comparing 25 x 4 and 25 + 4, the product is:",
   "much larger than the sum",
   C("Multiplying 25 by 4 stacks 25 four times, far more than adding a single 4 to it.")+
   steps("25 x 4 = 100","25 + 4 = 29","100 is much larger than 29.")+
   U("This is why buying 4 of something costs far more than buying 1 and getting 4 rupees off."),
   [("much smaller than the sum","The product 100 is far bigger than the sum 29, not smaller."),
    ("exactly equal to the sum","100 and 29 are very different, so they are not equal."),
    ("impossible to compare","Both are numbers (100 and 29) and are easy to compare.")]),
]

# ---------- PHYSICAL & CHEMICAL CHANGES (25) — Science ----------
PCC = [
 ("PCC","A change in which NO new substance is formed is called a:",
   "physical change",
   C("In a physical change only the form, shape or state alters; the substance stays the same.")+
   steps("Check if a new substance appears","If none does, it is a physical change","Only appearance or state has changed.")+
   U("Folding paper or moulding clay changes the look, not the material — physical changes."),
   [("chemical change","A chemical change DOES make a new substance; here none is formed."),
    ("nuclear change","Nuclear change alters the atom's core and is far beyond a simple no-new-substance change."),
    ("biological change","'Biological change' is not the term; with no new substance it is a physical change.")]),

 ("PCC","A change in which one or more NEW substances are formed is called a:",
   "chemical change",
   C("A chemical change rearranges atoms to make substances with new properties.")+
   steps("Look for a brand-new substance","If a new material with new properties forms","it is a chemical change.")+
   U("Cooking an egg makes a new solid that cannot be turned back — a chemical change."),
   [("physical change","A physical change makes NO new substance; here a new one is formed."),
    ("temporary change","'Temporary change' is not the classification; forming a new substance makes it chemical."),
    ("seasonal change","Seasons are about weather, not about new substances forming.")]),

 ("PCC","Melting of ice into water is a:",
   "physical change",
   C("Ice and water are the same substance in different states; no new substance forms.")+
   steps("Ice is solid water; melted, it is liquid water","Same substance, only the state changed","So it is a physical change.")+
   U("Refreeze the water and you get ice back — proof it was only physical."),
   [("chemical change","No new substance forms; ice and water are both just water, so it is physical."),
    ("irreversible change","Melting can be reversed by freezing, so it is a reversible, physical change."),
    ("an explosion","Melting is gentle; there is no sudden release of gas or energy.")]),

 ("PCC","Rusting of an iron gate is a:",
   "chemical change",
   C("Rust is a new substance (iron oxide) with different properties from the original iron.")+
   steps("Iron reacts with air and moisture","A flaky brown substance, rust, forms","A new substance means a chemical change.")+
   U("Rust weakens bridges and railings, which is why they are painted to keep air and water out."),
   [("physical change","Rust is a NEW substance, so rusting is chemical, not physical."),
    ("a change of state only","Rusting is not melting or boiling; it makes a new compound, so it is chemical."),
    ("a reversible change","You cannot simply turn rust back into shiny iron, so it is not a reversible physical change.")]),

 ("PCC","Cutting a sheet of paper into small pieces with scissors is a:",
   "physical change",
   C("The pieces are still paper; only the size and shape changed, with no new substance.")+
   steps("Paper is torn into bits","Each bit is still paper","No new substance -> physical change.")+
   U("Shredded paper is still paper and can be recycled back into new sheets."),
   [("chemical change","No new substance forms when paper is torn; it is still paper, so it is physical."),
    ("burning","Tearing is not burning; tearing makes no new substance, while burning does."),
    ("an irreversible chemical reaction","Tearing involves no reaction and no new substance; it is a simple physical change.")]),

 ("PCC","Burning of paper is a:",
   "chemical change",
   C("Burning turns paper into ash, smoke and gases — new substances that cannot become paper again.")+
   steps("Paper reacts with oxygen as it burns","Ash, smoke and gases form","These are new substances -> chemical change.")+
   U("Once paper is burnt to ash you can never get the paper back — a clear chemical change."),
   [("physical change","Burning forms new substances (ash, gases), so it is chemical, not physical."),
    ("a change of state","Burning is not melting or boiling; it makes new substances, so it is chemical."),
    ("a reversible change","Ash cannot be turned back into paper, so burning is irreversible and chemical.")]),

 ("PCC","Most physical changes are:",
   "reversible (they can usually be undone)",
   C("Because no new substance forms, the original can often be recovered.")+
   steps("A physical change alters form or state only","The substance stays the same","So it can usually be reversed.")+
   U("Freeze water to ice, melt it back — physical changes can often be reversed."),
   [("always irreversible","Physical changes can usually be reversed; it is chemical changes that are often permanent."),
    ("always explosive","Physical changes are usually gentle; explosions are not the rule."),
    ("changes that form new substances","Forming a new substance is a CHEMICAL change, not a physical one.")]),

 ("PCC","Most chemical changes are:",
   "usually permanent (hard to reverse)",
   C("New substances with new properties form, so simply reversing the change is usually not possible.")+
   steps("A chemical change makes a new substance","The new substance has different properties","So the change is usually permanent.")+
   U("You cannot un-bake a cake or un-burn wood — chemical changes are usually one-way."),
   [("always easy to reverse","Chemical changes are usually hard to reverse; it is physical changes that reverse easily."),
    ("never accompanied by energy change","Chemical changes often release or absorb heat or light, so this is false."),
    ("the same as a change of state","A change of state (melting, boiling) is physical, not chemical.")]),

 ("PCC","For iron to rust, BOTH of these must be present:",
   "oxygen (air) and water (moisture)",
   C("Rusting needs the iron to be exposed to both air and moisture together.")+
   steps("Dry air alone barely rusts iron","Water alone is not enough either","Both air and moisture together cause rust.")+
   U("Iron stored in a dry place rusts very slowly because moisture is missing."),
   [("only heat and light","Rusting can happen at room temperature in the dark; it needs air and moisture."),
    ("nitrogen and salt","It is oxygen (not nitrogen) plus water that rusts iron; salt only speeds it up."),
    ("carbon dioxide and oil","Oil actually PREVENTS rust; rusting needs oxygen and water.")]),

 ("PCC","The brown, flaky substance that forms on rusting iron is:",
   "rust, which is iron oxide",
   C("Rust is iron oxide, a new compound made when iron combines with oxygen and water.")+
   steps("Iron + oxygen + water react","They form a brown flaky compound","That compound is rust (iron oxide).")+
   U("The orange streaks on an old gate or nail are this iron oxide."),
   [("pure iron in powder form","Rust is NOT iron; it is a new compound, iron oxide, with different properties."),
    ("a kind of paint","Rust is not paint; it forms from a reaction of the iron itself."),
    ("carbon (soot)","Soot is carbon from burning; rust is iron oxide from a reaction with air and water.")]),

 ("PCC","One common way to protect iron objects from rusting is to:",
   "coat them with paint or a layer of another metal",
   C("A coating keeps air and moisture away from the iron, so rusting cannot start.")+
   steps("Rust needs air and water touching iron","A paint or metal coat blocks them","So the iron is protected from rust.")+
   U("Bicycles and gates are painted, and buckets are galvanised, for exactly this reason."),
   [("keep them in damp air","Damp air supplies the moisture that CAUSES rust, so this would make it worse."),
    ("sprinkle salt water on them","Salt water speeds up rusting, the opposite of protecting the iron."),
    ("leave bare iron in the rain","Bare iron in the rain rusts fastest; protection means keeping water off.")]),

 ("PCC","Iron filings and sulphur powder simply stirred together form a mixture, but HEATING them strongly forms iron sulphide. The heating is a:",
   "chemical change",
   C("Heating makes the iron and sulphur react into iron sulphide, a brand-new substance.")+
   steps("Just mixing -> still iron and sulphur (physical)","Heating -> they react","Iron sulphide forms -> chemical change.")+
   U("This classic experiment shows the difference between a mixture and a true chemical reaction."),
   [("physical change","Heating makes a NEW substance, iron sulphide, so it is a chemical change."),
    ("only a change of colour","The colour does change, but a new substance forms too, making it chemical."),
    ("the same as mixing them cold","Cold mixing is physical; heating causes a reaction, which is chemical.")]),

 ("PCC","Dissolving sugar in water is a:",
   "physical change",
   C("The sugar is still sugar — it just spreads through the water and can be recovered.")+
   steps("Sugar disappears into the water","It is still sugar, only mixed in","Evaporate the water and sugar returns -> physical change.")+
   U("Boil away the water from sweet tea and the sugar is left behind, proving it was physical."),
   [("chemical change","No new substance forms; the sugar can be recovered, so it is physical."),
    ("burning","Dissolving is not burning; no new substance and no flame are involved."),
    ("an irreversible change","Evaporating the water brings the sugar back, so it is reversible and physical.")]),

 ("PCC","The souring of milk into curd is a:",
   "chemical change",
   C("Curd is a new substance with different taste and texture; it cannot be turned back into milk.")+
   steps("Microbes act on the milk","New substances form, turning it sour","Curd cannot become milk again -> chemical change.")+
   U("Setting curd from milk at home is an everyday chemical change in the kitchen."),
   [("physical change","Curd is a new substance you cannot turn back into milk, so it is chemical."),
    ("a change of state only","It is not just liquid-to-solid; new substances form, making it chemical."),
    ("a reversible change","You cannot turn curd back into fresh milk, so it is irreversible and chemical.")]),

 ("PCC","When carbon dioxide gas is passed through clear lime water, the lime water:",
   "turns milky (a chemical change)",
   C("Carbon dioxide reacts with lime water to form a new white substance, making it milky.")+
   steps("Bubble carbon dioxide through lime water","A new white solid forms","The water turns milky -> chemical change.")+
   U("This milky-test is how we detect the carbon dioxide we breathe out."),
   [("stays perfectly clear","A new white substance forms, so it does not stay clear; it turns milky."),
    ("turns bright blue","It turns milky white, not blue; blue would suggest a different test."),
    ("freezes solid","No freezing happens; a chemical reaction turns the lime water milky.")]),

 ("PCC","Photosynthesis, in which a leaf makes food from carbon dioxide and water, is a:",
   "chemical change",
   C("New substances (glucose and oxygen) are made, so photosynthesis is a chemical change.")+
   steps("Carbon dioxide + water + sunlight in the leaf","New substances glucose and oxygen form","Making new substances -> chemical change.")+
   U("Every leaf is a tiny chemical factory turning air and water into food and oxygen."),
   [("physical change","Photosynthesis makes new substances (food and oxygen), so it is chemical."),
    ("a change of state","It is not melting or boiling; brand-new substances are produced."),
    ("just the movement of water","Water moves in, but new substances are made too, making it chemical.")]),

 ("PCC","Slowly evaporating a copper sulphate solution to obtain large, regular blue crystals is an example of:",
   "crystallisation, a physical change",
   C("Crystallisation arranges the same substance into pure crystals; no new substance forms.")+
   steps("The solution slowly loses water","The copper sulphate forms neat crystals","Same substance, so it is a physical change.")+
   U("Salt and sugar crystals are grown the same way, giving pure regular shapes."),
   [("a chemical change forming a new compound","No new substance forms; the copper sulphate just crystallises, so it is physical."),
    ("burning of the solution","Nothing burns; the water simply evaporates and crystals grow."),
    ("rusting of the copper","Rusting is for iron; here copper sulphate is merely crystallising.")]),

 ("PCC","The hardening (setting) of cement after water is added is a:",
   "chemical change",
   C("Cement reacts with water to form a new hard substance that cannot be returned to powder.")+
   steps("Water is mixed into cement","A reaction forms a new hard material","It cannot go back to powder -> chemical change.")+
   U("Once concrete sets in a building, that chemical change is permanent."),
   [("physical change","Set cement is a new, permanent substance, so it is a chemical change."),
    ("a reversible change","You cannot turn set cement back into loose powder, so it is irreversible."),
    ("just drying like a puddle","It is not simple drying; a reaction makes a new hard substance.")]),

 ("PCC","Cutting wood into pieces is a physical change, but burning wood is a:",
   "chemical change",
   C("Cutting only changes the size, but burning forms ash, smoke and gases — new substances.")+
   steps("Cutting -> still wood (physical)","Burning -> ash, smoke, gases form","New substances -> chemical change.")+
   U("Firewood once burnt to ash can never be turned back into wood."),
   [("physical change","Burning makes new substances (ash and gases), so it is chemical, not physical."),
    ("a reversible change","Ash cannot be turned back into wood, so burning is irreversible and chemical."),
    ("the same as cutting it","Cutting is physical; burning forms new substances and is chemical.")]),

 ("PCC","Coating iron with a thin layer of ZINC to protect it from rust is called:",
   "galvanisation",
   C("Galvanisation covers iron with zinc, keeping air and moisture from reaching the iron.")+
   steps("A zinc layer is put over the iron","Air and water cannot reach the iron","So rusting is prevented -> galvanisation.")+
   U("Galvanised buckets, sheets and nails last far longer outdoors."),
   [("crystallisation","Crystallisation is growing pure crystals, not coating iron with zinc."),
    ("evaporation","Evaporation is a liquid turning to vapour, unrelated to coating iron."),
    ("condensation","Condensation is vapour turning to liquid, nothing to do with a zinc coat.")]),

 ("PCC","Stainless steel resists rusting because it is an alloy of iron mixed mainly with:",
   "chromium (and some nickel)",
   C("Adding chromium and nickel to iron makes stainless steel, which does not rust easily.")+
   steps("Pure iron rusts readily","Mixing in chromium and nickel makes stainless steel","This alloy resists rust.")+
   U("Kitchen sinks and cutlery are stainless steel so they survive constant water with no rust."),
   [("sugar and salt","Sugar and salt are not metals for making steel; chromium and nickel are added."),
    ("rust and ash","Rust and ash are waste products, not ingredients of stainless steel."),
    ("zinc and tin only","Zinc and tin are used for coatings; stainless steel is iron with chromium and nickel.")]),

 ("PCC","A 20 g iron nail gains mass as it rusts, because rust contains oxygen taken from the air. If it gains 3 g, the rusted nail's mass is:",
   "23 g",
   C("Rust adds oxygen from the air to the iron, so the mass increases by the oxygen taken in.")+
   steps("Starting mass = 20 g","Oxygen gained = 3 g","20 + 3 = 23 g.")+
   U("This links a chemical change with a simple sum — the new substance is heavier than the iron alone."),
   [("17 g","17 g subtracts the gain; rust ADDS oxygen, so the mass goes up to 23 g, not down."),
    ("20 g","20 g ignores the gained oxygen; the rusted nail is heavier, at 23 g."),
    ("60 g","60 g multiplies instead of adding; the nail gains just 3 g, giving 23 g.")]),

 ("PCC","Boiling water until it turns into steam is a:",
   "physical change",
   C("Steam is still water, just in the gas state; no new substance forms.")+
   steps("Liquid water is heated","It turns into steam (water vapour)","Same substance, only the state changed -> physical change.")+
   U("Cool the steam and it condenses back to water, showing it was only physical."),
   [("chemical change","No new substance forms; steam is still water, so boiling is physical."),
    ("an irreversible change","Steam can cool back into water, so it is reversible and physical."),
    ("burning of the water","Water does not burn; boiling simply changes its state.")]),

 ("PCC","A burning candle shows BOTH kinds of change: the wax melting near the flame is physical, while the wax burning is:",
   "a chemical change",
   C("Melting only changes the wax's state, but burning turns wax into new substances (gases, heat, light).")+
   steps("Wax melts -> still wax (physical)","Wax burns in the flame -> new substances form","Burning is therefore a chemical change.")+
   U("This single candle neatly shows a physical and a chemical change happening together."),
   [("also just a physical change","Burning forms new substances, so it is chemical, not merely physical."),
    ("no change at all","Burning clearly changes the wax into new substances, so a change does occur."),
    ("a change of state like melting","Melting is a state change, but burning makes new substances, which is chemical.")]),

 ("PCC","Adding baking soda to lemon juice produces lots of fizzing bubbles of gas. This is a:",
   "chemical change",
   C("The fizz is a new gas (carbon dioxide) formed by a reaction — a sign of a chemical change.")+
   steps("Baking soda meets the acid in lemon juice","They react and release a gas","A new substance (gas) forms -> chemical change.")+
   U("The same fizz makes cakes rise and gives some drinks their bubbles."),
   [("physical change","A new gas is produced, so it is a chemical change, not a physical one."),
    ("a change of state only","The bubbling is a reaction making a new gas, not just a state change."),
    ("simple dissolving","Plain dissolving gives no fizz; here a gas is produced by a reaction.")]),
]

# Interleave so no two consecutive questions share a chapter, and Maths/Science alternate.
items = []
for i in range(25):
    items += [SYM[i], LIGHT[i], AEX[i], PCC[i]]
assert len(items) == 100

# Guard: no two consecutive same chapter.
for a, b in zip(items, items[1:]):
    assert a[0] != b[0], (a[1], b[1])

if __name__ == "__main__":
    here = os.path.dirname(os.path.abspath(__file__))
    papers_dir = os.path.abspath(os.path.join(
        here, "..", "..", "desktopAhaan", "Resources", "BossChallengePapers"))
    os.chdir(papers_dir)

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=10103,
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
    split = "/".join(str(counts[c]) for c in ("SYM", "LIGHT", "AEX", "PCC"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
