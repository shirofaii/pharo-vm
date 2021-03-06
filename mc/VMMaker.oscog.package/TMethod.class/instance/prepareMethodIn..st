transformations
prepareMethodIn: aCodeGen
	"Record sends of builtin operators, map sends of the special selector dispatchOn:in:
	 with case statement nodes, and map sends of caseOf:[otherwise:] to switch statements.
	 Declare limit variables for to:[by:]do: loops with limits that potentially have side-effects.
	 As a hack also update the types of variables introduced to implement cascades correctly.
	 This has to be done at the same time as this is done, so why not piggy back here?"
	extraVariableNumber ifNotNil:
		[declarations keysAndValuesDo:
			[:varName :decl|
			decl isBlock ifTrue:
				[self assert: ((varName beginsWith: 'cascade') and: [varName last isDigit]).
				 locals add: varName.
				 self declarationAt: varName
					put: (decl value: self value: aCodeGen), ' ', varName]]].
	aCodeGen
		pushScope: declarations
		while:"N.B.  nodesWithParentsDo: is bottom-up, hence replacement is destructive and conserved."
			[parseTree nodesWithParentsDo:
				[:node :parent|
				 node isSend ifTrue:
					[(aCodeGen isBuiltinSelector: node selector)
						ifTrue:
							[node isBuiltinOperator: true.
							"If a to:by:do:'s limit has side-effects, declare the limit variable, otherwise delete it from the args"
							 node selector = #to:by:do: ifTrue:
								[self ensureToByDoLoopLimitIsSafeAndEfficient: node in: aCodeGen]]
						ifFalse:
							[(CaseStatements includes: node selector) ifTrue:
								[parent replaceNodesIn: (Dictionary newFromPairs: { node. self buildCaseStmt: node in: aCodeGen})].
							 (#(caseOf: #caseOf:otherwise:) includes: node selector) ifTrue:
								[parent replaceNodesIn: (Dictionary newFromPairs: { node. self buildSwitchStmt: node parent: parent })]]]]]