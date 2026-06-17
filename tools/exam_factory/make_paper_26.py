# -*- coding: utf-8 -*-
# Boss Challenge Paper 26 — Electric Current & its Effects · Simple Equations · Reproduction in Plants · Data Handling
# Content-only. Uses the dependency-free examfactory engine.
# Difficulty ramp: this paper leans hard into FUSION — many Simple-Equations items are wrapped in a
# real circuit situation (counting cells in a torch, units of "push" per cell, spare bulbs in a series
# line) or a plant-reproduction situation (seeds in a sunflower head, seeds per pod, daily growth of a
# creeper). Many Data-Handling items are wrapped in a circuit context (hours a torch is used, current
# readings, weekly electricity units) or a reproduction context (seeds scattered per day, seeds per
# pod, seeds dispersed by trees). The child reads a Science context and applies a Maths skill.
# Class-7 scope, simple wording, hard thinking.
# Produces, under Resources/BossChallengePapers/:
#   Paper_26_<SHORT>_QuestionPaper.html  (pure HTML — questions + options)
#   Paper_26_<SHORT>_QuestionPaper.pdf
#   Paper_26_<SHORT>_Questions.md
#   Paper_26_<SHORT>_Solutions.html
import os, sys, shutil, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from examfactory import build_paper, C, steps, U

PNUM  = "26"
SHORT = "ElectricCurrent_SimpleEquations_ReproductionPlants_DataHandling"
TITLE = ("Electric Current & its Effects · Simple Equations · "
         "Reproduction in Plants · Data Handling")
LABELS = {
    "EC": "Electric Current & its Effects",
    "SE": "Simple Equations",
    "RP": "Reproduction in Plants",
    "DH": "Data Handling",
}

