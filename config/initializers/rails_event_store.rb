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
    store.subscribe(Stocks::OnStockCameIn, to: [InventoryControl::StockCameIn])
    store.subscribe(Stocks::OnStockCameOut, to: [InventoryControl::StockCameOut])
  end

  Rails.configuration.command_bus.tap do |bus|
    bus.register(InventoryControl::ComeInStock, InventoryControl::OnComeInStock.new)
    bus.register(InventoryControl::ComeOutStock, InventoryControl::OnComeOutStock.new)
  end
end