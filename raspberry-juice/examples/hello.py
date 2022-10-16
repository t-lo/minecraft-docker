# Make sure mcpi is installed, e.g. by "pip install mcpi"

from mcpi.minecraft import Minecraft

mc = Minecraft.create()

mc.postToChat("Hello Minecraft!")

oldpos = mc.player.getPos()
while True:
    pos = mc.player.getPos()
    if pos != oldpos:
        mc.postToChat("You moved to %d %d %d." %(pos.x, pos.y, pos.z))
        oldpos=pos

