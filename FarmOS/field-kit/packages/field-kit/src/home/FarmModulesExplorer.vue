<template>
  <div class="farm-modules-explorer">
    <!-- Header Section -->
    <div class="explorer-header">
      <div class="header-top">
        <div class="header-titles">
          <h2 class="title">{{ $t('farmOS Modules & Workflows') }}</h2>
          <p class="subtitle">
            {{ $t('Explore all available farmOS modules, understand their capabilities, and launch actions directly.') }}
          </p>
        </div>
        <div class="stats-badge">
          <span class="stats-num">{{ filteredModules.length }}</span>
          <span class="stats-label">{{ $t('Modules') }}</span>
        </div>
      </div>

      <!-- Controls: Search and Filters -->
      <div class="controls-bar">
        <div class="search-box">
          <input
            v-model="searchQuery"
            type="text"
            class="form-control search-input"
            :placeholder="$t('Search modules (e.g. planting, animal, map, harvest)...')"
          />
          <button v-if="searchQuery" class="clear-btn" @click="searchQuery = ''">✕</button>
        </div>

        <div class="category-tabs">
          <button
            v-for="cat in categories"
            :key="cat.id"
            :class="['category-tab', { active: selectedCategory === cat.id }]"
            @click="selectedCategory = cat.id"
          >
            {{ cat.label }}
            <span class="cat-count">{{ getCountForCategory(cat.id) }}</span>
          </button>
        </div>
      </div>
    </div>

    <!-- Modules Grid -->
    <div class="modules-grid">
      <div
        v-for="mod in filteredModules"
        :key="mod.id"
        class="module-card"
        :class="mod.category"
      >
        <div class="card-header">
          <div class="badge-row">
            <span :class="['type-badge', mod.category]">{{ mod.categoryLabel }}</span>
            <span v-if="mod.isPwaReady" class="pwa-badge">📱 Field Kit</span>
            <span v-if="mod.isCore" class="core-badge">Active</span>
          </div>
          <h3 class="card-title">{{ mod.name }}</h3>
        </div>

        <p class="card-description">{{ mod.description }}</p>

        <!-- Capabilities list -->
        <div class="capabilities-section">
          <h5 class="section-heading">{{ $t('What you can do:') }}</h5>
          <ul class="capability-list">
            <li v-for="(cap, i) in mod.capabilities" :key="i">
              <span class="check-bullet">✓</span> {{ cap }}
            </li>
          </ul>
        </div>

        <!-- Action Buttons -->
        <div class="card-actions">
          <!-- Direct PWA route if available -->
          <router-link
            v-if="mod.pwaRoute"
            :to="mod.pwaRoute"
            class="btn btn-primary action-btn"
          >
            {{ mod.pwaActionText || $t('Open in Field Kit') }}
          </router-link>

          <!-- Primary Backend Action -->
          <a
            v-if="mod.backendPrimaryUrl"
            :href="mod.backendPrimaryUrl"
            target="_blank"
            rel="noopener noreferrer"
            class="btn btn-outline-success action-btn"
          >
            {{ mod.backendPrimaryText }} ↗
          </a>

          <!-- Secondary Backend Action (View list, etc.) -->
          <a
            v-if="mod.backendSecondaryUrl"
            :href="mod.backendSecondaryUrl"
            target="_blank"
            rel="noopener noreferrer"
            class="btn btn-outline-secondary action-btn-secondary"
          >
            {{ mod.backendSecondaryText }} ↗
          </a>
        </div>
      </div>
    </div>

    <!-- Empty state if search finds nothing -->
    <div v-if="filteredModules.length === 0" class="empty-results">
      <h4>{{ $t('No matching modules found') }}</h4>
      <p>{{ $t('Try adjusting your search query or selecting a different category.') }}</p>
      <button class="btn btn-primary" @click="resetFilters">{{ $t('Show All Modules') }}</button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'FarmModulesExplorer',
  data() {
    return {
      searchQuery: '',
      selectedCategory: 'all',
      backendBase: 'http://localhost:8000',
      categories: [
        { id: 'all', label: 'All Modules' },
        { id: 'quick', label: 'Quick Forms' },
        { id: 'asset', label: 'Assets' },
        { id: 'log', label: 'Logs & Records' },
        { id: 'system', label: 'Maps & Systems' },
      ],
      modules: [
        // ================= QUICK FORMS =================
        {
          id: 'quick-planting',
          name: 'Planting Quick Form',
          category: 'quick',
          categoryLabel: 'Quick Form',
          isPwaReady: false,
          isCore: true,
          description: 'Single-step form to record a new crop planting with seeding date, variety, bed location, and harvest target.',
          capabilities: [
            'Create a plant asset and associate it with a field or greenhouse bed',
            'Optionally generate seeding, transplanting, and harvest logs simultaneously',
            'Specify crop variety, seed lots, and expected yield dates',
          ],
          backendPrimaryUrl: 'http://localhost:8000/quick/planting',
          backendPrimaryText: 'Start Planting Form',
        },
        {
          id: 'quick-movement',
          name: 'Movement Quick Form',
          category: 'quick',
          categoryLabel: 'Quick Form',
          isPwaReady: false,
          isCore: true,
          description: 'Move herds, machinery, or crops to new pastures, paddocks, or barns with map geometry tracking.',
          capabilities: [
            'Select one or multiple assets or animal herds',
            'Pick new location or draw GPS boundary directly on the map',
            'Maintains automated location history across the farm',
          ],
          backendPrimaryUrl: 'http://localhost:8000/quick/movement',
          backendPrimaryText: 'Record Movement',
        },
        {
          id: 'quick-birth',
          name: 'Birth Quick Form',
          category: 'quick',
          categoryLabel: 'Quick Form',
          isPwaReady: false,
          isCore: true,
          description: 'Record animal births, generate new offspring records, assign dam/sire lineages, and tag newborn livestock.',
          capabilities: [
            'Record birth of single or multiple offspring (lambs, calves, piglets, chicks)',
            'Automatically links mother (dam) and father (sire) animal assets',
            'Generates animal assets and birth observation logs simultaneously',
          ],
          backendPrimaryUrl: 'http://localhost:8000/quick/birth',
          backendPrimaryText: 'Record Birth',
        },
        {
          id: 'quick-group',
          name: 'Group Membership Form',
          category: 'quick',
          categoryLabel: 'Quick Form',
          isPwaReady: false,
          isCore: true,
          description: 'Quickly organize animals or crop batches into managed groups for grazing rotations and batch processing.',
          capabilities: [
            'Assign individual animals to herds or breeding groups',
            'Batch add or remove members with date timestamps',
            'Track group composition over time for herd management',
          ],
          backendPrimaryUrl: 'http://localhost:8000/quick/group',
          backendPrimaryText: 'Manage Groups',
        },
        {
          id: 'quick-inventory',
          name: 'Inventory Quick Form',
          category: 'quick',
          categoryLabel: 'Quick Form',
          isPwaReady: false,
          isCore: true,
          description: 'Rapidly adjust stock levels (count, weight, volume) for harvested produce, seeds, fertilizers, and supplies.',
          capabilities: [
            'Increment, decrement, or set exact inventory quantities',
            'Record lot numbers, storage locations, and adjustment reasons',
            'Maintains real-time stock balances across farm storage units',
          ],
          backendPrimaryUrl: 'http://localhost:8000/quick/inventory',
          backendPrimaryText: 'Adjust Inventory',
        },

        // ================= ASSETS =================
        {
          id: 'asset-plant',
          name: 'Plant Assets',
          category: 'asset',
          categoryLabel: 'Asset',
          isPwaReady: true,
          isCore: true,
          description: 'Track annual and perennial crops, cover crops, orchard trees, pasture grasses, and botanical varieties.',
          capabilities: [
            'Map crop plantings to specific beds, fields, or high tunnels',
            'Record seed source, maturity dates, and planting seasons',
            'Link input, harvest, and observation logs to individual plantings',
          ],
          backendPrimaryUrl: 'http://localhost:8000/asset/add/plant',
          backendPrimaryText: 'Add Plant',
          backendSecondaryUrl: 'http://localhost:8000/assets/plant',
          backendSecondaryText: 'View Plants',
        },
        {
          id: 'asset-animal',
          name: 'Animal Assets',
          category: 'asset',
          categoryLabel: 'Asset',
          isPwaReady: true,
          isCore: true,
          description: 'Manage livestock herds, flocks, and individual animals with ear tags, breeds, birthdates, and pedigree.',
          capabilities: [
            'Track individual ID tags, electronic RFID, and tattoo numbers',
            'Record pedigree, parents, castrate status, and sex',
            'Monitor medical records, weights, and paddock movement history',
          ],
          backendPrimaryUrl: 'http://localhost:8000/asset/add/animal',
          backendPrimaryText: 'Add Animal',
          backendSecondaryUrl: 'http://localhost:8000/assets/animal',
          backendSecondaryText: 'View Animals',
        },
        {
          id: 'asset-land',
          name: 'Land & Fields',
          category: 'asset',
          categoryLabel: 'Asset',
          isPwaReady: true,
          isCore: true,
          description: 'Map farm fields, paddocks, beds, watercourses, and property boundaries with precision GIS polygons.',
          capabilities: [
            'Define acreage, soil types, and land use (crop, pasture, woodland)',
            'Draw spatial boundaries directly with GPS coordinates or KML import',
            'Nest permanent beds and strips within larger parent fields',
          ],
          backendPrimaryUrl: 'http://localhost:8000/asset/add/land',
          backendPrimaryText: 'Add Land Area',
          backendSecondaryUrl: 'http://localhost:8000/assets/land',
          backendSecondaryText: 'View Land Areas',
        },
        {
          id: 'asset-equipment',
          name: 'Equipment & Machinery',
          category: 'asset',
          categoryLabel: 'Asset',
          isPwaReady: true,
          isCore: true,
          description: 'Maintain tractors, implements, pumps, vehicles, and tools with maintenance schedules and runtime logs.',
          capabilities: [
            'Store manufacturer, model, serial number, and purchase details',
            'Log scheduled servicing, oil changes, parts replacements, and repairs',
            'Assign equipment to field operations for cost and hour tracking',
          ],
          backendPrimaryUrl: 'http://localhost:8000/asset/add/equipment',
          backendPrimaryText: 'Add Equipment',
          backendSecondaryUrl: 'http://localhost:8000/assets/equipment',
          backendSecondaryText: 'View Equipment',
        },
        {
          id: 'asset-structure',
          name: 'Structures & Facilities',
          category: 'asset',
          categoryLabel: 'Asset',
          isPwaReady: true,
          isCore: true,
          description: 'Track barns, greenhouses, sheds, walk-in coolers, compost bays, and perimeter fences.',
          capabilities: [
            'Map physical building footprints and storage capacity',
            'Assign equipment, animals, and harvest lots to structures',
            'Schedule facility sanitation and maintenance inspections',
          ],
          backendPrimaryUrl: 'http://localhost:8000/asset/add/structure',
          backendPrimaryText: 'Add Structure',
          backendSecondaryUrl: 'http://localhost:8000/assets/structure',
          backendSecondaryText: 'View Structures',
        },
        {
          id: 'asset-sensor',
          name: 'Sensors & IoT Devices',
          category: 'asset',
          categoryLabel: 'Asset',
          isPwaReady: true,
          isCore: true,
          description: 'Connect IoT environmental monitors, soil moisture probes, automated weather stations, and telemetry units.',
          capabilities: [
            'Receive live JSON/API data streams from on-farm hardware',
            'Plot temperature, humidity, rainfall, and soil moisture over time',
            'Deploy sensors across fields, high tunnels, and storage coolers',
          ],
          backendPrimaryUrl: 'http://localhost:8000/asset/add/sensor',
          backendPrimaryText: 'Add Sensor',
          backendSecondaryUrl: 'http://localhost:8000/assets/sensor',
          backendSecondaryText: 'View Sensors',
        },
        {
          id: 'asset-water',
          name: 'Water Resources',
          category: 'asset',
          categoryLabel: 'Asset',
          isPwaReady: true,
          isCore: true,
          description: 'Track irrigation ponds, groundwater wells, cisterns, mainline valves, and water filtration setups.',
          capabilities: [
            'Monitor static water levels, flow capacity, and seasonal reserves',
            'Log irrigation runs and test water quality with lab test logs',
            'Map piping distribution and water meter locations',
          ],
          backendPrimaryUrl: 'http://localhost:8000/asset/add/water',
          backendPrimaryText: 'Add Water Asset',
          backendSecondaryUrl: 'http://localhost:8000/assets/water',
          backendSecondaryText: 'View Water Assets',
        },
        {
          id: 'asset-group',
          name: 'Groups & Batches',
          category: 'asset',
          categoryLabel: 'Asset',
          isPwaReady: true,
          isCore: true,
          description: 'Manage collections of assets that move or are treated together (e.g. Broiler Flock #2, 2026 Spring Heifers).',
          capabilities: [
            'Log activities or feed inputs for an entire group with one record',
            'Move entire groups between pastures seamlessly',
            'Track group membership history and split or merge batches',
          ],
          backendPrimaryUrl: 'http://localhost:8000/asset/add/group',
          backendPrimaryText: 'Add Group',
          backendSecondaryUrl: 'http://localhost:8000/assets/group',
          backendSecondaryText: 'View Groups',
        },

        // ================= LOGS =================
        {
          id: 'log-tasks',
          name: 'Tasks & Field Kit PWA',
          category: 'log',
          categoryLabel: 'Field Kit App',
          isPwaReady: true,
          isCore: true,
          description: 'Worker task assignments, daily to-do checklists, and field operations with full offline sync capability.',
          capabilities: [
            'Work offline in the field without internet and sync when reconnected',
            'View upcoming, late, and completed tasks assigned to you',
            'Quickly create Activity, Observation, Harvest, and Input logs from mobile',
          ],
          pwaRoute: '/tasks',
          pwaActionText: 'Open Tasks App',
          backendPrimaryUrl: 'http://localhost:8000/logs/activity',
          backendPrimaryText: 'View in Backend',
        },
        {
          id: 'log-harvest',
          name: 'Harvest Logs',
          category: 'log',
          categoryLabel: 'Log Record',
          isPwaReady: true,
          isCore: true,
          description: 'Record crop and produce yields, harvested weights, box counts, produce grades, and field lot origins.',
          capabilities: [
            'Quantify yield (lbs, kg, bushels, crates, bundles)',
            'Link harvest directly to specific crop plantings and field beds',
            'Automatically updates crop inventory balance for sales and delivery',
          ],
          backendPrimaryUrl: 'http://localhost:8000/log/add/harvest',
          backendPrimaryText: 'Record Harvest',
          backendSecondaryUrl: 'http://localhost:8000/logs/harvest',
          backendSecondaryText: 'View Harvests',
        },
        {
          id: 'log-activity',
          name: 'Activity Logs',
          category: 'log',
          categoryLabel: 'Log Record',
          isPwaReady: true,
          isCore: true,
          description: 'Document general farm operations, bed preparation, cultivating, mowing, weeding, and maintenance work.',
          capabilities: [
            'Assign workers, recording hours and machinery used',
            'Select target fields, plant varieties, or animal groups',
            'Set status as Pending for to-do items or Done when finished',
          ],
          backendPrimaryUrl: 'http://localhost:8000/log/add/activity',
          backendPrimaryText: 'Record Activity',
          backendSecondaryUrl: 'http://localhost:8000/logs/activity',
          backendSecondaryText: 'View Activities',
        },
        {
          id: 'log-observation',
          name: 'Observation Logs',
          category: 'log',
          categoryLabel: 'Log Record',
          isPwaReady: true,
          isCore: true,
          description: 'Field scouting, disease monitoring, weed pressure, insect sightings, bloom stages, and weather notes.',
          capabilities: [
            'Attach high-resolution scouting photos directly from your phone',
            'Pin exact GPS observation coordinates on the field map',
            'Categorize findings for seasonal pest and disease recurrence analysis',
          ],
          backendPrimaryUrl: 'http://localhost:8000/log/add/observation',
          backendPrimaryText: 'Record Observation',
          backendSecondaryUrl: 'http://localhost:8000/logs/observation',
          backendSecondaryText: 'View Observations',
        },
        {
          id: 'log-input',
          name: 'Input Logs',
          category: 'log',
          categoryLabel: 'Log Record',
          isPwaReady: true,
          isCore: true,
          description: 'Track all farm inputs: organic fertilizers, compost applications, lime, amendments, and crop protectants.',
          capabilities: [
            'Log application rates, dilution ratios, and total quantities used',
            'Essential for organic certification and GAP compliance audits',
            'Automatically decrements supply inventory of fertilizers and amendments',
          ],
          backendPrimaryUrl: 'http://localhost:8000/log/add/input',
          backendPrimaryText: 'Record Input',
          backendSecondaryUrl: 'http://localhost:8000/logs/input',
          backendSecondaryText: 'View Inputs',
        },
        {
          id: 'log-seeding',
          name: 'Seeding Logs',
          category: 'log',
          categoryLabel: 'Log Record',
          isPwaReady: true,
          isCore: true,
          description: 'Track direct field seed drilling, precision tray seeding, seed packet lots, and germination rates.',
          capabilities: [
            'Record seed rate (seeds/ft, lbs/acre, trays started)',
            'Specify seed batch lot number and supplier for traceability',
            'Connect with planting quick forms to automatically track crop emergence',
          ],
          backendPrimaryUrl: 'http://localhost:8000/log/add/seeding',
          backendPrimaryText: 'Record Seeding',
          backendSecondaryUrl: 'http://localhost:8000/logs/seeding',
          backendSecondaryText: 'View Seedings',
        },
        {
          id: 'log-transplanting',
          name: 'Transplanting Logs',
          category: 'log',
          categoryLabel: 'Log Record',
          isPwaReady: true,
          isCore: true,
          description: 'Record moving seedlings from propagation trays and greenhouses out into outdoor fields or high tunnels.',
          capabilities: [
            'Record plant spacing, bed feet, and count of transplanted starts',
            'Link tray seeding origin to final outdoor harvest bed',
            'Track survivability and days-to-maturity from transplant date',
          ],
          backendPrimaryUrl: 'http://localhost:8000/log/add/transplanting',
          backendPrimaryText: 'Record Transplant',
          backendSecondaryUrl: 'http://localhost:8000/logs/transplanting',
          backendSecondaryText: 'View Transplants',
        },
        {
          id: 'log-maintenance',
          name: 'Maintenance Logs',
          category: 'log',
          categoryLabel: 'Log Record',
          isPwaReady: true,
          isCore: true,
          description: 'Log repairs, periodic engine servicing, oil changes, blade sharpening, and infrastructure upkeep.',
          capabilities: [
            'Keep full preventative maintenance logs for tractors and implements',
            'Record parts replaced, hours on machine, and service costs',
            'Schedule recurring maintenance reminders for farm equipment',
          ],
          backendPrimaryUrl: 'http://localhost:8000/log/add/maintenance',
          backendPrimaryText: 'Record Maintenance',
          backendSecondaryUrl: 'http://localhost:8000/logs/maintenance',
          backendSecondaryText: 'View Maintenance',
        },
        {
          id: 'log-medical',
          name: 'Medical & Health Logs',
          category: 'log',
          categoryLabel: 'Log Record',
          isPwaReady: true,
          isCore: true,
          description: 'Track livestock health checks, veterinary treatments, vaccinations, dosages, and withdrawal periods.',
          capabilities: [
            'Record medication name, dosage, route (subcutaneous, oral, topical)',
            'Automatic withdrawal period calculation before milk/meat harvest',
            'Essential for livestock quality assurance and herd health protocols',
          ],
          backendPrimaryUrl: 'http://localhost:8000/log/add/medical',
          backendPrimaryText: 'Record Medical Log',
          backendSecondaryUrl: 'http://localhost:8000/logs/medical',
          backendSecondaryText: 'View Medical Logs',
        },
        {
          id: 'log-lab-test',
          name: 'Lab Test Logs',
          category: 'log',
          categoryLabel: 'Log Record',
          isPwaReady: true,
          isCore: true,
          description: 'Record lab assays for soil fertility (N-P-K, pH, organic matter), water chemistry, and plant tissue tests.',
          capabilities: [
            'Store soil sample test reports, nutrient levels, and recommendations',
            'Track water safety, coliform tests, and dissolved solids',
            'Attach lab PDF reports directly to farm location records',
          ],
          backendPrimaryUrl: 'http://localhost:8000/log/add/lab_test',
          backendPrimaryText: 'Record Lab Test',
          backendSecondaryUrl: 'http://localhost:8000/logs/lab_test',
          backendSecondaryText: 'View Lab Tests',
        },

        // ================= SYSTEMS & OPERATIONS =================
        {
          id: 'system-map',
          name: 'Interactive GIS Farm Map',
          category: 'system',
          categoryLabel: 'GIS System',
          isPwaReady: true,
          isCore: true,
          description: 'Full satellite and topographic mapping interface showing all fields, beds, paddocks, and asset locations.',
          capabilities: [
            'Draw GPS polygon boundaries with high precision on aerial maps',
            'Toggle layers: active crops, grazing herds, sensor locations, water lines',
            'Measure area (acres, hectares, sq ft) and perimeter lengths directly',
          ],
          backendPrimaryUrl: 'http://localhost:8000/farm/map',
          backendPrimaryText: 'Open Farm Map',
        },
        {
          id: 'system-timeline',
          name: 'Farm Activity Timeline',
          category: 'system',
          categoryLabel: 'System',
          isPwaReady: false,
          isCore: true,
          description: 'Visual chronological progression of farm events, past logs, crop cycles, and upcoming operational tasks.',
          capabilities: [
            'Visualize the whole season on an interactive time axis',
            'Zoom between days, weeks, months, and full multi-year histories',
            'Filter timeline by crop variety, field location, or worker',
          ],
          backendPrimaryUrl: 'http://localhost:8000/farm/timeline',
          backendPrimaryText: 'View Timeline',
        },
        {
          id: 'system-inventory',
          name: 'Inventory & Stock Tracking',
          category: 'system',
          categoryLabel: 'System',
          isPwaReady: true,
          isCore: true,
          description: 'Real-time inventory levels, unit conversions, and storage location tracking across all farm commodities.',
          capabilities: [
            'View on-hand quantities for harvested produce, seeds, and inputs',
            'Automated inventory adjustments whenever harvest or input logs are saved',
            'Traceability from field harvest lot to customer delivery',
          ],
          backendPrimaryUrl: 'http://localhost:8000/farm/inventory',
          backendPrimaryText: 'View Inventory',
        },
        {
          id: 'system-reports',
          name: 'Reports & Production Metrics',
          category: 'system',
          categoryLabel: 'System',
          isPwaReady: false,
          isCore: true,
          description: 'Aggregated analytics, total yield summaries, input application audits, and exportable regulatory spreadsheets.',
          capabilities: [
            'Generate yield per bed-foot or bushel per acre analytics',
            'Audit organic input applications for certification inspectors',
            'Export full data sets via CSV, JSON:API, or KML formats',
          ],
          backendPrimaryUrl: 'http://localhost:8000/farm/reports',
          backendPrimaryText: 'View Reports',
        },
        {
          id: 'system-plan',
          name: 'Farm Management Plans',
          category: 'system',
          categoryLabel: 'System',
          isPwaReady: false,
          isCore: true,
          description: 'Long-term planning tools for rotational grazing, multi-year crop rotations, and conservation projects.',
          capabilities: [
            'Design rotational grazing moves to prevent pasture overgrazing',
            'Plan 4-year crop rotations to break disease cycles and balance soil nutrients',
            'Group related logs, assets, and milestones under unified farm plans',
          ],
          backendPrimaryUrl: 'http://localhost:8000/plans',
          backendPrimaryText: 'View Plans',
        },
      ],
    };
  },
  computed: {
    filteredModules() {
      let result = this.modules;
      if (this.selectedCategory !== 'all') {
        result = result.filter(m => m.category === this.selectedCategory);
      }
      if (this.searchQuery.trim()) {
        const q = this.searchQuery.toLowerCase().trim();
        result = result.filter(m =>
          m.name.toLowerCase().includes(q)
          || m.description.toLowerCase().includes(q)
          || m.categoryLabel.toLowerCase().includes(q)
          || m.capabilities.some(c => c.toLowerCase().includes(q)),
        );
      }
      return result;
    },
  },
  methods: {
    getCountForCategory(catId) {
      if (catId === 'all') return this.modules.length;
      return this.modules.filter(m => m.category === catId).length;
    },
    resetFilters() {
      this.selectedCategory = 'all';
      this.searchQuery = '';
    },
  },
};
</script>

