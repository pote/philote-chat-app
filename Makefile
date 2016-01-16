GEM_DEPS := $(GEM_HOME)/.installed

.PHONY: all
all: $(GEM_DEPS) $(ASSETS) test

.PHONY: test
test: $(GEM_DEPS) $(GEM_HOME)/.test.installed | tmp
	script/test

.PHONY: console
console: $(GEM_DEPS)
	irb -r ./init

.PHONY: server
server: $(GEM_DEPS) | tmp
	shotgun --server=puma --port="$(PORT)" config.ru

$(GEM_DEPS): $(GEM_HOME) .gems .gems.dev
	cat .gems{,.dev} | xargs gem install --no-ri --no-rdoc && touch $@

$(GEM_HOME)/.test.installed: .gems.test
	cat .gems.test | xargs gem install --no-ri --no-rdoc && touch $@

##
# Directories
##

$(GEM_HOME) tmp:
	mkdir -p $@
