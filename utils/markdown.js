import marked from 'marked'
import hljs from 'highlight.js'

const markdown = () => {
  marked.setOptions({
    renderer: new marked.Renderer(),
    highlight: (code) => {
      return hljs.highlightAuto(code).value
    },
    pedantic: false,
    gfm: true,
    breaks: false,
    sanitize: false,
    smartLists: true,
    smartypants: false,
    xhtml: false
  })
  return marked
}

export default markdown()
