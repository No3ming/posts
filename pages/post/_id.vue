<template>
  <div>
    <div v-if="err" v-html="err" />
    <div v-else>
      <h2 class="title">{{ post.title }}</h2>
      <v-chip small color="indigo" text-color="white">
        <v-avatar left>
          <v-icon>mdi-account-circle</v-icon>
        </v-avatar>
        {{ post.creator.username }}
      </v-chip>
      <v-chip small color="pink" label text-color="white">
        <v-icon left>mdi-label</v-icon>
        {{ post.tag.name }}
      </v-chip>
      <p class="des">
        {{ post.createdAt }} 字数 {{ len }} 阅读 {{ post.view }}
      </p>
      <div v-html="post.post" class="markdown-body" />
    </div>
  </div>
</template>

<script>
// import axios from 'axios'
import markdow from '@/utils/markdown'
import gql from 'graphql-tag'
import dayjs from 'dayjs'
export default {
  data() {
    return {
      post: {
        id: '',
        title: '',
        post: '',
        view: 0,
        tag: {
          id: '',
          name: ''
        },
        creator: {
          id: '',
          username: ''
        },
        createdAt: 0
      },
      len: 0,
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
          view,
          createdAt,
          tag {
            id,
            name
          },
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
      const len = post.post.length
      post.post = markdow(post.post)
      post.createdAt = dayjs(post.createdAt).format('YYYY.MM.DD hh:mm:ss')
      return { post, len }
    } catch (err) {
      return { err: err.message }
    }
  },
  methods: {}
}
</script>

<style scoped>
@import url('https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/github.min.css');
@import url('https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/2.9.0/github-markdown.min.css');
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
.title {
  font-size: 30px;
  font-weight: 700;
}
.post-content {
  padding-top: 20px;
}

.v-application code {
  box-shadow: none;
}
.des {
  color: #969696;
  font-size: 13px;
  line-height: 24px;
}
</style>
