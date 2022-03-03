//SPDX-License-Identifier: Unlicense
pragma solidity ^0.4.24;

/**
 * @title TicTacToe contract
 **/
contract TicTacToe {
    address[2] public players;

    /**
     turn
     1 - players[0]'s turn
     2 - players[1]'s turn
     */
    uint public turn = 1;

    /**
     status
     0 - ongoing
     1 - players[0] won
     2 - players[1] won
     3 - draw
     */
    uint public status;

    /**
    board status
     0    1    2
     3    4    5
     6    7    8
     */
    uint[9] private board;

    /**
      * @dev Deploy the contract to create a new game
      * @param opponent The address of player2
      **/
    constructor(address opponent) public {
        require(msg.sender != opponent, "No self play");
        players = [msg.sender, opponent];
    }

    /**
      * @dev Check a, b, c in a line are the same
      * _threeInALine doesn't check if a, b, c are in a line
      * @param a position a
      * @param b position b
      * @param c position c
      **/    
    function _threeInALine(uint a, uint b, uint c) private view returns (bool){
        /*Please complete the code here.*/ 
        if ((board[a] != 0) && (board[a] == board[b]) && (board[a] == board[c])){
            return true;
        }
        else{
            return false;
        }
    }

    /**
     * @dev get the status of the game
     * @param pos the position the player places at
     * @return the status of the game
     */
    function _getStatus(uint pos) private view returns (uint) {
        /*Please complete the code here.*/

        uint mystatus = 0;
        bool ftoe = true;

        for(uint x = 0; x < 3; x++){
            /* Horizontal line */
            if (_threeInALine(x*3, x*3 + 1, x*3 +2)){ 
                mystatus = board[3*x];
                return mystatus;
            }
            
            /* Vertical line */
            else if (_threeInALine(x, x+3, x+6)){ 
                mystatus = board[x];
                return mystatus;
            }
        }
        
        /* Diagnal line */
        if (_threeInALine(0, 4, 8)){ 
            mystatus = board[0];
            return mystatus;
        }
        if(_threeInALine(2, 4, 6)){
            mystatus = board[2];
            return mystatus;
        }
        
        /* Check if no place left, we already checked win or loss,
         so the last possibility is toe */
        
        for(uint i = 0; i < 9; i++){
            if (board[i] == 0){
                ftoe = false;
                break;
            }    
        }
        if (ftoe){return 3;
        }
        return mystatus;
        // 
        // for( uint i = 0; i < 9; i++){
        //     if (board[i] == 0){
        //         return 3;
        //         break
        //     }    
        // }

        // return mystatus;
    }


    /**
     * @dev ensure the game is still ongoing before a player moving
     * update the status of the game after a player moving
     * @param pos the position the player places at
     */
    modifier _checkStatus(uint pos) {
        /*Please complete the code here.*/
        require( _getStatus(pos)== 0, "Game over");
        _;    
    }

    /**
     * @dev check if it's msg.sender's turn
     * @return true if it's msg.sender's turn otherwise false
     */
    function myTurn() public view returns (bool) {
       /*Please complete the code here.*/
       return msg.sender == players[turn - 1];
    }


    /**
     * @dev ensure it's a msg.sender's turn
     * update the turn after a move
     */
    modifier _myTurn() {
      /*Please complete the code here.*/
      require(myTurn(), "Not my turn");
      _;
    }

    /**
     * @dev check a move is valid
     * @param pos the position the player places at
     * @return true if valid otherwise false
     */
    function validMove(uint pos) public view returns (bool) {
      /*Please complete the code here.*/
      return pos < 9 && board[pos] == 0;
    }

    /**
     * @dev ensure a move is valid
     * @param pos the position the player places at
     */
    modifier _validMove(uint pos) {
      /*Please complete the code here.*/
      require(validMove(pos), "Non-valid spot");
      _;
    }

    /**
     * @dev a player makes a move
     * @param pos the position the player places at
     */
    function move(uint pos) public _validMove(pos) _checkStatus(pos) _myTurn {
        board[pos] = turn;

        
        status = _getStatus(pos);
        // Important to keep _getStatus(pos) down here
        // Otherwise it would not work
        if (turn == 1){turn = 2;} 
        // Switch the turn
        else{turn = 1;}
    }

    /**
     * @dev show the current board
     * @return board
     */
    function showBoard() public view returns (uint[9]) {
      return board;
    }
}