# ---------- ELECTRIC CURRENT & ITS EFFECTS (25) — Science ----------
EC = [
 ("EC","A small device used to break or complete the path of electric current in a circuit is the:",
   "switch",
   C("A switch opens the circuit (stops current) or closes it (lets current flow) at our command.")+
   steps("A circuit is a closed loop for current","A switch can break or join that loop","so it turns the current off or on."),
   [("filament","A filament is the thin wire that glows inside a bulb, not the on/off control."),
    ("cell","A cell pushes the current; the part that breaks or completes the path is the switch."),
    ("fuse","A fuse melts to protect the circuit; the everyday on/off control is the switch.")]),

 ("EC","When a magnetic compass needle is brought near a wire carrying current, the needle deflects. This shows that an electric current has a:",
   "magnetic effect",
   C("A current-carrying wire behaves like a magnet, so it pushes the compass needle aside.")+
   steps("Current flows through the wire","It creates a magnetic field around the wire","this field turns the nearby compass needle."),
   [("cooling effect","A current warms a wire; it does not cool it, and a compass turns because of magnetism."),
    ("chemical effect only","The chemical effect happens in liquids; a compass deflects because of the magnetic effect."),
    ("no effect at all","The needle clearly moves, so the current does have an effect — a magnetic one.")]),

 ("EC","A coil of insulated wire wound around an iron piece becomes a magnet only while current flows. This is called an:",
   "electromagnet",
   C("An electromagnet is a coil-and-iron magnet that works only as long as current passes through it.")+
   steps("Wind a coil of wire on an iron core","Pass current through the coil","the iron becomes a magnet — an electromagnet."),
   [("permanent magnet","A permanent magnet keeps its magnetism with no current; an electromagnet needs current."),
    ("compass","A compass is a tiny pivoted magnet used to find direction, not a coil-and-iron magnet."),
    ("fuse","A fuse is a safety wire that melts; the coil-and-iron magnet is an electromagnet.")]),

 ("EC","Inside a glowing electric bulb, the thin coiled tungsten wire that becomes white-hot is known as the:",
   "filament",
   C("The filament is the thin wire that gets white-hot and gives out light when current flows through it.")+
   steps("Current enters the bulb","It heats the thin coiled wire","the glowing wire is the filament."),
   [("switch","A switch turns the bulb on or off; the glowing wire is the filament."),
    ("terminal","A terminal is a connection point; the part that glows is the filament."),
    ("fuse","A fuse is a safety wire elsewhere; the wire that glows in a bulb is the filament.")]),

 ("EC","When current passes through a wire, the wire becomes warm. This is called the ___ of electric current.",
   "heating effect",
   C("Current makes a wire hot — the heating effect — which is used in heaters, irons and toasters.")+
   steps("Current flows through a wire","The wire opposes the flow and warms up","this warming is the heating effect."),
   [("magnetic effect","The magnetic effect turns a compass needle; the warming of the wire is the heating effect."),
    ("lighting effect","Light comes from the heating that makes a filament glow; the warming itself is the heating effect."),
    ("freezing effect","Current never freezes a wire; it warms it through the heating effect.")]),

 ("EC","In a circuit diagram, a single cell is drawn as a long line and a short thick line. The long line stands for the:",
   "positive terminal",
   C("By convention the longer line of a cell symbol is its positive (+) terminal; the short thick line is negative.")+
   steps("Look at the cell symbol","Find the longer thin line","that long line marks the positive terminal."),
   [("negative terminal","The negative terminal is the short thick line; the long line is positive."),
    ("switch","A switch has its own symbol; the long line of a cell marks the positive terminal."),
    ("filament","A filament belongs to a bulb; the long line of a cell is its positive terminal.")]),

 ("EC","When two or more cells are joined together to give more push to the current, the combination is called a:",
   "battery",
   C("A battery is two or more cells connected together to provide a larger total voltage.")+
   steps("One cell gives a small push","Join several cells in a line","the combination is a battery."),
   [("circuit","A circuit is the whole closed path; joined cells together make a battery."),
    ("switch","A switch only breaks or joins the path; joined cells form a battery."),
    ("conductor","A conductor carries the current; joined cells form a battery.")]),

 ("EC","A safety wire that melts and breaks the circuit when too much current flows is the:",
   "fuse",
   C("A fuse is a thin wire that melts when the current grows dangerously large, cutting off the supply.")+
   steps("Too much current heats the thin fuse wire","The wire melts and breaks","the circuit opens and the appliance is protected."),
   [("filament","A filament glows to give light; the wire that melts for safety is the fuse."),
    ("switch","A switch is for manual on/off; the wire that melts on overload is the fuse."),
    ("electromagnet","An electromagnet is a coil-and-iron magnet; the safety wire that melts is the fuse.")]),

 ("EC","The working of an electric bell depends mainly on the ___ of electric current.",
   "magnetic effect",
   C("An electric bell uses an electromagnet, which pulls an iron strip to strike the gong, so it relies on the magnetic effect.")+
   steps("Current flows through the bell's coil","The coil becomes an electromagnet","its pull strikes the gong — the magnetic effect."),
   [("heating effect","The heating effect runs heaters; a bell works by the magnetic effect of an electromagnet."),
    ("chemical effect","The chemical effect happens in liquids; a bell rings by the magnetic effect."),
    ("cooling effect","Current does not cool; a bell works by the magnetic effect of current.")]),

 ("EC","Materials such as copper and iron that let electric current pass through them easily are called:",
   "conductors",
   C("Conductors let current flow through them; metals like copper and iron are good conductors.")+
   steps("Test a material in a circuit","If the bulb lights, current passed through","such current-allowing materials are conductors."),
   [("insulators","Insulators block current, like rubber and plastic; current-allowing materials are conductors."),
    ("filaments","A filament is one part of a bulb, not a class of current-allowing materials."),
    ("switches","A switch is a device, not a class of materials that let current pass — those are conductors.")]),

 ("EC","An electric bulb stops glowing because its filament has broken. We say the bulb has:",
   "fused (its circuit is now open)",
   C("A broken filament leaves a gap, so the circuit is open and no current flows — the bulb is 'fused'.")+
   steps("The filament is the path for current inside the bulb","If it breaks there is a gap","the circuit is open, so the bulb does not glow."),
   [("more current flowing through it","A broken filament stops the current; no current flows at all."),
    ("become a battery","A broken bulb is simply not working; it does not turn into a battery."),
    ("turned into a conductor","A broken filament breaks the path; the bulb has fused, not become a better conductor.")]),

 ("EC","A circuit in which the cell, switch and bulbs are all joined one after another in a single loop is a ___ circuit.",
   "series",
   C("In a series circuit there is a single path, so the same current flows through every component in turn.")+
   steps("Trace the wire from the cell","It passes through each part one after another","a single-loop arrangement is a series circuit."),
   [("broken","A broken circuit has a gap and no current; a single-loop working circuit is a series circuit."),
    ("magnetic","'Magnetic' describes an effect, not a way of joining parts; a single loop is a series circuit."),
    ("chemical","'Chemical' describes an effect of current, not the single-loop arrangement, which is series.")]),

 ("EC","Why is the heating element (coil) of an electric heater made of nichrome rather than copper?",
   "nichrome has high resistance and a very high melting point",
   C("Nichrome resists current strongly, so it gets very hot, and its high melting point lets it glow without melting.")+
   steps("A heater needs a wire that heats up a lot","Nichrome resists current and gets very hot","its high melting point stops it from melting — ideal for the coil."),
   [("nichrome melts very easily when warm","If it melted easily the heater would break; nichrome's high melting point is exactly why it is used."),
    ("copper gives out more heat than nichrome","Copper has low resistance and stays cool; nichrome heats far more."),
    ("nichrome carries no current at all","Nichrome does carry current; it just resists it strongly so it heats up.")]),

 ("EC","Unlike a permanent magnet, a big advantage of an electromagnet is that it:",
   "can be switched on and off and its strength changed",
   C("An electromagnet works only while current flows, so it can be turned on or off and made stronger by adding turns or current.")+
   steps("Current makes the electromagnet a magnet","Cut the current and the magnetism stops","so we can switch it on/off and adjust its strength."),
   [("works even with no current at all","That describes a permanent magnet; an electromagnet needs current to work."),
    ("can never be turned off","Cutting the current turns an electromagnet off, which is its main advantage."),
    ("is always weaker than a compass needle","An electromagnet can be made very strong, far stronger than a compass needle.")]),

 ("EC","Adding more cells (joined correctly) to a torch circuit usually makes the bulb glow brighter because it:",
   "increases the current pushed through the filament",
   C("More cells give a bigger total push, so more current flows through the filament and it glows brighter.")+
   steps("Each cell adds a push to the current","More cells means a bigger total push","more current flows, so the bulb is brighter."),
   [("removes the filament from the bulb","More cells do not remove the filament; they push more current through it."),
    ("turns the current into sound","Adding cells brightens the bulb by raising the current, not by making sound."),
    ("cools the filament down","More current heats the filament more, making it brighter, not cooler.")]),

 ("EC","Touching a bare live wire is dangerous mainly because:",
   "the human body conducts current, which can give a harmful shock",
   C("Our body lets current pass, so touching a live wire sends current through us and causes a shock.")+
   steps("A live wire carries current","The body is a conductor of current","current passes through us and gives a dangerous shock."),
   [("the body blocks all current completely","The body conducts current, which is exactly why a live wire is dangerous."),
    ("live wires are always very cold","The danger is the electric shock, not temperature."),
    ("the wire turns into a magnet in your hand","The real danger is current flowing through the body, giving a shock.")]),

 ("EC","The filament of an electric bulb is usually made of tungsten because tungsten:",
   "has a very high melting point and glows white-hot without melting",
   C("Tungsten can be heated white-hot to give light yet not melt, because its melting point is extremely high.")+
   steps("A filament must glow without melting","Tungsten has a very high melting point","so it can glow white-hot safely."),
   [("melts as soon as it warms up","If it melted easily the bulb would fail; tungsten's high melting point is why it is chosen."),
    ("does not allow any current through","Tungsten conducts current; that current heats it until it glows."),
    ("stays completely cold when current flows","The filament must get hot to give light; tungsten glows white-hot.")]),

 ("EC","A modern safety device that, like a fuse, cuts off the supply on overload but can simply be switched back on is the:",
   "MCB (miniature circuit breaker)",
   C("An MCB trips open when the current is too high and can be reset by flipping it, instead of being replaced like a fuse.")+
   steps("On overload the MCB trips and opens the circuit","No wire is melted","you simply switch it back on once the fault is fixed."),
   [("ordinary fuse","An ordinary fuse melts and must be replaced; the resettable device is the MCB."),
    ("filament","A filament glows in a bulb; the resettable safety switch is the MCB."),
    ("battery","A battery supplies current; the resettable overload switch is the MCB.")]),

 ("EC","The magnetic field produced by a current-carrying coil becomes stronger when you:",
   "increase the current or add more turns to the coil",
   C("More current and more turns each strengthen the magnetic field of a coil (electromagnet).")+
   steps("A coil's field comes from the current in its turns","Push more current, or add more turns","either way the magnetic field grows stronger."),
   [("reduce the current to zero","With no current the field disappears; you need more current for a stronger field."),
    ("remove all the turns of the coil","With no turns there is no coil and no field; more turns make it stronger."),
    ("paint the coil a darker colour","Colour has no effect; current and number of turns control the field strength.")]),

 ("EC","Appliances such as an electric iron, a toaster and a room heater all work mainly using the:",
   "heating effect of electric current",
   C("These appliances turn electrical energy into heat, so they all rely on the heating effect of current.")+
   steps("Each appliance has a coil that gets hot","Current heats the coil","this warming is the heating effect they all use."),
   [("magnetic effect of electric current","The magnetic effect runs bells and motors; irons and toasters use the heating effect."),
    ("chemical effect of electric current","The chemical effect is used in plating; heaters use the heating effect."),
    ("cooling effect of electric current","Current has no cooling effect; these appliances use the heating effect.")]),

 ("EC","Why is the fuse always connected in the live wire and never in the path of a coloured 'earth' wire?",
   "so that when it melts it cuts off the dangerous current to the appliance",
   C("The live wire carries the dangerous current, so a fuse there breaks the supply the instant the current is too high.")+
   steps("Danger comes from the live wire's current","A fuse in the live wire melts on overload","this cuts the supply and protects the appliance."),
   [("because the earth wire carries the most current","The earth wire normally carries no current; the live wire does, so the fuse goes there."),
    ("so the appliance runs faster","A fuse is only for safety; it does not speed up an appliance."),
    ("to make the bulb glow brighter","A fuse protects against overload; it does not brighten bulbs.")]),

 ("EC","A fuse wire is made of a material with a LOW melting point so that it:",
   "melts quickly when the current becomes too large",
   C("A low melting point lets the fuse melt fast on overload, breaking the circuit before damage is done.")+
   steps("Too much current heats the fuse","A low-melting-point wire melts quickly","the circuit breaks and the appliance is saved."),
   [("never melts however large the current","A fuse must melt on overload; that is the whole point of its low melting point."),
    ("carries more current than a thick wire","A fuse is deliberately thin and low-melting so it melts first, not last."),
    ("glows brightly like a bulb filament","A fuse is meant to melt and break the circuit, not to glow as a lamp.")]),

 ("EC","Two identical cells are joined so that the positive terminal of one touches the negative terminal of the other. This proper joining means their pushes:",
   "add up to give a larger total push",
   C("When cells are joined + to −, their voltages add, giving the circuit a bigger total push.")+
   steps("Join + of one cell to − of the next","Their pushes line up in the same direction","so the total push is the sum of the two."),
   [("cancel out to give zero push","Pushes cancel only when cells are joined the wrong way (+ to + ); correct joining adds them."),
    ("turn into a magnetic field instead","Joining cells adds their pushes; it does not convert them into a magnet."),
    ("stop any current from flowing","Correctly joined cells push more current, not less.")]),

 ("EC","An electric fan and a washing-machine motor spin because an electric current can produce a:",
   "magnetic effect that makes a coil turn",
   C("A motor uses the magnetic effect of current: a current-carrying coil in a magnetic field is pushed round and round.")+
   steps("Current flows in the motor's coil","The coil becomes magnetic and is pushed by a magnet","this turning is the magnetic effect of current."),
   [("heating effect that boils the coil","Motors spin by the magnetic effect; boiling the coil would wreck them."),
    ("chemical effect that makes new gases","The chemical effect is used in cells and plating, not in spinning a motor."),
    ("cooling effect that freezes the axle","Current has no cooling effect; a motor spins by the magnetic effect.")]),

 ("EC","Compact fluorescent lamps (CFLs) and LED bulbs are preferred over ordinary filament bulbs mainly because they:",
   "give the same light while using much less electricity",
   C("CFLs and LEDs waste far less energy as heat, so they produce the same brightness for less electricity.")+
   steps("A filament bulb wastes much energy as heat","CFLs and LEDs waste far less","so they give the same light using less electricity."),
   [("are much hotter and waste more energy","They run cooler and waste less, which is exactly why they are preferred."),
    ("need no electricity at all to glow","Every bulb needs some electricity; CFLs and LEDs just need much less."),
    ("only work without any cell or supply","They still need an electric supply; they simply use it more efficiently.")]),
]

