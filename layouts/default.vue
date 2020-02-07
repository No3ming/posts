<template>
  <v-app id="inspire">
    <v-navigation-drawer v-model="drawer" fixed app>
      <v-list dense no-action>
        <v-list-item :nuxt="true" to="/" no-action>
          首页
        </v-list-item>
        <v-list-group
          v-for="item in lists"
          :key="item.id"
          v-model="item.active"
          @click="navClick(item)"
          no-action
        >
          <template v-slot:activator>
            <v-list-item-content>
              <v-list-item-title v-text="item.name"></v-list-item-title>
            </v-list-item-content>
          </template>

          <v-list-item
            v-for="subItem in item.items"
            :key="subItem.title"
            :nuxt="true"
            :to="`/post/${subItem.id}`"
            no-action
          >
            <v-list-item-content>
              <v-list-item-title v-text="subItem.title"></v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list-group>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar fixed app dark color="indigo">
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
      <!-- <v-toolbar-title v-text="title" /> -->
    </v-app-bar>
    <v-content style="padding: 56px 0px 0px;">
      <v-container>
        <nuxt />
      </v-container>
    </v-content>
  </v-app>
</template>

<script>
import gql from 'graphql-tag'

export default {
  data() {
    return {
      drawer: false,
      clipped: true,
      miniVariant: false,
      lists: [],
      title: '我的资料'
    }
  },
  created() {
    this.getTags()
  },
  methods: {
    navClick(item) {
      if (!item.active && !item.items.length) {
        this.getPost(item)
      }
    },
    async getPost(item) {
      const query = gql`
        query {
          findPosts(input: { title: "", tag: "${item.id}", limit: 10000, offset: 0 }) {
            list {
              id
              title
            }
            total
          }
        }
      `
      try {
        const lists = await this.$apollo
          .query({ query, variables: {} })
          .then(({ data }) => {
            return data.findPosts
          })
        item.items = lists.list
      } catch (err) {}
    },
    async getTags() {
      const query = gql`
        query {
          findTags(input: { name: "", limit: 100, offset: 0 }) {
            list {
              id
              name
            }
            total
          }
        }
      `
      try {
        const lists = await this.$apollo
          .query({ query, variables: {} })
          .then(({ data }) => {
            data.findTags.list = data.findTags.list.map((v) => ({
              items: [],
              ...v
            }))
            return data.findTags
          })
        this.lists = lists.list
      } catch (err) {}
    }
  }
}
</script>
<style>
.v-content__wrap {
  background: #f5f5f5;
}
.container {
  padding: 20px;
  min-height: 100vh;
  background: #fff;
}
</style>
