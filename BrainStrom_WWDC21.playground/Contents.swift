/*:
 # Welcome To BrainStorm
 BrainStorm is a simple but interesting brain training game. It can help to improve memory focus and concentration. There is a total of 3 levels in the game with increasing difficulties. Player need to pass all the level to win the game.
*/
/*:
 \
 \
 First Level: Player is required to memorise the number and it's corresponding location.
 \
 Second Level: Be careful of  traps in the game.
 \
 Third Level: Player needs to complete two missions at the same time in 60 seconds. Besides memorising the numbers, player needs to take a photo of the instructed object in the mission. 
 */
/*:
 - Note:
 Do pay extra focus on the game. Try your best to win the game.
 */


import PlaygroundSupport
import SpriteKit


let screenView = SKView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
let scene = Scene1 (size: CGSize(width: 640, height: 480))
scene.scaleMode = .aspectFit
screenView.presentScene(scene)
PlaygroundSupport.PlaygroundPage.current.liveView = screenView








