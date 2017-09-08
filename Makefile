AG = ./ag
SRC = ./src
SRCDERIVED = ./src-derived
OUT = ./out

all: uuagc
	ghc --make $(SRC)/Main.hs -i$(SRC):$(SRCDERIVED) -outputdir $(OUT) -o pxml

uuagc:
	uuagc -dm $(AG)/NTree.ag -P $(AG)
	uuagc -scf $(AG)/FormatTree.ag -P $(AG)
	mv $(AG)/*.hs $(SRCDERIVED)


