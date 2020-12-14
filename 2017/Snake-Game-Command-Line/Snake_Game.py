import random as rd
import signal as s
import sys
import os, time

#Let the player set the number of apples on the board, which remains unchanged over time.
#The number of apples should be between 1 and 10.
num_food = round(float(input("Please set the number of apples: ")))
while not 1 <= num_food <= 10:
        num_food = round(float(input("Please type a number between 1 and 10: ")))

#Let the player set the initial length of the snake.
#The initial length of the snake should be between 1 and 6.
init_len = round(float(input("Please set the initial length of snake: ")))
while not 1 <= init_len <= 6:
        init_len = round(float(input("Please type a number between 1 and 6: ")))

#Initial setups.
score = 0
life = 3
lose_life = False
row = 20
col = 30
game_over = False

#Use "#" to portray the sides of the board.
def board(row, col):
        lst = []
        [lst.append ([]) for i in range(row)]
        [lst[i].append('#') for j in range(col) for i in [0,row-1]]
        [lst[i].append('#') for i in range(1,row-1)]
        [lst[i].append(' ') for j in range(1,col-1) for i in range(1,row-1)]
        [lst[i].append('#') for i in range(1,row-1)]
        return lst

#Random setup of the snake's initial direction and position.
#Initial direction of the snake: half-time facing the right, half-time facing the bottom.
#Initial position of the snake's tail: anywhere in the second quadrant.
#A list "body" is designed to make a sequential record of the row and column coordinates of the snake's body.
key = rd.choice(['s','d'])
board = board(row, col)
rand_row = rd.randint(2, row//2)
rand_col = rd.randint(2, col//2)
body = []
if key == 's':
        for i in range(init_len):
                body.append([])
                body[-1].append(rand_row + init_len - i - 1)
                body[-1].append(rand_col)
elif key == 'd':
        for i in range(init_len):
                body.append([])
                body[-1].append(rand_row)
                body[-1].append(rand_col + init_len - i - 1)

#Choose a random coordinate on the board.
def rand_coor():
        return [rd.randint(1,row-2),rd.randint(1,col-2)]       

#Create a new apple (denoted by "*") in one of the empty board positions.
#While loop is applied to prevent the appearance of apples in non-empty positions.
def new_apple(): 
        r = rand_coor()
        while r in body or r in apple: r = rand_coor()
        board[r[0]][r[1]] = "*"
        apple.append(r)

#A list "apple" is designed to make a record of the existing apples on the board.
apple = []
[new_apple() for i in range(num_food)]
eat = False

#A global variable (predicate) "eat" is designed to determine if the snake eats an apple at any particular moment.
#A global variable "score" is designed to exhibit the player's score at any particular moment.

#When the snake eats an apple, the apple disappears and a new apple is generated randomly.
#When the snake eats an apple, the score goes up by 1.
def eat_apple():
        global eat
        global score
        if body[0] in apple:
                eat = True
                apple.remove(body[0])
                new_apple()
                score += 1
        else:
                eat = False

#Renew the board by denoting the position changes of the snake's body and the apples.
#Denote the snake's body by "@".
def renew_board():
        for i in body:
                board[i[0]][i[1]] = '@'
        for i in range(num_food):
                board[apple[i][0]][apple[i][1]] = '*'

#Exhibit the score and the remaining lives. Print the board.
def generate_board():
        print('     ' + 'SCORE' + ' ' + str(score) + '          ' + 'LIFE' + ' ' + str(life))
        [print(" ".join(i)) for i in board]

#Display the initial instructions of the game. Set up the initial board.
def init_board():
        print('Welcome to the Advanced Snake Game!')
        print('Control: "w","a","s","d" and press Enter quickly')
        renew_board()
        generate_board()

#A global variable (predicate) "lose_life" is designed to determine if the snake loses a life at any particular moment.
#A global variable "life" is designed to exhibit the snake's remaining number of lives.
#A global variable (predicate) "game_over" is designed to determine if the game is over.

#Determine the change in positions of the snake's body with regard to the life conditions defined above.
#If the snake's head hits the wall or hits its own body, then it loses one life.
def life_cond():
        global lose_life
        global life
        global game_over
        lose_life = False
        for i in body[1:]:
                if i[0] == body[0][0] and i[1] == body[0][1]:
                        lose_life = True
                        life -= 1
        if body[0][1] == col-1 or body[0][1] == 0 or body[0][0] == row-1 or body[0][0] == 0:
                lose_life = True
                life -= 1
        if life == 0: game_over = True

#Make an immutable copy of the snake's body at any particular moment.
def copy_body(lst):
        copy = []
        [copy.append(i[:]) for i in lst]
        return copy

#Choose a random position on either of the four sides of the board.
def rand_side():
        r= rd.randint(1,4)
        if r == 1:
                return [1,rd.randint(1,col-2)]
        if r == 2:
                return [row-2,rd.randint(1,col-2)]
        if r == 3:
                return [rd.randint(1,row-2),1]
        if r == 4:
                return [rd.randint(1,row-2),col-2]

#For every 20 apples eaten, a life (denoted by "+") is created on one side of the board.
def create_life():
        if score % 20 == 0 and eat == True:
                r = rand_side()
                while r in body or r in apple: r = rand_side()
                board[r[0]][r[1]] = "+"

#Eat the "+" and the player's number of lives will increase by 1.
def eat_life():
        global life
        if board[body[0][0]][body[0][1]] == "+":
                life += 1

#For every 30 apples eaten, a bomb (denoted by "o") is created on one side of the board.
def create_bomb():
        if score % 30 == 0 and eat == True:
                r = rand_side()
                while r in body or r in apple: r = rand_side()
                board[r[0]][r[1]] = "o"

#Eat the "o" and the snake's length (on its tail) will reduce by a random number from 5 to 10.
def eat_bomb():
        global body
        if board[body[0][0]][body[0][1]] == "o":
                for i in range(rd.randint(5,10)):
                        board[body[-1][0]][body[-1][1]] = ' '
                        body.remove(body[-1])

#Input setups for the bash command line game.
def interrupted(sig, frm):
        raise ValueError

def timed_input():
        try: return input()
        except ValueError: return

s.signal(s.SIGALRM, interrupted)

#Setups for the snake's initial speed and the keyboard buttons to be used.
init_board()
CTRL = ['w','s','a','d']
PreKEY = key
speed = 2

#A universal while loop is designed to end the game when the predicate "game_over" turns True.
#For every 25 apples eaten, the snake's speed increases by 1.
#Use bash commands "w", "s", "a", "d" + "enter" to control the snake. All other bash commands are invalidated.
#The snake's positions change if and only if it does not lose life at that particular moment.
#The snake becomes 1 unit longer if and only if it eats an apple at that particular moment.
#Implement all other features (i.e. bombs, additional lives) inside the loop.
while game_over == False:
        if score > 25: speed = 3
        if score > 50: speed = 4
        if score > 75: speed = 5
        if score > 100: speed = 6

        s.setitimer(s.ITIMER_REAL, 1/speed)
        key = timed_input()
        copy = copy_body(body)

        if key not in CTRL: key = PreKEY
        for i in range(4):
                if CTRL[i] in key: body[0][int(i/2)] = body[0][int(i/2)] + (-1)**(i+1)
                PreKEY = key
        life_cond()

        if lose_life == False:
                for i in range(1,len(copy)):
                        body[i] = copy[i-1]
        elif lose_life == True:
                for i in range(0,len(copy)):
                        body[i] = copy[i]

        eat_apple()
        if eat == False and lose_life == False: board[copy[-1][0]][copy[-1][1]] = ' '
        elif eat == True: body.append(copy[-1])

        create_life()
        eat_life()
        create_bomb()
        eat_bomb()
        renew_board()
        generate_board()

#Add final comments and give a "grade of performance" to the player based on the score he or she obtains.
print('Game Over!')
if score < 25:
        level = "Poor."
elif score >= 25 and score < 50:
        level = "Fair."
elif score >= 50 and score < 75:
        level = "Good!"
elif score >= 75 and score < 100:
        level = "Excellent!!"
else:
        level = "Perfect!!!"
print('Your score is: ' + str(score) + '. Performance: ' + level)