# ---------- SIMPLE EQUATIONS (25) — Maths (many FUSED with circuits/plants) ----------
SE = [
 ("SE","A torch already holds some cells. When 2 more cells are pushed in, it has 5 cells in all. Writing this as x + 2 = 5, the number it started with is:",
   "3",
   C("Solve x + 2 = 5 by subtracting 2 from both sides: x = 5 − 2 = 3.")+
   steps("Equation: x + 2 = 5","Subtract 2 from both sides","x = 5 − 2 = 3 cells."),
   [("7","7 comes from adding (5 + 2); to undo '+2' you subtract, giving x = 3."),
    ("10","10 is 5 × 2; the equation x + 2 = 5 gives x = 3."),
    ("2","2 is the number added, not the start; x = 5 − 2 = 3.")]),

 ("SE","Find the value of the unknown number that makes the statement x + 9 = 21 true.",
   "12",
   C("Subtract 9 from both sides: x = 21 − 9 = 12.")+
   steps("Equation: x + 9 = 21","Subtract 9 from both sides","x = 21 − 9 = 12."),
   [("30","30 is 21 + 9; to undo '+9' you subtract, giving 12."),
    ("3","3 is not correct; 21 − 9 = 12, not 3."),
    ("189","189 is 21 × 9; the equation needs subtraction, giving x = 12.")]),

 ("SE","A sunflower head holds the same number of seeds, x. Three identical heads together hold 150 seeds. Using 3x = 150, the number of seeds in one head is:",
   "50",
   C("Divide both sides by 3: x = 150 ÷ 3 = 50 seeds in each head.")+
   steps("Equation: 3x = 150","Divide both sides by 3","x = 150 ÷ 3 = 50 seeds."),
   [("450","450 is 150 × 3; to undo '×3' you divide, giving 50."),
    ("147","147 is 150 − 3; the equation 3x = 150 needs division, giving 50."),
    ("153","153 is 150 + 3; dividing 150 by 3 gives 50.")]),

 ("SE","What number makes the equation 6x = 54 correct?",
   "9",
   C("Divide both sides by 6: x = 54 ÷ 6 = 9.")+
   steps("Equation: 6x = 54","Divide both sides by 6","x = 54 ÷ 6 = 9."),
   [("48","48 is 54 − 6; to undo '×6' you divide, giving 9."),
    ("60","60 is 54 + 6; dividing 54 by 6 gives 9."),
    ("324","324 is 54 × 6; the equation needs division, giving x = 9.")]),

 ("SE","Solve the equation in which a number divided by 5 gives 7, written as x ÷ 5 = 7.",
   "35",
   C("Multiply both sides by 5: x = 7 × 5 = 35.")+
   steps("Equation: x ÷ 5 = 7","Multiply both sides by 5","x = 7 × 5 = 35."),
   [("12","12 is 7 + 5; to undo '÷5' you multiply, giving 35."),
    ("2","2 is 7 − 5; the equation x ÷ 5 = 7 gives x = 35."),
    ("1.4","1.4 is 7 ÷ 5; you must multiply by 5, giving 35.")]),

 ("SE","Find the value of x in the equation 2x + 1 = 13.",
   "6",
   C("First subtract 1 (2x = 12), then divide by 2 (x = 6).")+
   steps("2x + 1 = 13 → subtract 1: 2x = 12","Divide both sides by 2","x = 12 ÷ 2 = 6."),
   [("7","7 forgets to divide; after 2x = 12 you halve to get 6."),
    ("12","12 is the value of 2x, not x; halve it to get 6."),
    ("14","14 is 13 + 1; you subtract 1 first, then divide, giving 6.")]),

 ("SE","In a circuit each cell gives a 'push' of 2 units. A battery of x cells gives a total push of 12 units. Using 2x = 12, the number of cells is:",
   "6",
   C("Divide both sides by 2: x = 12 ÷ 2 = 6 cells.")+
   steps("Equation: 2x = 12","Divide both sides by 2","x = 12 ÷ 2 = 6 cells."),
   [("24","24 is 12 × 2; to undo '×2' you divide, giving 6."),
    ("10","10 is 12 − 2; the equation 2x = 12 gives x = 6."),
    ("14","14 is 12 + 2; dividing 12 by 2 gives 6.")]),

 ("SE","'Five more than a number is fourteen.' Turning this sentence into the equation x + 5 = 14, the number is:",
   "9",
   C("Subtract 5 from both sides: x = 14 − 5 = 9.")+
   steps("Sentence → x + 5 = 14","Subtract 5 from both sides","x = 14 − 5 = 9."),
   [("19","19 is 14 + 5; to undo '+5' you subtract, giving 9."),
    ("70","70 is 14 × 5; the equation x + 5 = 14 gives x = 9."),
    ("2.8","2.8 is 14 ÷ 5; you subtract 5 here, giving 9.")]),

 ("SE","Solve for x: 3x − 4 = 20.",
   "8",
   C("Add 4 to both sides (3x = 24), then divide by 3 (x = 8).")+
   steps("3x − 4 = 20 → add 4: 3x = 24","Divide both sides by 3","x = 24 ÷ 3 = 8."),
   [("16","16 is 20 − 4; you must add 4 first, then divide, giving 8."),
    ("24","24 is the value of 3x, not x; divide by 3 to get 8."),
    ("72","72 is 24 × 3; after 3x = 24 you divide, giving x = 8.")]),

 ("SE","A ripe pod always bursts into x seeds. Five such pods scatter 35 seeds altogether. Using 5x = 35, the number of seeds in one pod is:",
   "7",
   C("Divide both sides by 5: x = 35 ÷ 5 = 7 seeds per pod.")+
   steps("Equation: 5x = 35","Divide both sides by 5","x = 35 ÷ 5 = 7 seeds."),
   [("40","40 is 35 + 5; to undo '×5' you divide, giving 7."),
    ("30","30 is 35 − 5; the equation 5x = 35 gives x = 7."),
    ("175","175 is 35 × 5; the equation needs division, giving x = 7.")]),

 ("SE","Which value of the unknown satisfies the equation 4x = 28?",
   "7",
   C("Divide both sides by 4: x = 28 ÷ 4 = 7.")+
   steps("Equation: 4x = 28","Divide both sides by 4","x = 28 ÷ 4 = 7."),
   [("24","24 is 28 − 4; to undo '×4' you divide, giving 7."),
    ("32","32 is 28 + 4; dividing 28 by 4 gives 7."),
    ("112","112 is 28 × 4; the equation needs division, giving x = 7.")]),

 ("SE","A series light-line holds x glowing bulbs plus 3 spare bulbs, making 10 bulbs in all. Using x + 3 = 10, the number of glowing bulbs is:",
   "7",
   C("Subtract 3 from both sides: x = 10 − 3 = 7 glowing bulbs.")+
   steps("Equation: x + 3 = 10","Subtract 3 from both sides","x = 10 − 3 = 7 bulbs."),
   [("13","13 is 10 + 3; to undo '+3' you subtract, giving 7."),
    ("30","30 is 10 × 3; the equation x + 3 = 10 gives x = 7."),
    ("3","3 is the number of spares, not the glowing bulbs; x = 7.")]),

 ("SE","'Twice a number, decreased by 5, equals 9.' Writing this as 2x − 5 = 9, the number is:",
   "7",
   C("Add 5 (2x = 14), then divide by 2 (x = 7).")+
   steps("2x − 5 = 9 → add 5: 2x = 14","Divide both sides by 2","x = 14 ÷ 2 = 7."),
   [("2","2 is 9 − 5 ÷... ; you add 5 first (2x = 14), then halve to get 7."),
    ("14","14 is the value of 2x, not x; halve it to get 7."),
    ("28","28 is 14 × 2; after 2x = 14 you divide, giving x = 7.")]),

 ("SE","Solve the equation x − 12 = 0.",
   "12",
   C("Add 12 to both sides: x = 0 + 12 = 12.")+
   steps("Equation: x − 12 = 0","Add 12 to both sides","x = 12."),
   [("0","0 is the right-hand side; undoing '−12' gives x = 12."),
    ("−12","−12 would make the left side −24; the correct value is x = 12."),
    ("24","24 is 12 × 2; the equation x − 12 = 0 gives x = 12.")]),

 ("SE","A flower has 4 times as many pollen-bearing stamens as petals. It has 20 stamens. Using 4x = 20, the number of petals is:",
   "5",
   C("Divide both sides by 4: x = 20 ÷ 4 = 5 petals.")+
   steps("Equation: 4x = 20","Divide both sides by 4","x = 20 ÷ 4 = 5 petals."),
   [("16","16 is 20 − 4; to undo '×4' you divide, giving 5."),
    ("80","80 is 20 × 4; the equation 4x = 20 needs division, giving 5."),
    ("24","24 is 20 + 4; dividing 20 by 4 gives 5.")]),

 ("SE","Solve for x when half of a number, increased by 3, equals 8, written as (x ÷ 2) + 3 = 8.",
   "10",
   C("Subtract 3 (x ÷ 2 = 5), then multiply by 2 (x = 10).")+
   steps("(x ÷ 2) + 3 = 8 → subtract 3: x ÷ 2 = 5","Multiply both sides by 2","x = 5 × 2 = 10."),
   [("5","5 is the value of x ÷ 2, not x; multiply by 2 to get 10."),
    ("22","22 is (8 + 3) × 2; you must subtract 3 first, giving x = 10."),
    ("11","11 is 8 + 3; you still divide-undo by multiplying, giving x = 10.")]),

 ("SE","What value of x makes the equation x + 4 = 4 true?",
   "0",
   C("Subtract 4 from both sides: x = 4 − 4 = 0.")+
   steps("Equation: x + 4 = 4","Subtract 4 from both sides","x = 0."),
   [("4","4 would make the left side 8; the correct value is x = 0."),
    ("8","8 is 4 + 4; the equation x + 4 = 4 gives x = 0."),
    ("1","1 would make the left side 5; x must be 0.")]),

 ("SE","Solve the equation 5x + 2 = 2x + 17, which has the unknown on both sides.",
   "5",
   C("Move 2x across (3x + 2 = 17), subtract 2 (3x = 15), divide by 3 (x = 5).")+
   steps("5x + 2 = 2x + 17 → subtract 2x: 3x + 2 = 17","Subtract 2: 3x = 15","Divide by 3: x = 5."),
   [("15","15 is the value of 3x, not x; divide by 3 to get 5."),
    ("19","19 is 17 + 2; after collecting terms you get 3x = 15, so x = 5."),
    ("3","3 does not satisfy the equation; solving gives 3x = 15, so x = 5.")]),

 ("SE","The number of seeds in a fruit is 3 more than twice the number of carpels. The fruit has 11 seeds. Using 2x + 3 = 11, the number of carpels is:",
   "4",
   C("Subtract 3 (2x = 8), then divide by 2 (x = 4 carpels).")+
   steps("2x + 3 = 11 → subtract 3: 2x = 8","Divide both sides by 2","x = 8 ÷ 2 = 4 carpels."),
   [("7","7 is 11 − 4 by mistake; subtract 3 then halve to get 4."),
    ("8","8 is the value of 2x, not x; halve it to get 4."),
    ("14","14 is 11 + 3; you subtract 3 first, then divide, giving 4.")]),

 ("SE","Solve the equation 10 − x = 3.",
   "7",
   C("Rearranging, x = 10 − 3 = 7.")+
   steps("Equation: 10 − x = 3","Bring x across: 10 − 3 = x","x = 7."),
   [("13","13 is 10 + 3; here 10 − x = 3 gives x = 7."),
    ("−7","−7 would make the left side 17; the correct value is x = 7."),
    ("30","30 is 10 × 3; the equation 10 − x = 3 gives x = 7.")]),

 ("SE","A creeper grows the same length, x cm, each day. In 6 days it has grown 48 cm. Using 6x = 48, the daily growth is:",
   "8 cm",
   C("Divide both sides by 6: x = 48 ÷ 6 = 8 cm each day.")+
   steps("Equation: 6x = 48","Divide both sides by 6","x = 48 ÷ 6 = 8 cm."),
   [("42 cm","42 is 48 − 6; to undo '×6' you divide, giving 8 cm."),
    ("54 cm","54 is 48 + 6; dividing 48 by 6 gives 8 cm."),
    ("288 cm","288 is 48 × 6; the equation needs division, giving 8 cm.")]),

 ("SE","Solve the equation 3x = 2x + 8, in which the unknown appears on both sides.",
   "8",
   C("Subtract 2x from both sides: 3x − 2x = 8, so x = 8.")+
   steps("Equation: 3x = 2x + 8","Subtract 2x from both sides","x = 8."),
   [("4","4 is 8 ÷ 2; subtracting 2x leaves x = 8, not 4."),
    ("16","16 is 8 × 2; collecting the x terms gives x = 8."),
    ("2","2 does not satisfy the equation; x = 8.")]),

 ("SE","'The sum of a number and 13 is exactly 13.' Written as x + 13 = 13, the number is:",
   "0",
   C("Subtract 13 from both sides: x = 13 − 13 = 0.")+
   steps("Equation: x + 13 = 13","Subtract 13 from both sides","x = 0."),
   [("13","13 would make the left side 26; the correct value is x = 0."),
    ("26","26 is 13 + 13; the equation x + 13 = 13 gives x = 0."),
    ("1","1 would make the left side 14; x must be 0.")]),

 ("SE","Find the value of x in the equation 9 = x − 6.",
   "15",
   C("Add 6 to both sides: x = 9 + 6 = 15.")+
   steps("Equation: 9 = x − 6","Add 6 to both sides","x = 9 + 6 = 15."),
   [("3","3 is 9 − 6; to undo '−6' you add, giving 15."),
    ("54","54 is 9 × 6; the equation 9 = x − 6 gives x = 15."),
    ("6","6 is the number subtracted, not the answer; x = 15.")]),

 ("SE","A number multiplied by 7 gives 0. Writing this as 7x = 0, the value of the number is:",
   "0",
   C("Divide both sides by 7: x = 0 ÷ 7 = 0. (Only 0 times 7 gives 0.)")+
   steps("Equation: 7x = 0","Divide both sides by 7","x = 0 ÷ 7 = 0."),
   [("7","7 × 7 is 49, not 0; the only value giving 0 is x = 0."),
    ("1","1 × 7 is 7, not 0; the answer is x = 0."),
    ("70","70 × 7 is far from 0; only x = 0 works.")]),
]

