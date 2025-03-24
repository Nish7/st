Object subclass: #Counter
    instanceVariableNames: 'count'
    classVariableNames: ''
    poolDictionaries: ''
    category: nil!

Counter class methodsFor: 'instance creation'!
    new
        | instance |
        instance := super new.
        instance intialize.
        ^instance!
!

Counter methodsFor: 'counter operations'!
    "Initialize the counter"
    intialize
        count := 0!
    increment
        count := count + 1!
    getCount
        ^count!
    printCount
        stdout print: count; nl!
!

| c count |
c := Counter new.
1 to: 10 do: [:i |
    c increment.
    c printCount.
].
