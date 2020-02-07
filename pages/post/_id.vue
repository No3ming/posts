<template>
  <div>
    <h2 class="title">{{ post.title }}</h2>
    <v-chip :key="1" small color="indigo" text-color="white">
      <v-avatar left>
        <v-icon>mdi-account-circle</v-icon>
      </v-avatar>
      <span>{{ post.creator.username }}</span>
    </v-chip>
    <v-chip small color="pink" label text-color="white">
      <v-icon left>mdi-label</v-icon>
      <span>{{ post.tag.name }}</span>
    </v-chip>
    <p class="des">{{ post.createdAt }} 字数 {{ len }} 阅读 {{ post.view }}</p>
    <div v-html="post.post" class="markdown-body" />
  </div>
</template>

<script>
// import axios from 'axios'
import markdow from '@/utils/markdown'
import gql from 'graphql-tag'
import dayjs from 'dayjs'
import '~/assets/github.min.css'
import '~/assets/github-markdown.min.css'
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
      len: 0
    }
  },
  async asyncData(context) {
    const client = context.app.apolloProvider.defaultClient
    const { id } = context.params
    const query = gql`
      query {
        findOnePost(id: "${id}") {
          id,
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
      context.error(err)
    }
  },
  methods: {}
}
</script>

<style lang="scss">
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
