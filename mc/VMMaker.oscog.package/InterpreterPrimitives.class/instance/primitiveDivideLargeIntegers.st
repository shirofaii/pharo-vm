arithmetic largeint primitives
primitiveDivideLargeIntegers
	"Primitive arithmetic operations for large integers in 64 bit range"
	| a b result oopResult aIsNegative bIsNegative oopArg oopRcvr |
	<export: true>
	<var: 'a' type: 'usqLong'>
	<var: 'b' type: 'usqLong'>
	<var: 'result' type: 'usqLong'>

	oopArg := self stackValue: 0.
	oopRcvr := self stackValue: 1.
	aIsNegative := self isNegativeIntegerValueOf: oopRcvr.
	bIsNegative := self isNegativeIntegerValueOf: oopArg.
	a := self magnitude64BitValueOf: oopRcvr.
	b := self magnitude64BitValueOf: oopArg.
	self successful ifFalse:[^nil].
	
	"check for exact division"
	(b ~= 0 and:[a \\ b = 0]) ifFalse:[self primitiveFail. ^nil].

	result := a // b.
	oopResult := self magnitude64BitIntegerFor: result neg: aIsNegative ~= bIsNegative.

	self successful ifTrue:[self pop: 2 thenPush: oopResult].
