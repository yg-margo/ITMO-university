GHC = ghc
ALEX = Tokens.x
HAPPY = Grammar.y
SOURCES = Main.hs Expression.hs Axiom.hs Proof.hs ModusPonens.hs Deduction.hs Hypothesis.hs
GENERATED = Tokens.hs Grammar.hs
OUTNAME = formalMetalanguage

all: $(OUTNAME)

run:
	./$(OUTNAME)

pack: $(GENERATED)
	zip $(OUTNAME).zip $(SOURCES) $(ALEX) $(HAPPY) Makefile

clean:
	rm *.o
	rm *.hi
	rm $(GENERATED)

$(OUTNAME): $(GENERATED) $(SOURCES)
	$(GHC) Main.hs -o $(OUTNAME)
	$(clean)

$(GENERATED): $(ALEX) $(HAPPY) $(SOURCES)
	alex $(ALEX)
	happy $(HAPPY)
