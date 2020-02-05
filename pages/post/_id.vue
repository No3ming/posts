<template>
  <div>
    <div v-if="err" v-html="err" />
    <div v-else>
      <h2>{{ post.title }}</h2>
      <p>
        <span>from: </span><span>{{ post.creator.username }}</span>
      </p>
      <p v-if="post.tags.length">
        <span>tag: </span>
        <span v-for="item in post.tags" :key="item.id">{{ item.name }}</span>
      </p>
      <div v-html="post.post" />
    </div>
  </div>
</template>

<script>
// import axios from 'axios'
import markdow from '@/utils/markdown'
import gql from 'graphql-tag'
export default {
  data() {
    return {
      post: {
        id: '',
        title: '',
        post: '',
        tags: [],
        creator: {
          id: '',
          username: ''
        }
      },
      err: ''
    }
  },
  async asyncData(context) {
    const client = context.app.apolloProvider.defaultClient
    const { id } = context.params
    const query = gql`
      query {
        findOnePost(id: "${id}") {
          id
          title
          post,
          tags,
          creator {
            id,
            username
          }
        }
      }
    `
    try {
      const post = await client
        .query({ query, variables: {} })
        .then(({ data }) => {
          return data.findOnePost
        })
      return { post: { post: markdow(post.post), ...post } }
    } catch (err) {
      return { err: err.message }
    }
  },
  methods: {}
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
