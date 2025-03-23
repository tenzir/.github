# This Makefile adapts the content from this repo so that it can be directly
# included in https://github.com/tenzir/docs.
#
# See the corresponding GitHub Action workflow for invocation.

# Our working directory.
DIR := docs

# The full path directory of the content in tenzir/docs.
DOCS := $(DIR)/src/content/docs/guides/contribution

docs: files

destination:
	@test -d "$(DOCS)" || mkdir -p "$(DOCS)"

files: \
  destination \
  $(DOCS)/code-of-conduct.mdx \
  $(DOCS)/coding-style.mdx \
  $(DOCS)/security.mdx \
  $(DOCS)/workflow.mdx \
  $(DOCS)/git-branching-model.svg

$(DOCS)/code-of-conduct.mdx:
	@printf "processing $@\n"
	@printf -- "---\ntitle: Code of Conduct\n---\n\n" > $@
	@awk 'NR > 2' CODE-OF-CONDUCT.md >> $@

$(DOCS)/coding-style.mdx:
	@printf "processing $@\n"
	@printf -- "---\ntitle: Coding Style\n---\n\n" > $@
	@awk 'NR > 2' coding-style.md >> $@

$(DOCS)/security.mdx:
	@printf "processing $@\n"
	@printf -- "---\ntitle: Security Policy\n---\n\n" > $@
	@awk "NR > 2" SECURITY.md >> $@

$(DOCS)/workflow.mdx:
	@printf "processing $@\n"
	@printf -- "---\ntitle: Git and GitHub Workflow\n---\n\n" > $@
	@awk "NR > 2" workflow.md >> $@

$(DOCS)/git-branching-model.svg:
	@printf "processing $@\n"
	@cp git-branching-model.svg $@

clean:
	rm -rf $(DIR)
