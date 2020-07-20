require 'rails_event_store'
require 'aggregate_root'
require 'arkency/command_bus'

Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::Client.new(
    mapper: RubyEventStore::Mappers::Default.new(serializer: JSON)
  )
  Rails.configuration.command_bus = Arkency::CommandBus.new

  AggregateRoot.configure do |config|
    config.default_event_store = Rails.configuration.event_store
  end

  Rails.configuration.event_store.tap do |store|
    store.subscribe(InventoryControls::OnStockHandler, to: [InventoryControlling::StockCameIn])
    store.subscribe(InventoryControls::OnStockHandler, to: [InventoryControlling::StockCameOut])
    store.subscribe(InventoryControls::OnStockHandler, to: [InventoryControlling::StockAdjusted])
    store.subscribe(InventoryControls::OnStockHandler, to: [InventoryControlling::StockTransferred])
  end

  Rails.configuration.command_bus.tap do |bus|
    bus.register(InventoryControlling::ComeInStock, InventoryControlling::OnComeInStock.new)
    bus.register(InventoryControlling::ComeOutStock, InventoryControlling::OnComeOutStock.new)
    bus.register(InventoryControlling::AdjustStock, InventoryControlling::OnAdjustStock.new)
    bus.register(InventoryControlling::TransferStock, InventoryControlling::OnTransferStock.new)
  end
end