<template>
  <div>
    <div v-html="article.article" />
  </div>
</template>

<script>
// import axios from 'axios'
// import markdow from '@/utils/markdown'
import gql from 'graphql-tag'
export default {
  data() {
    return {
      article: {
        id: '',
        title: '',
        article: ''
      }
    }
  },
  async asyncData(context) {
    const client = context.app.apolloProvider.defaultClient
    const query = gql`
      query {
        findOneArticle(id: "5e37c25d71fa3f8783b41e93") {
          id
          title
          article
        }
      }
    `
    const variables = {}
    // but you could also call queries like this:
    const article = await client
      .query({ query, variables })
      .then(({ data }) => {
        console.log(data)
        return data.findOneArticle
      })
      .catch((err) => {
        console.log(err, 'err')
      })
    return { article }
    // eslint-disable-next-line no-console
    // const { data } = await axios.get(`http://localhost:3000/README.md`)
    // return { detail: markdow(data) }
  },
  methods: {
    foo() {
      const query = gql`
        query {
          findOneArticle(id: "5e37c25d71fa3f8783b41e93") {
            id
          }
        }
      `
      const variables = ''
      // but you could also call queries like this:
      this.$apollo.query({ query, variables }).then(({ data }) => {
        console.log(data)
      })
      console.log(this.$apollo.query)
    }
  }
}
</script>

<style>
@import url('highlight.js/styles/monokai-sublime.css');
.container {
  padding: 10px;
  min-height: 100vh;
}
pre {
  width: 100%;
  display: block;
  background: #000;
  padding: 0.8em;
  color: #fff;
  overflow: hidden;
  overflow-x: auto;
  border-radius: 3px;
}
</style>