<style scoped>
.farm-modules-explorer {
  margin-top: 1.5rem;
  padding-bottom: 3rem;
}

.explorer-header {
  background: white;
  border-radius: 12px;
  padding: 1.25rem 1.5rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  margin-bottom: 1.5rem;
  border: 1px solid var(--light);
}

.header-top {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  flex-wrap: wrap;
  gap: 1rem;
  margin-bottom: 1.25rem;
}

.header-titles .title {
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--dark);
  margin: 0 0 0.35rem 0;
}

.header-titles .subtitle {
  color: var(--text);
  font-size: 0.95rem;
  margin: 0;
  max-width: 650px;
}

.stats-badge {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: var(--alfalfa-light);
  border: 1px solid var(--primary);
  border-radius: 10px;
  padding: 0.5rem 1.25rem;
}

.stats-num {
  font-size: 1.5rem;
  font-weight: 800;
  color: var(--primary);
  line-height: 1;
}

.stats-label {
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  color: var(--dark);
  letter-spacing: 0.5px;
}

.controls-bar {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.search-box {
  position: relative;
  width: 100%;
}

.search-input {
  width: 100%;
  padding: 0.65rem 1rem;
  border-radius: 8px;
  border: 1px solid var(--subtle);
  font-size: 0.95rem;
  box-shadow: inset 0 1px 2px rgba(0,0,0,0.05);
}

.search-input:focus {
  border-color: var(--primary);
  outline: none;
  box-shadow: 0 0 0 3px rgba(51, 102, 51, 0.15);
}

.clear-btn {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: var(--subtle);
  font-size: 1rem;
  cursor: pointer;
  padding: 4px 8px;
}

.category-tabs {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.category-tab {
  background: var(--light);
  border: 1px solid transparent;
  padding: 0.45rem 0.9rem;
  border-radius: 20px;
  font-size: 0.85rem;
  font-weight: 600;
  color: var(--text);
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.4rem;
  transition: all 0.2s ease;
}

.category-tab:hover {
  background: #dedede;
}

.category-tab.active {
  background: var(--primary);
  color: white;
  border-color: var(--primary);
}

.cat-count {
  background: rgba(0, 0, 0, 0.1);
  padding: 0.1rem 0.4rem;
  border-radius: 10px;
  font-size: 0.75rem;
}

.category-tab.active .cat-count {
  background: rgba(255, 255, 255, 0.25);
  color: white;
}

/* Grid Layout */
.modules-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 1.25rem;
}

.module-card {
  background: white;
  border-radius: 12px;
  padding: 1.25rem;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
  border: 1px solid var(--light);
  display: flex;
  flex-direction: column;
  transition: transform 0.15s ease, box-shadow 0.15s ease;
}

.module-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 14px rgba(0, 0, 0, 0.08);
}