# ---------- REPRODUCTION IN PLANTS (25) — Science ----------
RP = [
 ("RP","Reproduction in which a new plant grows from a part of the parent (root, stem or leaf) without seeds is called:",
   "vegetative propagation",
   C("Vegetative propagation makes a new plant from a vegetative part — root, stem or leaf — with no seeds involved.")+
   steps("Take a part of the parent plant","It grows roots and shoots on its own","this seedless way is vegetative propagation."),
   [("pollination","Pollination is the transfer of pollen; growing a plant from a stem or leaf is vegetative propagation."),
    ("fertilisation","Fertilisation is the fusion of gametes; a seedless plant from a parent part is vegetative propagation."),
    ("dispersal","Dispersal is the scattering of seeds; making a plant from a parent part is vegetative propagation.")]),

 ("RP","The male reproductive part of a flower, made of an anther and a filament, is the:",
   "stamen",
   C("The stamen is the male part: its anther makes pollen and the filament holds it up.")+
   steps("Find the slender stalks with knobs on top","The knob (anther) makes pollen","the whole stalk-and-knob is the stamen."),
   [("pistil","The pistil is the female part with the stigma and ovary, not the pollen-making part."),
    ("petal","Petals are the coloured leaves that attract insects, not the male reproductive part."),
    ("sepal","Sepals are the small green leaves that protect the bud, not the male part.")]),

 ("RP","The female reproductive part of a flower, made of the stigma, style and ovary, is the:",
   "pistil (carpel)",
   C("The pistil (carpel) is the female part: pollen lands on the stigma and the ovary holds the ovules.")+
   steps("Find the central flask-shaped part","Its top is the stigma and its base is the ovary","this female part is the pistil."),
   [("stamen","The stamen is the male part that makes pollen, not the female part."),
    ("petal","Petals attract insects; the female reproductive part is the pistil."),
    ("sepal","Sepals protect the young bud; the female part is the pistil.")]),

 ("RP","The transfer of pollen grains from the anther of a flower to its stigma is called:",
   "pollination",
   C("Pollination is the movement of pollen from the anther onto a stigma, the first step before fertilisation.")+
   steps("Pollen is made in the anther","It is carried to a stigma","this transfer is called pollination."),
   [("fertilisation","Fertilisation is the fusion of the male and female cells, which happens after pollination."),
    ("germination","Germination is a seed sprouting into a seedling, not the transfer of pollen."),
    ("dispersal","Dispersal is the scattering of seeds, not the transfer of pollen to a stigma.")]),

 ("RP","When pollen from a flower reaches the stigma of a flower on a DIFFERENT plant, it is called:",
   "cross-pollination",
   C("Cross-pollination carries pollen from one plant to the stigma of another plant of the same kind.")+
   steps("Pollen leaves one plant's anther","It lands on another plant's stigma","pollen between two plants is cross-pollination."),
   [("self-pollination","Self-pollination keeps the pollen within the same flower or plant, not between two plants."),
    ("fertilisation","Fertilisation is the fusion of gametes after pollen arrives, not the cross-transfer itself."),
    ("vegetative propagation","Vegetative propagation makes plants from parent parts, not by moving pollen between plants.")]),

 ("RP","After fertilisation, the ovary of a flower grows and ripens into a:",
   "fruit",
   C("Once fertilised, the ovary swells and becomes the fruit, while the ovules inside become seeds.")+
   steps("Fertilisation happens inside the ovary","The ovary wall grows and ripens","it becomes the fruit holding the seeds."),
   [("root","A root grows downward for water; the fertilised ovary becomes the fruit."),
    ("petal","Petals usually wither after fertilisation; it is the ovary that becomes the fruit."),
    ("leaf","A leaf makes food by photosynthesis; the fertilised ovary becomes the fruit.")]),

 ("RP","Ferns and mosses do not make seeds. Instead they reproduce by means of tiny:",
   "spores",
   C("Spores are tiny reproductive units that ferns, mosses and fungi scatter to grow new plants without seeds.")+
   steps("These plants make no flowers or seeds","They form dust-like reproductive units","these light units are spores."),
   [("seeds","Ferns and mosses are seedless; they reproduce by spores."),
    ("fruits","Only flowering plants form fruits; ferns and mosses spread by spores."),
    ("tubers","A tuber is a swollen underground stem; ferns and mosses use spores.")]),

 ("RP","Simple water plants such as Spirogyra break into pieces, and each piece grows into a new plant. This is called:",
   "fragmentation",
   C("In fragmentation the parent breaks into fragments, and each fragment grows into a complete new individual.")+
   steps("The thread-like plant breaks apart","Each broken piece keeps growing","each fragment becomes a new plant — fragmentation."),
   [("pollination","Pollination is pollen transfer in flowers, not the breaking up of a water plant."),
    ("budding","In budding a small bud grows out and detaches; fragmentation is the breaking of the body into pieces."),
    ("germination","Germination is a seed sprouting; a water plant splitting into pieces is fragmentation.")]),

 ("RP","The brightly coloured part of a flower whose main job is to attract insects for pollination is the:",
   "petal",
   C("Petals are usually colourful and scented to attract insects that carry pollen from flower to flower.")+
   steps("Insects are drawn by bright colours and scent","Petals provide both","so petals attract pollinators."),
   [("sepal","Sepals are small and green and protect the bud; the colourful attractors are petals."),
    ("anther","The anther makes pollen; the colourful part that attracts insects is the petal."),
    ("ovary","The ovary holds the ovules deep inside; the showy attracting part is the petal.")]),

 ("RP","Light seeds with wing-like or hair-like parts, such as those of the drumstick or maple, are usually dispersed by:",
   "wind",
   C("Light, winged or hairy seeds are caught by moving air and carried far from the parent plant by the wind.")+
   steps("The seed is light with wings or hairs","A breeze lifts and carries it","so it is dispersed by wind."),
   [("water","Water disperses seeds that float, like the coconut; light winged seeds travel by wind."),
    ("animals","Animals carry sticky or eaten seeds; light winged seeds are blown by wind."),
    ("explosion","Some pods burst open, but light winged seeds are mainly carried by wind.")]),

 ("RP","A coconut can float across the sea and sprout on a distant shore. Its seed is dispersed mainly by:",
   "water",
   C("The coconut's light, fibrous husk lets it float, so flowing water carries it to new places.")+
   steps("The coconut has a light, fibrous husk","It floats on water","currents carry it far — dispersal by water."),
   [("wind","A coconut is far too heavy for the wind; it floats and is carried by water."),
    ("animals","Animals do not carry whole coconuts across the sea; water does."),
    ("explosion","A coconut does not burst to scatter; it floats and is dispersed by water.")]),

 ("RP","Seeds of plants like Xanthium have tiny hooks or spines so that they can be dispersed by:",
   "clinging to the fur of animals",
   C("Hooked, spiny seeds catch onto the fur of passing animals and are carried far before dropping off.")+
   steps("The seed has tiny hooks or spines","They catch on an animal's fur as it brushes past","the animal carries the seed away."),
   [("floating on still water","Hooked seeds are made to grip fur, not to float on water."),
    ("being blown by a gentle breeze","Hooked seeds are too rough and heavy for the wind; they cling to fur."),
    ("bursting out of a dry pod","Hooks are for catching fur, not for an explosive burst.")]),

 ("RP","Why is the dispersal of seeds away from the parent plant useful?",
   "it prevents overcrowding and competition for water, sunlight and minerals",
   C("Spreading seeds out stops too many seedlings crowding one spot and fighting over the same water and light.")+
   steps("If all seeds fell at the parent's feet they would crowd","Crowded seedlings compete for water and sunlight","spreading them out avoids this — so dispersal helps."),
   [("it makes the parent plant grow taller","Dispersal helps the new seeds, not the height of the parent plant."),
    ("it stops the seeds from ever growing","Dispersal helps seeds find space to grow, not prevents growth."),
    ("it removes the need for sunlight","All green plants still need sunlight; dispersal just spreads them out.")]),

 ("RP","A potato has small 'eyes' that can sprout into new plants. This is an example of vegetative propagation by a:",
   "stem (tuber)",
   C("A potato is a swollen underground stem (tuber); its eyes are buds that grow into new potato plants.")+
   steps("A potato is an underground stem, not a root","Its eyes are buds","each bud can grow a new plant — stem vegetative propagation."),
   [("leaf","Bryophyllum uses leaf buds; the potato's buds are on a swollen stem (tuber)."),
    ("seed","The potato's eyes are buds, not seeds; this is seedless vegetative propagation."),
    ("flower","A flower leads to seeds; the potato sprouts from buds on its stem.")]),

 ("RP","The leaves of the Bryophyllum plant grow tiny buds along their notched edges. Each bud can grow into a new plant. This shows vegetative propagation by:",
   "leaves",
   C("Bryophyllum produces buds on the margins of its leaves, and each detached bud grows into a new plant.")+
   steps("Look at the notched leaf edge","Tiny buds form there","each bud drops and grows a new plant — leaf propagation."),
   [("roots","Here the new buds form on the leaf edges, not on roots."),
    ("seeds","No seeds are involved; the new plants grow from buds on the leaves."),
    ("pollen","Pollen is part of seed-making; Bryophyllum's leaf buds are vegetative propagation.")]),

 ("RP","In sexual reproduction in plants, a new individual begins when:",
   "a male gamete (from pollen) fuses with a female gamete (egg)",
   C("Sexual reproduction needs fertilisation — the fusion of a male cell from pollen with the egg in the ovule.")+
   steps("Pollen brings the male cell to the ovule","It fuses with the female egg cell","this fusion (fertilisation) starts a new plant."),
   [("a piece of stem grows roots on its own","That is vegetative (asexual) propagation, not sexual reproduction."),
    ("a leaf bud falls and sprouts","That is vegetative propagation; sexual reproduction needs gametes to fuse."),
    ("a spore lands on wet soil","Spores are asexual units; sexual reproduction needs male and female gametes to fuse.")]),

 ("RP","The single cell formed when the male and female gametes fuse during fertilisation is called the:",
   "zygote",
   C("The zygote is the first cell of the new plant, formed by the fusion of the male and female gametes.")+
   steps("The male cell meets the egg","They fuse into one cell","this first cell is the zygote."),
   [("pollen","Pollen carries the male cell; the cell formed after fusion is the zygote."),
    ("stigma","The stigma is the part of the pistil that receives pollen, not the fused cell."),
    ("petal","A petal is a coloured flower part; the fused cell is the zygote.")]),

 ("RP","A flower that has both stamens (male) and a pistil (female) in the same flower is called a:",
   "bisexual flower",
   C("A bisexual flower carries both the male stamens and the female pistil together in one flower.")+
   steps("Check the flower for parts","It has both stamens and a pistil","so it is a bisexual flower."),
   [("unisexual flower","A unisexual flower has only stamens OR only a pistil, not both."),
    ("spore","A spore is a tiny asexual reproductive unit, not a kind of flower."),
    ("seed","A seed forms after fertilisation; a flower with both sexes is a bisexual flower.")]),

 ("RP","Gardeners grow new money plants and rose plants quickly by planting pieces cut from a healthy stem. This artificial method is called growing from:",
   "cuttings",
   C("A cutting is a piece of stem planted in soil or water that grows roots and becomes a new plant.")+
   steps("Cut a healthy piece of stem","Plant it in soil or water","it grows roots and shoots — a cutting."),
   [("seeds","Cuttings skip seeds entirely; a stem piece grows the new plant."),
    ("spores","Spores belong to ferns and mosses; gardeners use stem cuttings here."),
    ("pollen","Pollen is for seed-making; growing from a stem piece is using a cutting.")]),

 ("RP","Ferns and mosses spread very successfully by spores mainly because spores are:",
   "tiny, very many, and light enough to be carried far by wind",
   C("Spores are produced in huge numbers and are so light that the wind scatters them over wide areas.")+
   steps("Each plant makes thousands of spores","They are tiny and very light","the wind carries them far, so they spread widely."),
   [("large and heavy so they stay in one place","Spores are tiny and light, which is exactly why they spread far."),
    ("alive only inside water","Spores can travel through air; they are not limited to water."),
    ("made only by flowering plants","Flowering plants make seeds, not spores; ferns and mosses make spores.")]),

 ("RP","A seed has a tough outer coat. Its main job is to:",
   "protect the tiny embryo inside until conditions are right to grow",
   C("The seed coat shields the baby plant (embryo) from damage and drying until water and warmth let it sprout.")+
   steps("Inside the seed is a tiny embryo plant","The hard coat guards it from harm and drying","it sprouts only when conditions are right."),
   [("make the seed taste sweet","The coat's job is protection, not flavour."),
    ("stop the seed from ever growing","The coat protects the embryo so it CAN grow later, not prevents it."),
    ("attract insects with bright colour","Petals attract insects; the seed coat's job is to protect the embryo.")]),

 ("RP","Wind, water and insects that carry pollen from one flower to another are together called:",
   "agents of pollination",
   C("Anything that carries pollen to a stigma — wind, water or an insect — is an agent of pollination.")+
   steps("Pollen must travel from anther to stigma","Wind, water and insects do this carrying","so they are agents of pollination."),
   [("agents of digestion","Digestion happens inside animals; carriers of pollen are agents of pollination."),
    ("decomposers","Decomposers rot dead matter; pollen carriers are agents of pollination."),
    ("predators","Predators hunt prey; the carriers of pollen are agents of pollination.")]),

 ("RP","When pollen from a flower lands on the stigma of the SAME flower (or another flower on the same plant), it is called:",
   "self-pollination",
   C("Self-pollination keeps pollen within the same flower or the same plant, rather than going to a different plant.")+
   steps("Pollen leaves the anther","It lands on a stigma of the same flower or plant","this is self-pollination."),
   [("cross-pollination","Cross-pollination carries pollen to a DIFFERENT plant, not the same one."),
    ("fertilisation","Fertilisation is the fusion of gametes after pollen arrives, not the transfer itself."),
    ("dispersal","Dispersal scatters seeds; pollen staying on the same plant is self-pollination.")]),

 ("RP","Grafting and layering, used by gardeners to make new fruit and flower plants, are examples of:",
   "artificial vegetative propagation",
   C("Grafting and layering are man-made ways of growing new plants from parts of a parent plant, without seeds.")+
   steps("A gardener joins or bends a plant part","It grows roots or shoots","this human-aided seedless growth is artificial vegetative propagation."),
   [("sexual reproduction","Sexual reproduction needs gametes to fuse; grafting uses plant parts, so it is vegetative."),
    ("pollination","Pollination is pollen transfer; grafting and layering are vegetative propagation."),
    ("seed dispersal","Seed dispersal scatters seeds; grafting and layering grow plants from parts.")]),

 ("RP","After fertilisation, the ovules inside the ovary of a flower develop into:",
   "seeds",
   C("Each fertilised ovule grows into a seed, while the surrounding ovary becomes the fruit.")+
   steps("Ovules sit inside the ovary","After fertilisation each ovule ripens","each becomes a seed."),
   [("petals","Petals are flower parts that often fall away; ovules become seeds."),
    ("roots","Roots anchor the plant; fertilised ovules become seeds."),
    ("leaves","Leaves make food; fertilised ovules become seeds.")]),
]

