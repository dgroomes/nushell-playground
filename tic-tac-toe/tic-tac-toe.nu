# Let's write a tic-tac-toe game by using the 'tool/function calling' features of LLM APIs.
#
# We can have a thin kernel of code, and as much as possible, we can express the rules of the game and the officiating
# responsibilities to the LLM. This is of course a toy example, but I think it will help demonstrate what is possible
# with an LLM in the loop. In particular, how little code can we get away with? Similarly, it should show the faults
# and disadvantages of this approach like wrong answers, slowness, etc.
#
# Nushell has a 'table' type, and these tables render nicely as characters in the terminal. We'll use that to express
# the board visually in the terminal and to the LLM in the prompt.
#
# The game will be played by the user ('X') and by the AI ('O'). One thing I don't totally get is how to do the looping...
# When the model wants to call a tool, what do I do with that? Call the tool with the args and then ship that back to
# the completions API as just another 'user' message? Or is it a 'tool' message or something? What happens if the LLM
# wants to call two functions in a row (e.g. it makes a move, and because it knows it's the winning move, it needs to
# invoke a "game end" function).
#
# This is the entry point of the game.
export def --env main [message?: string] {
    mut board = if 'TIC_TAC_TOE_BOARD' in $env { $env.TIC_TAC_TOE_BOARD } else { [[a b c]; [- - -] [- - -] [- - -]] }

    let response = if ($message == null) {
        ask-llm $board
    } else {
        ask-llm $board $message
    }

    #print $response
    let function = $response.choices.0.message.tool_calls.0.function
    #print $function
    let function_name = $function.name

    match $function_name {
        "ask_user" => {
           print "You're up! Describe your next move."
           return
        }
        "place_mark" => {
           let args = $function.arguments | from json
           let row_index = $args.row | into int
           $board = ($board | update $row_index { |row| $row | update $args.column $args.mark })
           print $board
           $env.TIC_TAC_TOE_BOARD = $board
           return
        }
        _ => {
           print $"Unrecognized function: ($function_name)"
           return
        }
    }
}

# Ask the LLM what tool to invoke next. We are delegating a maximum amount of responsibility to the LLM. To me, this is
# a form of inversion of control of a traditional program structure.
def ask-llm [board: table, message?: string] nothing -> table {
   let user_content = if message == null {
       $"The board state is:(char newline)($board | table)(char newline)What's the next operation?"
   } else {
       $"The board state is:(char newline)($board | table)(char newline)The user player said '($message)'. What's the next operation?"
   }

   let system_prompt = open "system_prompt.txt"

   let body = {
       model: "gpt-4o"
       # model: "llama3.1:8b-instruct-q8_0"
       messages: [{
           role: "system"
           content: $system_prompt
       }
       {
           role: "user"
           content: $user_content
       }]
       tools: [
       {
           type: "function"
           temperature: 0.7
           max_tokens: 500
           function: {
               name: "ask_user"
               description: "Ask the user for the next instruction in the game. At this point, it's the user's turn in the game, and the officiator is waiting for them to pick a spot to mark the board or request to restart the game. 'X' (the user player) always goes first. The top row is row 0, the middle row is row 1, and the bottom row is row 2. The left column is column 'a', the middle column is column 'b', and the right column is column 'c'. It is NOT the user's turn if there are more 'X' than 'O'."
           }
       }
       {
           type: "function"
           temperature: 0.7
           max_tokens: 500
           function: {
               name: "place_mark"
               description: "Place a tic-tac-toe mark ('X', 'O', or '-') on the board"
               parameters: {
                   type: "object"
                   properties: {
                       mark: {
                           type: "string"
                           description: "The mark to place ('X', 'O', or '-'). The mark will be '-' in the case of an undo operation or as part of a board reset. It is YOUR turn if there are more 'X' than 'O'. You are expected to place an 'O'."
                       }
                       row: {
                           type: "number"
                           description: "The row to place the mark in (0, 1, or 2)"
                       }
                       column: {
                           type: "string"
                           description: "The column to place the mark in ('a', 'b', or 'c')"
                       }
                   }
                   required: ["mark" "row" "column"]
               }
           }
       }
       {
           type: "function"
           temperature: 0.7
           max_tokens: 500
           function: {
               name: "game_end"
               description: "Declare the winner of the game or a draw. This happens when X or O got three in a row, or the board is full."
               parameters: {
                   type: "object"
                   properties: {
                       winner: {
                           type: "string"
                           description: "'X', 'O' or 'draw'"
                       }
                   }
                   required: ["winner"]
               }
           }
       }]
    }

    print $body.messages.1

    # http post --content-type application/json http://localhost:11434/v1/chat/completions $body
    http post --content-type application/json --headers [Authorization $"Bearer ($env.TIC_TAC_TOE_KEY)"] https://api.openai.com/v1/chat/completions $body
}