.card-header {
  margin-bottom: 0.75rem;
}

.badge-row {
  display: flex;
  flex-wrap: wrap;
  gap: 0.4rem;
  margin-bottom: 0.5rem;
}

.type-badge {
  font-size: 0.7rem;
  font-weight: 700;
  text-transform: uppercase;
  padding: 0.2rem 0.55rem;
  border-radius: 6px;
  letter-spacing: 0.4px;
}

.type-badge.quick {
  background: #fdf3d7;
  color: #8f6400;
}

.type-badge.asset {
  background: #e1f5fe;
  color: #0277bd;
}

.type-badge.log {
  background: #e8f5e9;
  color: #2e7d32;
}

.type-badge.system {
  background: #f3e5f5;
  color: #6a1b9a;
}

.pwa-badge {
  background: #e0f2f1;
  color: #00695c;
  font-size: 0.7rem;
  font-weight: 600;
  padding: 0.2rem 0.5rem;
  border-radius: 6px;
}

.core-badge {
  background: #edf7ed;
  color: #1e4620;
  font-size: 0.7rem;
  font-weight: 600;
  padding: 0.2rem 0.5rem;
  border-radius: 6px;
}

.card-title {
  font-size: 1.2rem;
  font-weight: 700;
  color: var(--dark);
  margin: 0;
}