# ---------- DATA HANDLING (25) — Maths (many FUSED with circuits/plants) ----------
DH = [
 ("DH","Over 5 days a torch was switched on for 3, 5, 2, 4 and 6 hours. The arithmetic mean (average) number of hours per day is:",
   "4",
   C("Mean = sum of values ÷ number of values = (3+5+2+4+6) ÷ 5 = 20 ÷ 5 = 4.")+
   steps("Add the hours: 3+5+2+4+6 = 20","There are 5 days","mean = 20 ÷ 5 = 4 hours."),
   [("20","20 is the total of all five days, not the average; divide by 5 to get 4."),
    ("6","6 is the largest single day, not the mean; the mean is 4."),
    ("5","5 is the number of days, not the average hours, which is 4.")]),

 ("DH","The arithmetic mean (average) of the three numbers 4, 6 and 8 is:",
   "6",
   C("Mean = (4 + 6 + 8) ÷ 3 = 18 ÷ 3 = 6.")+
   steps("Add them: 4 + 6 + 8 = 18","There are 3 numbers","mean = 18 ÷ 3 = 6."),
   [("18","18 is the total, not the average; divide by 3 to get 6."),
    ("8","8 is the largest number, not the mean, which is 6."),
    ("3","3 is how many numbers there are, not their average of 6.")]),

 ("DH","In the data set 2, 3, 3, 5 and 7, the value that occurs most often (the mode) is:",
   "3",
   C("The mode is the most frequent value; here 3 appears twice and the others once, so the mode is 3.")+
   steps("Count how often each value appears","3 appears twice, the rest once","so the mode is 3."),
   [("7","7 is the largest value, but the most frequent (mode) is 3."),
    ("5","5 is the middle value here, not the most frequent; the mode is 3."),
    ("4","4 is not even in the list; the most frequent value is 3.")]),

 ("DH","When the numbers 4, 1, 7, 3 and 9 are arranged in order, the middle value — the median — is:",
   "4",
   C("Arrange them: 1, 3, 4, 7, 9. The middle (3rd of 5) value is 4.")+
   steps("Order the data: 1, 3, 4, 7, 9","Five values — the middle is the 3rd","the median is 4."),
   [("7","7 is the 4th value once ordered, not the middle; the median is 4."),
    ("9","9 is the largest value, not the middle; the median is 4."),
    ("5","5 is the mean here, not the median; the median is 4.")]),

 ("DH","The range of the data set 12, 5, 18, 9 and 7 is found by subtracting the lowest value from the highest. The range is:",
   "13",
   C("Range = highest − lowest = 18 − 5 = 13.")+
   steps("Highest value = 18, lowest value = 5","Range = highest − lowest","= 18 − 5 = 13."),
   [("23","23 is 18 + 5; the range is the difference 18 − 5 = 13."),
    ("18","18 is just the highest value; the range is 18 − 5 = 13."),
    ("5","5 is just the lowest value; the range is 18 − 5 = 13.")]),

 ("DH","Over 5 days a plant scattered 10, 12, 8, 10 and 10 seeds. The value that occurs most often (the mode) is:",
   "10",
   C("The mode is the most frequent value; 10 appears three times, more than any other, so the mode is 10.")+
   steps("Count how often each number appears","10 appears three times","so the mode is 10."),
   [("12","12 is the largest count, but it appears only once; the mode is 10."),
    ("8","8 appears only once; the most frequent value is 10."),
    ("50","50 is the total of all five days, not the mode, which is 10.")]),

 ("DH","In a pictograph one full picture of a battery stands for 5 cells sold. A shelf row shows 4 full battery pictures. The number of cells sold is:",
   "20",
   C("Each picture = 5 cells, and there are 4 pictures, so 4 × 5 = 20 cells.")+
   steps("One picture stands for 5 cells","There are 4 pictures","total = 4 × 5 = 20 cells."),
   [("9","9 is 4 + 5; each picture stands for 5, so 4 × 5 = 20."),
    ("5","5 is what one picture stands for; four pictures mean 4 × 5 = 20."),
    ("4","4 is just the number of pictures; each is worth 5, so 4 × 5 = 20.")]),

 ("DH","Tossing one fair coin a single time, what is the chance (probability) that it lands showing a head?",
   "1/2",
   C("A coin has 2 equally likely sides, and a head is 1 of them, so the probability is 1 out of 2 = 1/2.")+
   steps("There are 2 equally likely outcomes: head or tail","A head is 1 of them","probability = 1/2."),
   [("1","A probability of 1 means certain; a head is not certain, so it is 1/2."),
    ("2","A probability cannot be 2; it must be between 0 and 1, and here it is 1/2."),
    ("0","A probability of 0 means impossible; a head is possible, so it is 1/2.")]),

 ("DH","When an ordinary six-faced die is rolled once, the probability of getting a number GREATER than 4 is:",
   "1/3",
   C("Numbers greater than 4 are 5 and 6 — that is 2 of the 6 faces, so 2/6 = 1/3.")+
   steps("Faces greater than 4 are 5 and 6 (2 faces)","Total faces = 6","probability = 2/6 = 1/3."),
   [("1/2","1/2 would be 3 of the 6 faces; only 2 faces (5 and 6) are greater than 4, giving 1/3."),
    ("2/3","2/3 would be 4 of the 6 faces; only 2 faces are greater than 4, so it is 1/3."),
    ("1/6","1/6 is for a single face; two faces (5 and 6) give 2/6 = 1/3.")]),

 ("DH","A bar graph is best described as a way of showing data using:",
   "bars of equal width whose heights stand for the quantities",
   C("In a bar graph each category gets an equal-width bar, and the bar's height shows how big that quantity is.")+
   steps("Each category gets its own bar","The bars all have the same width","their HEIGHTS show the quantities."),
   [("a single line joining changing points","That describes a line graph; a bar graph uses bars whose heights show the data."),
    ("slices of a circle for each part","That describes a pie chart; a bar graph uses bars of equal width."),
    ("pictures that each stand for a number","That describes a pictograph; a bar graph uses bars whose heights show quantities.")]),

 ("DH","The median of the four ordered current readings 3, 5, 9 and 11 (in milliamperes) is the average of the two middle values, which is:",
   "7",
   C("With an even count, the median is the average of the two middle values: (5 + 9) ÷ 2 = 7.")+
   steps("The two middle values are 5 and 9","Average them: (5 + 9) ÷ 2","= 14 ÷ 2 = 7."),
   [("9","9 is one of the two middle values; the median is their average, 7."),
    ("14","14 is the sum of the two middle values; you must halve it to get 7."),
    ("8","8 is the mean of all four readings here, not the median, which is 7.")]),

 ("DH","An event that is certain to happen, such as the sun rising tomorrow, has a probability of:",
   "1",
   C("A certain event always happens, so its probability is the maximum value, 1.")+
   steps("Probability runs from 0 (impossible) to 1 (certain)","A certain event always happens","its probability is 1."),
   [("0","A probability of 0 means impossible; a certain event has probability 1."),
    ("1/2","1/2 means an even chance; a certain event has probability 1."),
    ("100","Probability never exceeds 1; a certain event has probability 1, not 100.")]),

 ("DH","To find the arithmetic mean of a set of observations, you:",
   "add up all the observations and divide by how many there are",
   C("The mean is the total of all the values shared equally — the sum divided by the number of values.")+
   steps("Add every observation together","Count how many observations there are","mean = sum ÷ number of observations."),
   [("pick the value that appears most often","That gives the mode, not the mean."),
    ("pick the middle value once they are ordered","That gives the median, not the mean."),
    ("subtract the smallest from the largest","That gives the range, not the mean.")]),

 ("DH","Four pods held 6, 8, 8 and 10 seeds. The mean (average) number of seeds per pod is:",
   "8",
   C("Mean = (6 + 8 + 8 + 10) ÷ 4 = 32 ÷ 4 = 8 seeds per pod.")+
   steps("Add the seeds: 6 + 8 + 8 + 10 = 32","There are 4 pods","mean = 32 ÷ 4 = 8."),
   [("32","32 is the total number of seeds, not the average; divide by 4 to get 8."),
    ("10","10 is the largest pod, not the mean, which is 8."),
    ("4","4 is the number of pods, not the average of 8.")]),

 ("DH","An event that can never happen, such as rolling a 7 on an ordinary six-faced die, has a probability of:",
   "0",
   C("An impossible event never happens, so its probability is the smallest value, 0.")+
   steps("A die has only the faces 1 to 6","Rolling a 7 is impossible","so its probability is 0."),
   [("1","A probability of 1 means certain; an impossible event has probability 0."),
    ("1/6","1/6 is the chance of a face that DOES exist; a 7 is impossible, so 0."),
    ("7","Probability is never the number itself; an impossible event has probability 0.")]),

 ("DH","The most suitable average to answer 'which shoe size is the most common in the class?' is the:",
   "mode",
   C("The mode is the value that occurs most often, so it directly tells you the most common shoe size.")+
   steps("'Most common' means most frequent","The mode is the most frequent value","so the mode answers this best."),
   [("mean","The mean is the overall average size, not the single most common one — that is the mode."),
    ("median","The median is the middle size when ordered, not the most common — that is the mode."),
    ("range","The range is the spread between largest and smallest, not the most common value.")]),

 ("DH","For which task would a double bar graph (two bars per category) be the most useful kind of chart?",
   "compare two sets of data side by side for each category",
   C("A double bar graph places two bars next to each other per category, making comparison easy.")+
   steps("Each category gets two bars, not one","The pair sits side by side","so you can compare two data sets at a glance."),
   [("show the parts of a single whole","That is a pie chart's job; a double bar graph compares two data sets."),
    ("show how one quantity changes smoothly over time","That is a line graph's job; a double bar graph compares two sets."),
    ("display only a single set of values","A simple bar graph shows one set; a double bar graph compares two.")]),

 ("DH","Five daily current readings were 4, 4, 6, 5 and 6 milliamperes. Their mean (average) is:",
   "5",
   C("Mean = (4 + 4 + 6 + 5 + 6) ÷ 5 = 25 ÷ 5 = 5 milliamperes.")+
   steps("Add the readings: 4+4+6+5+6 = 25","There are 5 readings","mean = 25 ÷ 5 = 5."),
   [("25","25 is the total of the readings, not the average; divide by 5 to get 5."),
    ("6","6 is the largest reading, not the mean, which is 5."),
    ("4","4 is the smallest reading, not the mean of 5.")]),

 ("DH","When a fair die is rolled once, the probability of getting an EVEN number is:",
   "1/2",
   C("The even faces are 2, 4 and 6 — that is 3 of the 6 faces, so 3/6 = 1/2.")+
   steps("Even faces are 2, 4, 6 (3 faces)","Total faces = 6","probability = 3/6 = 1/2."),
   [("1/3","1/3 would be 2 of the 6 faces; there are 3 even faces, giving 1/2."),
    ("1/6","1/6 is the chance of a single face; three even faces give 3/6 = 1/2."),
    ("2/3","2/3 would be 4 of the 6 faces; only 3 are even, so the answer is 1/2.")]),

 ("DH","The arithmetic mean of the first five whole numbers 0, 1, 2, 3 and 4 is:",
   "2",
   C("Mean = (0 + 1 + 2 + 3 + 4) ÷ 5 = 10 ÷ 5 = 2.")+
   steps("Add them: 0 + 1 + 2 + 3 + 4 = 10","There are 5 numbers","mean = 10 ÷ 5 = 2."),
   [("10","10 is the total of the numbers, not the average; divide by 5 to get 2."),
    ("4","4 is the largest number, not the mean, which is 2."),
    ("2.5","2.5 would be the mean of 1,2,3,4; including 0 over 5 numbers gives 2.")]),

 ("DH","A frequency table records how often each value appears, often using groups of marks like ||||. These groups of marks are called:",
   "tally marks",
   C("Tally marks are short strokes used to count, usually bundled in fives, in a frequency table.")+
   steps("Each time a value appears you draw one stroke","Bundle them in fives for easy counting","these counting strokes are tally marks."),
   [("bar graphs","A bar graph uses bars; the counting strokes in a table are tally marks."),
    ("pictographs","A pictograph uses pictures; the counting strokes are tally marks."),
    ("medians","A median is a middle value, not a counting stroke; those are tally marks.")]),

 ("DH","A bar graph shows the number of seeds dispersed by four trees: P = 30, Q = 45, R = 25 and S = 50. The tree that dispersed the MOST seeds is:",
   "S",
   C("The tallest bar shows the most seeds; S = 50 is the highest of the four counts.")+
   steps("Compare the four counts: 30, 45, 25, 50","The largest is 50","that bar is tree S, so S dispersed the most."),
   [("Q","Q dispersed 45, but S dispersed more, with 50."),
    ("P","P dispersed only 30; the most was tree S with 50."),
    ("R","R dispersed the fewest at 25; the most was tree S with 50.")]),

 ("DH","Across a week a home used 6, 7, 5, 8, 6, 9 and 8 units of electricity. The range of the daily usage is:",
   "4",
   C("Range = highest − lowest = 9 − 5 = 4 units.")+
   steps("Highest daily usage = 9, lowest = 5","Range = highest − lowest","= 9 − 5 = 4 units."),
   [("14","14 is 9 + 5; the range is the difference 9 − 5 = 4."),
    ("9","9 is just the highest day; the range is 9 − 5 = 4."),
    ("49","49 is the total for the week, not the range, which is 4.")]),

 ("DH","In the data set 8, 2, 8, 5, 2, 8, the value that appears most often (the mode) is:",
   "8",
   C("The mode is the most frequent value; 8 appears three times, more than any other, so the mode is 8.")+
   steps("Count each value: 8 appears 3 times, 2 appears twice","8 is the most frequent","so the mode is 8."),
   [("2","2 appears twice, but 8 appears three times, so the mode is 8."),
    ("5","5 appears only once; the most frequent value is 8."),
    ("33","33 is the total of the values, not the mode, which is 8.")]),

 ("DH","The mean (average) of two numbers is 7. If one of the numbers is 5, the other number is:",
   "9",
   C("If the mean is 7, the two numbers add to 2 × 7 = 14, so the other is 14 − 5 = 9.")+
   steps("Mean of two numbers is 7, so their sum is 2 × 7 = 14","One number is 5","the other = 14 − 5 = 9."),
   [("7","7 is the mean itself, not the missing number; the other number is 9."),
    ("2","2 is the difference 7 − 5; the missing number is 14 − 5 = 9."),
    ("12","12 is 7 + 5; using the sum 14, the missing number is 14 − 5 = 9.")]),
]

