<template>
  <v-app dark>
    <v-navigation-drawer v-model="drawer" :mini-variant="miniVariant" fixed app>
      <v-list>
        <v-list-group
          v-for="item in lists"
          :key="item.id"
          v-model="item.active"
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
            @click="itemClick(subItem)"
            :to="subItem.to"
            no-action
          >
            <v-list-item-content>
              <v-list-item-title v-text="subItem.title"></v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list-group>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar :clipped-left="clipped" fixed app>
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
      <!-- <v-toolbar-title v-text="title" /> -->
    </v-app-bar>
    <v-content>
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
  async created() {
    const query = gql`
      query {
        findTags(input: { name: "", limit: 100, offset: 0 }) {
          id
          name
        }
      }
    `
    try {
      const lists = await this.$apollo
        .query({ query, variables: {} })
        .then(({ data }) => {
          return data.findTags
        })
      this.lists = lists
    } catch (err) {}
  }
}
</script>