.card-description {
  font-size: 0.9rem;
  color: var(--text);
  line-height: 1.45;
  margin-bottom: 1rem;
}

.capabilities-section {
  flex-grow: 1;
  background: #fbfbfb;
  border-radius: 8px;
  padding: 0.75rem 0.85rem;
  margin-bottom: 1.15rem;
  border: 1px solid #f0f0f0;
}

.section-heading {
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  color: var(--subtle);
  margin: 0 0 0.4rem 0;
  letter-spacing: 0.3px;
}

.capability-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.capability-list li {
  font-size: 0.825rem;
  color: var(--text);
  margin-bottom: 0.35rem;
  line-height: 1.35;
  display: flex;
  align-items: baseline;
  gap: 0.35rem;
}

.check-bullet {
  color: var(--primary);
  font-weight: bold;
}

.card-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-top: auto;
}

.action-btn {
  flex: 1 1 auto;
  font-size: 0.85rem;
  font-weight: 600;
  padding: 0.5rem 0.75rem;
  border-radius: 6px;
  text-align: center;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.action-btn-secondary {
  font-size: 0.8rem;
  font-weight: 500;
  padding: 0.5rem 0.65rem;
  border-radius: 6px;
  text-align: center;
  text-decoration: none;
}

.btn-primary {
  background-color: var(--primary);
  color: white;
  border: 1px solid var(--primary);
}

.btn-primary:hover {
  background-color: #2b552b;
}

.btn-outline-success {
  background-color: transparent;
  color: var(--primary);
  border: 1px solid var(--primary);
}

.btn-outline-success:hover {
  background-color: var(--primary);
  color: white;
}

.btn-outline-secondary {
  background-color: transparent;
  color: var(--text);
  border: 1px solid var(--subtle);
}

.btn-outline-secondary:hover {
  background-color: var(--light);
}

.empty-results {
  background: white;
  padding: 3rem 1.5rem;
  text-align: center;
  border-radius: 12px;
  border: 1px solid var(--light);
}

.empty-results h4 {
  color: var(--dark);
  margin-bottom: 0.5rem;
}

.empty-results p {
  color: var(--text);
  margin-bottom: 1rem;
}
</style>
