tests
testMoveRAw
	"self new testMoveRAw"
	self concreteCompilerClass registersWithNamesDo:
		[:reg :regname|
		#(16r555555 16rAAAAAA) do:
			[:addr| | inst len |
			inst := self gen: MoveRAw operand: reg operand: addr.
			len := inst concretizeAt: 0.
			self processor
				disassembleInstructionAt: 0
				In: inst machineCode object
				into: [:str :sz| | plainJane herIntended |
					plainJane := self strip: str.
					herIntended := 'movl ', regname, ', 0x', (addr hex allButFirst: 3).
					self assert: (plainJane match: herIntended).
					self assert: len = sz]]]