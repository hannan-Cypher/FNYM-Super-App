<template>
  <farm-main>
    <app-bar-options :title="$t('Home')"/>
    <home-widgets :modules="modules"/>
    <farm-modules-explorer/>
  </farm-main>
</template>

<script>
import fieldModules from '../field-modules';
import HomeWidgets from './HomeWidgets';
import FarmModulesExplorer from './FarmModulesExplorer.vue';

export default {
  name: 'HomeScreen',
  components: { HomeWidgets, FarmModulesExplorer },
  data() {
    return {
      modules: fieldModules,
    };
  },
};
</script>
