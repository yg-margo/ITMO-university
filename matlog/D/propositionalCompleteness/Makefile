GHC = ghc
ALEX = Tokens.x
HAPPY = Grammar.y
SOURCES = Main.hs Expression.hs CounterExample.hs Proof.hs Proving.hs ProofList.hs
GENERATED = Tokens.hs Grammar.hs
OUTNAME = propositionalCompleteness

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
	$(GHC) -O2 Main.hs -o $(OUTNAME)
	$(clean)

$(GENERATED): $(ALEX) $(HAPPY) $(SOURCES)
	alex $(ALEX)
	happy $(HAPPY)