# ---------- real-life use-cases (one per question, same order as each list) ----------
EC_UC = [
 "Flicking the wall switch off completes or breaks the circuit, turning your room light on or off.",
 "The magnetic effect of current is why a wire near a compass nudges the needle, the basis of every electric motor.",
 "A scrapyard crane lifts cars with a huge electromagnet that drops them the instant the current is switched off.",
 "The glowing wire you see inside an old-style bulb is its filament heating up white-hot.",
 "An electric kettle boils water using the heating effect of the current in its element.",
 "When wiring a torch, you match the long line (+) of the cell symbol to the battery's bump end.",
 "The 'battery' in a TV remote is really two cells joined together to give a bigger push.",
 "When too many appliances overload a circuit, the fuse melts and saves the wiring from catching fire.",
 "A doorbell rings because current turns a coil into an electromagnet that strikes the gong.",
 "Copper wires conduct the current to your gadgets, while their plastic covers (insulators) keep you safe.",
 "When a bulb suddenly goes dark, its filament has usually snapped, leaving the circuit open.",
 "Old fairy lights are wired in series, so if one bulb fails the whole string can go dark.",
 "A heater's coil is nichrome so it glows red-hot to warm the room without melting away.",
 "A scrapyard electromagnet can be switched on to grab steel and off to drop it — a permanent magnet cannot.",
 "Putting fresh cells in a dim torch pushes more current through the bulb and makes it bright again.",
 "We are warned never to touch bare wires because the body conducts the current and gets a shock.",
 "The filament in a bulb is tungsten so it can glow white-hot for hours without melting.",
 "A modern home uses an MCB that you simply flip back on after an overload, instead of changing a fuse.",
 "Winding more turns onto an electromagnet's coil makes it strong enough to pick up heavier iron.",
 "Your toaster, iron and geyser all turn electricity into heat using the heating effect of current.",
 "Electricians place the fuse in the live wire so it cuts off the dangerous current the moment it surges.",
 "A fuse wire is a low-melting metal so it melts first and breaks the circuit before anything else is harmed.",
 "Joining two torch cells end to end (+ to −) adds their pushes to light the bulb more strongly.",
 "A ceiling fan spins because current's magnetic effect pushes its coil round inside a magnet.",
 "Switching your home to LED bulbs gives the same light while cutting the electricity bill.",
]
SE_UC = [
 "Counting how many cells your torch started with, before you topped it up, is solving x + 2 = 5.",
 "Working out an unknown count by undoing an addition is everyday equation-solving, like x + 9 = 21.",
 "A farmer dividing a total seed count by the number of flower heads is solving 3x = 150.",
 "Splitting a total equally into 6 groups, like 54 sweets among 6 friends, solves 6x = 54.",
 "Finding the whole when a fifth of it is known, like x ÷ 5 = 7, undoes a division by multiplying.",
 "Two-step puzzles like 2x + 1 = 13 turn up whenever you peel off an extra before sharing.",
 "Knowing each cell's push and the battery's total, you solve 2x = 12 to count the cells.",
 "Turning the sentence 'five more than a number is 14' into x + 5 = 14 is how word problems become equations.",
 "Undoing a subtraction and then a multiplication, as in 3x − 4 = 20, is a common two-step solve.",
 "Dividing a total scatter of seeds by the number of pods, like 5x = 35, finds the seeds per pod.",
 "Sharing 28 items into 4 equal lots, as in 4x = 28, is a one-step division equation.",
 "Counting glowing bulbs after setting aside the spares, like x + 3 = 10, is a quick subtraction equation.",
 "Phrases like 'twice a number less 5 is 9' become 2x − 5 = 9, a two-step equation to solve.",
 "Recovering a starting amount after a drop of 12, as in x − 12 = 0, undoes the subtraction.",
 "Knowing a flower has four times as many stamens as petals lets you solve 4x = 20 for the petals.",
 "Half-then-add puzzles like (x ÷ 2) + 3 = 8 appear when you split something and add a bit.",
 "Some equations like x + 4 = 4 have the answer zero — a useful check that you solved correctly.",
 "Equations with the unknown on both sides, like 5x + 2 = 2x + 17, are solved by gathering the x's together.",
 "Turning 'three more than twice the carpels is 11 seeds' into 2x + 3 = 11 finds the carpel count.",
 "Working out what was taken away, as in 10 − x = 3, rearranges to find x.",
 "A creeper's steady daily growth is found by solving 6x = 48 to get the centimetres per day.",
 "Equations like 3x = 2x + 8 are solved by subtracting the smaller multiple of x from both sides.",
 "Some sums, like x + 13 = 13, lead to the answer zero, confirming nothing was added.",
 "Recovering a number after a drop of 6, as in 9 = x − 6, undoes the subtraction by adding.",
 "Recognising that only zero times 7 gives 0, so 7x = 0 means x = 0, is a handy shortcut.",
]
RP_UC = [
 "Growing a new rose bush from a cut stem, with no seed at all, is vegetative propagation.",
 "The little stalks tipped with pollen you see in a lily are its stamens, the male parts.",
 "The central flask-shaped part of a flower, where fruit later forms, is the pistil.",
 "A bee dusting pollen from one bloom onto another is carrying out pollination.",
 "An apple orchard often needs two varieties so pollen can cross from one tree to another.",
 "The tomato or mango you eat is really the ripened ovary of its flower — a fruit.",
 "The brown dust you see under a fern leaf is its spores, scattering to grow new ferns.",
 "Pond scum (Spirogyra) that keeps spreading does so by simply breaking into pieces — fragmentation.",
 "The bright petals of a flower are billboards that lure insects in to carry the pollen.",
 "The winged seeds of a maple that spin away on the breeze are dispersed by wind.",
 "A coconut washed up on a far-off beach travelled there floating on the sea — water dispersal.",
 "The burrs that stick to your socks after a walk are seeds hitching a ride on animals.",
 "Spreading seeds far apart is what stops a clump of seedlings from starving each other of light.",
 "Planting the 'eyes' of a potato to grow a whole new crop is vegetative propagation by stem.",
 "Bryophyllum leaves sprouting tiny plantlets along their edges show leaf vegetative propagation.",
 "A new mango tree from a seed begins only when pollen's male cell fuses with the egg in the ovule.",
 "The very first cell of a new plant, formed at fertilisation, is the zygote inside the seed.",
 "A mustard flower carrying both stamens and a pistil is a bisexual flower.",
 "Gardeners multiply money plants in days by snipping and replanting stem cuttings.",
 "A single fern can colonise a whole damp wall because its spores are tiny, countless and wind-borne.",
 "The hard shell of a bean seed guards the baby plant until water and warmth tell it to sprout.",
 "Bees, the wind and water are the agents of pollination that carry pollen between flowers.",
 "A wheat flower that pollinates itself, without help from another plant, shows self-pollination.",
 "Grafting a tasty mango branch onto a hardy rootstock is artificial vegetative propagation.",
 "Each pip inside an apple is a fertilised ovule that has ripened into a seed.",
]
DH_UC = [
 "Averaging your daily screen time over a week, by adding the hours and dividing by 7, gives the mean.",
 "Finding the average of three test marks, like 4, 6 and 8, is exactly working out their mean.",
 "Spotting the most common size sold, like the value that repeats most, is finding the mode.",
 "Lining up data and picking the middle value, as in 1, 3, 4, 7, 9, gives the median.",
 "Subtracting the coldest day's temperature from the hottest gives the range of the week.",
 "The seed count a plant repeats most often across several days is the mode of its daily totals.",
 "Reading a pictograph where one symbol stands for 5 lets you multiply symbols to get the total.",
 "Calling a coin toss 'fifty-fifty' is just saying the probability of heads is 1/2.",
 "Working out the chance of rolling more than 4 on a die, 2 faces out of 6, gives 1/3.",
 "A bar graph lets you compare quantities at a glance by the differing heights of equal-width bars.",
 "Averaging the two middle current readings of four sorted values gives their median.",
 "Saying an event is certain, like the sun rising, means its probability is 1.",
 "Whenever you 'average' anything, you add all the values and divide by how many there are.",
 "Finding the typical number of seeds per pod, by adding and dividing, gives the mean per pod.",
 "Knowing a die cannot show a 7 tells you that outcome has probability 0.",
 "To answer 'which size sells most?', a shopkeeper looks at the mode of the sizes sold.",
 "A double bar graph lets you compare, say, boys' and girls' scores side by side per subject.",
 "Averaging several current readings, by summing and dividing, gives the mean current.",
 "The chance of an even number on a die, 3 faces out of 6, works out to 1/2.",
 "Averaging the first few whole numbers, like 0 to 4, by adding and dividing gives their mean.",
 "The bundled strokes a teacher uses to count votes in a tally chart are tally marks.",
 "Reading a bar graph of seeds per tree, the tallest bar tells you which tree spread the most.",
 "Subtracting the lowest day's electricity use from the highest gives the range for the week.",
 "The reading that turns up most often in a list, like a repeated value, is its mode.",
 "Knowing the average of two numbers and one of them lets you work back to find the other.",
]


