Object subclass: #Blackjack
    instanceVariableNames: 'deck playerHand dealerHand'
    classVariableNames: ''
    poolDictionaries: ''
    category: nil!

Blackjack class methodsFor: 'initialize'!
    new
        ^super new initialize!
!

"Knuth shuffle algorithm"
OrderedCollection extend [
    shuffle [
        | n random |
        n := self size.
        random := Random new.
        n to: 2 by: -1 do: [ :i |
            | j temp |
            j := (random next * i) truncated + 1. "Random index from 1 to i"
            temp := self at: i.
            self at: i put: (self at: j).
            self at: j put: temp.
        ].
        ^self
    ]
]

Blackjack methodsFor: 'game logic'!
    initialize
        "Initialize the game state"
        deck := self generateDeck shuffle.
        playerHand := OrderedCollection new.
        dealerHand := OrderedCollection new.

        "Deal two cards to the player and dealer"
        dealerHand add: self dealCard.
        dealerHand add: self dealCard.
        playerHand add: self dealCard.
        playerHand add: self dealCard.
    !

    generateDeck
        "Generate a deck of cards"
        | suits values deck |
        suits := #('S' 'D' 'H' 'L').
        values := #('2' '3' '4' '4' '5' '6' '7' '8' '9' '10' '11').
        deck := OrderedCollection new.
        suits do: [ :suit |
            values do: [ :value |
                deck add: suit, value.
            ].
        ].
        ^deck
    !

    dealCard
        "Deal a card from the deck"
        ^deck removeFirst
    !

    calculateScore: hand
        "Calculate the score of a hand"
        | score |
        score := 0.
        hand do: [ :card |
            score := score + card allButFirst asInteger.
        ].
        ^score.
    !

    printGameState: dealerHidden
        "Print the game state"
        | dealerScore playerScore dealerDisplay |
        dealerScore := self calculateScore: dealerHand.
        dealerDisplay := dealerHidden
            ifTrue: [ dealerHand first printString, ' [hidden]' ]
            ifFalse: [ dealerHand printString ].

        ('Dealer: ', dealerDisplay, ' -> ', dealerScore printString) printNl.

        playerScore := self calculateScore: playerHand.
        ('Player: ', playerHand printString , ' -> ', playerScore printString) printNl.
    !

    determineWinner: playerScore dealerScore: dealerScore
        "Determine the winner of the game"
        playerScore > dealerScore ifTrue: [
            ('Player wins!') printNl.
        ] ifFalse: [
            ('Dealer wins!') printNl.
        ].
        ^self.
    !

    playerTurn
        "Play the player's turn"
        | playerScore choice |
        playerScore := self calculateScore: playerHand.
        ('Player Score: ', playerScore printString) printNl.
        ('Hit or Stand? (h/s)') printNl.
        choice := FileStream stdin nextLine.
        choice = 'h' ifTrue: [
            playerHand add: self dealCard.
            ^false.
        ].
        choice = 's' ifTrue: [
            ^true.
        ].

        ^false.
    !

    play
        "Play the game"
        | playerScore dealerScore isStand|
        'Playing Blackjack...' displayNl.

        self printGameState: true.
        playerScore := self calculateScore: playerHand.
        isStand := false.

        "Play the player's turn"
        [ playerScore < 21 and: [isStand not] ] whileTrue: [
            isStand := self playerTurn.
            playerScore := self calculateScore: playerHand.
            self printGameState: true.
        ].

        "Print blackjack on 21"
        playerScore = 21 ifTrue: [
            ('Player Blackjack!') printNl.
        ].

        "if player score is over 21, player loses"
        playerScore > 21 ifTrue: [
            ('Player busts! Player Loses') printNl.
            ^self.
        ].

        "dealer turn"
        'Dealer Turn...' displayNl.
        dealerHand add: self dealCard.
        dealerScore := self calculateScore: dealerHand.
        self determineWinner: playerScore dealerScore: dealerScore.
        self printGameState: false.
        ^self.
    !
!

|game|
game := Blackjack new.
game play.