def _with_uc(lst, ucs):
    assert len(lst) == len(ucs) == 25
    out = []
    for it, uc in zip(lst, ucs):
        code, stem, correct, html, distr = it
        out.append((code, stem, correct, html + U(uc), distr))
    return out


EC = _with_uc(EC, EC_UC)
SE = _with_uc(SE, SE_UC)
RP = _with_uc(RP, RP_UC)
DH = _with_uc(DH, DH_UC)

items = []
for i in range(25):
    items += [EC[i], SE[i], RP[i], DH[i]]
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

    keydist = build_paper(PNUM, TITLE, SHORT, LABELS, items, seed=26741,
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
    split = "/".join(str(counts[c]) for c in ("EC", "SE", "RP", "DH"))
    with open("PAPERS_MANIFEST.md", "a", encoding="utf-8") as fh:
        fh.write(f"| {PNUM} | 2026-06-18 | {TITLE} | {split} | ✓ |\n")

    # ---- update QUESTION_INDEX.json ----
    idx["fingerprints"] = sorted(existing | set(new_fps))
    idx.setdefault("combos", []).append({
        "paper": PNUM,
        "chapters": ["Electric Current & its Effects",
                     "Simple Equations",
                     "Reproduction in Plants",
                     "Data Handling"],
    })
    idx["papers"] = idx.get("papers", 0) + 1
    with open(idx_path, "w", encoding="utf-8") as fh:
        json.dump(idx, fh, ensure_ascii=False, indent=2)
        fh.write("\n")

    print("Files:", sorted(v for v in moves.values()))
    print("Answer key spread A/B/C/D =", dict(keydist))
    print("Fingerprints added:", len(new_fps))
